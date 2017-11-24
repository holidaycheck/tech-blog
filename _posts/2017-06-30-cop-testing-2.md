---
layout: post
title:  "CoP Testing #2 - Structuring Tests"
date: 2017-06-30 22:40:00 +0200
categories: event testing cop how-we-learn
author_name: Wolfram Kriesing
author_url : /author/wolframkriesing
author_avatar: wolframkriesing
show_avatar : true
read_time : 6
show_related_posts: false
square_related: recommend-wolf
feature_image: posts/2017-06-cop-testing/feature-image.jpg
---

At HolidayCheck we are doing ["Communities of Practice"][cop] for various things. The one I started, is the
"CoP Testing", which cares about all things around testing. Since I care a lot about it
I like to join people who care about testing too, or who are at least interested in talking about it. 
So I started the "CoP Testing".

## The Plan and the Reality

As usual the plan was different to what reality turned out to be. "What are good tests?". 
That was the title of the email I sent out to announce this Friday's CoP.
After I had not really prepared the session today at all, I just triggered the 
question of what good tests are. I opened a test file. I searched for a bigger one
and folded all the tests, so that only the descriptions were readable. That's how 
I normally start with a test file, so I tried to get people follow me along.

After that the discussion went very quickly into the direction of how should 
we structure out tests.

## Nesting Tests or not

<img src="{{site.baseurl}}/img/posts/2017-06-cop-testing/mind-map.jpg" alt="talk teaser" width="300" style="float: left; margin: 1rem;" />

As you can see in our very simple mindmap the "Structure" became the central thing of our
discussion. This discussion got triggered by the comment that there are test libraries out
there that don't allow you to nest tests or create test suites (as they are called in some places).
Instead those libs force you to create a new file for every group of test that you might
put in a test suite, otherwise. This in turn triggered the question what kind of naming 
those files than have. Would they be named by their use case, by the file (sometimes a unit)
that they are testing with some postfix?

```
- search.js
- search-hotel.spec.js
- search-city.spec.js
- search-region.spec.js
```

This shows one possible naming scheme, that we also agreed we had never seen in any place.
The word `search` is the actual name of the unit we are testing, mostly the function that is exported.
And the postfix behind it is the groups tests. This might be the result of a test lib that
enforced multiple files. This kinda forces modularity, small files and maybe good separation of
concerns.

In a style like mocha or alike test libraries allow you to use, a nested approach might look like this.

```js
describe('search', () => {
    it('for a hotel');
    it('for a city');
    it('for a region');
});
```

One argument for this structure was that it might encourage more to get refactored, because
renaming files and restructuring test cases across files is much harder than just rearranging tests
that are grouped in functions or other kind of blocks.

## How go-lang does it

Fortunately we have different technologies that are used in HolidayCheck and Go is one of them.
We learned that Go has a thing called "examples", which are basically tests for an entire package.
And it has "tests" which are kinda unit tests for the inner parts of a package.
This sounds like a nice separation of tests, because it naturally separates the interface and contract
tests from the technical unit tests on the inside. And they are used as API documentation 
in Go, by default.

## More

Later we dipped our toes into the endless discussion of "What is a unit test?". This came up in the context
of asking who is the user of our tests. And we identified the human as the very first user
of our tests, but figured out that machines are also kinda consuming it. But mainly just in order
to make it easier for us to understand test results.
I guess the definition of unit tests offers enough content for another over-time session, 
that has probably be done many times already in many places. That feels like a late evening beer session :).

We got a quick introduction to [snapshot tests], as e.g. [jest] provides and we are using them in a couple of projects
in HolidayCheck to verify what React components render. We compared this to golden master tests and 
mostly figured out that those might have their use case but it seemed not a too big of a crowd
was convinced of this approach and it might be evaluated carefully when to use it.

Next time we want to tackle the topic "How do test descriptions and test code correlate".
Looking forward to next Friday's CoP-Testing.

[cop]: https://en.wikipedia.org/wiki/Community_of_practice
[snapshot tests]: http://randycoulman.com/blog/2016/09/06/snapshot-testing-use-with-care/
[jest]: https://facebook.github.io/jest/
