---
layout: post
title: Questions every unit test should answer
date: 2019-06-18 10:20:30 +0200
categories: testing
author_name: Jacek Smolak
author_url : /author/jaceksmolak
author_avatar: jaceksmolak
read_time : 5
show_related_posts: false
square_related:
excerpt: "We should write tests to prevent defects from happening. That is one of the key roles tests play. But not everyone knows there is more to writing tests than that."
feature_image: posts/2019-06-18-questions-every-unit-test-should-answer/poster.jpg
---

We should write tests to prevent defects from happening. That is one of the key roles tests play. But not everyone knows there is more to writing tests than that.

Tests play a very vital role when it comes to explaining two very important questions behind the feature they, well, test. Those are: the _how_ and the _why_.

## The 'how'

But not how the code is written, rather than how it is working. I find it the single most important question your tests must answer. 

 - How is this piece of code working?
 - What to expect given certain input?
 - What is happening if something goes wrong?
 - How it will behave under certain conditions?

The how, if answered properly, will tell you all about it.

Let's take [Fizz Buzz](https://en.wikipedia.org/wiki/Fizz_buzz) as an example. A simple game, with even simpler rules. But is it? Not so while ago I conducted, with a colleague of mine, an interview for an engineer position for our company. Fizz Buzz came out, and I asked: given that you know how it works, how many tests would you write to explain the rules (yes, that was a trick question). The answer was: around 50. I asked why? Why not 100? OK—perhaps 60, 70 (was the answer). The person interviewed clearly did not understand what I wanted to achieve.

What is the number of tests, the maximum number of tests, Fizz Buzz requires in order to answer the how behind it?

…

It's 4. All you need is four tests, to get to know how Fizz Buz works. Here's the list:

```javascript
it('should return Fizz when the number is divisible by 3', () => {
    const anyNumberDivisibleBy3 = 3;

    expect(fizzBuzz(anyNumberDivisibleBy3)).to.equal('Fizz');
});

it('should return Buzz when the number is divisible by 5', () => {
    const anyNumberDivisibleBy5 = 5;

    expect(fizzBuzz(anyNumberDivisibleBy5)).to.equal('Buzz');
});

it('should return FizzBuzz when the number is divisible by 3 and 5', () => {
    const anyNumberDivisibleBy3And5 = 15;

    expect(fizzBuzz(anyNumberDivisibleBy3And5)).to.equal('FizzBuzz');
});

it('should return that number when it is not divisible by 3 nor 5', () => {
    const anyNumberNotDivisibleBy3Nor5 = 1;

    expect(fizzBuzz(anyNumberNotDivisibleBy3Nor5)).to.equal(anyNumberNotDivisibleBy3Nor5);
});
```

A little side note: why all of those named variables? For couple of reasons: naming things (to provide extended description), and also, if you were to use [property based testing](https://techblog.holidaycheck.com/post/2017/07/25/property-based-testing-in-javascript) here, it would be as easy as applying the input generator function instead of those numbers. Tests are also code—they should be easy to refactor.

_"OK, but it's a simple game, thus simple rules and simple tests."_—you might say. Well… yes, and no (see my story up above). Fair enough, let's take something that nobody knows, but you and your team—a part of the application you're developing, say, a form on a page. Here is how it could work:

> As a user when I click the submit button:
>
> - I want to send the form data
> - display the spinner
> - when the response comes back the spinner disappears
> - and confirmation box with some message is presented

How would the tests look like then? How about:

```javascript
context('when the button is clicked', () => {
    it('should send a request with data from the form', () => {});
    it('should show the spinner', () => {});
});

context('when the response is back', () => {
    it('should remove the spinner', () => {});
    it('should display confirmation box with a message', () => {});
});
```

Such test suite is readable not only to your fellow engineers, but also to non—technical people (Product Owners for example).

Now that you know this, the very next time you will want to create a test where you check, for instance, that some API `should be called with right payload`—think about the end user (your team mates or yourself in 6 months), how much value does such test description bring? Is it answering _the how_ behind the process this code goes through or not?

## The 'why'

Why is this endpoint called with that payload? Why is number 42 used? Why are we wrapping this string in double quotes? The why is as important as the how. Without it, the unit under the test lacks context. Here's an example:

```javascript
describe('Action', () => {
    context('when it is resolved', () => {
        it('should call /foo endpoint', async () => {
            const apiCallback = sinon.spy();
            const action = createAction(apiCallback);
            
            await action();
            
            expect(apiCallback).to.have.been.calledWith({
                path: '/foo'
            });
        });
    });
});
```

Why is this endpoint called? Why does the payload look like it looks? Again, questions left unanswered and we don't know what is this test actually testing.

How about:

```javascript
describe('Action', () => {
    context('when it is resolved', () => {
        it('should inform some important rest API that it has finished', async () => {
            const apiCallback = sinon.spy();
            const action = createAction(apiCallback);
            
            await action();
            
            expect(apiCallback).to.have.been.calledWith({
                path: '/foo'
            });
        });
    });
});
```

Simple change in test's description made it very clear _why_ this endpoint is called. Should there be some significant payload going with it, I would even be tempted to create a separate unit test to explain why such payload.

Here's another case you might stumble upon:

```javascript
describe('Modal component', () => {
    context('when open', () => {
        it('should have proper width', () => {
            const modal = new Modal();
            
            modal.open();
            
            const width = modal.getWidth();
        
            expect(width).to.equal(500);
        }); 
    });
});
```

What is _proper_? Why 500? Why not 1000 or 200? You are left with so many unknowns, up to the point that in order to figure it out, you need to run the application and check it manually. But even then you might not get the answer, because how would you know it should do something specific? Would you have guessed the reason behind the number 500? Such a test is misleading and only confuses the reader. I would even risk an opinion, that it's a test that is a bad one, as nobody will know why it is there even if it is passing. And what if it will fail at some point?

How about this instead:

```javascript
describe('Modal component', () => {
    context('when open', () => {
        it('should have width big enough to cover the container it is rendered in', () => {
            const modal = new Modal();
                        
            modal.open();
            
            const width = modal.getWidth();

            expect(width).to.equal(500);
        });
    });
});
```

Or even better:

```javascript
describe('Modal component', () => {
    context('when open', () => {
        it('should have width big enough to cover the container it is rendered in', () => {
            const modal = new Modal();
            const parent = modal.getParent();
                        
            modal.open();
            
            const modalWidth = modal.getWidth();
            const parentWidth = parent.getWidth();

            expect(modalWidth).to.be.at.least(parentWidth);
        });
    });
});
```

Now, it is all clear—you know why the width matters. No more proper (whatever it means) and we got rid of a [magic number](https://en.wikipedia.org/wiki/Magic_number_(programming)). Especially that number—should the width of the parent change, and your number not, this test would, again, become invalid (simply lying), as the parent would not have width of 500 (whatever units) anymore.

## Some final thoughts—to be added
