---
layout: post
title: "Resource Timing (part 2) - Loading Dependencies"
categories: browsertools
author_name: Wolfram Kriesing
author_url : /author/wolframkriesing
author_avatar: wolframkriesing
read_time : 4
feature_image: posts/2019-06-08-browsertools-2/ben-harritt-75854-unsplash.jpg
---

This is post #2 in the [category "Browser Tools"][0], focusing on understanding Loading Dependencies. In [part 1 about ResourceTiming][3] we looked at the attributes `responseEnd` and `startTime`. Now we want to go a bit deeper and look at how the tools allow us to understand the dependencies of the loaded resources.

For doing so we are using the `Resource Timing API`, which allows to gather information about resources our site loads. This is done by using the `Performance API` accessible via JavaScript using `window.performance`. Here we will explore how much details we can gather about each resource that is loaded (JS files, CSS files, fetches, etc.). Especially about their timing and dependencies.

## Setting the Context

Let's shortly sum up how we gather those data. There is a built-in functionality that you see in action, right here:

```js
> window.performance.getEntriesByType('resource')
```

```js
[{
    // ... shortened
    name: "http://techblog.holidaycheck.com/css/main.css",
    initiatorType: "link",
    startTime: 18.41499999864027,
    // ... shortened
}, {...}]
```

As you can see above `window.performance` provides these data right in the browser. If you want to understand more details read [part 1][3].

From here on we will take apart some of the data and make sure we understand what they mean.

## The `startTime` Attribute

The spec says that the attribute `startTime` is ["the time immediately before the [browser] starts to queue the resource for fetching"][2]. This means, e.g. if the browser is about to load the HTML page the `startTime` is recorded. This time is relative from ["the time when the browsing context is first created"][1]. In other words when the browser starts loading a new page. So this is a very browser-internal thing, that we would not be able to get access to without extending the browser itself. That proves that this API can give us insights which we could not be able to obtain otherwise, especially not on any website itself. These numbers are also way more explicit in regards to what the user expriences.

A `startTime` of 0 is the moment when the browsing context was created, when the browser started loading this page. This is for example a website reload, or navigating to a new site, opening a tab with a certain URL and alike. That means a `startTime=20` means 20 milliseconds after the browser context was created. Having a timestamp relative to the browser context creation allows us to get insights on our resource timings without any timestamp offset calculations, as we used to do using `Date.now()` (more in the [previous post][3]).

Let's look at some real life numbers:

<figure id="chart-1">
    <figcaption>The "startTime" for all resources requested by this page</figcaption>
    <hc-chart id="waterfall-chart-1" style="height: 350px;"></hc-chart>
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

Hint: The chart above shows the real numbers of the page you are looking at, if you <a id="reload-link-1" href="{{ page.url }}?force-reload=0#chart-1">reload</a>, the numbers above may change (changes can be seen best on the x-axis scale).
{% raw %}
<script type="text/javascript">
  (() => {
    const anchor = document.querySelector('#reload-link-1');
    const href = anchor.getAttribute('href');
    const counter = +(new URL(location).searchParams.get('force-reload'));
    anchor.setAttribute('href', href.replace(/force-reload=\d+/, 'force-reload=' + (counter+1)));
  })()
</script>
{% endraw %}

In the chart one should see that some requests start at the same time. These requests have most probably been triggered by the same resource. For example the "main.css", the logo and the "main.js" files start to get loaded around the same time, as the first resources. This is because the HTML file that directly references them, triggers the loading of these files. The browser reads the HTML file, interprets it and finds `<link>` and `<script>` tags that reference those resources, so they start to get loaded, hence they have the lowest `startTime`. 

In the chart one can also see that the fonts start loading way later. This is because they are referenced inside the "main.css" file, which needs to be downloaded and read by the browser first to know that the according fonts need to get loaded. This way one can understand better how the browser handles the resources, in which order and also using which constraints to load them.

## The `initiatorType` Attribute

This attribute is the type that triggered this resource to be loaded. In the chart above one can see strings like `initiatorType: navigation`, `initiatorType: link`, `initiatorType: script` and others. There are basically two types of attributes, the `initiatorType` is either: 
1. The name of the HTML tag, the DOM node (or as the spec text says the ["value as the localName of that element [DOM], if the request is a result of processing the element"][4]),
  * this refers to attributes like `src` in a `<script src="resource.js">` tag, the `href` attribute in a `<link href="resource.css">` tag or the `src` atttribute of an `<img>` tag among others.
1. Or it is one of "css", "navigation", "xmlhttprequest", "fetch", "beacon" or "other" when the loading was not directly triggered by a DOM node,
  * these are things like loading a new page ("navigation"), loading a resource from within a CSS file ("css") or the request done via the native JavaScript `window.fetch()` method ("fetch").

This attribute gives a bit more context to the loading times and makes the loading dependencies talked about in the paragraph before easier to understand. A CSS file needs to be loaded by the browser, before it can know what other files are referenced inside of it and need to be loaded. This might also surface the question how much should be inlined, or if [preload][5] should be used to speed up website loading.

## Focus on the Dependencies

I hope this post allows to gather better insights and hopefully also decouple the dependencies among resources where accurate and therefore speed up the website. I tried to focus on just looking at the two attributes `startTime` and `initiatorType` so the loading dependencies become very obvious and in case it is what one wants to focus on, they might be a good start. 

This site is quite simple and therefore makes the dependencies easy to understand. If you try this out on a more complex page loading dependencies will also be a bit harder to identify. Have fun untangling your loading dependencies. Feel free to [share findings and insights with us on twitter][6].

You want to know more? Read [part 3 of this series about "Waterfall Chart"][7].

[0]: /category/browsertools
[1]: https://www.w3.org/TR/hr-time-2/#dfn-time-origin
[2]: https://www.w3.org/TR/2019/WD-resource-timing-2-20190424/#sec-performanceresourcetiming
[3]: {% post_url 2019-05-06-browsertools#1-resource-timing-part1 %}
[4]: https://www.w3.org/TR/2019/WD-resource-timing-2-20190424/#dom-performanceresourcetiming-initiatortype
[5]: https://html.spec.whatwg.org/multipage/links.html#link-type-preload
[6]: https://twitter.com/holidaychecklab
[7]: {% post_url 2019-06-15-browsertools#3-waterfall-chart %}

*Main photo by <a href="https://unsplash.com/photos/4W92z8cNQ_c?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Ben Harritt</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a><br />

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

