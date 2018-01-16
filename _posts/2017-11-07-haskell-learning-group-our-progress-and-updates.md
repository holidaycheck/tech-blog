---
layout: post
title:  "Haskell Learning Group: Our Progress and Updates"
date: 2017-11-07 00:03:30 +0200
categories: haskell how-we-learn
author_name: Sergii Paryzhskyi
author_url : /author/sergii_paryzhskyi
author_avatar: sergii_paryzhskyi
read_time : 7
show_related_posts: false
square_related: recommend-wolf
feature_image: posts/2017-10-17-first-haskell-meeting/haskell-poster.jpg
---

This post is a quick update and the latest news about our Haskell learning group. Even though there were no blog posts on this topic recently, we are still having weekly meetings and mostly stick to the plan. That of course implies preparation time, spent between our sessions. There is no rush in our learning process and we take time to discuss interesting topics a bit longer, especially when all participants are involved. That being said, we might have a plan to go through one chapter per session but it also fine if it is less than that.

As expected the difficulty is slowly increasing as we go along. We are spending more time reading chapters. Sometimes the same material has to be read multiple times in order to fully understand what it is about.

It helps a lot that the most of the concepts are familiar to us through other languages or libraries we are using. For instance functions in JavaScript are not curried by default, the way it is in Haskell, but there are libraries which introducing this functionality. We are very often using [RamdaJS][ramdajs] in our projects, so such things as function composition, currying, partial application and so on were not something totally new to us. They still had to be "translated" and demonstrated in a Haskell way but we certainly didn't need much time to get the idea.

The same applies to the the parts that we learned about the Haskell type system. As many people from the group doing i.e. TypeScript or Scala, there were not that many surprises for us. Nevertheless it's pretty impressive what can be achieved with type constraints in Haskell.

[ramdajs]: http://ramdajs.com

## Types

We went through many topics in the book and since the last update we've covered chapter four, five and discussed a half of the chapter six which covers Typeclasses. The main topics were:
* Basic DataTypes
* Types
* Typeclasses

We learned important basics that help a lot when you read and try to understand what certain code does. For instance understanding how to read type signature, so something like this starting to make sense:

`(Num a, Num b) => a -> b -> b`

In this case there are two constraints, one for each parameter. They must be of a typeclass Num. You might already have some idea what function might do, based on its type signature.
We had a look on different examples of how type signatures limit a scope of what body of the function might be. Even more, some type signatures of function tells us exactly what it does because its the only possible implementation of the function. The simplest example of that will be an identity function:

```haskell
id :: a -> a
id x = x
```

The only thing this function can possibly do is return parameter that was passed to it. More advanced example when there is only one possible implementation is function composition:

```haskell
f :: (b -> c) -> (a -> b) -> (a -> c)
f x y = \z -> x(y(z))
```

It's not obvious from the first look at this type definition that there is no other possible implementation of a function based on its type. Compiler won't let us implement it in any other way. The same thing could be written a bit nicer, since we learned about `$` operator:
```haskell
f g h = \j -> g $ h $ j
```

The shortest and probably the neatest way to compose two functions would be to use composition operator from Prelude:
```haskell
f g h = g . h
``` 

## Katas and Exercises

I like the idea of projects and platforms like [exercism.io][exercism], [Project Euler][project-euler] and similar. There are small well defined problems, that can be solved in multiple ways. People share solutions, comment other people's code and try to improve themselves. Its can be very handy for those who learning a new programming language. In case of Haskell, you can see how with multiple iteration you improve the initial solution from having i.e. multiple if-else to use pattern matching and so on. 
I've started a [Haskell Exercises Repo][haskell-exercises-repo], which is basically nothing more than a collection of such problems and solutions to them. Most of them wouldn't make sense to make as a separate repository because of small size. So each directory is a separate exercise. It can be just one file or a Stack Project with tests and code that make them green. This repository has been created for learning purposes and accept contributions either as improvements to existing solutions or as new solutions. 

[haskell-exercises-repo]: https://github.com/HeeL/haskell-exercises
[exercism]: http://exercism.io
[project-euler]: https://projecteuler.net

## Haskell Meetup @ HolidayCheck

This might be great news for those of you who live in Munich and surrounding area and read this post before 28th of November ;). As the headline suggests we will be hosting the next Munich Haskell Meetup in our office at HolidayCheck. It will take place on 28th of November. Many thanks to [Tobias Pflug][tobias-pflug] for organizing this event, getting in contact with people and do other things to make it happen :) 
You have to sign up at [MeetUp][meetup] if you want to take part in this event. There will be two talks:
Johannes Drever will talk about `pipes`, powerful stream processing library that lets you build and connect reusable streaming components. 
We will also talk about some quirks and surprises in Haskell. There will be things you might  already know, but we try to see why it behaves this way.

[meetup]: https://www.meetup.com/de-DE/munich-haskell/events/244861031/
[tobias-pflug]: http://techblog.holidaycheck.com/author/tobiaspflug/