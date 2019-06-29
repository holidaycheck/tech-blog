---
layout: post
title: "Resource Timing (part 3) - Waterfall Chart"
categories: browsertools
author_name: Wolfram Kriesing
author_url : /author/wolframkriesing
author_avatar: wolframkriesing
read_time : 4
feature_image: posts/2019-06-15-browsertools-3/michelle-rosen-390381-unsplash.jpg
---

This is post #3 in the [category "Browser Tools"][0], focusing on understanding the loading times by charting them in a Waterfall Chart. In [part 1][1] and [part 2 about ResourceTiming][2] we looked at the attributes `responseEnd`, `startTime` and `initiatorType`. Now we want to understand what happens after a resource starts loading and how to understand those numbers.

## Setting the Context

Let's shortly sum up how we gather those data. There is a built-in `Resource Timing API` (read more in [part 1][1]) that you see in action, right here:

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

As you can see above `window.performance` provides these data right in the browser. In the [previous][1] [parts][2] of this series we covered the meaning of the attributes `duration`, `startTime`, `responseEnd` and `initiatorType`. These gave a good high-level view on our resource loading behavior and can answer questions like "How long does each resource need to load?" or "What is the loading order and dependency of resources?".

From here on we will go deeper and look at the attributes `fetchStart`, `requestStart` and `responseStart` in order to see which parts belong to loading one resource. Even though `duration` can give us the overall loading time, the API does also provide more granular information, these we will inspect now.

## The `fetchStart`, `requestStart` and `responseStart` Attributes

For better understandability of these data, the chart below shows each of those attributes in a waterfall chart. Hover over (or click) each line to see the detailed numbers for each attribute.

<figure>
    <hc-chart id="waterfall-chart-2" style="height: 350px;"></hc-chart>
    <figcaption>The waterfall chart showing the data gathered via the "Resource Timing API" (hover shows details)</figcaption>
</figure>

{% raw %}
<script type="text/javascript">
  window.__loadChartFunctions__ = [];
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
    <img src="/img/posts/2019-06-15-browsertools-3/resource-timing-overview-modified.png" alt="resource-timing-overview" class="centered" />
    <figcaption>The graph illustrates the timing attributes defined by the PerformanceResourceTiming interface</figcaption>
</figure>

The chart is [taken from the spec][6] and slightly enhanced, to show the attributes and some comments about them.

## Let's Investigate More

I hope disecting `window.performance` especially the `User ResourceTiming API` triggers some interest in diving deeper into page timing insights. The most common use case, of course, is optimizing page speed. Since page speed is a very complex topic I hope this helps getting some handle on how to look at it.


[0]: /category/browsertools
[1]: {% post_url 2019-05-06-browsertools#1-resource-timing-part1 %}
[2]: {% post_url 2019-06-08-browsertools#2-loading-dependencies %}

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
    scriptTag.setAttribute('src', 'https://holidaycheck.github.io/hc-live-chart-component/HcChart.js');
    document.head.insertBefore(scriptTag, document.head.childNodes[0]);
  })();
</script>
{% endraw %}

