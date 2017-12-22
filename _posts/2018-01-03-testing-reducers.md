---
layout: post
title:  "Evolution of reducers testing"
date: 2017-12-20 08:03:00 +0200
categories: coding
author_name: Artur Szott
author_url : /author/arturszott
author_avatar: arturszott
show_avatar : true
read_time : 9
feature_image: posts/2017-07-on-personal-development/growth.jpg
show_related_posts: false
square_related: recommend-growth
---

It's been over a year since we started using redux in one of our applications. Codebase changed a lot within that time. We changed a lot. The same had to happen with our tests.

## Testing reducers

The goal of testing reducers is to verify if for given input (action) they will return correct output (state). Holding code coverage bar at 100% unfortunately won't prevent us from making all the mistakes.

What kind of mistakes? Let's see:


```javascript
// one case from our application reducer
...
case ADD_APPLICATION_ERROR:
    return { ...state, error: { statusCode: action.error.statusCode } };
```

```javascript
// one unit test for case above

it('should handle ADD_APPLICATION_ERROR', () => {
    const state = {}; // empty initial state
    const action = {
        type: ADD_APPLICATION_ERROR,
        error: {
            statusCode: 403
        }
    };

    const expectedState = {
        error: {
            statusCode: 403
        }
    };

    expect(reducer(state, action)).to.deep.equal(expectedState); // passes
});
```

This kind of simple assertion kept us stable for until the moment when somebody will actually forget to return the rest of the state. From the test above we know that action will add error to the state, but what about the rest of the properties inside reducers? One mistake and they are gone.


```javascript
// the same unit test with different input

it('should handle ADD_APPLICATION_ERROR', () => {
    const state = {
        someOtherProperty: 'someValue' // this value indicates that state was not empty
    };
    const action = {
        type: ADD_APPLICATION_ERROR,
        error: {
            statusCode: 403
        }
    };

    const expectedState = {
        error: {
            statusCode: 403
        }
    };

    expect(reducer(state, action)).to.deep.equal(expectedState); // throws error, GREAT!
});
```

Great? YES! We've prepared the test that prevents us from making mistakes. We won't loose other parts of the state because of better input in tests. This gave us a rule to always provide other properties in state before it will be modified.

Coming up with new artificial properties for the tests in time became cumbersome, so developers started to copy the ones in initial state. This led to the situation when some changed properties have got outdated. They were changed in reducer but still present test files.

We already had the test for reducer's initial state:

```javascript
it('should return initial state', () => {
    const initialState = {
        language: 'en',
        error: {}
    };

    expect(reducer(undefined, {})).to.be.deep.equal(initialState);
});
```

So we've realised that we can place `initialState` at the top of the test suite and then reuse it between the tests. This was right for us since `initialState` had only one declaration in reducer as well.

Let's reuse it!

```javascript
// spreading initialState inside input state

it('should handle ADD_APPLICATION_ERROR', () => {
    const state = {
        ...initialState, // some other state properties
        error: {} // property that is overwritten is shown explicitly
    };
    const action = {
        type: ADD_APPLICATION_ERROR,
        error: {
            statusCode: 403
        }
    };

    const expectedState = {
        ...initialState, // we expect that it won't be overwritten
        error: {
            statusCode: 403
        }
    };

    expect(reducer(state, action)).to.deep.equal(expectedState);
});
```


Enlisting property that will be overwritten when reducer handles the action helps us to clarify what we are actually changing. It helps a lot in case of reducers that contain some more logic behind setting variables since there is no need to read more code beside the test itself.

We still struggle when seeing the code like in example above if we should remove the boilerplate. My good recommendation of reading on the topic there is [post of Sandi Metz, Wrong abstraction][wrong_abstraction]{:target="_blank"}. Personally I really like the simplicity of syntax behind reducers.

If you have some more ideas for improvement, find me on Twitter! https://twitter.com/ArturSzott.

[wrong_abstraction]: https://www.sandimetz.com/blog/2016/1/20/the-wrong-abstraction