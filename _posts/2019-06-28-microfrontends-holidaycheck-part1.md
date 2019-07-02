---
layout: post
title:  "Micro Frontends at HolidayCheck (part 1)"
categories: microfrontend javascript 
author_name: Sebastian Bruckner
author_url : /author/sebastianbruckner
author_avatar: sebruck
read_time : 10
feature_image: posts/2019-06-08-browsertools-2/ben-harritt-75854-unsplash.jpg
---

At HolidayCheck we just released our first Micro Frontend, the "new header", which is placed
above all HolidayCheck pages to guarantee a common look & feel. In this series of articles I will 
elaborate why we have chosen to build a Micro Frontend, how we did it exactly and what challenges
we had to solve.

Micro Frontends are currently a big hype and controversially discussed. Cam Jackson wrote a good 
[article](https://www.martinfowler.com/articles/micro-frontends.html) on Martin Fowlers blog, additionally
[Micro Frontends recently moved to Adopt in April 2019](https://www.thoughtworks.com/de/radar/techniques/micro-frontends)
 on the ThoughtWorks Technology Radar. If you have not heard about Micro Frontends yet, I recommend you 
 to read Cam's article and the resources on [micro-frontends.org](https://micro-frontends.org/). 

## Why Micro Fronted?

Why did we decide to jump on the Hype-Train 🚂 and build a Micro Frontend? 

To fully understand the decision one has to know, that at HolidayCheck we have a lot of teams, 
which work on different parts (pages) of our product. Those parts have their own tech stack and are 
developed independently from the rest of the product. This means we face a variety of 
programming languages and frameworks. Additionally, as probably most of the companies with some history,
we have some legacy hanging around, which serve less important parts of the page and have never been
important enough to be migrated.

With this context in mind, we as a team who will be responsible for the header from now on, made a 
list of requirements for the new header. 

* It must be **technology agnostic**. We do not want to force a team to use a specific framework or language
to use the new header.
* We want to be able to **develop and deploy** the new header independently. When we change the header we do **not**
want to have to deploy every single stack which uses the header.
* It must be **fast**. The header must not slow down the page. 
* It must be **SEO friendly**. The header is an important aspect when it comes to SEO, therefore
**Server Side Rendering** the header into the initial DOM is a must.
* It must be **self contained**. The header should **not** be just a UI component but instead  contain
all the logic and capabilities to fully function as a unit.

The first two points, technology agnostic and independent development & deployment, made it clear to us
that a Micro Frontend approach is the right choice for our task. At the same time, we realised that
we must have a very very strong focus on speed. The header Micro Frontend must be very small and fast, since
with the Micro Frontend approach we cannot easily reuse existing dependencies on the page. I will write
a separate article about how we achieved 100 out of 100 points in the performance test of Google Lighthouse.

### Composition

So how to get the Micro Frontend onto the pages? There are basically two different main ways to achieve this, 
**build time composition** or **runtime composition**. 

**Build time composition** could mean that you publish your Micro Frontend as a library, for example a npm package, which can 
then be used and bundled together with the other apps. This has two major drawbacks. It is not technology agnostic, so
for example you can not simply use a npm package in an application which is rendered with PHP server side.
Also it violates the independent deployment requirement. Everytime the header is changed, one would have to
use the new version in every project and deploy it.

The other approach is **runtime composition**. This means that the micro frontend is not built and bundled 
together with the app using it, but instead it is composed during runtime of the application. This
is usually done with techniques like [Server Side Includes (SSI)](https://en.wikipedia.org/wiki/Server_Side_Includes), 
[Edge Side Includes (ESI)](https://en.wikipedia.org/wiki/Edge_Side_Includes), Client Side Includes (e.g. with a XHR) 
or frameworks like [Podium](https://podium-lib.io/) and [Tailor](https://github.com/zalando/tailor).
While the details of the different runtime composition approaches differ and each of them has their
advantages and disadvantages, the idea is the same. When the main app or page is queried, the Micro Frontend
endpoints are also queried and their results are embedded into the main page at the specified position.

We decided to use **runtime composition** with SSI on Nginx. This was the simplest setup for us, since we
already have Nginx running and had simply to add the configuration. The configuration of our Nginx
looks like this:

```
# Location of the header micro frontend
location /fragment/hc-header {
  # Standard proxying options
  proxy_http_version 1.1;
  proxy_pass http://our_api_gateway;
  proxy_set_header ...;

  # Timeouts after which nginx gives up the SSI
  proxy_connect_timeout 1s;
  proxy_read_timeout 1s;

  # Do not show response body of upstream when status is greater than 300
  proxy_intercept_errors on;

  # Fallback when the header fragment is not working or times out
  error_page 400 404 500 501 502 503 504  @fragment_hc-header_fallback;
}

# A minimal and static version of the header which is deployed to google cloud storage 
location @fragment_hc-header_fallback {
  rewrite ^/fragment/hc-header(.*)$ /hc-static-sites/fragment/hc-header/index.html break;

  proxy_set_header Host storage.googleapis.com;
  proxy_set_header Authorization "";
  proxy_pass http://storage_googleapis_com;
}

# Example usage 
location / {
  # enable ssi processing
  ssi on;
  # track requests to SSI fragments in the nginx logs
  log_subrequest on;
}
```

Inside the apps which use the micro fronted one has simply to put the SSI tag at the position in the HTML 
where it should be rendered. Nginx will pick it up, query the provided URL and embed the response body at the 
same place.

```html
<!--#include virtual="/fragment/hc-header/header?maxWidth=988&version=full" -->
```

However SSI with Nginx is not the silver bullet and we already hit some limitations of this simple setup.

* Configuration like timeouts is part of the Nginx config and therefore usually harder to change than if it would be inside code.
* It is not possible to set response headers from within a fragment. We would have wanted to modify the [Link
HTTP Response Header to trigger some preloading of resource](https://www.w3.org/TR/preload/#example-2-using-http-header) to speed up the page.
* It is not possible to set individual cache strategies per micro frontend.

So while it is a good way for us to get started, I think on the long run, when we adopt micro frontends more and more,
we will change to a more sophisticated solution.

### Tech Stack

The next thing to tackle was the tech stack of the header micro frontend itself.
Since we gave ourselves the requirement to build a very fast and tiny micro frontend, we set ourselves
performance budgets. The most important one is that we want to stay below ~10 kB minified + gzipped 
javascript (I will write a separate article about the speed aspect of the project).

This forced us to evaluate every technology choice against the speed requirement.

#### UI Rendering

Currently the standard for new web project inside HolidayCheck is React and either TypeScript or some 
EcmaScript version. Since [react](https://bundlephobia.com/result?p=react@16.8.6) + [react-dom](https://bundlephobia.com/result?p=react-dom@16.8.6) 
are already ~35 kB minified + gzipped this was a show stopper for React. After checking alternatives like
Web Components or [lit-html](https://github.com/Polymer/lit-html) we decided to stay in 
well-known filds and went with [Preact](https://preactjs.com/) + [unistore](https://github.com/developit/unistore)
and TypeScript.

Preact is a fast 3.5 kB (minified + gzipped) alternative to React with the same API. Unistore is a 
state container with component actions for Preact & React, it has a minified + gzipped size of roughly 0.5 kB.
With this round about 4 kB setup, we achieved a similar developer experience as the React setup we are used to.

Web Components would have been a very interesting alternative, but since polyfills are still needed and 
server side rendering plus state management is not as easy as with Preact, we were not courageous enough
and have chosen to not use Web Components yet. Still I am very confident that for future micro frontends 
we will use Web Components since the technologies and the eco system around it matures very quickly.

#### Styles

In another recent project, we have used CSS in JS with [Emotion](https://emotion.sh/docs/introduction). 
But both prominent CSS in JS solutions out there, Emotion and JSS with 5.8 kB and 7 kB minified + gzipped
are way to big for our performance budget of 10 kB. That why we have decided to go with the more traditional
approach and use [Stylus](http://stylus-lang.com/). Using Stylus over Less and Sass was mainly a matter of taste
and does in the end not make any real difference.

One big concern with micro frontends is encapsulation, which also affects CSS. This is where [CSS Modules](https://github.com/css-modules/css-modules)
come into place. CSS modules generate unique class names which scopes them locally. With CSS Modules
we achieved that we can guarantee that we never have side effecting CSS coming from our micro frontend.
However it still happened that the apps using the micro frontend had some global CSS rules which overrode some of 
the styles **within** the micro frontend. In such cases we had to reset those styles within the micro frontend by hand.

Side node: With Web Components and their shadow dom, this encapsulation would be built-in and have even stronger
guarantees.     

### Customization and Communication

While the new header should provide a common look and feel between the pages, there are still some 
small customizations which have to be done between the pages. One of them is the maximum width
to which the header grows. This information is simply passed a query parameter to the URL in the SSI tag.

Sometimes it might be necessary that the micro frontend has to communicate with the rest of the page.
In our case we need to update the "Favorites Counter", as soon as someone adds a hotel to their favorites.
In this case no page reload is done, so we need the ability to tell the header to update its counter during
the current page load. 

Because of that we listen on simple browser events inside the micro frontend and dispatch them outsides. For example:

```javascript
// Inside the header micro frontend
window.addEventListener('hc:favourites:count-updated', event => 
  console.log('New count is', event.detail.newCount)
);

// On the page using it
const evt = new Event('hc:favourites:count-updated');
evt.detail = {
  newCount: XXX
};
window.dispatchEvent(evt);
```

## Try it out & stay tuned!
The header micro frontend is already live on our .at page [http://www.holidaycheck.at](http://www.holidaycheck.at),
you can reach the endpoint of the micro frontend also directly here [https://www.holidaycheck.at/fragment/hc-header/header?dev=true](https://www.holidaycheck.at/fragment/hc-header/header?dev=true).
The `dev=true` parameter adds a small HTML Shell around the header which we use mainly for development and 
acceptance. On production usage the `dev` parameter is set to `false`.

Thank you for reading part 1 of the micro frontend series, stay tuned for the next articles!

