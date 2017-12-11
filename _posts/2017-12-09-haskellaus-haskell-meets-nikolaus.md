---
layout: post
title:  "Haskellaus: Haskell meets Nikolaus"
date: 2017-12-09 00:03:30 +0200
categories: haskell how-we-learn
author_name: Sergii Paryzhskyi
author_url : /author/sergii_paryzhskyi
author_avatar: sergii_paryzhskyi
show_avatar : true
read_time : 10
show_related_posts: false
square_related: recommend-wolf
feature_image: posts/2017-12-09-haskellaus-haskell-meets-nikolaus/haskellaus-poster.jpg
---

Last Friday we had a very special Haskell meeting at HolidayCheck - we called it Haskellaus. In this post I will explain what it was about and then we look at some highlights of how it went. Let me start first with a short update on how it goes at our Haskell Learning Group, as it was not much news from us lately.


## Learning Group

Despite a lack of Blog posts to this topic lately, we've never stopped with our regular meetings. We've also sent a signal that we are alive and [doing some progress][tweet-progress] with the book. Chapter 8 introduces important concept of recursions, which replaces in many cases traditional loops in Haskell. That was a lot of fun to play with it. We implemented different kinds of recursions and examine how compiler behaves in case when we run a deeply nested recursion. In case of tail recursion with forced calculations we've seen high CPU load and gigabytes of RAM being used. We tried normal recursion by forcing compiler to calculate insane numbers, like factorial of a huge Integer (we actually used the maximum bound of Int by writing `(maxBound :: Int)`). When we waited long enough, we've seen a stack overflow error in a console and application terminated. Sometimes it's good to step to the side from exercises and start to experiment with whatever suggestion comes from a crowd. It seems like we are starting doing this more and more often during our sessions.  
Since then we've got to Chapter 9 (or 9.6 to be precise) and that's where we are at the moment. We've learned and practiced with many standard library functions for operating on Lists. It was a good hands-on session with many exercises, we learned about List’s datatype and how to effectively pattern match on it. I think these two last chapters gave us a good base for being able to implement katas and solve small challenges, which bring us to a Haskellaus.

[tweet-progress]: https://twitter.com/HolidayCheckLab/status/937313093612396545


## Haskellaus

The idea of organizing this meeting belongs to [Tobi][tobias-pflug], a colleague of mine. He also wrote a description, which I found quite funny and wanted to quote it here: 
> The lazily evaluated FP Saint Nicholas doesn't show up until you force him so he is a bit late, but this Friday is *Haskellaus - treats for the functionally inclined*. Saint Nicholas has a bag full of challenges that we will try to solve.

The starting point for us was a repository with a project generated with [Stack][stack]. We had a module and a list of different functions with type definitions that were missing implementation. There was a Spec file for this module, but tests weren't implemented either, we had to write them on our own. The challenges were pretty straightforward in terms of requirements. Basically we were always able to write a clear expectation of output for each input of the function.  
There were always some constraints that we set on ourselves to make it more interesting. For instance, the usage of some functions were limited to make sure that we implement our solution from scratch and not just get work done by calling couple of pre-defined functions of Prelude.  
At the end we've implemented about 5 - 7 different functions and wrote tests to them. Let's have a look on a couple of examples of what we managed to accomplish.


## Implement function getLast

We had a type signature of the function that looked like this:
```haskell
    getLast :: [a] -> a
```

We expect a List of some items on input and an item of the same type should be returned. We started with a test and represented it in a spec file like this:
```haskell
  describe "getLast" $ do
    it "gets the last element from a given list" $ do
      getLast [1, 2, 3] `shouldBe` 3
```

In our example, we give a list of [ 1, 2, 3 ] and expect 3 as a result of function execution, because it's the last element of the list. Haskell already has a function that does exactly this and that of course was NOT the idea of this challenge to do it like this:
```haskell
    getLast :: [a] -> a
    getLast = last
```

The other possible solution, which was also NOT acceptable is to use combination of `reverse` and `head` like:
```haskell
    getLast :: [a] -> a
    getLast = head . reverse
```
It works but it's definitely not what we wanted to practice by implementing these functions. As we learned how to pattern match on lists recently, our final solution looked like this:
```haskell
    getLast :: [a] -> a
    getLast [x] = x
    getLast (x:xs) = getLast xs
```

We pattern match on two cases. When we have a list with more than one item, we reduce it from the beginning and recursively call our function with the rest of the list. The second case is our exit-case, that's how we stop the recursion so it won't go infinite. When the List has one item, this item will be matched and returned. 

## Implement function reverseList

This is a bit more difficult comparing to a previous example. This function should have a functionality of a standard `reverse`. As we had some problems at first to implement it, we started with really small steps both in tests and in implementation as TDD suggests it. So here are our tests:

```haskell
describe "reverseList" $ do

    it "reverses list of two elements" $ do
        reverseList [1, 2] `shouldBe` [2, 1]

    it "reverses list of three elements" $ do
        reverseList [1, 2, 3] `shouldBe` [3, 2, 1]
```

Our first steps didn't even require recursion, because we could pattern match on a list of two elements and just swap them. The interesting part started when we've added the second test. The simple swap didn't work, even after making the function exhaustive for a list of three elements, as the result we had `[1, 3, 2]` instead of `[3, 2, 1]`. It was a good visual feedback from tests that we needed to perform a left associative operation, which exactly what `foldl` does. It didn't work right away but after playing a bit with it in a console, we made it work as we wanted it to work:

```haskell
reverseList :: [a] -> [a]
reverseList = foldl (flip (:)) []
```

The nature of cons (:) operator requires first to receive a value and then a list, which in our case is other way around. We can easily fix this by using `flip` function. Type signature of flip says exactly what it does:

```haskell
flip :: (a -> b -> c) -> b -> a -> c
```

After implementing it this way, we actually took a step back and thought how to implement it alternatively with pattern matching:

```haskell
reverseList :: [a] -> [a]
reverseList [] = []
reverseList (x:xs) = reverseList xs ++ [x]
```
This solution was more obvious and that was kind of silly that we didn't come up with this one at first.

[tobias-pflug]: http://techblog.holidaycheck.com/author/tobiaspflug/
[stack]: https://docs.haskellstack.org/en/stable/README/

## Plans

We were all enjoying implementing those small functions and practicing what we've learned so far. We have decided to use our next regular meeting to do some more mob programming in Haskell challenges. We expect it to be similar to what we did during our Haskellaus session. We concentrate exclusively on practicing what we know, without looking at the book or moving further to the next chapter.  
There is no concrete list of problems we want to tackle, but there are plenty of challenges for different levels on projects that were mentioned before. Good candidates for that are [Ninety-Nine Haskell Problems][99-problems], [Project Euler][project-euler] and [Exercism.io][exercism].


[99-problems]: https://wiki.haskell.org/H-99:_Ninety-Nine_Haskell_Problems
[exercism]: http://exercism.io
[project-euler]: https://projecteuler.net