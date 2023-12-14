---
layout: post
title: "Our previous experiments with augmented reality (AR) in travel applications"
date: 2023-12-11 00:00:00 +0200
categories: javascript motivation product
author_name: Adrian Schmid
read_time: 5
feature_image: posts/2023-12-11-augmented-reality-in-travel-applications/augmented-reality.jpg
---

Since its inception, HolidayCheck has thrived on user-generated content (UGC), which remains our cornerstone. Our commitment to elevating this UGC experience continually drives us to innovate for our holidaymakers. In this spirit, we've been exploring fresh avenues, such as integrating interactive, geo-based experiences accessible right from the browser. This exploration opens many possibilities, like offering immersive hotel room previews, comprehensive travel guides, and more to enrich the traveler's journey with us.

## AR with geolocalization in browsers

Fast and pragmatic MVP development on smartphones requires a robust and feature-rich toolkit. [Apple's ARKit](https://developer.apple.com/augmented-reality/arkit/) and [Google's ARCore](https://developers.google.com/ar?hl=en) came into question to support native hardware (i.e. the camera in our case) in the best possible way. Nevertheless, I opted for [AR.js](https://github.com/AR-js-org/AR.js), a browser-based solution, due to its simplicity in terms of quick setup and speed of experimentation. At the time, December 2021, the framework was already 2 years in the making, and quite mature.

Even though I was never a fan (and user) of Pokemon Go, many people are familiar with the app that allowed you to use the real world as a game map to catch your Pokemon. But since our Urlaubers are more interested in sightseeing when they travel, I wanted to develop an interactive camera that shows exciting places nearby.

## The setup

Experiments have a great advantage: you can start a greenfield project. An option that is not always available to developers. In my case, I opted for the following simple setup:

- A simple HTML file containing AR.js markup. We will go into this in more detail in the next section.
- A JSON: two representative locations to the left and right of my apartment at the time with geo-coordinates coming from our database with over 173,000 POIs: [Augsburg City Hall](https://www.holidaycheck.de/pi/rathaus/24e3daee-7218-3ff1-8111-613f11d0dbc4) and the [Fuggerei](https://www.holidaycheck.de/pi/fuggerei/7a9ada69-b008-31af-8361-0e12f2d62158). What a great way to get to know my home town!
- A JavaScript function: To load nearby places and enrich them with some data.
- A simple express server: To deliver the HTML. Why? Because I don't want to run around with my laptop. The app should be accessible from my iPhone.

## Initialize the camera in the browser

For an executable version, you only need markup — no code (except for the AR.js library). The location-based camera needs a scene to which it must be added to work. It looks like this:

```html
<a-scene
  raycaster="objects: [gps-entity-place];"
  arjs="sourceType: webcam;"
  embedded
>
  <a-camera gps-camera rotation-reader></a-camera>
</a-scene>
```

Let's take a look at the attributes:

- `raycaster`: We want to interact with places. To do this, we need to render 3D objects. Under the hood, [AR.js uses Three.js](https://ar-js-org.github.io/AR.js-Docs/ui-events/) for this.
- `arjs`: Sure, we have to initialize the scene. We also specify `sourceType: webcam` to ensure that the smartphone camera is used as well.

For `a-camera` we need `gps-camera` to activate [Location AR](https://ar-js-org.github.io/AR.js-Docs/location-based#camera-component-gps-new-camera-gps-projected-camera-or-gps-camera) and `rotation-reader` to actively track the position when the camera is rotated. This way, we know where the user is pointing their device.

The app is now ready to be tested for the first time via the smartphone browser. To do this, we start the server and call up the IP of my machine. Once access to the camera has been granted, a red camera appears in the address bar:

<figure>
    <img src="img/posts/2023-12-11-augmented-reality-in-travel-applications/iphone-status-bar-while-recording.png" alt="iPhone status bar while recording" class="centered" />
    <figcaption>The status bar of my iPhone while recording in Safari.</figcaption>
</figure>

## Interact with remote locations

First of all, we need our own location. To get our current geo-position, we use the [Navigation API](https://developer.mozilla.org/en-US/docs/Web/API/Navigation_API). We now use the callback from `getCurrentPosition` for our further logic:

```js
Navigator.geolocation.getCurrentPosition((position) => {
  // the logic
});
```

To mark locations visually on the camera, we make use of an `a-box`, which we add to the DOM. With the help of attributes, we can determine its position. We also determine what is rendered. For the first test, I simply opted for blue bars. To inform the scene about the location, we dispatch the event `gps-entity-place-loaded`.

```js
const icon = document.createElement("a-box");
icon.setAttribute(
  "gps-entity-place",
  `latitude: ${latitude};longitude: ${longitude}`
);
icon.setAttribute("name", place.name);
icon.setAttribute("width", "100");
icon.setAttribute("height", "35");
icon.setAttribute("material", "color: #0e55cd");

icon.addEventListener("loaded", () =>
  window.dispatchEvent(new CustomEvent("gps-entity-place-loaded"))
);
```

We have already created dynamics: The locations are rendered in the camera, during the movement. The only thing missing is interaction.

We want the user to be shown the name of the point of interest and its distance from the current location (which we have calculated beforehand) when they click on the object:

```js
icon.addEventListener("click", (e) => {
  e.stopPropagation();
  e.preventDefault();

  const location = e.target;
  const locationName = location.getAttribute("name");

  alert(locationName + "\nDistance: " + distance + " meters");
});
```

The majority is once again: HTML. Therefore, we must now add the `a-box` elements to the scene:

```js
const scene = document.querySelector("a-scene");
// ...
scene.appendChild(icon);
```

And this was the first working version:

<figure>
    <video controls rc="https://media-cdn.holidaycheck.com/video/upload/v1702298405/videos/blog/elfarxu9nrcjkjpemvvg.mp4"></video>
    <figcaption>The first version of the interactive camera with blue blocks marking the position of the location.</figcaption>
</figure>

Admittedly, this doesn't look very appealing. But it shows very well how the different locations are displayed in terms of size. While the Fuggerei is closer to my current location, it appears larger than the town hall, which is shown smaller because it is further away. That's super cool!

<figure>
    <video controls rc="https://media-cdn.holidaycheck.com/video/upload/v1702298408/videos/blog/yhjwymyfd2mtoh8sazn6.mp4"></video>
    <figcaption>The second version of the interactive camera, which renders the name and a picture of the location.</figcaption>
</figure>

## Conclusion

This experiment was more of an opportunity to broaden my horizons and test something new, to play with it. Doing this in a product context made it even more exciting.

Fast-forward 2 years, through our explorations at HolidayCheck, we've seen firsthand how the synergy of AI and AR can revolutionize travel experiences. In this context, I would also like to thank Konark Modi, who, with his expertise in AI, is always on the lookout on how technology can further help our Urlaubers.

Our geo-based camera app is just the beginning. As we continue to blend AI with AR, we're expanding our technological horizons and paving the way for a new era of personalized and immersive travel. Join us in this exciting journey to reshape the future of travel.

For those interested in contributing to this innovative field, check out our [career opportunities](https://holidaycheck.jobs.personio.de/?language=en).
