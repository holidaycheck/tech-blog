---
layout: post
title:  "Evolution of reducers testing"
date: 2017-12-20 08:03:00 +0200
categories: coding
author_names: [ artur, jacek ]
author_avatar: arturjacek
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
default:
    return state;
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

Enlisting property that will be overwritten when reducer handles the action helps us to clarify
what we are actually changing. It helps a lot in case of reducers that contain some more logic
behind setting variables since there is no need to read more code beside the test itself.

Another careless thing we did was exporting initial (default) state from reducer.
It has been exported for test purposes, see code example below.
I will also add a test for `CHANGE_LANGUAGE` action type as it is influenced as well.

```javascript
/**
 * Reducer
 */
export const initialState = {
    language: 'en',
    // ... some other properties
};

...
case CHANGE_LANGUAGE:
    return { ...state, language: action.language };
default:
    return state; // <-- remember that we have this, default case

/**
 * Test for that reducer
 */
import reducer, { initialState } from '../reducer';

it('should return initial state', () => {
    expect(reducer(undefined, {})).to.deep.equal(initialState);
});

it('should handle CHANGE_LANGUAGE', () => {
    const action = {
        type: CHANGE_LANGUAGE,
        language: 'pl'
    };
    const expectedState = {
        ...initialState,
        language: 'pl'
    };

    // mind the imported initialState passed here
    expect(reducer(initialState, action)).to.deep.equal(expectedState);
});
```

What can go wrong? Few things. Let's change default language in reducer from `en` to `pl`.

Test for initialState (`'should return initial state'`) will pass. But wait, it shouldn't be happening!
If we change something in code, at least one test should fail, right?

It's because we import initialState directly from reducer.
So how could that test fail? Also, how descriptive is that test? What about TDD approach, where you should
first have a failing test? How can you fail such a test? In current state, you can't.

Here's how it should be done:

```javascript
/**
 * Reducer
 */
const initialState = {
    language: 'pl',
    // ... some other properties
};

/**
 * Test for that reducer
 */
const initialState = {
    language: 'pl',
    // ... some other properties
}

it('should return initial state', () => {
    expect(reducer(undefined, {})).to.deep.equal(initialState);
});
```

Two things have changed:
1. `initialState` is not exported from reducer. Frankly, why would it be? Will it be used anywhere
   in the application? No. It was for tests only.
1. Right now, if `initialState` will change in reducer, a test will fail. Yes!

OK, let's check the other test, for `CHANGE_LANGUAGE` action type, with initialState still being exported from the reducer:

```javascript
/**
 * Reducer
 */
export const initialState = {
    language: 'pl',
    // ... some other properties
};

...
case CHANGE_LANGUAGE:
    return { ...state, language: action.language };

/**
 * Reducer's test
 */
it('should handle CHANGE_LANGUAGE', () => {
    const action = {
        type: CHANGE_LANGUAGE,
        language: 'pl'
    };

    const expectedState = {
        ...initialState,
        language: 'pl'
    };

    // mind the initialState passed here
    expect(reducer(initialState, action)).to.deep.equal(expectedState);
});
```

Remember that we changed language from `en` to `pl`.
Test for that action will also pass. But what happened to the test? What is THE code
needed to pass it? ... Yes, you're right, none. Have a look:

```javascript
/**
 * Reducer
 */
export const initialState = {
    language: 'pl',
    // ... some other properties
};

...
// (1) we can delete this part of the code
case CHANGE_LANGUAGE:
    return { ...state, language: action.language };

/**
 * Reducer's test
 */
// (2) and this test will pass
it('should handle CHANGE_LANGUAGE', () => {
    const action = {
        type: CHANGE_LANGUAGE,
        language: 'pl'
    };
    const expectedState = {
        ...initialState,
        language: 'pl'
    };

    // (3) because initialState is used here
    expect(reducer(initialState, action)).to.deep.equal(expectedState);
});
```

It will be even hard to spot, because initial state is being imported from reducer.
Just by looking at a test you won't be able to tell what the default language is.
Not importing initialState, but having it in test (like with initial state's test previously)
would help, but test itself would still remain meaningless.

Therefore above test should be deleted because:
 - it tests literally nothing: you could read it as `initial value should stay the same as value passed`,
   so why this action is there at all when it does nothing? Why this test
   is there at all? (test's description is to be blamed as well, but I will get
   to it later)
 - a bad test is worse than no test

So, how can this be fixed? Here's how:

```javascript
// reducer does not export initialState anymore

/**
 * Reducer's test
 */
const initialState = {
    language: 'pl',
    // ... some other properties
};

it('should handle CHANGE_LANGUAGE', () => {
    const state = { // <-- (1) create current state
        ...initialState,
        language: 'en' // <-- (2) set some value, any
    };
    const action = {
        type: CHANGE_LANGUAGE,
        language: 'pl'
    };
    const expectedState = {
        ...initialState,
        language: 'pl' // <-- (3) that will eventually change to this one
    };

    expect(reducer(state, action)).to.deep.equal(expectedState);
});
```

By creating current state with a value explicitly shown this test becomes:
 - valid and future-change-proof; if you change default language to any value, this test
   will still test if `CHANGE_LANGUAGE` action alters that value; remember that initialState
   is tested elsewhere, so no need to worry about that
 - more descriptive; one sees what happens to which state property


We still struggle when seeing the code like in example above if we should remove the boilerplate.
Our good recommendation of reading on the topic there is [post of Sandi Metz, Wrong abstraction][wrong_abstraction]{:target="_blank"}. Personally I really like the simplicity of syntax behind reducers.

If you have some more ideas for improvement, find us on Twitter!
https://twitter.com/ArturSzott and https://twitter.com/jacek_smolak

[wrong_abstraction]: https://www.sandimetz.com/blog/2016/1/20/the-wrong-abstraction
