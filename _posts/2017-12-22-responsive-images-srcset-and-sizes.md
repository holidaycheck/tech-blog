---
layout: post
title:  "Responsive Images in HTML5: Srcset and Sizes"
date: 2017-12-22 09:11:00 +0200
categories: css
author_name: Martin Kreidenweis
author_url : /author/martinkreidenweis
author_avatar: martinkreidenweis
read_time : 7
show_related_posts: false
square_related:
feature_image: posts/2017-12-22-responsive-images-srcset-and-sizes/patricia-serna-colores-a-medida-415257.jpg
---

A long time ago Eric Portis wrote an [excellent article about "Srcset and sizes"][eric-article]. With funny pictures. 
I've been told it's too long though. Let me summarize.

## The Problem

We're building a "responsive" web site at HolidayCheck, meaning we deliver the same HTML and CSS to mobile and desktop browsers. Using CSS media queries the content is then formatted appropriately to fit our customer's screen size. So the same image will be displayed in different sizes, depending on the viewport size.
<br/>
And ever since Apple introduced its "Retina" displays, we have another dimension to look at: pixel density of the physical screen.

### Background: CSS Units

In the old days it was easy: `1px` in CSS was exactly one pixel on your monitor. We assumed that displays had a resolution of about 96 pixels per inch. But now we have to deal with device-pixel-ratios (DPRs): For backwards-compatibility `1px` in CSS might actually cover multiple physical pixels on your screen. [Devices][mydevice-io] have CSS dimensions that are different from their physical screen dimensions.

So for for a raster graphic (like PNG or JPG) we actually might want do deliver a 640x480 file, even if the CSS width of the image element is only `320px`.

### Variables Determining the Image File

In total we have four variables that should determine which picture file is to be loaded:

<table class="table">
    <tr>
        <th>Variable</th>
        <th>Developer knows during development</th>
        <th>Browser knows during page load</th>
    </tr>
    <tr>
        <td>Screen Pixel Density</td>
        <td><span class="glyphicon glyphicon-minus gi-5x"></span></td>
        <td><span class="glyphicon glyphicon-plus gi-5x"></span></td>
    </tr>
    <tr>
        <td>Viewport Size</td>
        <td><span class="glyphicon glyphicon-minus gi-5x"></span></td>
        <td><span class="glyphicon glyphicon-plus gi-5x"></span></td>
    </tr>
    <tr>
        <td>Image Display Size (as defined in CSS)</td>
        <td><span class="glyphicon glyphicon-plus gi-5x"></span></td>
        <td><span class="glyphicon glyphicon-minus gi-5x"></span> (only if being told)</td>
    </tr>
    <tr>
        <td>Image File Dimensions</td>
        <td><span class="glyphicon glyphicon-plus gi-5x"></span></td>
        <td><span class="glyphicon glyphicon-minus gi-5x"></span> (only if being told)</td>
    </tr>
</table>

Unfortunately with a simple old-fashioned `<img>` tag the browser doesn't know enough to chose the right file to download. <br/>
Fortunately, with HTML5 we can simply give the browser the missing information.


## Simple Solution: The `<img>` Tag

HTML 5 introduced the `<picture>` tag. However, for most responsive use cases this is actually not necessary.
We can instead just use two new attributes that have been added to the good old `<img>` tag: `srcset` and `sizes`.

By providing the two missing variables &ndash; image file dimensions and relative display sizes &ndash; the browser can then decide best what to use, depending on the physical resolution of the device, zoom level, and even network quality.

The reason we want to duplicate the image display size from CSS in the HTML is simply page speed: Browsers start downloading the images before having downloaded or parsed any CSS, just based on information in the HTML.

### The `srcset` Attribute

Provide a selection of image URLs with their respective physical pixel widths with the `srcset` attribute. It's just a comma-separated list of URLs and widths, like that:

```
srcset="small.jpg 320w, medium.jpg 800w, large.jpg 1920w"
```

### The `sizes` Attribute

