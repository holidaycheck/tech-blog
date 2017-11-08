---
layout: post
title:  "Haskell Learning Group: Beyond Maths (2nd Session)"
date: 2017-10-25 00:03:30 +0200
categories: haskell how-we-learn
author_name: Sergii Paryzhskyi
author_url : /author/sergii_paryzhskyi
author_avatar: sergii_paryzhskyi
show_avatar : true
show_related_posts: false
square_related: recommend-wolf
feature_image: posts/2017-10-17-first-haskell-meeting/haskell-poster.jpg
---

The previous [blog post][previous-blog-post] was an introduction to our Haskel Learning Group. This is a new initiative that we started at HolidayCheck recently. As the first chapter was about mathematical concepts and lambda calculus, we didn't see or write any Haskell code at all. For the second meeting we had to prepare chapters 2 and 3 from the book. They were all about programming and tooling that can be used to run Haskell code.  
It seems like most of the people were switching back and forth between pdf-book and REPL to try things out. That was also an agreement of the learning group. Doesn't matter how obvious/easy/boring things are - do not skip parts and commit yourself to doing all exercises at the end of each chapter.

[previous-blog-post]: http://techblog.holidaycheck.com/post/2017/10/17/first-haskell-meeting

## Tooling
At this point we don't need to know or to use many different tools, so REPL was good to start with. REPL stands for **r**ead-**e**val-**p**rint **l**oop, an interactive programming shell that evaluates expressions and returns results in the same environment. For Haskell this is [GHCi][ghci]. One way of getting it is by installing [stack][stack]. Stack also provides many other things that we will be using in the future. It can be used for installing packages (including dependencies to specific project), and also building, testing and benchmarking your project.
For now we will be using it only for the REPL and running tests later on. It can be started in the console by running `ghci`. We began to play around by executing simple expressions and see results. Sometimes its more convenient to write code in an editor. It's possible to save source code in lets say `test.hs` file and load it as a module later on by running `:load filename.hs` in ghci.

[ghci]: https://docs.haskellstack.org/en/stable/ghci/
[stack]: https://docs.haskellstack.org/en/stable/README/

## Hello World

It all starts with printing out the "Hello World!" and Haskell is not an exception. Here is how this simple program can look like in Haskell:
```haskell
sayHello :: String -> IO ()
sayHello x = putStrLn ("Hello, " ++ x ++ "!")
```

Well, I guess just ouputting a string was too easy, so we started with a bit more upgraded version of the classic program. Instead of hardcoding "World", this function takes one argument which is a string and says "Hello" to whatever was passed as a parameter to it. 
We went briefly through the the code, looked at type definition and tried to run it to see results. After loading this module from `hello.hs`, we got the expected results by executing `sayHello "World"`.  

## Basic Expressions and Operations

During the session we quickly went through arithmetical operations. Nobody was having any real issues with the exercises or understanding how it works so we went through all of them rather quickly. We spend some time writing expressions in infix style. So the normal way of writing it `1 + 2`, with infix style would look like this `(+) 1 2`. There is a useful command in ghci which is called `:info`, we started to use it for different functions we wanted to get information about. It is not limited to functions and also works for operations like multiply or division: `:info *`. It's useful to get type information and also to find out if its infix operator. For `*` it says `infixl 7 *`. We learned how to read and understand the provided info. So it's an infix operator, left associative with precedence `7`.
Something totally new for us was `$`, which has precedence `0`. It is an infix operator and it can be convenient for reducing the amount of parentheses in an expression. We tried to experiment with it and had a look on how it could be used. For example:
`(2^) (2 + 2)` _becomes_ `(2^) $ 2 + 2`  
A slightly more complex example with multiple dollar signs:
`(2^) ((+2) ( 3*2))` _becomes_ `(2^) $ (+2) $ 3*2`

## Strings

Chapter 4 was all about strings and operations that can be performed on strings. It is important to understand that strings in Haskell are Lists of characters. There is a REPL command `:type` which gives type information on given statement. We tried it on string and we got `[Char]`. This means that "Hello" could be also represented as `['H', 'e', 'l', 'l', 'o']`. On the other hand, there is still `String` as a type alias, which can be used for instance when function take a string parameter as in example with sayHello: `sayHello :: String -> IO ()`.  
By knowing that String is a List, we can perform operations like `++` for joining two Lists (or Strings if you wish). We were also playing a lot with such functions as `take` and `drop`. One of the exercises from the book was to write a function that swap the order of the words in the sentence. So the sentence "Curry is awesome" should be reversed to "awesome is Curry". One constraint we had - we are limited to use only functions `drop` and `take` to get the result. Of course it is not optimal for this case, but here is how the solution to that exercise looks like:

```haskell
rvrs :: String -> String
rvrs x = ((drop 9 x) ++ (" " ++ (take 2 (drop 6 x)))) ++ (" " ++ (take 5 x))
```



## Exercises

Some participants of a group who went a bit further with the book or even read the whole book before, decided to create a [repo with exercises][repo-exercises]. Project structure in a repository represents chapters in the book we are following. This is really practical, you know exactly where to stop or how you can practice things that you've just read about.
The idea is that you have tests that are either pending or failing. Your task is to make them all green. For instance, here are the tests for [the third Chapter][chapter3-exercises].  
You have to uncomment them or in some cases change `xit` to `it` to see them fail. Write whatever is required to make the tests green.  
If you are really stuck and the solution doesn't seem to be obvious, you can always look the answers in the [solutions branch][solutions] of the repo. Sometimes it happens that solutions for specific chapter are not yet there. That's a good opportunity for you to make them all green and contribute by opening PR against solutions branch.

[repo-exercises]: https://github.com/yannick-cw/haskell_katas
[chapter3-exercises]: https://github.com/yannick-cw/haskell_katas/blob/master/test/Chapter3/ExercisesSpec.hs
[solutions]: https://github.com/yannick-cw/haskell_katas/tree/solutions

## Conclusion

At the end of one hour meeting we took about 10 - 15 minutes of time to gather a feedback from participants on how it goes so far. These kind of discussions are very important at the beginning of such an initiative and might be reduced later on. After talking about topics   that bothered people or basically what we liked and didn't like so far, we could identify things that could be changed or improved.  
One of the decision was to slow down and tackle one chapter instead of two chapters per session. This will automatically influence a format of our sessions and might have better learning effect as we are no longer in a hurry to pack everything in one hour meeting. The other positive side of this change is more people could attend learning since preparation time cut in half now.  
As the group will be progressing with Haskell learning, we keep you updated on how it goes. Expect some more blog posts on this topic soon, so stay tuned.
