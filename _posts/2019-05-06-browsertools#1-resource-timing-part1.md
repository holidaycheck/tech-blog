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

<hc-live-chart style="padding: 0.5rem; background: lightyellow; font-size: 1.5rem; height: 25rem; width: calc(100% + 20rem); margin-left: -10rem;">
const resources = window.performance.getEntriesByType('resource');
const durations = resources.map(r => ({label: r.name, value: r.duration}));
// Show the first ten durations, to make the chart easier to understand.
return durations.slice(0, 10);
</hc-live-chart>

> The startTime attribute MUST return a DOMHighResTimeStamp [HR-TIME-2] with the time immediately before the user agent starts to queue the resource for fetching. If there are HTTP redirects or equivalent when fetching the resource, and if the timing allow check algorithm passes, this attribute MUST return the same value as redirectStart. Otherwise, this attribute MUST return the same value as fetchStart.

it all starts with "startTime"









Now that you got here, we pick up the thing we did at the beginning of the page again and list the tiny statistics again. After the [event "load"][6] (the whole page has loaded, including all dependent resources such as stylesheets images) this **page loaded <span id="num-assets-loaded-2">??</span> assets** (or resources) and **took <span id="time-taken-loading-2">??</span> seconds to load**. <span id="loading-failed-hint-2">(If you just see "??" then reading the data didn't work, do you have an old browser?)</span>
{% raw %}
<script type="text/javascript">
window.addEventListener('load',() => __updateInlineStats__(2));
</script>
{% endraw %}



















Example 1, the number of resources this website loaded

<hc-live-chart style="padding: 0.5rem; background: lightyellow; font-size: 1.2rem; height: 25rem; width: calc(100% + 20rem); margin-left: -10rem;">
const resources = window.performance.getEntriesByType('resource');
return resources.map(r => ({label: r.name, value: r.duration}));
</hc-live-chart>

      
## Resource Types

There are many different performance related information we could get from  the browser. If you ever opened the developer tools you know that a lot of things happen under the hood and make up the (perceived) website performance. That's why there are different types of performance entries that the browser provides. 
We look into resources here. By calling `window.performance.getEntriesByType("resource")` we receive an array of all resources that had been loaded on the current website. Resources are basically all things loaded via HTTP, hence you can also find out which protocol version (HTTP1 or HTTP2) was used for loading.
Besides "resource" which we used as parameter for `getEntriesByType()` before you can also use "navigation", "paint", "mark" and "measure". But we won't cover those in this blog post, feel free to explore them yourself.

## Inspect Resources

To see all CSS files, we can simply filter the resources by the property `initiatorType="css"` like so  
```js
const resources = window.performance.getEntriesByType("resource");
const cssFiles = resources.filter(r => r.initiatorType==='css');
return cssFiles.map(r => ({label: r.name, value: r.transferSize}));
```

That this reads only the CSS files is not entirely correct, actually it reads all ____________.

Let's take a closer look at the objects, the resource entries (`PerformanceResourceTiming` entries, to be correct). First they contain the various size properties that allow us to understand what was invested in transporting the resource to the client and also how big the actual content is. The property `transportSize` is the amount of bytes we can also inspect in the network tabs of the developer tools, the pure size of the asset as transported over the network. This size includes the headers that were sent with the resource.
Most resources are compressed, either via compression algorithms on the transport layer or certain content encodings.
____ what about images such as png, jpgs, are decodedSize the full bitmap image size_____????
The sizes before and after compression are available as `encodedBodySize` and `decodedBodySize`. In the names one can see that the size refers only to the body of the asset, or better said of the HTTP message, excluding the headers as opposed to the `transferSize`.

## Browser Compatibility



[1]: https://developer.mozilla.org/en-US/docs/Web/API/Performance
[2]: https://developer.mozilla.org/en-US/docs/Web/API/Resource_Timing_API
[3]: https://www.w3.org/TR/2019/WD-resource-timing-2-20190424/
[4]: https://www.w3.org/TR/2017/CR-resource-timing-1-20170330/
[5]: https://www.w3.org/TR/performance-timeline-2/
[6]: https://developer.mozilla.org/en-US/docs/Web/API/Window/load_event
[7]: https://www.w3.org/TR/hr-time-2/