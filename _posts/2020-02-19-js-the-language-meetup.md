---
layout: post
title: "JavaScript The Language Meetup: async/await"
date: 2020-03-02 10:00:00 +0200
categories: javascript
author_names: ["Pablo Palacios", "Sergii Paryzhskyi"]
read_time : 5
show_related_posts: false
square_related:
feature_image: posts/2020-02-19-js-the-language-meetup-async-await/poster.jpg
---

Yesterday we've hosted a “JavaScript the Language” Meetup at
HolidayCheck. This is a monthly meetup where we go into details about
specific aspects of JavaScript. The topic of Thursday's meetup was
`async/await`.

There are no presentations, but it is a very interactive and hands-on
event. Instead of a keynote speaker and slides, the guests here are
protagonists. It all starts with socialising and getting to know each
other while enjoying snacks and drinks.

We then started an introduction round where people share their
background and JavaScript experiences. At that point we realized how
broad our audience actually was: some people had barely started with
programming, while others were actively using JavaScript for over 15
years. That turned out not to be a problem at all. In order to bring
everyone on the same page about `async/await`, we briefly discussed
the general knowledge about this language construct and what it is
normally used for.

<img src="/img/posts/2020-02-19-js-the-language-meetup-async-await/collect-ideas.jpg" alt="Collect Ideas" class="centered" />

Afterward we've collected all the topics that people would be
interested to know in context of `async/await`. Participants of all
experience levels were actively engaged in proposing ideas and
questions to be discussed in more detail. It seems like it took us
less than 10 minutes to fill up the flipchart with lots of exciting
topics to tackle:

<img src="/img/posts/2020-02-19-js-the-language-meetup-async-await/ideas-list.jpg" alt="Ideas List" class="centered" />

We've tried to answer, present and learn through a dynamic code
session. We've started by checking what can and cannot be
"awaited". Can only async functions be used as await expressions?
From that, we've tried to await almost everything (sync functions,
values, generators, code blocks, exceptions and so on). That was lots
of fun and many wow-effects, especially when a code-execution went not
as many people would expect it to go.

```javascript
  it('a value IS awaitable', async () => {
    const result = await 1;
    assert.equal(result, 1);
  });

  it('sync function IS awaitable', async () => {
    const cb = () => 1;
    const result = await cb();
    assert.equal(result, 1);
  });

  it('throw IS NOT awaitable', () => {
    assert.throws(() => eval(`(async () => {
      await throw 1;
    })()`), SyntaxError);
  });

  it('blocks ARE NOT awaitable', () => {
    assert.throws(() => eval(`(async () => {
      await { const x = 1; }
    })()`), SyntaxError);
  });
```

Then, we focused on the relationship between async functions and
promises. We've covered topics such as implicit promises, error
handling and chaining of async functions:

```javascript
  it('return type of async function is Promise', () => {
    const asyncFunction = async () => 1;
    return asyncFunction().then(result => assert.equal(result, 1));
  });

  it('await a Promise returns resolved value', async () => {
      const promise = Promise.resolve(1);
      const result = await promise;
      assert.equal(result, 1);
  });

  it('await a nested Promise returns resolved value', async () => {
      const promise = Promise.resolve(Promise.resolve(1));
      const result = await promise;
      assert.equal(result, 1);
  });

  it('await rejected promise throws', async () => {
      const promise = Promise.reject(1);
      try {
        const result = await promise;
      } catch(error) {
        return assert.equal(error, 1);
      }
      assert.fail('Expected to catch');
  });
```

As the last test, we've checked the behavior of generators as an await
expression. Nobody was certain if it returns a yielded value from the
generator or the generator itself:

```javascript
  it('await do not yield generator function', async() => {
    function *g() {
      let x= 0;
      while(true) {
        x += 1;
        yield x;
      }
    }
    const result = await g();
    assert.deepEqual(result, {});
  });
```

The test cases for all arisen questions can be found
[here](https://gitlab.com/wolframkriesing/jslang-meetups/-/blob/3a2bb056de1119bc53ef9ce7be6e72a4323c0330/async-await-2020-02-20/async-await.spec.js). There you can take a deep look on all the experiments we did.

<img src="/img/posts/2020-02-19-js-the-language-meetup-async-await/coding.JPG" alt="Coding" class="centered" />

Finally, it is important to say that the topic for the next meetup is
already chosen. In order to do so, we've collected all ideas that
people would be interested to hear about. This wishlist was filled
within a couple of minutes as people started to name all the topics
that they would like to learn or know more about.

<img src="/img/posts/2020-02-19-js-the-language-meetup-async-await/next-topics.jpg" alt="Next Topics" class="centered" />

Here we've experienced again a high participation rate of all people no matter
how long they have been using JavaScript. Each participant had two
votes to give for any of the listed topics. At first it looked very
promising for `Prototypes`, but in the end the winner was `Reflect`.


<img src="/img/posts/2020-02-19-js-the-language-meetup-async-await/next-topics-list.jpg" alt="Next Topics List" class="centered" />

We are already excited to host this event again in March, and looking
forward to seeing all of you at our office!
