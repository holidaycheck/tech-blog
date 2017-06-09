---
layout: post
title:  "Our journey discovering a Node.js memory leak"
date:   2017-06-09 17:00:00 +0200
categories: post
---

# Tracking down a Node.js memory leak

In this blog post we want to share our experience of tracking down and fixing a memory leak in one of our Node.js applications. For several reasons, this proved quite difficult, and took us several days to fix.

## Preface

Our team built a Node.js application that is responsible for synchronizing logs from an external service provider to our internal log pooling system (Google Stackdriver Logs). Let's call this application `sync-logs-to-stackdriver`.

To make it simple, the job periodically checks if there are new logs available in the external system. If that’s the case it syncs them to Stackdriver. If not, it waits a short amount of time and then checks again for new logs.

In our internal container infrastructure, we have two instances of this service running:

- a production instance (syncing ~ 100 logs/minute)
- a development instance (syncing ~ 100 logs/day)


## Discovery

One day, we were noticed by our infrastructure team that one of applications, `sync-logs-to-stackdriver`,  killed and restarted automatically several times a day. They said the likely cause would be a memory leak.

As we are using NewRelic for monitoring our Node.js applications, we quickly checked the health of the application there. And indeed, we could confirm the suspicion: we really had a memory leak. This memory usage graph of the development instance of the application illustrates that:

![NewRelic memory monitoring](https://github.hc.ag/pages/checkin/img/2017-05-10-memory-leak/dev-memory-leak-crashes.png)

As one can see, the memory usage increases without upper border, until the container is killed by our infrastructure. Then the container is respawned, and it starts all over again.

Interestingly, the leak was present in our production instance, but had far smaller impact – it only ran out of memory every other week.

We noticed one thing that were quite suprised of that point in time: The memory leak was in the so-called "non-heap" memory of Node – that is the memory that is used by Node itself and binary extensions, but not by application code.


## First measures

In order to be reliably notified of this and future memory leaks, we first setup an alert for all of our services. As we are already using [Prometheus](https://prometheus.io/) for monitoring, we added new alert rules for our services there.

The alert basically looks like this:

```
ALERT SyncLogsToStackdriverMemoryUsage
  IF (container_memory_usage_bytes{app="sync-logs-to-stackdriver"} / container_spec_memory_limit_bytes{app="sync-logs-to-stackdriver"}) > 0.8
  FOR 5m
  LABELS {severity="warning", team="..."}
```

## Reproducing the leak locally

In order to fix the leak, we now wanted to reproduce the leak locally.

### DevTools to the rescue?

At first, we wanted to profile the Node.js process [via the Chrome DevTools](https://medium.com/@paul_irish/debugging-node-js-nightlies-with-chrome-devtools-7c4a1b95ae27) or any other common memory profiling/debugging tool. However, as mentioned before, the leak occurs in Node.js’ "non-heap" memory. Unfortunately, typical debugging tools can't give you insight into this memory region; they only enable you to profile the application’s heap and stack.


### DIY profiling!

As a consequence, we resorted to some kind of "manual profiling": we logged the memory usage of the process from within the Node.js application with [`process.memoryUsage()`](https://nodejs.org/api/process.html#process_process_memoryusage). That returns an object that looks like this:

```JavaScript
{ rss: 22552576,
  heapTotal: 7258112,
  heapUsed: 4421240,
  external: 43177 }
```

Here, we were only looking at the `rss` ("[Resident Set Size](https://www.dynatrace.com/blog/understanding-garbage-collection-and-hunting-memory-leaks-in-node-js/)") value, as this is the only value including the non-heap memory usage.

Then, we started `sync-logs-to-stackdriver` basically via running `node index.js` on the command line and watching the output. If we saw that the `rss` value increased for several minutes without any upper border, we declared the application to have a memory leak. If the `rss` value was stable for several minutes, we declared the application to have no memory leak.


### OS X vs. Linux

Unfortunately, in the beginning we could not reproduce the leak locally. But after some time, it deemed us, that the operating system might play a role here. The real container in our service infrastructure is of course not running on OS X (which we were using locally), but rather some Linux distribution. Consequently, we ran the application again in a Linux VM, and voilà – we were able to reproduce the memory leak repeatedly.




No more memory leak image:
https://github.hc.ag/pages/checkin/img/2017-05-10-memory-leak/no-more-memory-leak.png
