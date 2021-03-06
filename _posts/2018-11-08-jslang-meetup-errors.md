---
layout: post
title:  "#jslang Meetup - Errors"
date: 2018-11-08 20:03:00 +0200
categories: event
author_name: Wolfram Kriesing
author_url : /author/wolframkriesing
author_avatar: wolframkriesing
read_time : 4
show_related_posts: false
square_related: recommend-wolf
feature_image: posts/2017-06-jslang/post-header.jpg
---

In our offices we have a monthly meetup, which is all about JavaScript language features,
we call it "JavaScript The Language" (see twitter [#jslang][jslang-twitter]). 
We pick one language feature and by writing tests for each piece of the feature we step by step
explore the feature in depth.

## The plan

The plan for the meetup was to:

1. Collect items that we want to learn about JavaScript Errors
1. Write tests to learn, verify and describe some Error properties. 

## How we ran the meetup

We organized the meetup on [meetup.com][meetup].

## Onsite

We started by introducing each other shortly.
Then we did 1. and collected items. We came up with this:
* TypeError, RangeError, ...
* async await
* Promise handling
* properties and methods,
* assert
* catching 
* extend Error
* Error() as a function
* stacktrace

We started by trying out how to cause a TypeError or RangeError. We fiddled around a bit
and figured out that reading up on [MDN][mdn-error] helps us to understand better what
we need to do to cause errors. Of course accessing `[][0]` the first elements of an empty
array does not trigger a RangeError, as we assumed first. But in the end we found out
how to trigger RangeError and TypeError (see the [tests]) and so on. The funny thing
was that now, we looked much more closely on what error our tests throw and we learned
a lot just from failing tests. Of course we also read into the [spec] a little bit.

Along the way we also dug into `undefined`, arrays, `JSON.stringify` and others.
We covered some of the things that we had listed at the beginning of the session, but
as usual we didn't cover it all. 

My personal impression was that it was a good evening. I was afraid that we would not
have enough things to explore around errors and that we would sit around being bored
or finding artificial tasks, but that was not the case by far. Instead we learned quite
some things about errors and touched on some other topics too.
That is what I like about those meetups, you never know how it goes and the people
who are there drive it, which makes it unique every time.
Thanks to the participants for a great evening. 

## Planning the next Meetup 

At the end of every meetup we collect a set of language features which we vote on to
determine the next meetup's topic. This time we collected some topics while writing
our code during the meetup, this is the list we came up with:
* Array
* Symbol
* Proxy
* async errors
* SharedArrayBuffers and Atomics

As you can see here the [next meetup][next-meetup] will be about Proxies.

[mdn-error]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error
[tests]: https://gitlab.com/wolframkriesing/jslang-meetups/tree/master/errors-2018-10-18/error.spec.js
[meetup]: https://www.meetup.com/JavaScript-The-Language/events/254796389/
[next-meetup]: https://www.meetup.com/JavaScript-The-Language/events/255646068/
[spec]: https://tc39.github.io/ecma262/#sec-error-objects
[jslang-twitter]: https://twitter.com/search?f=tweets&vertical=default&q=%23jslang&src=typd
