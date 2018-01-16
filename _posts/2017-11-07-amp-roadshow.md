---
layout: post
title:  "AMP Roadshow in Munich"
date: 2017-11-07 23:03:00 +0200
categories: event
author_name: Wolfram Kriesing
author_url : /author/wolframkriesing
author_avatar: wolframkriesing
read_time : 7
show_related_posts: false
square_related: recommend-wolf
feature_image: posts/2017-11-amp-roadshow/road.jpg
---

Google invited [lots of developers][devs-tweet] to the [AMP Roadshow][amp-roadshow] that they are currently doing worldwide.
We joined the Munich edition in their offices. 
Google does that to promote their technology [AMP][amp]. Now it was on us to figure out
if AMP could add value for HolidayCheck.
I personally only knew the 10.000 feet view of AMP, which basically is what the abbreviation 
stands for: "Accelerated Mobile Pages". But I learned quickly that it was not just about mobile.
It was about fast web sites that are also responsive, serving any device's dimension.

[devs-tweet]: https://twitter.com/wolframkriesing/status/927820303270662144
[amp-roadshow]: https://www.ampproject.org/amp-roadshow/
[amp]: https://www.ampproject.org/

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="en" dir="ltr">Just kicked off the <a href="https://twitter.com/hashtag/amproadshow?src=hash&amp;ref_src=twsrc%5Etfw">#amproadshow</a> Munich, and the room is packed! Great to see so many of you here. <a href="https://t.co/Y5pwzssvyz">pic.twitter.com/Y5pwzssvyz</a></p>&mdash; Paul Bakaus (@pbakaus) <a href="https://twitter.com/pbakaus/status/927828722572562433?ref_src=twsrc%5Etfw">November 7, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## Intro

When I arrived at 9:00 and saw already about twenty people waiting and I thought I was late. But actually the event didn't start until 9:45 with about 120 people. Many people from the huge Munich community showed up. Maybe the Google food was attracting the people :). Ah no, AMP was the topic. So it was rather topics like SEO, ads, fast websites and the expected profit for ones business that made the people come. I guess.

<div style="float: left; padding: 1rem;">
<img src="{{site.baseurl}}/img/posts/2017-11-amp-roadshow/1-intro.jpg" alt="some numbers" width="100" class="sizeup-onhover-image scale3 origin-left-top" />
<br/><em>Some numbers</em>
</div>

The official part was opened by a short five minutes "hello" and sales intro.
Later [Paul Bakaus][paul], developer evangelist for the AMP team, started the day by setting the stage for AMP, showing some numbers and aligning everyone on the problem that AMP tries to solve: fast websites. He mentioned that there are already about 4 billion AMP pages out there and 90 new ones pop up every second. That was impressive to hear. Supporting the AMP story and stating the well-known facts that decreasing a page load times improve conversion rates made everyone want to know more. What caught my attention was the statement that AMP is just a library. Now you got my ear, I am a developer and a library sounds usable to me.

[paul]: https://twitter.com/pbakaus/

## AMP Technically

<div style="float: right; padding: 1rem;">
<img src="{{site.baseurl}}/img/posts/2017-11-amp-roadshow/2-amp-is.jpg" alt="Overview" width="100" class="sizeup-onhover-image scale3 origin-right-top" />
<br/><em>Overview</em>
</div>

Next, Raghu told us about some of the technology inside AMP. When he said that AMP is a [web components] library I was [all ear][tweet-1], since that is the thing I am currently learning and evaluating. The later discussion with Paul also made me understand that AMP's approach to web components has a focus on fully controlling the web site's loading and rendering behavior (as far as possible) and not on providing (UI) components in the first place. That [took me a little][tweet-2] to understand. But in the AMP context it makes sense.

AMP re-implements many DOM elements we know from HTML, that interact with "slow" external dependencies, such as images (and rendering them). AMP focuses on optimizing the user experience, which is rendering speed to name the most important one. For example in AMP you use `<amp-img>` instead of `<img>`. The custom elements `<amp-youtube>`, `<amp-video>` and `<amp-twitter>` make it very obvious what AMP wants to control: the loading pipeline of anything that might make the rendering slow. There are various extensions though, so there might be many even more customized elements that can be used with AMP.

