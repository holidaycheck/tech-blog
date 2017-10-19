---
layout: post
title:  "Haskell Learning Group: Beyond The Math (2nd Session)"
date: 2017-10-19 00:00:00 +0200
categories: haskell learn
author_name: Sergii Paryzhskyi
author_url : /author/sergii_paryzhskyi
author_avatar: sergii_paryzhskyi
show_avatar : true
read_time : 15
show_related_posts: false
square_related: recommend-wolf
feature_image: posts/2017-10-17-first-haskell-meeting/haskell-poster.jpg
---

Previous [blog post][previous-blog-post] was an introduction to our Haskel Learning Group. This is a new initiative we started at HolidayCheck recently. As the first chapter was about mathematical concepts and lambda calculus, we haven't touch or seen any haskell code by than. For the second meeting we had to prepare chapters 2 and 3. They were all about programming and tooling that can be used to run haskell code. 
For us right now REPL is more than enough to try things out. It seems like most of the people were switching back and forth between pdf-book and REPL to try things out. That was also an agreement of the learning group. Doesn't matter how obvious/easy/boring things are - do not skip parts and commit to do all exercises at the end of each chapter.

[previous-blog-post]: http://techblog.holidaycheck.com/post/2017/10/17/first-haskell-meeting

## Tooling
At this point we don't need to know or to use many different tools, so REPL was good to start with. This is short for *r*ead-*e*val-*p*rint *l*oop, an interactive programming shell that evaluates expressions and returns results in the same environment. For Haskell this is [GHCi][ghci]. You get it by installing [stack][stack]. Stack also provides many other things that we will be using in the future. It can be used for installing packages (also as dependencies to specific project), but also building, testing and benchmarking your project.
For now we will be using it only for REPL and running tests later on.
You can start REPL in your console by running `ghci`. You can begin to play there by executing simple expressions and see results. If you feel more comfortable writting code in your editor of choice, feel free to do so. You can execute modules later on by running this in ghci: `:load filename.hs`. 

[ghci]: https://docs.haskellstack.org/en/stable/ghci/
[stack]: https://docs.haskellstack.org/en/stable/README/

## Hello World

It all starts with printing out the "Hello World!" and Haskell is not an exception. Here is how this simple programm can look like written with Haskell:
```javascript
sayHello :: String -> IO ()
sayHello x = putStrLn ("Hello, " ++ x ++ "!")
```

Well, I guess only to ouput a string was too easy so we started with a bit more upgraded version of the classic programm. Instead of hardcoding "World", this function takes one argument which is a string and says "Hello" to whatever was passed as a parameter to it. 
Let's try to run it. Save the code snippet above in test.hs and type in ghci `:load test.hs`. Now sayHello function is available for you and you can run with a string argument like this: `sayHello "World"`
First line of the code snippet is type definition for the function defined on line 2. You can recognize it by '::', and read first as "sayHello has type `String -> IO ()`". As was mentioned in the book, its not important to understand every single detail of it at the moment. Those things will be explained in detail later on and right now we can concentrate on syntax.
So, the second line is definition of the function itself. We take x as a parameter and concatenate it with other strings on the left and right by using `++` operator.

## Some Basic Expressions and Operations
  - arithmetic operations
  - order of parameters (i.e. (+) 1 1 == 1 + 1)

## Strings
  - strings
  - exercises


## Exercises

Some participants of a group who went a bit further with the book or even read the whole book before, decided to create a [repo with exercises][repo-exercises]. Project structure in a repository represents chapters in the book we are following. This is really practical, you know exactly where to stop or how you can practice things that you've just read about.
The idea is that you have tests that are either pending or failing. Your task is to make them all green. For instance, here are the tests for [chapter3-exercises][the third Chapter].
You have to uncomment them or in some cases change `xit` to `it` to see them fail. Write whatever needed to make tests green.
If you are practicing TDD, its not a right time to follow suggestions "write as less code as possible just to make test pass". So don't cheat and if expectation is that function `add` with arguments 1 and 2 should equal 3, don't just return 3 in the body of the Function ;). 
If you really stuck and the solution doesn't seem to be obvious, you can always look the answers in the [solutions][solutions branch] of the repo. Sometimes it happens that solutions for specific chapter are not yet there. That's a good oportunity for you to make them all green and contribute by opening PR against solutions branch.

[repo-exercises]: https://github.com/yannick-cw/haskell_katas
[chapter3-exercises]: https://github.com/yannick-cw/haskell_katas/blob/master/test/Chapter3/ExercisesSpec.hs
[solutions]: https://github.com/yannick-cw/haskell_katas

## Conclusion

At the end of one hour meeting we took us about 10 - 15 minutes of time to gather a feedback from participants on how it goes so far. These kind of discussions are very important at the beginning of such an initiative and might be reduce later on. After talking about topics   that bothered people or basically what we liked and didn't like so far, we could identify things that could be changed or improved.
One of the decision was to slow down and tackle one chapter instead of two chapters per session. This will automatically influence a format of our sessions and might have better learning effect as we are no longer in a hurry to pack everything in one hour meeting. The other positive side of this change is more people could attend learning since preparation time cut in half now.
As the group will be progressing with haskell learning, we keep you updated on how it goes. Expect some more blog posts on this topic soon, so stay tunned.
