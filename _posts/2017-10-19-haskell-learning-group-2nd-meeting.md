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
```haskell
sayHello :: String -> IO ()
sayHello x = putStrLn ("Hello, " ++ x ++ "!")
```

Well, I guess only to ouput a string was too easy so we started with a bit more upgraded version of the classic programm. Instead of hardcoding "World", this function takes one argument which is a string and says "Hello" to whatever was passed as a parameter to it. 
Let's try to run it. Save the code snippet above in test.hs and type in ghci `:load test.hs`. Now sayHello function is available for you and you can run with a string argument like this: `sayHello "World"`
First line of the code snippet is type definition for the function defined on line 2. You can recognize it by '::', and read first as "sayHello has type `String -> IO ()`". As was mentioned in the book, its not important to understand every single detail of it at the moment. Those things will be explained in detail later on and right now we can concentrate on syntax.
So, the second line is definition of the function itself. We take x as a parameter and concatenate it with other strings on the left and right by using `++` operator.

## Some Basic Expressions and Operations

Function is a type of expression in Haskell, lets define a simple function and have a closer look on what it consist of. The example from the book is function triple which multiply provided number on 3. Here is how it's declared:
```haskell
triple x = x * 3
```

`tripple` is the name of the function. The only parameter it takes has name `x` and it's called `head` of the function. Equal sign is for assignment values and functions. The last part which defines what function does is called `body`. The last line (in our case the only one) is what will be returned.
You can call this function like this `triple 2`. In this case x is bound to 2 and we get 6 as the result.
During the session we quickly went through arithmetical operations. You can use them as you would normally use them: `1 + 2`  but also written with infix style like this `(+) 1 2`. In this particular example you can see how + will be applied to two arguments 1 and 2. Let's have a closer look what infix is about. First of all, you have a useful command in ghci it calls `:info`, you can apply it to function you want to get information about. You can get information not only on functions but on operations like multiply or division like this `:info *`. Its useful to get type information and also to find out if its infix operator. For `*` it says `infixl 7 *`, what exactly does it mean? `infixl` means it's an infix operator, left associative. Then `7` is the precedence: higher is applied first, on a scale of 0-9. At the end is Infix function name - `*`. Precedence for `+` is lower, its `6`. That is why `2 + 2 * 2` equal `6` and not `8`.
The lowest precedence has `$` its `0`. It is an infix operator and it can be convinient for reducing amount of parentheses in expression.
Here are examples some simple example on how it might be used:
```haskell
Prelude> (2^) (2 + 2)
16
-- can replace those parentheses
 Prelude> (2^) $ 2 + 2
16
-- without either parentheses or $
 Prelude> (2^) 2 + 2
 6
```

Because of low precedence it evaluates things from right side first and can be used to delay function application. You can use as many `$` as you want in one expression:
```haskell
Prelude> (2^) $ (+2) $ 3*2
256
```

## Strings

Chapter 4 was all about strings and operations that can be performed on strings. It is important to understand that strings in Haskell are Lists of characters. There is a REPL command `:type` which gives type information on given statement. Let's try it with string like this `:type "Hello"`. As type information we get "[Char]". This means that "Hello" could be also represented as ['H', 'e', 'l', 'l', 'o']. On the other hand, you still have `String` as a type alias, which can be used for instance when function take a string parameter as in example with sayHello: `sayHello :: String -> IO ()`.
By knowing that String is a List, we can perform operations like `++` for joining two Lists (or Strings if you wish). We were also playing a lot with such functions as `take` and `drop`. One of the exercises from the book was to write a function that swap the order of the words in the sentence. So the sentence "Curry is awesome" should be reversed to "awesome is Curry". One constraint is that you are limited to use only functions drop and take to get the result. Of course it is not optimal for this case, but here is how the solution to that exercise looks like:

```haskell
rvrs :: String -> String
rvrs x = ((drop 9 x) ++ (" " ++ (take 2 (drop 6 x)))) ++ (" " ++ (take 5 x))
```



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
