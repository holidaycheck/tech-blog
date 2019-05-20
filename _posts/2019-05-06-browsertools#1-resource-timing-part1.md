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

Up to here this **page loaded <span id="num-assets-loaded-1">??</span> assets** (or resources) and **took <span id="time-taken-loading-1">??</span> seconds to load**. All those information were gathered, just now, via the Resource Timing interface, which we would like to cover in this article. <span id="loading-failed-hint-1">(If you just see "??" then reading the data didn't work, do you have an older browser? Anyways read on so you can try if and how the described API works in your browser?)</span> At the end of the article the same stats with the updated values can be found, watch out.
If you <a href="">reload</a>, the numbers may change.
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
> window.performance.getEntriesByType('resource')
```

```js
[{
    // ... shortened
    duration: 14.79000000108499,
    name: "http://techblog.holidaycheck.com/css/main.css",
    startTime: 18.41499999864027,
    responseEnd: 33.20499999972526,
    // ... shortened
}, {...}]
```

The `duration` is given in milliseconds. The time is measured using the DOMHighResTimestamp interface, which allows for very exact time measuring. Why is this needed? We could have used `Date.now()`, but [the spec][7] says it "does not allow for sub-millisecond resolution and is subject to system clock skew". Better to have exact timestamps. You can see the sub-milliseconds part in the `duration`'s value above. So we have reliable time measuring in the browser available, details might become another blog post in this series.

The `name` is the URL of the resource the website loaded and the API measured.
Let's sum it all up, by looking at the part of the API we have learned about.

```js
> // Read all resource that our website has loaded.
> const resources = window.performance.getEntriesByType('resource');
> // Filter out the name and the duration. 
> const durations = resources.map(({name, duration}) => ({name, duration}));
> durations
```

```js
[  // shortened for readability
   {name: ".../css/main.css", duration: 14.42500000121072},
   {name: ".../img/hc-labs-only-logo.svg", duration: 18.744999993941747},
   ...
]
```

## The `responseEnd` Attribute In Use

The `duration` attribute seen before, is the result of subtracting the `responseEnd - startTime` attribute ([spec][8]). The `startTime` attribute is the time when fetching the resource started ([MDN][9]). The `responseEnd` is the timestamp when the last byte was received or when the transport connection closes ([MDN][10]). The time taken how long loading all resources took, as you saw at the beginning of the article and as you can see at the end again, is calculated by retreiving all `responseEnd` values, sorting them and taking the biggest one, as you can see below:

```js
> const resources = window.performance.getEntriesByType('resource');
> // Filter out the responseEnd attribute only.
> const allEnds = resources.map(r => r.responseEnd);
> resources.length + ' resources, ' + allEnds.sort().reverse()[0], ' ms'
```
<pre id="inline-stats-result" class="highlight"></pre>
<script type="text/javascript">
  (() => {
    const resources = window.performance.getEntriesByType('resource');
    const resourcesStr = resources.length + ' resources, ';
    const timeStr = resources.map(r => r.responseEnd).sort().reverse()[0] + ' ms';
    document.querySelector('#inline-stats-result').innerHTML = resourcesStr + timeStr;
  })()
</script>

## Finally

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
[8]: https://www.w3.org/TR/2017/CR-resource-timing-1-20170330/#performanceresourcetiming
[9]: https://developer.mozilla.org/en-US/docs/Web/API/PerformanceEntry/startTime
[10]: https://developer.mozilla.org/en-US/docs/Web/API/PerformanceResourceTiming/responseEnd
