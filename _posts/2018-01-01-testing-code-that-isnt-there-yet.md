---
layout: post
title:  "Testing code that isn't there yet"
date: 2017-12-28 10:10:10 +0200
categories: testing
author_name: Jacek Smolak
author_url : /author/jaceksmolak
author_avatar: jaceksmolak
show_avatar : true
read_time : 8
show_related_posts: false
square_related:
feature_image: posts/2017-12-28-testing-code-that-isnt-there-yet/poster.jpg
---

It's relatively easy to test a piece of code that is already there.
Stub dependencies, check calls, returned values. Voilà, there you have it.
But what about a code that is not there yet?

## TF / TDD

We've all heard about it. Make it red, make it green, step back, have a look, refactor. Repeat the whole process.
Easy to say. But it's also a big step to make for some.

It's also very tempting to write some amount of code, just to have a thing to grasp, a point to start from.
In this post I would like to show you how to start testing without any code upfront, so that you can get
comfortable with TF (test first) approach as well.

## Things I will show you

The example I am going to work with here is not going to be trivial like some simple function
that conditionally returns some string, you can google plenty of those.
What I would like to show is a part of a backend micro-service I was working on
that included connecting to MongoDB and fetching some data. A more real-life example one would say.
It's not 1:1 copy, but does almost all what my production code does.

The code produced here will have 100% code coverage, but might not be the prettiest one.
Why? It's not a purpose of this post to show you how to refactor, but how to test code that isn't there,
to get you started with TF programming with more complex cases.

## Know what you want in `return`

One of the things that helps me start off with writing a test is to know what my function
will eventually return. This way I can build the very first test.

My function will return a collection of photos for given hotel ID (yes, I work in hotel/holiday business).
I learned that photos are a part of hotel entity and are stored under `photos` property.
This is worth investigating before any code is written.

<blockquote>
If there will be two pieces of code one after the other, I will always write test code first and code that
passes it second.
</blockquote>

```javascript
import fetchHotelPhotos from '../fetchHotelPhotos';

describe('fetchHotelPhotos', () => {
    it('should return hotel photos collection', () => {
        const photosCollection = fetchHotelPhotos();

        expect(photosCollection).to.deep.equal([
            'photo-1.jpg', 'photo-2.jpg', 'photo-3.jpg'
        ]);
    });
});
```

This is what I want to have returned if I call this function. An array of file names.
Now, having this test I can create the very first code that passes it:

```javascript
export default function fetchHotelPhotos() {
    return [ 'photo-1.jpg', 'photo-2.jpg', 'photo-3.jpg' ];
}
```

As I mentioned, there will be things related with connecting to Mongo, finding some data,
also some error handling. But, if everything goes well, this is what you want to have returned.

If you will look at it as some steps needed to be taken, this (returning that array), will
look like the final one. I find it very easy to start with and then building the rest on top of that,
like adding layers of more responsibility as the code evolves. At the very end I will exchange returning
this array of file names with some kind of DB handler's `find` method that I will stub.

## Provide dependencies

<blockquote>
I assume that at bootstrap level MongoDB driver is configured and what is being passed here
is ready to use instance, that is already connected to DB.

