---
layout: post
title: "Browser Tools #1: Resource Timing (part 1)"
categories: browsertools
author_name: Wolfram Kriesing
author_url : /author/wolframkriesing
author_avatar: wolframkriesing
read_time : 10
excerpt: ""
---

This post is the start of a series of blog posts about browser tools. Among those we plan to look into any kind of tool in and around the browser, so mostly things web developers eventually find useful. Let's dive right in.

Up to here this **page loaded <span id="num-assets-loaded-1">??</span> assets** (or resources) and **took <span id="time-taken-loading-1">??</span> seconds to load**. All those information were gathered via the Resource Timing interface, which we would like to cover in this article. <span id="loading-failed-hint-1">(If you just see "??" then reading the data didn't work, do you have an old browser?)</span>
{% raw %}
<script type="text/javascript">
const __updateInlineStats__ = (index) => {
  try {
    const r = window.performance.getEntriesByType('resource');
    document.querySelector(`#num-assets-loaded-${index}`).textContent = r.length;
    document.querySelector(`#time-taken-loading-${index}`).textContent = (r.map(r => r.responseEnd).sort().reverse()[0] / 1000).toFixed(1);
    document.querySelector(`#loading-failed-hint-${index}`).remove();
  } catch (e) { /* swallow errors */ }
}
__updateInlineStats__(1);
</script>
{% endraw %}

## Resource Timing Interface

Let us start by looking into the `Resource Timing` interface  ([on MDN][2], [in the spec][4]), it is part of the `Performance` interface ([on MDN][1], [the spec][5]), which you can reach via `window.performance` in all modern browsers. We will learn how it can be useful to better understand the impact on performance of resources that a website loads, e.g. JS, CSS, images, XHRs and alikes.

The [specification (or spec)][3] introduces the topic in a very understandable way: 

> [The spec] introduces the PerformanceResourceTiming interface to allow JavaScript mechanisms to collect complete timing information related to resources on a [website].

The interface that the spec defines is called "PerformanceResourceTiming", which is in simple terms the collection of many attributes about one resource that the website (or document) loads. For example the `duration` attribute, which tells us how long it took to load a certain resource. For that we have to read all resources that were loaded, which we do via `window.performance.getEntriesByType('resource')`. This returns an array of all resources, which contains the `name` and `duration` properties (among others):
```js
[{
    // ... shortened
    duration: 142.5950000048033,
    name: "http://techblog.holidaycheck.com/css/main.css",
    // ... shortened
}, {...}]
```

The `duration` is given in milliseconds. The time is measured using the DOMHighResTimestamp interface, which allows for very exact time measuring. Why is this needed? [The spec][7] says `Date.now()` "does not allow for sub-millisecond resolution and is subject to system clock skew". You can see the sub-milliseconds part in the `duration`'s value above. So we have reliable time measuring in the browser available, details will be another blog post in this series.

<hc-live-chart style="padding: 0.5rem; background: lightyellow; font-size: 1.5rem; height: 25rem; ">
const resources = window.performance.getEntriesByType('resource');
const durations = resources.map(r => ({label: r.name, value: r.duration}));
// Show the first ten durations, to make the chart easier to understand.
return durations.slice(0, 10);
</hc-live-chart>











Now that you got here, we pick up the thing we did at the beginning of the page again and list the tiny statistics again. After the [event "load"][6] (the whole page has loaded, including all dependent resources such as stylesheets images) this **page loaded <span id="num-assets-loaded-2">??</span> assets** (or resources) and **took <span id="time-taken-loading-2">??</span> seconds to load**. <span id="loading-failed-hint-2">(If you just see "??" then reading the data didn't work, do you have an old browser?)</span>
{% raw %}
<script type="text/javascript">
window.addEventListener('load',() => __updateInlineStats__(2));
</script>
{% endraw %}








[1]: https://developer.mozilla.org/en-US/docs/Web/API/Performance
[2]: https://developer.mozilla.org/en-US/docs/Web/API/Resource_Timing_API
[3]: https://www.w3.org/TR/2019/WD-resource-timing-2-20190424/
[4]: https://www.w3.org/TR/2017/CR-resource-timing-1-20170330/
[5]: https://www.w3.org/TR/performance-timeline-2/
[6]: https://developer.mozilla.org/en-US/docs/Web/API/Window/load_event
[7]: https://www.w3.org/TR/hr-time-2/