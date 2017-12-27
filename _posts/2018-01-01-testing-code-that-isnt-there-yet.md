---
layout: post
title:  "Testing code that isn't there yet"
date: 2018-01-01 10:10:10 +0200
categories: testing
author_name: Jacek Smolak
author_url : /author/jaceksmolak
author_avatar: jaceksmolak
show_avatar : true
read_time : 8
show_related_posts: false
square_related:
feature_image: posts/2017-10-22-jbhc17-from-my-perspective/poster.jpg
---

It's relatively easy to test a piece of code that is already there.
Stub dependencies, check calls, returned values. Voilà, there you have it.
But what about a code that is not there yet?

## TDD

We've all heard about it. Make it red, make it green, step back, have a look, refactor. Repeat the whole process.
Easy to say. But it's also a big step to make for some.

It's also very tempting to write some amount of code, just to have a thing to grasp, a point to start from.
In this post I would like to show you how to start testing without any code upfront, so that you can get
comfortable with TF (test first) approach as well.

## Know what you want in `return`