So result of calling
[`mongodb.MongoClient.client.connect()`](http://mongodb.github.io/node-mongodb-native/3.0/api/MongoClient.html#.connect)
is what we will use.
</blockquote>

First thing you want to avoid is to have global imports in your file
(e.g. [Mongo driver](https://www.npmjs.com/package/mongodb)), as it will be very hard to test.
Let's inject it. Also let's have a very first use of it.

As our data lies in some collection, we need to fetch it using `collection` method.
I will use [sinon](http://sinonjs.org/) for organizing spies and stubs.

```javascript
describe('fetchHotelPhotos', () => {
    const connectedClientDouble = {
        collection: sinon.spy()
    };
    const collectionName = 'hotels';

    it('should connect to hotels collection', () => {
        fetchHotelPhotos(connectedClientDouble, collectionName);

        expect(connectedClientDouble.collection)
                    .to.have.been.calledWithExactly('hotels') // (1)
                    .to.have.been.calledOnce;
    });

    it('should return hotel photos collection', () => {
        const photosCollection = fetchHotelPhotos(connectedClientDouble, collectionName); // (2)

        expect(photosCollection).to.deep.equal([
            'photo-1.jpg', 'photo-2.jpg', 'photo-3.jpg'
        ]);
    });
});
```

```javascript
export default function fetchHotelPhotos(dbClient, collectionName) {
    dbClient.collection(collectionName); // (3)

    return [ 'photo-1.jpg', 'photo-2.jpg', 'photo-3.jpg' ];
}
```

<blockquote>
I will often comment the code with (1), (2) and so on, when there will be things worth noticing.
</blockquote>

1. You might ask why did I hardcode collection name instead of reusing the variable?
   That is because tests are applications as well. If I change something in one place,
   I would also like to know that it has an impact in other place(s) as well. In this example
   if I would change collection to something else, I would like to know that one of my tests
   have failed. Here, in this example, it's not so very important, but there can be cases where
   passed string will have important meaning and just reusing a declared variable at the top
   might be not safe enough. This is just how I go about writing my tests.

1. This test has failed, because `fetchHotelPhotos` calls for collection, and thus client
   and collection name need to be passed here as well.

1. This might look awkward at this moment, but we will get to the point where getting the collection
   and returning an array with file names are connected.

It works, but something doesn't seem right. If we are to get photos of a particular hotel,
we should only pass hotel's ID (or other unique identifier) as a single argument for that
function.

Perhaps:

```javascript
fetchHotelPhotos(hotelId, dbClient, collectionName);
```

No, rather not. Ideally this is what we would like to have:

```javascript
fetchHotelPhotos(hotelId);
```

How can we pass `dbClient` and `collectionName` then?<br>
Let's take a step back.

## Routing

Because this is a micro-service, then at some point there has to be some kind of route handling.
There, instead of calling directly `fetchHotelPhotos`, we can call a function that prepares / creates
handler for particular route (e.g. `/hotel/:hotelId/photos`).

Let's say it looks like this:

```javascript
router.get('/hotel/:hotelId/photos', createHotelPhotosRouteHandler(dbClient, collectionName))
```

OK, this seems better. Let's create this handler. First, a test:

```javascript
describe('createHotelPhotosRouteHandler', () => {
    const connectedClientDouble = {
        collection: sinon.spy()
    };
    const collectionName = 'hotels';

    it('should return a function', () => {
        const routeHandler = createHotelPhotosRouteHandler(connectedClientDouble, collectionName);

        expect(routeHandler).to.be.a('function'); // (1)
    });
});
```

```javascript
export default function createHotelPhotosRouteHandler(dbClient, collectionName) {
    return () => {};
}
```

1. Why a function? You will soon find out. Keep on reading. There is no use for it right now,
   but we will get to it. We will also reuse previously created `fetchHotelPhotos` function very soon.

<blockquote>
For route and HTTP request / response handling, I'll be using [Koa](http://koajs.com/),
but you can use whatever you like, e.g. [Express](http://expressjs.com/).
</blockquote>

Koa expects, for each route, a function to be passed (we already have it), and that function
is passed `ctx`  and  `next` arguments. We are interested in `ctx` only, as it holds:
 - request params
 - response object reference

So, some raw route would look like this:

```javascript
router.get('/from/path/for/:someId', (ctx) => {
    // here we handle this route
    // and access params from: ctx.params.someId
    // and response from: ctx.response
});
```

OK, I believe we have all requirements discussed. Let's combine them:

```javascript
describe('createHotelPhotosRouteHandler', () => {
    const collectionName = 'hotels';
    const hotelId = 'hotelId';

    const connectedClientDouble = {
        collection: sinon.spy()
    };
    const ctxDouble = {
        params: {
            hotelId
        }
    };

    beforeEach(() => {
        connectedClientDouble.collection.reset(); // (1)
    });

    it('should return a route handler', () => {
        const routeHandler = createHotelPhotosRouteHandler(connectedClientDouble, collectionName);

        expect(routeHandler).to.be.a('function');
    });

    describe('route handler', () => {
        it('should connect to hotels collection', () => {
            const routeHandler = createHotelPhotosRouteHandler(connectedClientDouble, collectionName);

            routeHandler(ctxDouble);

            expect(connectedClientDouble.collection)
                .to.have.been.calledWithExactly('hotels')
                .to.have.been.calledOnce;
        });

        it('should return hotel photos collection', () => {
            const routeHandler = createHotelPhotosRouteHandler(connectedClientDouble, collectionName);
            const photosCollection = routeHandler(ctxDouble); // (2)

            expect(photosCollection).to.deep.equal([
                'photo-1.jpg', 'photo-2.jpg', 'photo-3.jpg'
            ]);
        });
    });
});
```

```javascript
export default function createHotelPhotosRouteHandler(dbClient, collectionName) {
    dbClient.collection(collectionName);

    return () => [ 'photo-1.jpg', 'photo-2.jpg', 'photo-3.jpg' ];
}
```

1. It is a very good practice (most of the time a requirement) to reset calls count for spies
   if we check in tests if they were called given amount of times. Remember that you should
   be able to call all unit tests independently, at any given moment, in any order. That being
   said, one spy call should not affect the other call in other test. Same goes for stubs.

1. At this point, we still want to have photos returned. But since this is a route handler,
   I guess it should not return a plain array, but a response with status code and a body
   holding that array.

<blockquote>
For the sake of readability, I will add only a single test here and there to not overwhelme
anyone with the whole codebase. If needed, I will show everything, but not always.
</blockquote>

In order for Koa to return a response with given status code and a body,
we need to set `status` and `body` properties of `response` property of `ctx` (I will explain it shortly).
This is, again, a thing worth discovering before doing any coding.<br>

### "Learn how to use your tool, before using it."

So, if we want to set `200` and a body with that collection of photos, we need to do something like:

```javascript
ctx.response.status = 200;
ctx.response.body = [ 'photo-1.jpg', 'photo-2.jpg', 'photo-3.jpg' ];
```

Let's write a test for that:

```javascript
const ctxDouble = {
    response: { // (1)
        status: 0,
        body: ''
    }
};

beforeEach(() => {
    connectedClientDouble.collection.reset();

    ctxDouble.response.status = 0; // (2)
    ctxDouble.response.body = '';
});

it('should return hotel photos collection', () => { // (3)
    const routeHandler = createHotelPhotosRouteHandler(connectedClientDouble, collectionName);

    routeHandler(ctxDouble); // (4)

    expect(ctxDouble.response.status).to.equal(200);
    expect(ctxDouble.response.body).to.deep.equal([
        'photo-1.jpg', 'photo-2.jpg', 'photo-3.jpg'
    ]);
});
```

```javascript
export default function createHotelPhotosRouteHandler(dbClient, collectionName) {
    dbClient.collection(collectionName);

    return (ctx) => {
        ctx.response.status = 200;
        ctx.response.body = ['photo-1.jpg', 'photo-2.jpg', 'photo-3.jpg'];
    };
}
```
1. We're adding `response` property which is an object holding `status` and `body` properties,
   which will be set and checked.

1. They need to be reseted before each test.

1. It is still returning this collection (as a response), that is why this test's description
   didn't change. From user's perspective, this is what will be happening: returning a collection
   of photos means a body with an array of file names and a status code of 200.

1. No `photosCollection` anymore, as response is set in `ctx`.

## Back to Mongo

Now, let's take care of actually fetching this data from Mongo.
We've ended up requesting a collection. Next, we need to find an entry for given hotel.
If you take a look into docs, [findOne()](http://mongodb.github.io/node-mongodb-native/3.0/api/Collection.html#findOne)
is what we will use.

```javascript
const ctxDouble = {
    params: { // (1)
        hotelId
    },
    response: { // (1)
        status: 0,
        body: ''
    }
};
const findOneSpy = sinon.spy();
const connectedClientDouble = {
    collection: sinon.stub().returns({ // (2)
        findOne: findOneSpy
    })
};

beforeEach(() => {
    connectedClientDouble.collection.resetHistory(); // (3)
    findOneSpy.reset();

    ctxDouble.response.status = 0;
    ctxDouble.response.body = '';
});

it('should find hotel entry by hotel id passed in params', () => {
    const routeHandler = createHotelPhotosRouteHandler(connectedClientDouble, collectionName);

    routeHandler(ctxDouble);

    expect(findOneSpy)
        .to.have.been.calledWithExactly({ hotelId: 'hotelId' })
        .to.have.been.calledOnce;
});
```

```javascript
return default function createHotelPhotosRouteHandler(dbClient, collectionName) {
    return (ctx) => {
        dbClient // (4)
            .collection(collectionName)
            .findOne({ hotelId: ctx.params.hotelId });

        ctx.response.status = 200;
        ctx.response.body = [ 'photo-1.jpg', 'photo-2.jpg', 'photo-3.jpg' ];
    };
}
```
1. We need `hotelId` in params.

1. `collection` now becomes a stub, so we had to take care of that...

1. ... as well as changing how call count reset is handled.

1. Now, as we need `hotelId` from params, connection must be called within returned function.

After finding the entity for given hotel, we need to return `photos` property from it and we will be almost done.

```javascript
const findOneStub = sinon.stub().resolves({ // (1)
    photos: [ 'photo-1.jpg', 'photo-2.jpg', 'photo-3.jpg' ]
});
const connectedClientDouble = {
    collection: sinon.stub().returns({
        findOne: findOneStub
    })
};

beforeEach(() => {
    connectedClientDouble.collection.resetHistory();
    findOneStub.resetHistory(); // (2)

    ctxDouble.response.status = 0;
    ctxDouble.response.body = '';
});

it('should return hotel photos collection', () => {
    const routeHandler = createHotelPhotosRouteHandler(connectedClientDouble, collectionName);

    return routeHandler(ctxDouble) // (3)
        .then(() => {
            expect(ctxDouble.response.status).to.equal(200);
            expect(ctxDouble.response.body).to.deep.equal([
                'photo-1.jpg', 'photo-2.jpg', 'photo-3.jpg'
            ]);
        });
});
```

```javascript
export default function createHotelPhotosRouteHandler(dbClient, collectionName) {
    return (ctx) => {
        return dbClient
            .collection(collectionName)
            .findOne({ hotelId: ctx.params.hotelId })
            .then((hotelEntity) => {
                ctx.response.status = 200;
                ctx.response.body = hotelEntity.photos;
            });
    };
}
```

1. As `findOne` returns a Promise, this is what we must stub. This is finally the place
   where we can return our photos.

1. Reseting history changes (for stubs).

1. As we are dealing with Promise, the way of executing this part of the test code
   needed to change as well.

## Handling negative cases

What if the collection doesn't have hotel entity in it? Well, let's take care of this:

```javascript
context('if hotel entity is not found', () => {
    it('should return 404 status', () => {
        const connectedClientDoubleWithNoHotelEntity = { // (1)
            collection: sinon.stub().returns({
                findOne: sinon.stub().resolves(null)
            })
        };
        const routeHandler = createHotelPhotosRouteHandler(
            connectedClientDoubleWithNoHotelEntity,
            collectionName
        );

        return routeHandler(ctxDouble)
            .then(() => {
                expect(ctxDouble.response.status).to.equal(404);
            });
    });
});
```

```javascript
function createHotelPhotosRouteHandler(dbClient, collectionName) {
    return (ctx) => {
        return dbClient
            .collection(collectionName)
            .findOne({ hotelId: ctx.params.hotelId })
            .then((hotelEntity) => {
                if (hotelEntity) {
                    ctx.response.status = 200;
                    ctx.response.body = hotelEntity.photos;
                } else {
                    ctx.response.status = 404; // (2)
                }
            });
    };
}
```
1. We need different behaviour of `findOne`, but because changing this deeply
   nested property would be cumbersome, I decided to create a completely new
   client double, as it is not so big and complex. In other case, I would
   probably create a function that builds this double for me and prepare it
   for different scenarios.

1. Here's a simple response when no entity is to be found.

If there should be any other cases handled, it's going to be pretty straightforward
from now on.

## Final code:

```javascript
describe('createHotelPhotosRouteHandler', () => {
    const collectionName = 'hotels';
    const hotelId = 'hotelId';

    const findOneStub = sinon.stub().resolves({
        photos: [ 'photo-1.jpg', 'photo-2.jpg', 'photo-3.jpg' ]
    });
    const connectedClientDouble = {
        collection: sinon.stub().returns({
            findOne: findOneStub
        })
    };
    const ctxDouble = {
        params: {
            hotelId
        },
        response: {
            status: 0,
            body: ''
        }
    };

    beforeEach(() => {
        connectedClientDouble.collection.resetHistory();
        findOneStub.resetHistory();

        ctxDouble.response.status = 0;
        ctxDouble.response.body = '';
    });

    it('should return a route handler', () => {
        const routeHandler = createHotelPhotosRouteHandler(connectedClientDouble, collectionName);

        expect(routeHandler).to.be.a('function');
    });

    describe('route handler', () => {
        it('should connect to hotels collection', () => {
            const routeHandler = createHotelPhotosRouteHandler(connectedClientDouble, collectionName);

            routeHandler(ctxDouble);

            expect(connectedClientDouble.collection)
                .to.have.been.calledWithExactly('hotels')
                .to.have.been.calledOnce;
        });

        it('should find hotel entry by hotel id passed in params', () => {
            const routeHandler = createHotelPhotosRouteHandler(connectedClientDouble, collectionName);

            routeHandler(ctxDouble);

            expect(findOneStub)
                .to.have.been.calledWithExactly({ hotelId })
                .to.have.been.calledOnce;
        });

        context('if hotel entity is not found', () => {
            it('should return 404 status', () => {
                const connectedClientDoubleWithNoHotelEntity = {
                    collection: sinon.stub().returns({
                        findOne: sinon.stub().resolves(null)
                    })
                };
                const routeHandler = createHotelPhotosRouteHandler(
                    connectedClientDoubleWithNoHotelEntity,
                    collectionName
                );

                return routeHandler(ctxDouble)
                    .then(() => {
                        expect(ctxDouble.response.status).to.equal(404);
                    });
            });
        });

        it('should return hotel photos collection', () => {
            const routeHandler = createHotelPhotosRouteHandler(connectedClientDouble, collectionName);

            return routeHandler(ctxDouble)
                .then(() => {
                    expect(ctxDouble.response.status).to.equal(200);
                    expect(ctxDouble.response.body).to.deep.equal([
                        'photo-1.jpg', 'photo-2.jpg', 'photo-3.jpg'
                    ]);
                });
        });
    });
});
```

```javascript
export default function createHotelPhotosRouteHandler(dbClient, collectionName) {
    return (ctx) => {
        return dbClient
            .collection(collectionName)
            .findOne({ hotelId: ctx.params.hotelId })
            .then((hotelEntity) => {
                if (hotelEntity) {
                    ctx.response.status = 200;
                    ctx.response.body = hotelEntity.photos;
                } else {
                    ctx.response.status = 404;
                }
            });
    };
}
```

## Final words

For me, personally, doing the first step was always the hardest one. I had no idea how to start.
How could I test something that wasn't there. I believe it is the same for some of us.
And that is why I wanted to share how I managed to overcome this obstacle.

Just to wrap things up, this is what I found helping me most:
 - **know what you want in `return`** -
   then build your app from the very top to that point. This way you will end up with an application
   that has the minimum code required, as you will want to get to that `return` step ASAP
   (this and writing a minimum code that passes the tests and does nothing more).
 - **learn how to use your tool before you start using it** - discover how APIs of given modules / classes
   you will use look like. Not knowing this also slows you down and make you lean towards writing code, and
   not test, first.<br>
   OK, to be fair. If you really would like to try it out, do it, write a code, make sure it works,
   but then delete it and start by writing tests. You might end up with less code (most of the time),
   because it will only do whatever your tests will require it to do. And you will practice TF programming.

I believe that having done this first step will encourage you to do TF (TDD) more often, without
the fear of falling into *I don't know what my code will look like so I need to write it first*
trap. And don't worry if it will take a long time to do it on daily basis. It took my 'only' 6 months :)

*Photo by [Hal Ozart](https://unsplash.com/photos/MyRBq7GoVK0?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)
on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText).*