While the reasoning behind it and the techniques used make a lot of sense, AMP also limits the web site features one can use. Because if you want your site to be a valid AMP site you need to run it against the [AMP validator][amp-validator], which checks the site to fulfill certain criteria, for example that all CSS must be inlined and must not be exceed 50kB.

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="en" dir="ltr">I’d rephrase: <a href="https://twitter.com/AMPhtml?ref_src=twsrc%5Etfw">@AMPhtml</a> leverages Web Components to enable everyone to declaratively markup complex(-ish) fast HTML widgets.</p>&mdash; Thomas Steiner 🦖🎗 (@tomayac) <a href="https://twitter.com/tomayac/status/929657825286029312?ref_src=twsrc%5Etfw">November 12, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

[web components]: https://www.webcomponents.org/
[tweet-1]: https://twitter.com/wolframkriesing/status/927825238766882818
[tweet-2]: https://twitter.com/wolframkriesing/status/927835789404319744
[amp-validator]: https://validator.ampproject.org/

## AMP in Production

<div style="float: left; padding: 1rem;">
<img src="{{site.baseurl}}/img/posts/2017-11-amp-roadshow/3-in-prod.jpg" alt="amp in production" width="100" class="sizeup-onhover-image scale3 origin-left-top" />
<br/><em>AMP in production</em>
</div>

After the basics, the "why" and "how" of AMP, [Rudy][rudy] went to show us about how to get AMP live. Three basic steps he talked about 1) Validate 2) Distribute and 3) Measure. After an AMP page ran through the validator it can be put into production. Afterwards the measuring part is an important one. Some sites need only simple page view tracking, others even want A/B tests. AMP tries to serve them all. There is a `<amp-analytics>` custom element that unifies the analytics work under one hood. It basically serves as a proxy on the client, I assume it has a fixed set of tracking data that it collects and does then spread it to the configured backends (analytics provider). This allows AMP to do the tracking and not every tracker to bring its own code, polute your site and potentially crash it.
For the A/B testing `<amp-experiment>` can be used. As far as I have understood it's still limited and there might be complex scenarios that it doesn't serve yet.

[rudy]: https://twitter.com/rudygalfi/

## AMP and Ads

As you can see in the [first commit][amp-first-commit] of the AMP project, ads were in there since the beginning. Which is of course not surprising for a company that makes most of it's revenue with ads. In current websites ads are often a big slow down factor. It makes sense to tackle this problem. As with the analytics mentioned above AMP also provides strategies to deal with ads.

<div style="float: left; padding: 1rem;">
<img src="{{site.baseurl}}/img/posts/2017-11-amp-roadshow/4-ads-on-amp-pages.jpg" alt="Ads on AMP pages" width="100" class="sizeup-onhover-image scale3 origin-left-top" />
<br/><em>Ads on AMP pages</em>
</div>

There are two ad strategies with AMP: 1) ads on AMP pages and 2) ads written in AMP. 
The first one is the "simple" strategy, where you know the ad's size upfront and embed the ad using `<amp-ad>`. Doing this allows the page size to be determined upfront and won't make the site jump once the ad is loaded.

<div style="float: right; padding: 1rem;">
<img src="{{site.baseurl}}/img/posts/2017-11-amp-roadshow/5-ads-in-amp.jpg" alt="Ads written in AMP" width="100" class="sizeup-onhover-image scale3 origin-right-top" />
<br/><em>Ads written in AMP</em>
</div>

The other ad strategy is to build ads using AMP. Which means building your ads yourself by just using AMP elements.
Which will ensure the ad to be built with the speed that AMP tries to ensure. The embeddability is another factor, which is another of the unique selling points of AMP.

[amp-first-commit]: https://github.com/ampproject/amphtml/commit/5f414868caf5f431ebe64f840d6b1de6464085c4
[ben]: https://twitter.com/benmorss

## How to AMP?

Finally that leaves us with one question: Do I need (to care about) AMP at all?

I think (at least) web developers should care, since AMP is also kind of a instructions
manual to learn about fast web pages. If AMP as technology is important to your project and/or
business, that is a more complex question that does also require insight in your market
and how your project/business makes money. And last but not least you want to look at the
invest and the future risk that AMP might bring. So, it's the usual answer: "it depends".
I think there is no way around spending some time and effort in finding out if AMP might
add value.

One thing I believe, there are three potential strategies forward when you want or need to decide if you want to do AMP.

1. Don't do AMP (but use it to learn about web site speed)
1. Do an AMP-only page
1. Build a layer on top of AMP and the "normal" web site

Let's keep speeding up our web sites, anyways.