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

{% raw %}
<script type="text/javascript">
  window.__loadChartFunctions__ = [];
</script>
{% endraw %}


This is post #3 in the [category "Browser Tools"][0], focusing on understanding the loading times by charting them in a Waterfall chart. In [part 1][1] and [part 2 about ResourceTiming][2] we looked at the attributes `startTime`, `responseEnd`, `duration` and `initiatorType`. Now we want to understand what happens after a resource starts loading and how to understand attributes like `fetchStart`, `requestStart` and `responseStart`, to mention the most relevant ones.

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

As you can see above `window.performance` provides these data right in the browser (details in the [previous][1] [parts][2] of this series).

From here on we will go deeper and look at the attributes `fetchStart`, `requestStart` and `responseStart` in order to see which parts belong to loading one resource. Even though `duration` can give us the overall loading time, the API does also provide more granular information, these we will inspect now.

## The Waterfall Chart in Action

For better understanding the attributes, let's chart them. The Waterfall chart below initially shows each of those attributes **for the first seven requests only** (you can show all, see buttons below).
Hover over (or click) each line to see the value of each attribute and read on to find deeper explanation of each of them.

<figure>
    <figcaption>The waterfall chart showing the first seven resources loaded (hover/click the bars in the chart to see details).</figcaption>
    <hc-chart id="waterfall-chart-2" style="height: 350px;"></hc-chart>
    {% raw %}
    <script type="text/javascript">
        const _renderChartWithFirstSevenResources = () => _renderWaterfallChart(document.querySelector('#waterfall-chart-2'), 7)
        const _renderChartWithAllResources = () => _renderWaterfallChart(document.querySelector('#waterfall-chart-2'))
        window.__loadChartFunctions__.push(_renderChartWithFirstSevenResources);
    </script>
    {% endraw %}
    <button onclick="_renderChartWithAllResources()">Show all resources</button>
    <button onclick="_renderChartWithFirstSevenResources()">Show only first 7 resources</button>
</figure>

Note: The times in the chart above, are calculated differences using the values the API's returned.
The time shown in the tooltip is always the difference to the previous attribute.  
For example: if `startTime` and `fetchStart` have the value `23`, the tooltip will show `Request started after 23.0 ms (startTime)` and `Redirect took 0.0 ms (fetchStart)`.

## The `fetchStart` attribute

Often `fetchStart` has the value `0ms`. That is because the according resource started to be fetched right away after the `startTime` was recorded. In the end this is an browser internal, the [spec only says it as the "time immediately before the user agent starts to fetch the resource"][7]. But it also means that **no redirect** took place, see the image from the spec below.  
On the other hand be careful interpreting the numbers, the browser might be "working" between each of the measurement points. Even if you see in the chart `Redirect took 1.7 ms (fetchStart)` (instead of 0ms), it is also possible that the browser just started measuring the data later because it was busy with something else. 

<figure>
    <figcaption>A value for "fetchStart>0" does not always mean a redirect took place.</figcaption>
    <img src="/img/posts/2019-06-15-browsertools-3/maybe-no-redirect.jpg" alt="maybe-no-redirect" />
</figure>

That's why looking at the raw data, as the chart shows them above needs knowledge on how to understand them! If a redirect took place can be seen though by calculating `redirectEnd - redirectStart`, in case of no redirect it will be 0.

Looking at it from the numbers point of view the `fetchStart` is at least made up out of:
```js
fetchStart >= startTime + redirectDuration
  // with        
  redirectDuration = redirectEnd - redirectStart
```
("redirectDuration" is a variable that I introduced, the spec does not define it). 



One interesting aspect is that the [spec][3] defines some kind of logic into the values of some attributes. Some attributes can have the value 0, for example `redirectStart` and `redirectEnd`. This might not be interpreted as "redirect started at 0ms" but rather as "there was no redirect". Even though it feels strange and requires more effort using the values, I think it's a clever move. See below a screenshot from the spec text.

