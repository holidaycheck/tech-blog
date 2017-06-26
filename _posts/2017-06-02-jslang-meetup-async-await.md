---
layout: post
title:  "Async Function Kata at #jslang Meetup"
date: 2017-06-02 08:03:00 +0200
categories: meetup javascript kata
author_name: Wolfram Kriesing
author_url : /author/wolframkriesing
author_avatar: wolframkriesing
show_avatar : true
read_time : 6
show_related_posts: false
square_related: recommend-wolf
---

![airplane]({{site.baseurl}}/img/posts/2017-06-jslang/post-header.jpg)

The callback-hell times are long over. We have better tools now. But which of the new kids on the block do you want to 
play with? In this meetup, last night we tried out [async functions][async-funcs], also known by the name "async/await". 
It was a fun learning experience. Keep reading and get inspired.

## The meetup
["JavaScript The Language" #jslang][jslang-meetup] is a hands-on meetup just about the language JavaScript (as specified).
Not about any library,
framework or the latest programming techniques. You could argue that the language JavaScript has become kind of a
framework itself. The language changes as fast as those hipster frameworks.
But let's put that aside.

We focus on language features only. We try to get a handle on a specific feature. One at a time and we sharpen our knowledge
about this one feature for our tool belts. That's why this is a very hands-on meetup.
Also there are no talks or anything alike, just a short intro and then the crowd works together. All attendees are actively
participating, by coding, discussing or facilitating.
If you want to do something like that in your city too, just start a meetup. Use the katas, for example those that we solve
(we try to link them on the [meetup page][jslang-meetup-home]) or find one at [kata-log], and make it happen.

## Our Scope and the Kata
I announced the meetup about two weeks ago. There was no #jslang meetup since April 2016, for more than a year.
So I had to restart this meetup. The language JavaScript is moving forward and we need to keep up with what it offers.
Async functions are one of the most interesting things that is changing in the language. In order to understand 
them in the JS context I prepared a [short slide set summarizing the state the async functions feature][slides].
That was all of presentation we had. I set the context and introduced [the kata][kata] that we wanted to work on.
In the kata we want to combine two asynchronous functionalities, 1) getting the geolocation and 2) loading the 
(nearest) airports depending on that result.
The interesting part is actually not (only) the implementation but it already starts with the tests. Have you ever 
had trouble writing asynchronous tests? Do [this kata][kata] and practice even more!

## How we did it
We were twelve people at the event. After a quick show-hands we all agreed on setting up two mobs and solve the
problem by [mob-programming]. We had two mobs of 6 people each. Thanks to [Chris Neuroth][chris] who facilitated the
mob-programming for us. The most important rule I took away from it was, that the one sitting at the keyboard should
not act unless told to.

Both teams solved the first task, which was to implement the kata by using promises. This was the first
step in order to get familiar with the kata and also to feel the pain of using promises and test them properly. 
Every team had the ambition to write good tests, and boy they did. This took about one hour. After that
we took a five minutes break and did some physical activity, playing table tennis. The table tennis challenge was 
that we had to pass on one of the four rackets to the person who had none, while running around the table.
Back to the kata, the next step was to move the tests to use async+await keywords, which mostly replaces promises 
and makes tests more readable. But it has it's own challenges.
In step three, which at this time kind of merged with step 2 we used async+await in all places. We learned about 
async functions this way and naturally put `await` where it felt right. I had the impression this did not really 
cause many problems and made it very easy to understand how async+await works. This was also the intention of this
meetup: allow us to learn without breaking a sweat and without falling asleep at some talk, but doing it.

## The Discussion afterwards
The last part after about 1,5 hours of mob-programming we used to discuss aspects of the kata. Topics we touched on were:

- The source code of the two mobs
- Pros and cons of async functions
- How valuable is the contract test we wrote?
- How clear/good are the requirements?

It was a very lively and inspiring discussion. What I liked about it was the sharp focus the group had. We didn't 
get carried away but went very much into depth of the topic. All statements were very objective and everyone tried 
to learn from the crowd and share insights. 

## Where is the code?
There is no code to see. We threw away the code, but we all keep the learnings and if we did it right they
will stick. With all the intrinsic motivation in the room I am sure people took away a lot and those learnings
will be applied in real life. If applying means not to use async functions or how to think more about contract
tests that's up to everyone self. So there is no need to keep the code.
You still want it? Do the kata yourself! And enjoy learning :).

## Conclusion
I liked it a lot. Keep it up and we will do it again.

If you are keen on diving deeper even before any next meetup, jump to [es6katas] and practice some ES6. And if you 
want a two-day learning event come to [JSCraftCamp][jscc], it will take place July 21+22 in Munich, a self-organized 
open-space for, with and by people who deeply care about crafting (software).

[async-funcs]: https://github.com/tc39/ecmascript-asyncawait/
[jslang-meetup-home]: https://www.meetup.com/de-DE/JavaScript-The-Language/
[jslang-meetup]: https://www.meetup.com/de-DE/JavaScript-The-Language/events/240120367/
[kata]: https://twitter.com/wolframkriesing/status/870383195849674753
[chris]: https://twitter.com/c089
[es6katas]: http://es6katas.org
[jscc]: http://jscraftcamp.org
[kata-log]: http://kata-log.rocks/
[mob-programming]: https://en.wikipedia.org/wiki/Mob_programming
[slides]: https://www.slideshare.net/wolframkriesing/javascript-the-language-meetup-async-functions
