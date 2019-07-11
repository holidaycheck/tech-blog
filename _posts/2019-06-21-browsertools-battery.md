---
layout: post
title: "The Battery Status API"
date: 2019-06-21 12:0:00 +0200
categories: browsertools
author_name: Maša Reko
author_url : /author/masareko
author_avatar: masareko
read_time : 4
excerpt: 
feature_image: posts/2019-06-21-browsertools-battery/header.jpg
---

Did you know that you can use JavaScript to obtain information about your battery's current charge level and status? <span id="loading-failed"> For example, your device is currently <span id="charging">??</span> charging and your battery level is at <span id="battery-level">??</span>%. How did I know that? Stay tuned to find out!</span>

In this post, #[insert-number-here] in the [category Browsertools](../../../../category/browsertools/), we take a look at the __Battery Status API__, show how it can be used, provide some ideas on where it can come in handy, as well as explain how its wrong usage has led to many privacy issues in the past years.

The specification defines the Battery Status API as ["means for web developers to programmatically determine the battery status of the hosting device"](https://www.w3.org/TR/battery-status/). It is a very simple API that provides you with battery's charge details, as well as the possibility to get notified whenever a change happens.

{% raw %}
<script type="text/javascript">

const __updateInlineStats__ = () => {
  try {
	navigator.getBattery().then(battery => {
		if (battery.charging) {
			document.querySelector(`#charging`).textContent = "";
		}
		else {
			document.querySelector(`#charging`).textContent = "not";
		}
		document.querySelector(`#battery-level`).textContent = battery.level * 100;
    });
  } catch (e) { 
	document.querySelector(`#loading-failed`).remove();
  }
}

__updateInlineStats__();
</script>
{% endraw %}

## Battery Manager Interface

The `BatteryManager` interface represents the current battery status information of the hosting device.

We can access it through the `Navigator` object, using a function `getBattery()`. This function returns a promise that eventually resolves to a `BatteryManager` object, containing the following attributes:

* `charging`: the charging state of the battery (`true` if the device is charging, `false` otherwise)
* `chargingTime`: the time remaining until the battery is fully charged (in seconds)
* `dischargingTime`: the time remaining until the battery is dead (in seconds)
* `level`: the level of the battery (between 0.0 and 1.0)

All these attributes have corresponding event handlers, to monitor any changes that might occur, namely: `onchargingchange`, `onchargingtimechange`, `ondischargingtimechange` and `onlevelchange`.

Here is an example of how these can be used:

``` javascript
navigator.getBattery().then(battery => {
    // log the current charging state
    console.log(battery.charging);
    // get notified for all future changes
    battery.onchargingchange = () => {
        console.log(battery.charging);
    };
});
```

## Usage

So what can we use this information for? The whole idea behind a Battery Status API was to help the developers in building power-aware and therefore power-efficient applications, in order to provide a better experience for the users.

Here are some examples on how this can be done:

* Have the app use less resources when the battery level is low (no high-resolution images, videos, animations, advertisements, etc.) - either don't load them at all or load alternative smaller resources
* Prevent data loss by saving the changes when the battery is about to die
* Warn the users that a process they are about to start is very power-intensive and that their current battery level may not be enough for it
* Reduce the amount of light on the screen when the battery level is low, by switching to a darker color palette
* Lower the Geolocation accuracy
* Reduce background task intervals
* Decrease network activity
* And many others...

## Issues

Despite being standardized and a part of the HTML5 specification, the Battery Status API is now unfortunately only available on Google Chrome. While IE, Edge and Safari never even implemented it, Firefox removed it in 2017 due to privacy issues.

What Firefox discovered, led by its privacy & security expert __Lukasz Olejnik__, is that the developers hadn't really been using the API in the manner it was intended. Olejnik explained his findings in a [research paper](http://lukaszolejnik.com/battery.pdf) published in 2015. 

Namely, he explained how the API can be used to monitor the users' behavior, such as the frequency at which they charge their devices, or detecting the times when the device was heavily used. But that's not all: given that the information obtained from the API is relatively static (it changes slowly), it can even be used as a short-term identifier! This means that if the user revisits a website within a short interval, even if browsing in private mode, or having previously cleared cookies, the battery level and charge/discharge times can be used to determine that it is, in fact, the same user accessing the website! 

And if that wasn't enough, some companies have abused the API for gaining more money, as users are generally prone to paying more for a service if their battery is about to die.

## Finally

Even though the Battery Status API is not too widely supported by the browsers, it can still be a very useful tool for optimizing your website and adapting it to different device power levels of your users. However, it is known to cause privacy issues if used in an illegitimate way. With that said, this API stands as a good example of how even the most unlikely mechanisms can have unforseen and drastic consequences on the users' privacy. 