<figure>
    <figcaption>The spec allows some attributes to be zero.</figcaption>
    <img src="/img/posts/2019-06-15-browsertools-3/spec-attributes-zero.jpg" alt="spec-attributes-zero.jpg" />
</figure>


## The `requestStart` attribute

The attribute `requestStart` has the timestamp when the real data are about to be requested, that means after DNS lookup ("domainLookupDuration") and TCP handshake ("connectDuration"). The spec says it is the ["time immediately before the user agent starts requesting the resource from the server, or from relevant application caches or from local resources"][8]. That means when one thinks about working on the website speed that all optimization on this resource up to here might contains infrastructure work, connection caching or pre-fetching. Depending on what one found out is the bottleneck, knowing what these attributes are made of allows for focusing effort on where to work on page speed.

Taking `requestStart` apart a little bit can even show hints where slow sites have potential. Also consider that optimization of the parts that make up `requestStart` might effect many more requests, a speedup might be worth it.  
This attribute contains at least the following times:
```js
requestStart >= startTime + redirectDuration 
                + domainLookupDuration + connectDuration
  // with        
  redirectDuration = redirectEnd - redirectStart
  domainLookupDuration = domainLookupEnd - domainLookupStart  
  connectDuration = connectEnd - connectStart
```
(the variables "domainLookupDuration" and "connectDuration" are not defined in the spec, they are here for convinience). 

## The `responseStart` attribute

The next interesting attribute is `responseStart` which the spec describes as the ["time immediately after the user agent receives the first byte of the response from relevant application caches, or from local resources or from the server"][9]. If this time is very high, it is most likely the server that takes it easy delivering the resource, this might be a resource to be optimized.

Besides all the mentioned attributes there are some more, which will be documented in the chart below. It shows well how they all relate to each other and when they might occur in the progress of loading a resource.

<figure>
    <figcaption>The graph illustrates the timing attributes defined by the PerformanceResourceTiming interface.</figcaption>
    <img src="/img/posts/2019-06-15-browsertools-3/resource-timing-overview-modified.jpg" alt="resource-timing-overview" />
</figure>

The chart is [taken from the spec][6] and slightly enhanced, to show the attributes and some comments about them.

## Let's Investigate More

I hope disecting `window.performance` especially the `User ResourceTiming API` triggers some interest in diving deeper into page timing insights. The most common use case, of course, is optimizing page speed. Since page speed is a very complex topic I hope this helps getting some handle on how to look at it.


[0]: /category/browsertools
[1]: {% post_url 2019-05-06-browsertools#1-resource-timing-part1 %}
[2]: {% post_url 2019-06-08-browsertools#2-loading-dependencies %}
[3]: https://www.w3.org/TR/resource-timing-2/

[6]: https://www.w3.org/TR/2017/CR-resource-timing-1-20170330/#processing-model
[7]: https://www.w3.org/TR/2017/CR-resource-timing-1-20170330/#dom-performanceresourcetiming-fetchstart
[8]: https://www.w3.org/TR/2017/CR-resource-timing-1-20170330/#dom-performanceresourcetiming-requeststart
[9]: https://www.w3.org/TR/2017/CR-resource-timing-1-20170330/#dom-performanceresourcetiming-responsestart

*Main photo by <a href="https://unsplash.com/photos/MmPamQEr-ec?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Michelle Rosen</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a><br />


{% raw %}
<script type="text/javascript">

  const _renderWaterfallChart = (domNodeToRenderInto, numberOfEntriesToShow = Number.POSITIVE_INFINITY) => {
    const chart = domNodeToRenderInto;
    const resources = [
      ...window.performance.getEntriesByType('navigation'),
      ...window.performance.getEntriesByType('resource').slice(0, numberOfEntriesToShow - 1),
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
      'Request started after ${value} ms (startTime)', 
      'Redirect took ${value} ms (fetchStart)', 
      'AppCache+DNS+TCP took ${value} ms (requestStart)',
      'Server responded after ${value} ms (responseStart)',
      'Response was complete after ${value} ms (responseEnd)',
    ];
    chart.updateStackedWaterfallData(times, {valueLabels, precision: 1});
  };

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

