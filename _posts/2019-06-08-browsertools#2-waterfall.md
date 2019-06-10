---
layout: post
title: "Browser Tools #2: Waterfall - Resource Timing (part 2)"
categories: browsertools
author_name: Wolfram Kriesing
author_url : /author/wolframkriesing
author_avatar: wolframkriesing
read_time : 10
excerpt: "This is the second post about the `Resource Timing Interface`, which allows to gather information about resources a site loads. Now we want to go a bit deeper and look at what happens in between the two times."
feature_image: posts/2019-06-08-browsertools-2/michelle-rosen-390381-unsplash.jpg
---

This is the second post about the `Resource Timing Interface`, which allows to gather information about resources our site loads, via JavaScript right on the website. This is done by using the `Performance Interface` accessible via `window.performance`. This article will explore how much details we can gather about each resource that is loaded (JS files, CSS files, fetches, etc.). Especially about their timing, which includes: when did loading start, how long did it take and more.

In [part 1 about ResourceTiming][3] we looked at the attributes `responseEnd` and `startTime`. Now we want to go a bit deeper and look at what happens in between the two times. 

## Setting the Context

Let's shortly sum up how we gather those data. There is a built-in functionality that you see in action, right here:

```js
> window.performance.getEntriesByType('resource')
```

```js
[{
    // ... shortened
    duration: 14.79000000108499,
    name: "http://techblog.holidaycheck.com/css/main.css",
    initiatorType: "link",
    startTime: 18.41499999864027,
    responseEnd: 33.20499999972526,
    // ... shortened
}, {...}]
```

As you can see above `window.performance` provides these data right in the browser. If you want to understand more details read [part 1][3].

From here on we will take apart the data and make sure we understand what they mean.

## The `startTime` Attribute

The spec says that the attribute `startTime` is "the time immediately before the [browser] starts to queue the resource for fetching" ([spec][2]). This means, e.g. if the browser is about to load the HTML page the `startTime` is recorded. This time is relative from the "the time when the browsing context is first created" ([spec][1]). In other words when the browser starts loading a new page. So this is a very browser-internal thing, that we would not be able to get access to without extending the browser itself. That proves that this interface can give us insights which we could not be able to obtain otherwise, especially not on any website itself. These numbers are also way more explicit in regards to what the user exepriences.

A `startTime` of 0 is the moment when the browsing context was created, when the browser started loading this page. This is for example a website reload, or navigating to a new site, opening a tab with a certain URL and alike. That means a `startTime=20` means 20 milliseconds after the browser context was created. Having a timestamp relative to the browser context creation allows us to get insights on our resource timings without any timestamp offset calculations, as we used to do using `Date.now()` (more in the [previous post][3]).

Let's look at some real life numbers:

<figure>
    <hc-chart id="waterfall-chart-1" style="height: 350px;"></hc-chart>
    <figcaption>The "startTime" for all resources requested by this page</figcaption>
</figure>
{% raw %}
<script type="text/javascript">
  window.__loadChartFunctions__ = [];
  window.__loadChartFunctions__.push(() => {
    const chart = document.querySelector('#waterfall-chart-1');
    const resources = [
      ...window.performance.getEntriesByType('navigation'),
      ...window.performance.getEntriesByType('resource'),
    ];
    const startTimes = resources.map(
      resource => ({label: `${resource.name} - (initiatorType: ${resource.initiatorType})`, value: resource.startTime}));
    chart.updateChartData(startTimes);
  });
</script>
{% endraw %}

In the chart one should see that some requests start at the same time. These requests have most probably been triggered by the same resource. For example the "main.css", the logo and the "main.js" files start to get loaded around the same time, as the first resources. This is because the HTML file that directly references them, triggers the loading of these files. The browser reads the HTML file, interprets it and finds `<link>` and `<script>` tags that reference those resources, so they start to get loaded, hence they have the lowest `startTime`. 

In the chart one can also see that the fonts start loading way later. This is because they are referenced inside the CSS file, which means the CSS file needs to be loaded first to know that the according fonts need to get loaded. This way one can understand better how the browser handles the resources, in which order and also using which constraints to load them.

## The `initiatorType` Attribute

This attribute is the type that triggered this resource to be loaded. In the chart above one can see strings like `initiatorType: navigation`, `initiatorType: link`, `initiatorType: script` and others. There are basically two types of attributes, the `initiatorType` is either: 
1. The name of the HTML tag, the DOM node (or as [the spec text says][4] the "value as the localName of that element [DOM], if the request is a result of processing the element"),
  * this refers to attributes like `src` in a `<script src="resource.js">` tag, the `href` attribute in a `<link href="resource.css">` tag or the `src` atttribute of an `<img>` tag among others.
1. Or it is one of "css", "navigation", "xmlhttprequest", "fetch", "beacon" or "other" when the loading was not directly triggered by a DOM node,
  * these are things like loading a new page ("navigation"), loading a resource from within a CSS file ("css") or the request done via the native JavaScript `window.fetch()` method ("fetch").

This attribute gives a bit more context to the loading times and makes the loading dependencies talked about in the chapter before easier to understand. A CSS file needs to be loaded by the browser, before it can know what other files are referenced inside of it and need to be loaded. This might also surface the question how much should be inlined, or if [preload][5] should be used to speed up website loading.

## The `fetchStart`, `requestStart` and `responseStart` Attributes

For understanding where the data come from, one can run following JavaScript in the developer console:

```js
> window.performance.getEntriesByType('resource')
```

