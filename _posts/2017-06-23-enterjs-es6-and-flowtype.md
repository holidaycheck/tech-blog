---
layout: post
title:  "EnterJS, ES6, ES8 and Typing with Flow"
date: 2017-06-23 08:03:00 +0200
categories: conference
author_name: Wolfram Kriesing
author_url : /author/wolframkriesing
author_avatar: wolframkriesing
show_avatar : true
read_time : 13
show_related_posts: false
square_related: recommend-wolf
feature_image: posts/2017-06-enterjs/the-road.jpg
---

Back on the road. Three days of EnterJS are just over and 
I am already on the [next trip][hcss17-trip-tweet], this time with HolidayCheck.
So let me quickly sum up EnterJS where I had the pleasure to meet lots of interesting new people and
to give a workshop on ES6 (and ES8) and [a talk][talk] on the static type checker flow.

## ES6 and beyond workshop

Actually we held a [CodeRetreat][coderetreat] but that seems not to sell so good to the EnterJS audience, so it was called workshop.
We? I had the luck to do this workshop with [Marco Emrich][marco], who has some experience doing CodeRetreats. I was especially happy
that he knew how to do retrospectives well, it's just not my area of expertise.

Our CodeRetreat style required us to set the stage first, which means
we do pair programming, TDD, we throw away the code at the end of every session and we do the [Game of Life][gol] all
day long. We used the first session for getting this across. I had the feeling that many people had been surprised
to get a strong dose of pair-programming and especially TDD surprised many. But in the end we got lots of positive feedback.
We even heard stuff like "this ping pong is pretty cool". We did [pairing in ping pong style][ping-pong]
right the first session.
And as usual the audience was very diverse, there had been people using [Promises] right away in the first session, 
"because in JavaScript we program asynchronous all the time", others didn't do JS for a long time yet.
In session #2 we explained the arrow functions and didn't allow any kind of loops. Instead we gave
a short introduction on how to use the Array functions such as `map`, `filter`, `reduce` and so on.

After lunch, in session #3, we started right away with classes. We did ["No Primitives"][no-primitives]
where the attendees were not allowed to return or pass primitives to any method, except for the constructor.
This forced people into using classes. Which perfectly set the stage for session #4, where we simply said,
that all methods on their classes are async now. We quickly explained Promises and told people that 
all the methods must return Promises now. For us it was easy to just go around and look over people's
shoulders and if there was a test where the assertion expected a primitive we just had to point the
finger to it and got the "oh, no primitives, right?". That session was fun. But now it got even more interesting!

We had the pleasure of having [Brian Terlson][brian] around, after lunch. 
He authored the [async functions part of the ECMAScript specification][async-spec]. And since our next session
was replacing the Promises with async+await, I could not have imagined having a better expert around.
Brian paired with one of the workshop attendees and guess what, they found something peculiar. The `async`
keyword seems not to be allowed on getters and setters. And Brian took notes to find out what was the reason for it. 
The last info I heard was, that it was not allowed to keep consistency. Because a setter does never return 
anything, so it was simpler and easier to comprehend both just don't do `async`.

## "Typing JavaScript with Flow" talk

The workshop shipped successfully, I guess. 
Now it was time to get all preparations done for my upcoming 
talk about [flowtype or flow][flow]. I had all the puzzle pieces done. I had slides and I had code. 
I wanted to do quite some live coding, to give the audience the feeling of what it feels like to use flow.

<img src="{{site.baseurl}}/img/posts/2017-06-enterjs/lets-make-holidays.jpg" alt="talk teaser" width="300" style="float: left; margin: 1rem;" />

I hate to use artificial coding example. I was thinking a bit about what to do.
I also always like to use examples that have to do with the domain I am working in currently.
So I chose one from HolidayCheck.
We offer holidays, that sells great to everyone, I guess.
And since I worked a little bit on a feature called [passion search] lately I knew what my coding example 
will be about. I just needed a union type. The search tries to find destinations, 
which can be hotels, cities or regions. And here we go, we got a union type `Destination`.

Afterwards I realized that the coding example I prepared can perfectly be used as a kata.
But let's not start from the end :).
I had the last slot of the day, I started at 17:25. Which was perfect, it gave me time to 
practice and also do [some teasing][talk-ad1] and [advertising for my talk][talk-ad3]:

> 20min, 13 commits, to get a untyped piece of JS to make use of types and provides exhaustiveness checks
> #enterjs … cu at 17:25 Spektrum B

[I tweeted 1h before my talk][talk-ad3].

The thing I was most excited about is actually just a tiny part which comes at the end of my live coding,
it's the [exhaustiveness check] that is possible with flow. Explained in short: exhaustiveness checks verify that all possible
cases that a certain type can have are handled in the source code. That is why I actually turned in this talk.
I had experienced this power in another project where I intensly used flow and at one point when I extended
one type (it was a union type) flow warned me all the time to implement x and y and so on. And once all flow
errors had been gone the code handled this new type wherever it needs to be handled. Getting this for JS
seemed like enlightenment to me. So I turned in a talk about flow. And got accepted at enterjs :).

## What got typed? - The Kata

As explained above, the use case for the live coding comes from the search area in HolidayCheck.
So I wrote some code that implements a simplified search. The search can find three different 
types of results and shows them all in the autosuggest box, just like it happens on the
real HolidayCheck site.

![autosuggest]({{site.baseurl}}/img/posts/2017-06-enterjs/autosuggest.jpg)

The search can search for a different set of attributes in every type. If one searches for "Valencia",
as shown in the image above, the results yield a city, region and a hotel.
The string "Valencia" might appear in the attribute `name` of each of them. The hotel also has an attribute `city`
which might match the search term too. So the search needs to be implemented differently for every
type that can be found. This is the use case!

