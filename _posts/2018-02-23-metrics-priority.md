---
layout: post
title:  "Backlog Priority Automation using Github Apps"
date: 2018-04-11 14:45:00 +0200
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

In this post we will describe one way of how we started to prioritize our tasks. Starting from actual metrics that we want to improve, we collected actions that we could do. Next, we needed to figure out how to sort the actions to achieve an impact sooner.

## What was the problem?

Our exact case was the page speed. We were (and still are) working on speeding up our website.

In order for us to be data-driven, we needed numbers. We set up tools that helped us steadily figure out those numbers, such
as TTFB (time to first byte) and TTI (time to interactive). We also measured the downloaded file sizes (JavaScript files, CSS, images, ...) needed to render our website.
We've also set up a tool to continuously measure them (numbers) and produce reports showing our progress.

## We had metrics, what was next?

We knew our current numbers. Next we needed to find a way to figure out the potentials we had
in certain areas.

For example, TTFB of 1.5s might sound very good, but we didn't know.
So we figured out what to compare this number to. Let's say in this case we saw there was **a 10% potential** by which we could improve this number (to 1.35 seconds).

We took a look at the actions that we could take in order to speed this metric up. Once we derived **ten actions** we still had no clue which one to do first. So we needed some numbers that we could use to decide what we were going to work on.

Why? Because the plan and the reality always diverge and we wouldn't get all ten actions done. So we tried to plan for being most effective as soon as possible. We didn't want to work on them in just an alphabetical order. Instead we wanted to figure out which one would have
**the most impact the soonest**. And that would be the one to begin with. We could come up with a million
reasons why we wouldn't finish all actions,
so we had to make sure the actions were sorted to push this topic as far as possible.

## How to sort the actions

We explained above that we had the following facts:
- **the potential** (here 10%) by which we could improve our metrics
- ten **actions** that might improve our metric
- **many metrics**, with actions and potential that we needed to prioritize

One of our metrics, TTFB, was the only part of what contributed to our overall goal. So we had to make sure to set all of the actions into relation to one another and find the right order for them. **The potential** is one part of the formula. **The effort** that is required to implement a feature is another one and the third one, we defined, was **the weight**. 

**Effort** didn't need much explaination, since we needed to know if a task was just a simple change or felt like it was impossible to do. **The weight** was the most volatile and dangerous factor here, since it couldn't be determined very explicitly. In order to prioritize correctly we needed also to take into account: the legacy factor, the danger, the risk, user experience, and so on. That factor should have been chosen by the same people applying the same standards. This made it a useful and consistent value.

Determine the metrics, potential, effort and weight of every issue is not something we can automate. Those values should be discussed and defined for every issue manually, ideally in a group. It increases probability that different opinions and concerns will be raised and those values will be defined more precise. For this reasons we created issue labels on github with names such as "Effort: 0.1", "Effort: 0.2" ... "Effort: 1.0" and so on for other two metrics "Potential" and "Weight". 
As soon as we have all metrics set, we can calculate a priority of the issue. That's the part that can be automated and here is a formula we came up with to determine in which order to work on pool of issues in backlog:
```
2 * potential + 1 - effort + weight
```

Knowing that all metrics are in range from 0.1 to 1.0, we can tell that our range of possible priorities is between 0.3 and 3.9.  
Our next step towards automation was to create a bot that would constantly listen to the changes in issue labels and react to those changes accordingly. Let's say, as soon as manual work done and all metrics for an issue are set, this bot would calculate priority based on these values and set proper priority-label to this issue.  


## Automating things

There is a pretty new concept on Github which helps to create bots or better to say develop GitHub Apps. It is called [Probot][probot] and it's aimed to extend standard GitHub functionality and build on top of it. It also provides a much simpler way of being aware what happens in terms of events and provides interface for taking actions based on these events.  
We've published our app and you can install it for any repo you have access to. This app does pretty much what described above. Here is a little demo to visualise this process:

<img onClick="this.src='{{site.baseurl}}/img/posts/2018-02-23-metrics-priority/demo-labels.gif'" src="{{site.baseurl}}/img/posts/2018-02-23-metrics-priority/demo-labels-play.png" alt="Demo" />

You can find this app in Github Marketplace and install it from [this Github Page][app]. This project was [open sourced][repo], you might want to adopt or extend it for your needs.

<img src="{{site.baseurl}}/img/posts/2018-02-23-metrics-priority/install-app.png" alt="Install the App" />

[probot]: https://probot.github.io/
[app]: https://github.com/apps/issue-prioritizer
[repo]: https://github.com/holidaycheck/issue-prioritizer

## Next Steps

There were some other ideas on how to extend the bot's functionality. Some of them were born just by looking at all those events you can listen on Github and all actions you can perform with their App Engine or API.  
One of the things that is on a very top of our to-do list is automated sorting of issues based on priority label. This can be implemented by listening on all label-events and changing of issues order. So, as soon as something changes there - it is a sign issue has to be sorted based on number in Priority label.  
Everyone is welcome to contribute and make [feature requests][feature-requests].

[feature-requests]: https://github.com/holidaycheck/issue-prioritizer/issues 