```js
[{
    // ... shortened
    name: "http://techblog.holidaycheck.com/css/main.css",
    startTime: 81.32500003557652,
    fetchStart: 81.32500003557652,
    requestStart: 123.62999998731539,
    responseStart: 395.3000000328757,
    responseEnd: 404.55500001553446,
    // ... shortened
}, {...}]
```

For better understandability of these data, the chart below shows each of those attributes in a waterfall chart. Hover over (or click) each line to see the detailed numbers for each attribute.

<figure>
    <hc-chart id="waterfall-chart-2" style="height: 350px;"></hc-chart>
    <figcaption>The waterfall chart showing the data gathered via the "Resource Timing Interface" (hover shows details)</figcaption>
</figure>

{% raw %}
<script type="text/javascript">
  window.__loadChartFunctions__.push(() => {
    const chart = document.querySelector('#waterfall-chart-2');
    const resources = [
      ...window.performance.getEntriesByType('navigation'),
      ...window.performance.getEntriesByType('resource'),
    ];
    const times = resources.map(
      resource => ({label: resource.name, values: [
        resource.startTime,
        resource.fetchStart,
        resource.requestStart || resource.fetchStart,
        resource.responseStart || resource.fetchStart,
        resource.responseEnd,
      ]}));
    const valueLabels = [
      'start at ${value} ms (startTime)', 
      'fetchStart took ${value} ms', 
      'requestStart took ${value} ms',
      'responseStart took ${value} ms',
      'responseEnd took ${value} ms',
    ];
    chart.updateStackedWaterfallData(times, {valueLabels, precision: 1});
  });
</script>
{% endraw %}

Note: The widths of each bar, in the chart above, are calculated and the time shown in the tooltip is always the difference to the previous attribute. For example if `startTime` and `fetchStart` have the value `23`, the tooltip will show `start at 23.0 ms (startTime)` and `fetchStart took 0.0 ms`.

Often `fetchStart` has the value `0ms`. That is because the according resource started to be fetched right away after the `startTime` was recorded. In the end this is an browser internal, the [spec only says it as the "time immediately before the user agent starts to fetch the resource"][7]. But it also means that **no redirect** took place, see the image from the spec below.

The attribute `requestStart` has the timestamp when the real data are about to be requested, that means after DNS lookup and TCP handshake. The spec says it is the ["time immediately before the user agent starts requesting the resource from the server, or from relevant application caches or from local resources"][8]. That means all optimization on this resource up to here are mostly infrastructure related or connection caching related and require often more effort.

The next interesting attribute is `responseStart` which the spec describes as the ["time immediately after the user agent receives the first byte of the response from relevant application caches, or from local resources or from the server"][9]. If this time is very high, it is most likely the server that takes it easy delivering the resource, this might be a resource to be optimized.

Besides all the mentioned attributes there are some more, which will be documented in the chart below. It shows well how they all relate to each other and when they might occur in the progress of loading a resource.

<figure>
    <img src="/img/posts/2019-06-08-browsertools-2/resource-timing-overview-modified.png" alt="resource-timing-overview" class="centered" />
    <figcaption>The graph illustrates the timing attributes defined by the PerformanceResourceTiming interface</figcaption>
</figure>

The chart is [taken from the spec][6] and slightly enhanced, to show the attributes and some comments about them.

## Let's Investigate More

I hope disecting `window.performance` especially the `User ResourceTiming Interface` triggers some interest in diving deeper into page timing insights. The most common use case, of course, is optimizing page speed. Since page speed is a very complex topic I hope this helps getting some handle on how to look at it.


[1]: https://www.w3.org/TR/hr-time-2/#dfn-time-origin
[2]: https://www.w3.org/TR/2019/WD-resource-timing-2-20190424/#sec-performanceresourcetiming
[3]: {% post_url 2019-05-06-browsertools#1-resource-timing-part1 %}
[4]: https://www.w3.org/TR/2019/WD-resource-timing-2-20190424/#dom-performanceresourcetiming-initiatortype
[5]: https://html.spec.whatwg.org/multipage/links.html#link-type-preload
[6]: https://www.w3.org/TR/2017/CR-resource-timing-1-20170330/#processing-model
[7]: https://www.w3.org/TR/2017/CR-resource-timing-1-20170330/#dom-performanceresourcetiming-fetchstart
[8]: https://www.w3.org/TR/2017/CR-resource-timing-1-20170330/#dom-performanceresourcetiming-requeststart
[9]: https://www.w3.org/TR/2017/CR-resource-timing-1-20170330/#dom-performanceresourcetiming-responsestart

*Main photo by <a href="https://unsplash.com/photos/MmPamQEr-ec?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Michelle Rosen</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a><br />


{% raw %}
<script type="text/javascript">
  (() => {
    const onLoaded = () => {
      window.customElements.whenDefined('hc-chart').then(() => {
        window.addEventListener('load', () => {
          window.__loadChartFunctions__.forEach(fn => fn());
        });
      });
    };
    const scriptTag = document.createElement('script');
    scriptTag.onload = onLoaded;
    scriptTag.setAttribute('type', 'module');
//    scriptTag.setAttribute('src', 'https://holidaycheck.github.io/hc-live-chart-component/HcChart.js');
    scriptTag.setAttribute('src', 'http://localhost:9898/src/HcChart.js');
    document.head.insertBefore(scriptTag, document.head.childNodes[0]);
  })();
</script>
{% endraw %}