The untyped JS code looks like this:

```javascript
const searchDestinationsByWord = (destinations, word) => {
  const findPassion = passions => 
    passions && passions.some(passion => findString(passion, word));
  return destinations.filter(destination =>
    destination.city && findString(destination.city, word) ||
    findString(destination.name, word) ||
    findPassion(destination.passions))
  ;
};
```

Nice small functions. But still it's not clear and well understandable what is searched 
where and why. The process of adding types and listening a little bit to what flow
tells us and adjusting the code accordingly carved out code that looks like this

```javascript
const findOne = word => destination => {
  if (destination.type === 'hotel') return findHotel(destination, word);
  if (destination.type === 'city') return findCity(destination, word);
  if (destination.type === 'region') return findRegion(destination, word);
};
```

Actually flow pushed me really hard to get to some good looking code like this.
The only thing I did, was adding the three types `HotelType`, `RegionType` and `CityType`.
It took me a couple of tries to get the increments as small as I like to have 
them in order to create useful commits, that one can learn from and understand 
what is going on. If you are interested in the progress feel free to read the 
commits in [this branch][typed-branch].

You want to try this and maybe practice this as a kata with your team?
Feel free to find some minimal [instructions in the README of the repo on gitlab][kata-instructions].

## Types don't make Tests obsolete!

One learning besides a lot of in depth flow knowledge and exhaustiveness checks was
that I learned that types DO NOT make tests obsolete.

The tests I had written for this task had focused on the use case, some might call them
acceptance tests, I don't care about the name now. Adding the types on top of the 
non-typed JS solution didn't have any impact on my tests. I have to say, I refactored
the tests already quite a bit upfront. But that was basically in order for the audience
to easier match the tests to the use case. Which is always a good thing, anyways.
The types basically just had impact on the code where those three types were
either built or where they were consumed. The [builder.js][builder-js-file] file contains all the construction
and the [search.js][search-js-file] contains all the consumer logic.

## Cleaner Code by applying flow

And those two know about the different types. So those two files got pushed to
change by applying types. The `builder.js` which uses the builder pattern was pushed to use [generic type annotations][generics]
and the `search.js` was pushed to handle the cases for each type separatly.
And not use ugly `obj.property && <do something>` checks, that are very common in JS.

Another learning was that it is now easy to remove nullables. In [this commit][add-null-check-commit]
I first had to add a null check, which later, by [making the type not-nullable][remove-null-check] I removed again.

Adding types makes you think of things that feel artificial to think of when doing pure 
JavaScript. If you come from a typed environment you might be thinking like that more
often already, but in the JS world I don't see this a lot. The pleasures and shortcut the
language offer are often thankfully used without thinking deeper of consequences.

.oO(Writing this here, I see that I should restructure my talk to carve out those learnings a bit more.)

## Conclusion

After all: this year's EnterJS was a great learning experience for me again. This year it pushed
me deeper into the typing space, which I am thankful for.
Especially [Vladimir Kurchatkin][vladi] and [Adam Solove's][exhaustiveness] help really pushed
me further than I had thought, thanks! Thanks also [Tobias] for passing me the link to Adam's article.

Maybe see you next year at EnterJS, or [maybe the Clean Code Days][enterjs-vs-ccd-tweet].

[talk]: https://www.enterjs.de/abstracts#flowtype-strikte-java-script-typisierung-in-beliebiger-dosis
[talk-ad1]: https://twitter.com/wolframkriesing/status/877481691018911744
[talk-ad2]: https://twitter.com/wolframkriesing/status/877500929670606848
[talk-ad3]: https://twitter.com/wolframkriesing/status/877529674607407107
[exhaustiveness check]: http://www.adamsolove.com/js/flow/type/2016/04/15/flow-exhaustiveness.html
[passion search]: http://holidaycheck.de/vorlieben
[brian]: https://twitter.com/bterlson
[typed-branch]: https://gitlab.com/wolframkriesing/talk-flow-type-enterjs-2017/tree/add-typing-incl-exhaustiveness-%233
[exhaustiveness]: http://www.adamsolove.com/js/flow/type/2016/04/15/flow-exhaustiveness.html
[vladi]: https://twitter.com/vkurchatkin
[Tobias]: https://twitter.com/tpflug
[flow]: https://flow.org/


[hcss17-trip-tweet]: https://twitter.com/wolframkriesing/status/878137941880713217
[marco]: https://twitter.com/marcoemrich
[coderetreat]: http://coderetreat.org/
[gol]: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
[ping-pong]: http://coderetreat.org/facilitating/activities/ping-pong
[no-primitives]: http://wiki.c2.com/?PrimitiveObsession
[Promises]: https://promisesaplus.com/
[async-spec]: https://github.com/tc39/ecmascript-asyncawait
[kata-instructions]: https://gitlab.com/wolframkriesing/talk-flow-type-enterjs-2017#getting-started-as-a-kata
[builder-js-file]: https://gitlab.com/wolframkriesing/talk-flow-type-enterjs-2017/blob/master/src/builders.js
[search-js-file]: https://gitlab.com/wolframkriesing/talk-flow-type-enterjs-2017/blob/master/src/search.js
[generics]: https://flow.org/en/docs/types/generics/
[add-null-check-commit]: https://gitlab.com/wolframkriesing/talk-flow-type-enterjs-2017/commit/5d730cbc56b0bc3df13d072b597a772699238fd7
[remove-null-check]: https://gitlab.com/wolframkriesing/talk-flow-type-enterjs-2017/commit/4ee599f8ba3b4557c26d6629da3e2cd1c147c0ab
[enterjs-vs-ccd-tweet]: https://twitter.com/wolframkriesing/status/877826511859990528
