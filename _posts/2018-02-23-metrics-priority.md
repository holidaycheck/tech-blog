---
layout: post
title:  "Backlog Prioritzing (Bot)"
date: 2018-02-23 12:45:00 +0200
categories: product
author_names: [ "Sergii Paryzhskyi", "Wolfram Kriesing" ]
read_time : 10
show_related_posts: false
square_related:
feature_image: posts/2018-02-23-metrics-priority/poster.jpg
---

Working in small iterations, being data-driven, user-input driven or simply lean is our ideal
style of working. And it is awesome when this works. But there are also other situations where
we have a big pile of work ahead of us that we need to sort out somehow. If it is a huge backlog
with ideas, some tasks that "just need to be done" or whatever the reason is that makes us
have lots of things on our plate (or in our backlog), we want to get them done efficiently.

In this post we will describe one way of how we started to prioritize our tasks.
Starting from actual metrics that we want to improve, we collected actions that we can do
and next we needed to figure out how to sort the actions to achieve an impact sooner.

## What's the problem?

Our exact case was the page speed. We are working on speeding up our website, which might have
a great impact, [as][impact-1] [many][impact-2] [numbers][impact-3] [show][impact-4].
The reason why to work on website speed is not questionable.

Next we need numbers, so we setup tools that help us steadily figure out our numbers, such
as TTFB (time to first byte) and TTI (time to interactive). We also measured the file sizes of the 
downloads (JavaScript files, CSS, images, ...) needed to render our website.
We setup a continuous measuring for it, which reports numbers and shows our progress.

[impact-1]: ??? 
[impact-2]: ???
[impact-3]: ???
[impact-4]: ???

## We have Metrics, What now?

We know our current numbers. Next we needed to find a way to figure out the potentials we have
in certain areas. For example, TTFB of 1.5s might be a great number, but we don't know. So
we figured out what to compare this number too (there are many ways to do that). Let's say in this case
we saw there is about 10% by which we can improve this number (to 1.35 seconds).

We look at the actions that we can take in order to speed up this metric.
There are many ways to figure out what to do. Once we derived ten actions
we still had no clue which one to do first. So we need some numbers that we can use to decide
what we shall work on.

Why? Because the plan and the reality always diverge and we won't get all ten actions done. So let's
try to plan for being most effective as soon as possible. Let's not plan the ten actions
and just work on them in alphabetical order. But let's figure out which one has
the most impact soonest and lets start with it. We could come up with a million
reasons why after the third action we will not continue on the next seven actions, so
let's make sure the first the actions are sorted to move this topic as far as possible.

## How to sort the Actions

Above we explained that we have the following facts:
- **the potential** (here 10%) by which we can improve our metrics
- ten **actions** that might improve our metric.
- **many metrics** with a potential to improve

Our one metric TTFB is only part of what contributes to our overall goal, the website speed.

Next:
- figure out potential per actions (might be an experiment)
- figure out effort
- determin weight
- fianlly calculate the priority

* Details of Solution
  - bot automation (abstract)

* Details of Bot automation
  - idea
  - tech stuff
  - link to app + promotion
  - gif demo
  - open to everyone

* Conclusions