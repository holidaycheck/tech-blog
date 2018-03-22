---
layout: post
title:  "Backlog Priority Automation using Github Apps"
date: 2018-03-09 12:45:00 +0200
categories: product
author_names: [ "Sergii Paryzhskyi", "Wolfram Kriesing" ]
read_time : 10
show_related_posts: false
square_related:
feature_image: posts/2018-02-23-metrics-priority/poster.jpg
---

Working in small iterations, being data-driven, user-input driven or simply lean is our ideal
style of working. And it is awesome when this works. But there are also other situations where
we have a big pile of work ahead of us that we need to sort out somehow. If it is a huge backlog with ideas, some tasks that "just need to be done" or whatever the reason is that makes us have lots of things on our plate (or in our backlog), we want to get them done efficiently.

In this post we will describe one way of how we started to prioritize our tasks. Starting from actual metrics that we want to improve, we collected actions that we can do and next we needed to figure out how to sort the actions to achieve an impact sooner.

## What's the problem?

Our exact case was the page speed. We are working on speeding up our website, which might have
a great impact.

Next we need numbers, so we setup tools that help us steadily figure out our numbers, such
as TTFB (time to first byte) and TTI (time to interactive). We also measured the file sizes of the  downloads (JavaScript files, CSS, images, ...) needed to render our website.
We setup a continuous measuring for it, which reports numbers and shows our progress.

## We have Metrics, What now?

We know our current numbers. Next we needed to find a way to figure out the potentials we have
in certain areas. For example, TTFB of 1.5s might be a great number, but we don't know. So
we figured out what to compare this number to (there are many ways to do that). Let's say in this case we saw there is **a 10% potential** by which we can improve this number (to 1.35 seconds).

We look at the actions that we can take in order to speed up this metric. Once we derived **ten actions** we still had no clue which one to do first. So we need some numbers that we can use to decide what we shall work on.

Why? Because the plan and the reality always diverge and we won't get all ten actions done. So let's try to plan for being most effective as soon as possible. Let's not just work on them in alphabetical order. Let's instead figure out which one has
**the most impact soonest** and let's start with it. We could come up with a million
reasons why we won't finish all actions,
so let's make sure the actions are sorted to push this topic as far as possible.

## How to sort the Actions

Above we explained that we have the following facts:
- **the potential** (here 10%) by which we can improve our metrics
- ten **actions** that might improve our metric
- **many metrics**, with actions and potential that we need to prioritize

Our one metric TTFB is only part of what contributes to our overall goal.

Next:
- figure out potential per actions (might be an experiment)
- figure out effort
- determin weight
- finally calculate the priority

Determine metrics such as potential, effort and weight of every issue is not something we can automate. Those values should be discussed and defined for every issue manually, ideally in a group. It increases probability that different opinions and concerns will be raised and those values will be defined more precise. For this reasons we created issue labels on github with names such as "Effort: 0.1", "Effort: 0.2" ... "Effort: 1.0" and so on for other two metrics "Potential" and "Weight". 
As soon as we have all metrics set, we can calculate a priority of the issue. That's the part that can be automated and here is a formula we came up with to determine in which order to work on pool of issues in backlog:
```
2 * potential + 1 - effort + weight
```

Knowing that all metrics are in range from 0.1 to 1.0, we can tell that our range of possible priorities is between 0.3 and 3.9.  
Our next step towards automation was to create a bot that would constantly listen to the changes in issue labels and react to those changes accordingly. Let's say, as soon as manual work done and all metrics for an issue are set, this bot would calculate priority based on these values and set proper priority-label to this issue.  


## Automating things

There is a pretty new concept on Github which helps to create bots or better to say develop GitHub Apps. It calls [Probot][probot] and its aimed to extend standard GitHub functionality and build on top of it. It also provides a much simpler way of being aware what happens in terms of events and provides interface for taking actions based on these events.  
We've published our app and you can install it for any repo you have access to. This app does pretty much what described above. Here is a little demo to visualise this process:

<img onClick="this.src='{{site.baseurl}}/img/posts/2018-02-23-metrics-priority/demo-labels.gif'" src="{{site.baseurl}}/img/posts/2018-02-23-metrics-priority/demo-labels-play.png" alt="Demo" />

You can find this app in Github Marketplace and install it from [this Github Page][app]. This project was [open sourced][repo], you might want to adopt or extend it for your needs.

<img src="{{site.baseurl}}/img/posts/2018-02-23-metrics-priority/install-app.png" alt="Install the App" />

[probot]: https://probot.github.io/
[app]: https://github.com/apps/issue-prioritizer
[repo]: https://github.com/holidaycheck/issue-prioritizer

## Next Steps

There were some other ideas on how to extend bot's functionality. Some of them were born just by looking at all those events you can listen on Github and all actions you can perform with their App Engine or API.  
One of the things that is on a very top of our to-do list is automated sorting of issues based on priority label. This can be implemented by listening on all label-events and changing of issues order. So, as soon as something change there - it is a sign issue has to be sorted based on number in Priority label.  
Everyone is welcome to contribute and make [feature requests][feature-requests].

[feature-requests]: https://github.com/holidaycheck/issue-prioritizer/issues 

