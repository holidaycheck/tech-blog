---
layout: post
title: Workflow automation
date: 2018-04-04 12:00:01 +0200
categories: culture
author_name: Radek Benkel
author_url : /author/radekbenkel
author_avatar: radekbenkel
read_time : 10
show_related_posts: false
square_related:
---

As engineers, we like to script and automate whatever’s possible. It doesn’t matter if we’re talking about creating three-character-long aliases for a ten-character-long command, adding labels to newly created issues, or ordering a donut delivery to the office at the touch of a button (currently in development ;) - it has a lot of advantages.

Whenever you write a script or automate some process, these things happen:

- you never forget to do something, as it’s not your job any more to remember
- you don't make any errors (not counting the dozen of errors you made while writing such a script)
- the process is documented – very often the code serves as documentation
- depending on a task, it sometimes comes with a coolness factor (see donut example above)

In today’s world, where more and more products provide an API, the options are often limited only by our imagination. We have [IFTTT](https://ifttt.com/) and [Zapier](https://zapier.com/). We have self-hosted tools like [Kibitzr](https://kibitzr.github.io/) or [Beehive](https://github.com/muesli/beehive). 

This post focuses on **what** we automate at HolidayCheck and **how** we do it.

## First? Clean

Each time a branch is created/updated in our repository, the content of this branch is deployed to a staging environment (based on Mesos + Marathon). This means that a couple of minutes after pushing changes, a developer can show them to the product owner. This allows us to iterate quickly.

On the other side, the amount of resources (RAM + CPU) is limited. And people can sometimes forget to undeploy a branch when a feature is merged to production. That’s how `deployment-cleaner` was born, created by [Mathias](https://twitter.com/lo1tuma).

It was a simple application, which basically glued [express](https://www.npmjs.com/package/express), [github-webhook-handler](https://www.npmjs.com/package/github-webhook-handler) and [healthcheck-ping](https://www.npmjs.com/package/healthcheck-ping) with two-dozen lines of custom code, making API requests to the staging environment. This app would be notified via webhooks whenever a branch was deleted (which in our case is a natural follow-up to merging a feature-branch). After that happened, `deployment-cleaner` would make an API request to our staging environment causing undeployment of that specific branch.

Simple. Effective. One problem that we had with the mentioned event approach was that in case of some bug/network issue webhook or request to the API, it might not be delivered, which would mean that without manual intervention, it would stay on staging environment "forever".

So, instead of

> after a branch is merged, undeploy this specific branch

we wanted something more like

> each X minutes, fetch a list of deployed branches from Marathon, compare then with branches on GitHub and undeploy those, which are no longer on GitHub

So, in this case, more of a *scheduled* than an *event-based* approach.

## Second? Organize

At HolidayCheck, the inseparable part of development is the code review process. For a big majority of projects, an approval from a colleague is required for a pull request to be merged into `master`. Back in the day, when GitHub didn’t have official support for the code reviewing process we were relying – like a lot of different projects – on labels like `needs-review`, `in-rework`, `ready-to-merge` and of course the famous `LGTM 👍` comment, which was basically a pull request's approval.

After a couple of weeks of someone forgetting to change a label during workflow (we’re only human), we started to think how we can automate this part. What we wanted was:

> every time someone creates a new pull request, add a `needs-review` label to this pull request

So, we needed a very simple “application” to do that. Very similar to `deployment-cleaner`. Same `express`, `github-webhook-handler`, `healthcheck-ping` combo, just different custom logic.

## Third? Keep dependencies up-to-date

Some time ago we started using [greenkeeper](https://greenkeeper.io/#enterprise). It was a nice tool which helped us with keeping dependencies up-to-date. Whenever a new version of a dependency was released, the pull request with this specific change was created automatically and run through our continuous-integration pipeline. What was left for the developer was clicking the big green `Merge` button under the PR. For the first time, for the second time, for the seventeenth time, for the nth time.

Remember what I said about being a lazy engineer? Well, we thought we could automate that part, too. And so we did.

![auto-merge-greenkeeper](img/posts/2018-04-04-workflow-automation/auto-merge-greenkeeper.png)

Notes for the screenshot above:

- you can also see [mention-bot](https://github.com/facebook/mention-bot) in action (something that we stopped using a couple of months ago)
- this integration also deleted the branch after merge (which isn’t something that GitHub does automatically)
- [Borderlands](https://en.wikipedia.org/wiki/Borderlands_(video_game)) fans – you know what to look for ;)

## One to rule them all

More and more automation pieces like that started popping up at HC, so we wanted something which would serve as a “runner”. After a brief encounter with [botdylan](https://www.npmjs.com/package/botdylan) and not being able to find a replacement, we created a simple runner on our own.

And that’s how, during two December days on Gran Canaria (one of our company hackathons), [liam](https://www.npmjs.com/package/@holidaycheck/liam) was born (after almost a year of using it, we published it as open-source).

Our main ideas while developing liam were:

- flexibility
- tasks should be stateless
- might run at specific times (cron-like)
- ...or in response to some GitHub events (hooks)
- easily testable – every dependency for a task should be injected
- integrated health check

Flexibility of liam works in two ways. You don’t need `liam` in order to run liam’s task (although it’s easier with liam, especially for GitHub hooks). On the other side, you can use `liam` for running any task you want.

```js
// Require `liam` module
const createLiamInstance = require('@holidaycheck/liam');

// Provide simple logger, this parameter is required
const logger = { log: console.log, error: console.error };

// `add-jira-link` task requires githubClient instance, e.g. for our github.example.com.
// More info: https://www.npmjs.com/package/github
const githubClient = require('github')({
    debug: false,
    protocol: 'https',
    host: 'github.example.com',
    pathPrefix: '/api/v3',
    timeout: 30000
})

// `add-jira-link` task requires authenticated githubClient instance.
// Suggested approach is to generate a specific token and use it instead of credentials.
// Remember that user for which you're generating token needs to write access to the repository for some tasks.
githubClient.authenticate({
    type: "token",
    token: '..', // you can hardcode token or pass it through ENV
});

// Create liam instance passing real webhook secret, as hook task is also used. If you want to use cron tasks only, just pass an empty string as second parameter.
const liam = createliamInstance(logger, process.env.WEBHOOK_SECRET);

// Enable `add-jira-link` task running in response to `pull_request` webhook event.
// Note: such configuration will work for any repository which will point it webhooks into this `liam` instance. You can use `repository` param, to whitelist repository, see examples in docs.
liam.addHook({
    events: [ 'pull_request' ],
    handler: require('@holidaycheck/liam-tasks/tasks/add-jira-link'),
    arguments: { githubClient }
});

function doSomethingInScheduledWay(logger, args) {
    logger.log(`"foo" value is "${args.foo}"`);
}

// Run scoped function each second and display value of passed argument
liam.addCron({
    time: '* * * * * *',
    handler: doSomethingInScheduledWay
    arguments: { foo: 'bar' }
});

// Run liam server on port 3000
liam.start(3000);
```

There’s no `liam.json|yaml|conf` file here – that’s intentional. Most of the time we were restricted by possibilities of static config, so we decided to go with pure code approach. Although one can easily create something like `liam-configurator` which would read the aforementioned config and call `addHook` and `addCron` respectively.

We released some general use tasks as part of [liam-tasks](https://www.npmjs.com/package/@holidaycheck/liam-tasks) repository. In addition to these, we're using a couple of internal ones, meant specifically for our architecture, like:

- cleaning deployed branches from staging environment

- keeping our branches in sync with our translation management tool

- posting notifications on Slack when specific conditions are met (not all of them can be realized by existing integrations)

- reminding people to check whether their Slack’s `Working Remotely` status is still relevant (eg. someone forgot to change status next day) - we have a rather open home-office policy

  ![home-office-guard](img/posts/2018-04-04-workflow-automation/home-office-guard.png)

You can have one `liam` instance per company, per project, per multiple projects, you can create `liam` instances per specific tasks – it’s up to you. For us, one `liam` per project turned out to be the sweet spot, but that doesn’t mean the same will work for you.
Probot


Some time ago GitHub released [probot](https://probot.github.io/) – a framework for building GitHub Apps to automate and improve workflow. We’re experimenting with this too. For example, [Sergii](author/sergii_paryzhskyi) created [issue-prioritizer](https://github.com/holidaycheck/issue-prioritizer), which automatically calculates issue priority based on *Effort*, *Potential*, and *Weight* labels:

![issue-prioritizer](img/posts/2018-04-04-workflow-automation/issue-prioritizer.png)


Visible differences in `probot` :

- it utilizes [Github Apps API](https://developer.github.com/apps/)
- it’s more opinionated, therefore easier – it uses [@octokit/rest.js](https://github.com/octokit/rest.js) as GitHub API library, while in case of `liam` each task can use different client or dependencies
- API calls are already repository aware (eg. you don’t need to specify the repository name and owner when you want to make a comment under PR, as this is prepopulated)
- doesn’t support scheduled tasks – it’s only possible via an [extension](https://github.com/probot/scheduler)
- exposes express router so you can implement your own static routes (like health check)

Depending on your needs, `probot` might work better for you than `liam`, or it could be the exact opposite.

## Whatever you choose, be responsible

Automation is fun. Automation is for lazy people. Also, it’s not easy. Having once deleted all branches in a project while writing an automation task, I can just repeat what Uncle Ben once said:

> With great power comes great responsibility

Test your automations well. Cover error cases. And when everything works and the robots are doing your job – have a tea or coffee. You’ve earned it, lazy engineer.

*Cover photo by [Alex Knight](https://unsplash.com/photos/2EJCSULRwC8)*
