---
layout: post
title:  "Haskell Learning Group - first meeting"
date: 2017-10-17 15:45:00 +0200
categories: learn product haskell
author_names: [ kamil, dawid ]
author_avatar: kamildawid
show_avatar : true
read_time : 15
show_related_posts: false
square_related: recommend-kamil
feature_image: posts/2017-10-17-first-haskell-meeting/haskell-poster.jpg
---

In HolidayCheck we believe in the value of learning new things. So the last week we held a first meeting of our Haskell Learning Group. The point of this group is to learn ourselves the basics of Haskell language.

We do not intend to rewrite all our production codebase to Haskell (yet?) nor any particular parts of it. We just want to add yet another tool to our toolbelt to choose from. And Haskell is a great tool! It’s well established statically and strongly typed pure functional language, with a ton of research under it’s belt.

But when you have a learning group you also need a book, and it should be an approachable book so everyone on any level of knowledge could easily learn from it. There are a lot of books to learn Haskell from, but we decided to go with [Haskell Programming from first principle][haskellbook].

[haskellbook]: http://haskellbook.com/

The book starts with the chapter on Lambda calculus, a mathematical concept that underlines functional programming. Although it’s not a requirement to know it to program in Haskell this is after all _from the first principle_ so lets dig in.

Around 7 people were present at the meeting. One may suggest it was insignificant or  unimportant because of low attendance. It’s not true. As the matter of fact it was very fun and valuable!

We started from small talk about what we liked in chapter 1. Everyone had different thoughts about it. That allowed us to take other point of view on Lambda calculus then our own. Already a victory. True value, tough, came just after: resolving exercises.

At first we went by the book. We took a look on `combinators`. That went very smoothly since we all knew more or less what `combinators` are. One of participants resolved related to `combinators` exercises. So, what are `combinators`? They are Lambdas without `free variables`. `Free variable` is the one which is not defined in Lambda’s head and it’s used in the Lambda’s body.

Here we stopped for a second. We take our time to also point out the `Alpha equivalence`, which is when structure of given Lambda is exactly the same as some other Lambda, but variables are named differently. For instance:  𝜆𝑥.𝑥𝑥𝑥 and 𝜆.𝑦.𝑦𝑦𝑦

After mastering `Combinators` exercises we started talking about `normal and diverge Lambdas`. Here one of participants asked another to also show us on screen how he is deciding if given Lambda `diverges` or not. Person who was resolving this part of exercises did it very nicely and smoothly.

To understand what `diverges` is one needs to know what `beta normal form` is, and for that I should probably tell you about `beta reduction`. So a quick recap just here, and if one would like a more proper explanation I suggest looking to a book mentioned earlier. `Beta reduction` is a process of applying function to its parameters, simple as that. `Beta normal form` is when there are no more parameters to apply. But sometime we get an infinite loop, where our expression never terminates no matter how much we `beta reduce` it, then we say it `diverges`.

What was left from exercises was even more fun! We took `beta reduction` on board.

Almost each of us made at least one exercise. We had precedent where one of attendants didn’t actually read the whole chapter. It didn’t stop us from explaining to him step by step `beta reduction` on those exercises. What was even cooler that we all valued from it and we built firm foundation of Lambda knowledge. We explained what Lambda head is, that it starts from `𝜆` and ends on `.`. We established that:

* reduction starts from far most left (if parentheses doesn’t apply otherwise),

* after each reduction we removing one head,

* reduction starting from outside to inside direction,

* inside reduction occurs only when there is nothing left to reduce outside,

* it’s possible to utilise `alpha equivalence` for convenience

  (ex. when we got two variables called `z` in `(𝜆z.z)(𝜆x.z)` we can call one of them `a` and we will get `(𝜆z.z)(𝜆x.a)`),

* When you stuck it’s good to write before each reduction what variable actually will become

  (ex. we reducing this: `(𝜆z.z)(𝜆x.z)`, we establish that `[z := (𝜆x.z)]` so our result is `(𝜆x.z)`. There is nothing more to reduce.

Beta reduction went nicely. Then we spoke about what we liked on this meeting and shared our thoughts. One of the conclusion was that Math can be very fun. Many people is afraid of Mathematics, but it appears it can give you pleasure and resolving Mathematical problems is very rewarding.

So don't be afraid of taking those first steps. They may be hard, but reward is far greater than you expect!