The `sizes` attribute basically duplicates what we have in our CSS, to make it available before image download. So we need to put the width of the image in CSS units. If those differ depending on the viewport, the same media queries like in CSS can be used. For example:

Always 100% viewport width: `sizes="100vw"`

100% wide on mobile, 726px wide on tablets and 946px wide on larger viewports: `sizes="(max-width: 750px) 100vw, (max-width: 999px) 726px, 946px"`


## Antipattern: Explicit DPR

I often see explicit DPRs in image tags:
```
srcset="cat.jpg, cat@2x.jpg 2x, cat@3x.jpg 3x"
```
Don't do this! It doesn't actually give enough information to the browser to load the right image version. As it tells neither actual physical resolution of the image nor the intended display size, browsers cannot take the current viewport into account, only the physical density of the screen.<br/>
With complicated enough `media` conditions in `<source>` tags, manually selecting image URLs depending on DPR conditions, one can actually work around this. See [Eric's article][eric-article] for more details. (Or better don't. It's really super ugly.)


## "Art Direction" &ndash; when the `<img>` tag is not enough
Still, for ["art direction"][art-direction] (design or user experience considerations), it still makes sense to use `<picture>` and `<source>` tags with media queries. For example on [our destination pages][di-spanien] we use 4:3 images on tablet/desktop for beaches and points of interest, but 16:9 images on mobile, so that we have more space left for text on small screens.

Within the different source tags the `srcset` and `sizes` attributes should be used again, giving the physical image width and intended display sizes to the browsers. It works just like described above for `<img>` tags.


## Little Hack: Hide Images on Mobile

Sometimes we have images that really look nice on desktop and tablet viewports, but that just won't fit nor help on mobile device screens.

So we hide them with CSS: `display: none;`

Now they're hidden. But they're still downloaded! Browsers start downloading those images even before they might have the chance to look at any CSS. This is bad especially for mobile users who might be on slow, unreliable or expensive connections.

The [standard][hidden-images-issue] doesn't have a proper solution to deal with this.

An easy hack to do it anyway is using `data:` URLs, and `<picture>` tags. This is an example of "art direction" after all:

```html
<picture>
    <source srcset="data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs=" media="(max-width: 749px)">
    <source srcset="thumb80.jpg 80w, thumb150.jpg 150w, thumb360.jpg 360w" sizes="(max-width: 999px) 62px, 80px" media="(min-width: 750px)">
    <img src="thumb80.jpg" alt=""> 
</picture>
```

This doesn't load anything (no additional HTTP request) for screens less than 750 pixels width; instead an empty GIF image is shown, which can be hidden using CSS. 
And it lets the browser choose an appropriate file for displaying the image at 62 or 80 pixels width on larger screens.


## Summary &ndash; tldr

To provide different resolutions of the same image content just use an `<img>` tag with `srcset` with `sizes` attributes. `<picture>` and `<source>` are not necessary. 

In the `srcset` you provide a comma-separated list of image variants, providing the physical pixel width of each file next to the URL (postfixed with `w`).<br/> 
In the `sizes` you provide a comma-separated list of CSS sizes that you plan to show your picture in. Sizes are prefixed with media queries in parentheses. The last size without a media query is the default size.

```html
<img src="pool-946.jpg"
     srcset="pool-320.jpg 320w, pool-946.jpg 946w, pool-1920.jpg 1920w"
     sizes="(max-width: 750px) 100vw, 946px"
     alt="Hotel Pool" />
```

Browsers then have all the information available to chose the optimal image.

Only if you want to do "art direction", meaning you use different aspect ratios or even different image content depending on the browser viewport, then you need to use `<picture>` and `<source>` tags having `media` conditions.



[eric-article]: https://ericportis.com/posts/2014/srcset-sizes/
[mydevice-io]: https://mydevice.io/
[art-direction]: http://usecases.responsiveimages.org/#art-direction
[di-spanien]: https://www.holidaycheck.de/di/spanien/29ed38c7-75eb-362c-923e-4bab92dd0b22
[hidden-images-issue]: https://github.com/ResponsiveImagesCG/picture-element/issues/243
