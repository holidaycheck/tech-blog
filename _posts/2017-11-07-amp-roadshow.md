---
layout: post
title:  "AMP Roadshow in Munich"
date: 2017-11-07 23:03:00 +0200
categories:  
author_name: Wolfram Kriesing
author_url : /author/wolframkriesing
author_avatar: wolframkriesing
show_avatar : true
read_time : 3
show_related_posts: false
square_related: recommend-wolf
feature_image: posts/2017-11-amp-roadshow/road.jpg
---

Google invited lots of developers to the [AMP Roadshow][amp-roadshow], that they are currently doing worldwide.
We joined the Munich edition in their offices. 
Google does that to promote their technology [AMP][amp]. Now it was on us to figure out
what value could AMP add for HolidayCheck.
I personally only knew the 10.000 feet view of AMP, which basically is what the abbreviation 
stands for: "Accelerated Mobile Pages". But I learned quickly that it was not just about mobile.
It was about fast web sites that are also responsive, serving any device's dimension.

[amp-roadshow]: https://www.ampproject.org/amp-roadshow/
[amp]: https://www.ampproject.org/

## Intro

When I arrived at 9:00 and saw already about twenty people waiting and I thought I was late. But actually the event didn't start until 9:45 with about 120 people. Many people from the huge Munich community showed up. Maybe the Google food was attracting the people :). Ah no, AMP was the topic. So it was rather topics like SEO, ads, fast websites and the expected profit for ones business that made the people come. I guess.

<div style="float: left; padding: 1rem;">
<img src="{{site.baseurl}}/img/posts/2017-11-amp-roadshow/1-intro.jpg" alt="some AMP numbers" width="100" class="sizeup-onhover-image scale3 origin-left-top" />
<br/><em>AMP, some numbers</em>
</div>

The official part was opened by a short five minutes "hello" and sales intro.
Later [Paul Bakaus][paul], developer evangelist for the AMP team, started the day by setting the stage for AMP, showing some numbers and aligning everyone on the problem that AMP tries to solve: fast websites. It was said that there are already about 4 billion AMP pages out there and 90 new ones pop up every second, that was impressive to hear. Supporting the AMP story and state the well-known facts that decreasing a page load times improve conversion rates made everyone want to know more. What caught my attention was the statement that AMP is just a library. Now you got my ear, I am a developer and a library sounds usable to me.

[paul]: https://twitter.com/pbakaus/

## AMP Technically

<div style="float: right; padding: 1rem;">
<img src="{{site.baseurl}}/img/posts/2017-11-amp-roadshow/2-amp-is.jpg" alt="Rough AMP overview" width="100" class="sizeup-onhover-image scale3 origin-right-top" />
<br/><em>Rough AMP overview</em>
</div>

Next, Raghu told us about some of the technology inside AMP. When he said that AMP is a web components library I was [all ear][tweet-1], since that is the thing I am currently learning and evaluating. The later discussion with Paul also made me understand that AMP's approach to web components has a focus on fully controlling the web site's beahvior and not on providing (UI) components in the first place. That [took me a little][tweet-2] to understand. But in the AMP context it makes sense.

AMP re-implements many DOM elements we know from HTML, that interact with "slow" external dependencies, such as loading images (and rendering them). AMP focuses on optimizing the user experience, which is rendering speed to name the most important one. For example in AMP you use `<amp-img>` instead of `<img>`. The custom elements `<amp-youtube>`, `<amp-video>` and `<amp-twitter>` make it very obvious what AMP wants to control: the loading pipeline of anything that might make the rendering slow. There are various extensions though, so there might be many even more customized elements that can be used with AMP.

While the reasoning behind it and the techniques used make a lot of sense, AMP also limits down the possibility of what one can use. Because if you want your site to be a valid AMP site you need to run it against the [AMP validator][amp-validator], which checks the site to fulfill certain criteria, for example that all CSS must be inlined and must not be exceed 50kB.

[tweet-1]: https://twitter.com/wolframkriesing/status/927825238766882818
[tweet-2]: https://twitter.com/wolframkriesing/status/927835789404319744
[amp-validator]: https://validator.ampproject.org/

## AMP in Production

<div style="float: left; padding: 1rem;">
<img src="{{site.baseurl}}/img/posts/2017-11-amp-roadshow/3-in-prod.jpg" alt="amp in production" width="100" class="sizeup-onhover-image scale3 origin-left-top" />
<br/><em>AMP in production</em>
</div>

After the basics, the "why" and "how" of AMP, [Rudy][rudy] (???????? was it Rudy?????????) went to show us about how to get AMP live. Three basic steps he talked about 1) Validate 2) Distribute and 3) Measure. After an AMP page ran through the validator one wants to take it live. When this comes up the measuring part is an important one. Some sites need only simple page view tracking, others even want A/B tests. AMP tries to serve them all. There is a `<amp-analytics>` custom element that unifies the analytics work under one hood. It basically serves as a proxy on the client, I assume it has a fixed set of tracking data that it collects and does then spread it to the configured backend (analytics provider). This allows AMP to do the tracking and not every tracker to bring its own code, polute your site and potentially crash it.
For the A/B testing `<amp-experiment>` can be used. As far as I have understood it's still limited and there might be complex scenarios that it doesn't serve yet.

[rudy]: https://twitter.com/rudygalfi/

## How to AMP?

I see three potential strategies forward when you want or need to decide if you want to do AMP.
1. Don't do AMP (but use it to learn about web site speed)
1. Do an AMP-only page
1. Build a layer on top of AMP and the "normal" web site

That brings one to the point where to ask: Do I need (to care about) AMP at all?




----------------------------in progress------------------------------


- bing, yahoo support amp pages

## What is AMP?

I will put that into my words. I understand that Google wants to tackle the big fight of speeding up
websites, which people like 

[first-commit]: https://github.com/ampproject/amphtml/commit/5f414868caf5f431ebe64f840d6b1de6464085c4

AMP is a set of HTML tags that 

- restricted
- no resizing of the visible viewport allowed
- core AMP JS library, the one that is blocking page layout
- an AMP box reserves its space on the page immediately (no loading of extra ressources needed)
- more concise DOM operations (more speedy)
- AMP does tracking/measuring ... and reports - using ONE script/code, no ad vendors

- AMP prerenders the "first search result"
- every AMP page runs the latest version of AMP (updated every week)

"The Google AMP Cache serves cached copies of valid AMP content published to the web."
https://developers.google.com/amp/cache/overview

[How AMP achieves its speed - Google I/O 2016][malte-on-amp]
[malte-on-amp]: https://www.youtube.com/watch?v=cfekj564rs0
[who-uses-amp]: https://www.ampproject.org/learn/who-uses-amp/


<div style="float: right; padding: 1rem;">
<img src="{{site.baseurl}}/img/posts/2017-11-amp-roadshow/4-ads-on-amp-pages.jpg" alt="" width="100" class="sizeup-onhover-image scale3 origin-left-top" />
<br/><em>loadStudent function flow</em>
</div>

<div style="float: left; padding: 1rem;">
<img src="{{site.baseurl}}/img/posts/2017-11-amp-roadshow/5-ads-in-amp.jpg" alt="" width="100" class="sizeup-onhover-image scale3 origin-left-top" />
<br/><em>loadStudent function flow</em>
</div>
