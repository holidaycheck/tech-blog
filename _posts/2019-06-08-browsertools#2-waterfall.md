---
layout: post
title: "Browser Tools #2: Waterfall - Resource Timing (part 2)"
categories: browsertools
author_name: Wolfram Kriesing
author_url : /author/wolframkriesing
author_avatar: wolframkriesing
read_time : 10
excerpt: "???????????"
feature_image: posts/2019-06-08-browsertools-2/michelle-rosen-390381-unsplash.jpg
---

This is the second post about the `Resource Timing interface`, which allows to gather information about resources our site loads, via JavaScript right on the website. This is done by using the `Performance Interface` accessible via `window.performance`. This article will explore how much details we can gather about each resource that is loaded (JS files, CSS files, XHRs, etc.). Especially about their timing, which includes: when did loading start, how long did it take and more.

In [part 1 about ResourceTiming][3] we looked at the attributes `responseEnd` and `startTime`. Now we want to go a bit deeper and look at what happens in between the two times. 

## Set the context

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

## The `startTime`

The spec says that the attribute `startTime` is "the time immediately before the [browser] starts to queue the resource for fetching" ([spec][2]). This means, e.g. if the browser is about to load the HTML page the `startTime` is recorded. This time is relative from the "the time when the browsing context is first created" ([spec][1]). In other words when the browser starts loading a new page. So this is a very browser-internal thing, that we would not be able to get access to without extending the browser itself. That proves that this interface can give us insights which we could not be able to obtain otherwise, especially not on any website itself. These numbers are also way more explicit in regards to what the user exepriences.

A `startTime` would be 0 the moment when the browsing context was created. This is for example a website reload, or navigating to a new site, opening a tab with a certain URL and alike. That means a `startTime=20` means 20 milliseconds after the browser context was created. Having a timestamp relative to the browser context creation allows us to get insights on our resource timings without any timestamp offset calculations, as we might have done before using `Date.now()` (more in the [previous post][3]). 


## The Waterfall Chart

<hc-chart id="waterfall-chart" style="height: 350px;"></hc-chart>
{% raw %}
<script type="text/javascript">
  (() => {
    const onLoaded = () => {
      window.customElements.whenDefined('hc-chart').then(() => {
        window.addEventListener('load', () => {
          const chart = document.querySelector('#waterfall-chart');
          const resources = window.performance.getEntriesByType('resource');
          const durations = resources.map(({name, startTime, responseEnd}) => ({label: name, values: [startTime, responseEnd}));
          chart.updateStackedWaterfallData(durations, {valueLabels: ['startTime', 'responseEnd']});
        });
      });
    };
    const scriptTag = document.createElement('script');
    scriptTag.onload = onLoaded;
    scriptTag.setAttribute('type', 'text/javascript');
    scriptTag.setAttribute('src', 'https://holidaycheck.github.io/hc-live-chart-component/HcChart.js')
    document.head.insertBefore(scriptTag, document.head.childNodes[0]);
  })();
</script>
{% endraw %}






[1]: https://www.w3.org/TR/hr-time-2/#dfn-time-origin
[2]: https://www.w3.org/TR/2019/WD-resource-timing-2-20190424/#sec-performanceresourcetiming
[3]: {% post_url 2019-05-06-browsertools#1-resource-timing-part1 %}

*Main photo by <a href="https://unsplash.com/photos/MmPamQEr-ec?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Michelle Rosen</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a><br />
