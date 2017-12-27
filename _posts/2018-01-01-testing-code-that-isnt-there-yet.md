---
layout: post
title:  "Testing code that isn't there yet"
date: 2018-01-01 10:10:10 +0200
categories: testing
author_name: Jacek Smolak
author_url : /author/jaceksmolak
author_avatar: jaceksmolak
show_avatar : true
read_time : 8
show_related_posts: false
square_related:
feature_image: posts/2017-10-22-jbhc17-from-my-perspective/poster.jpg
---

It's relatively easy to test a piece of code that is already there.
Stub dependencies, check calls, returned values. Voilà, there you have it.
But what about a code that is not there yet?

## TDD

We've all heard about it. Make it red, make it green, step back, have a look, refactor. Repeat the whole process.
Easy to say. But it's also a big step to make for some.

It's also very tempting to write some amount of code, just to have a thing to grasp, a point to start from.
In this post I would like to show you how to start testing without any code upfront, so that you can get
comfortable with TF (test first) approach as well.

## Things I will show you

The example I am going to work with here is not going to be trivial like some simple function
that conditionally returns some string, you can google plenty of those.
What I would like to show is a part of a backend microservice I was working on
that included connecting to Mongo DB and fetching some data. A more real-life example one would say.

Also, the code produced here will have 100% code coverage, but might not be the prettiest one.
Why? It's not a purpose of this post to show you how to refactor, but how to test code that isn't there,
to get you started with TF programming with more complex code.

## Know what you want in `return`

One of the things that helps me start off with writing a test is to know what my function
will eventually return. This way I can build the very first test.

My function will return a collection of photos for given hotel ID (yes, we work in hotel/holiday business).

<blockquote>
If there will be two pieces of code one after the other, I will always write test code first and code that passes it second.
</blockquote>

```javascript
import fetchHotelPictures from '../fetchHotelPictures';

describe('fetchHotelPictures', () => {
    it('should return hotel pictures collection', () => {
        const picturesCollection = fetchHotelPictures();

        expect(picturesCollection).to.deep.equal([
            'picture-1.jpg', 'picture-2.jpg', 'picture-3.jpg'
        ]);
    });
});
```

This is what I want to have returned if I call this function. An array of file names.
Now, having that ready I can create the very first code that passes that test.

```javascript
export default function fetchHotelPictures() {
    return [ 'picture-1.jpg', 'picture-2.jpg', 'picture-3.jpg' ];
}
```

As I mentioned, there will be things related with connecting to Mongo, finding some data,
also some error handling. But, if everything goes well, this is what you want to have returned.

If you will look at it as some steps needed to be taken, this (returning that array), will
look like the final one. I find it very easy to start with and then building the rest on top of that,
like adding layers of more responsibility as the code evolves. At the very end I will exchange returning
this array of file names with some kind of DB handler's `find` method that I will stub.

## Prepare dependencies
