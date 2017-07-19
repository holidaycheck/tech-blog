---
layout: post
title:  "Our journey discovering a Node.js memory leak"
date:   2017-06-09 17:00:00 +0200
categories: javascript node.js memoryleak bug
author: Florian Störkle
---

# Tracking down a Node.js memory leak

In this blog post we want to share our experience of tracking down and fixing a memory leak in one of our Node.js applications. For several reasons, this proved quite difficult, and took us several days to fix.

## Preface

Our team built a Node.js application that is responsible for synchronizing logs from an external service provider to our internal log pooling system (Google Stackdriver Logs). Let's call this application `sync-logs-to-stackdriver`.

To make it simple, the job periodically checks if there are new logs available in the external system. If that is the case it syncs them to Stackdriver. If not, it waits a short amount of time and then checks again for new logs.

In our internal container infrastructure, we have two instances of this service running:

- a production instance (syncing ~ 100 logs/minute)
- a development instance (syncing ~ 100 logs/day)


## Discovery

One day, we were notified by our infrastructure team that one of applications, `sync-logs-to-stackdriver`, killed and restarted automatically several times a day. They said the likely cause would be a memory leak.

As we are using NewRelic for monitoring our Node.js applications, we quickly checked the health of the application there. And indeed, we could confirm the suspicion: we really had a memory leak. This memory usage graph of the development instance of the application illustrates that:

![NewRelic memory monitoring](https://github.hc.ag/pages/checkin/img/2017-05-10-memory-leak/dev-memory-leak-crashes.png)

As one can see, the memory usage increases without upper border, until the container is killed by our infrastructure. Then the container is respawned, and it starts all over again.

Interestingly, the leak was present in our production instance, but had far smaller impact – it only ran out of memory every other week.

We noticed one thing that were quite suprised of that point in time: The memory leak was in the so-called ["non-heap" memory](https://blog.newrelic.com/2017/03/30/nodejs-vm-metrics-view-apm/) of Node – that is the memory that is used by Node itself and binary extensions, but not by application code.


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

Here, we were only looking at the `rss` ("[Resident Set Size](https://www.dynatrace.com/blog/understanding-garbage-collection-and-hunting-memory-leaks-in-node-js/)") value, as only this value includes the non-heap memory.

Then, we started `sync-logs-to-stackdriver` basically via running `node index.js` on the command line and watching the output. If we saw that the `rss` value increased for several minutes without any upper border, we declared the application to have a memory leak. If the `rss` value was stable for several minutes, we declared the application to have no memory leak.


### macOS vs. Linux

Unfortunately, in the beginning we could not reproduce the leak locally. But after some time, it deemed us, that the operating system might play a role here. The real container in our service infrastructure is of course not running on OS X (which we were using locally), but rather some Linux distribution. Consequently, we ran the application again in a Linux VM, and voilà – we were able to reproduce the memory leak repeatedly.



## Tracking down the actual cause

For starters, we skimmed the code manually for obvious bugs that could cause a  memory leak. However, we found none. Therefore, without clear indiciation what was causing the leak, we investigated in different directions.


### Promises & functions

We suspected that we might have hit a bug/known issue with promises in Node.js that is also [mentioned in the Promise spec](https://github.com/promises-aplus/promises-spec/issues/179). When constructing an infite chain of promises a memory leak might appear under certain conditions. As we used and chained Promises heavily in `sync-logs-to-stackdriver`, we tried to get rid of them and rewrote the code question in callback style. Unfortunately, to no avail.

Still, the log polling loop was implemented recursively in a rather functional way. While we deemed it unlikely, we wanted to ensure that the rather high level of recursion was not causing the leak. Thus, we rewrote the log polling loop iteratively using a `while` loop. This did not get rid of the leak either.


### Dependencies

Another idea was to check if one of our dependencies might be causing the problem. We were relying on different npm modules, that could possible cause the leak, e.g. `@google-cloud/logging`, or `promise-sleep`. However, after have replaced these dependencies with stubs or a custom implementation, the memory leak was still present.


### Idling considered harmful?

As mentioned before, the development instance of our application was affected far more than the production one. The main difference between the two instances are the amount of logs they synchronize. The production instance synchronizes logs almost continously and only waits rarely for new logs to appear. On the contrary, the development instance syncs only very few logs, leaving the job waiting and checking for new logs most of the time.

This led us to the assumption that the memory leak was caused by the constant polling for new logs, and not the actual synchronization.

We could confirm this assumption by removing and stubbing out all code related to synchronizing the logs. After that, with only the waiting logic left, the leak was still present.


### Getting to the root

Following the previous approach, we stripped down the log polling code more and more until we could pinpoint a single line to cause the memory leak:

```JavaScript
const response = await fetch(url, fetchOptions);
```

Here, the `sync-logs-to-stackdriver` app is using [`node-fetch`]() to perform a HTTP GET request to the external service provider in order to check if there are any new logs to synchronize. If we removed this line, the memory leak was no longer reproducible. First, we thought that `node-fetch` might be the culprit here. So, we replaced it with `superagent`, however, the leak was still present.

The only thing that reproducibly stopped the leak was not performing the GET request at all.

During the whole process, we were searching for bugs/leaks in Node.js and our dependencies all the time. At some point we found a [memory leak in Node.js (<= v7.8)](https://github.com/nodejs/node/pull/12089) that occurs when validating certificates.

For three reasons, we considered that Node.js bug a possible cause for our memory leak:

1. We were using Node.js 7.8, which is affected by the bug.
1. The HTTP GET request is performed via HTTPS; therefore, a memory leak in certificate validation might actually have an effect on our application.
1. Our memory leak affected the non-heap memory, that is only used by Node.js (and native extensions) itself. A bug in native Node.js code might indeed affect this memory region.


Finally, we could reproduce the leak with this sample code:

```JavaScript
'use strict';

const fetch = require('node-fetch');
const sleep = require('sleep-promise');

async function main() {
	while (true) {
		const response = await fetch('https://httpbin.org/get', { method: 'GET' });
		const body = await response.text();

		console.log(process.memoryUsage());

		await sleep(50);
	}
}

main();
```

This made us even more confident that what we experienced is actually a memory leak of Node.js itself, and not caused by our application code.

## The solution

Having figured out the real problem, the solution was pretty simple: Node.js 7.10.0 had already been released, so we switched to using that for our application.

After upgrading to the new Node.js version, we could no longer reproduce the memory leak. We were relieved 🎉🍻.

Too be sure, we checked our NewRelic monitoring after some days. It clearly shows that we were able to fix the memory leak:

![no more memory leaks](https://github.hc.ag/pages/checkin/img/2017-05-10-memory-leak/no-more-memory-leak.png)
