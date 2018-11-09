---
layout: post
title:  "Simple Slackbot"
date: 2018-11-09 00:03:30 +0200
categories: javascript
author_name: Sergii Paryzhskyi
author_url : /author/sergii_paryzhskyi
author_avatar: sergii_paryzhskyi
read_time : 7
show_related_posts: false
square_related: recommend-wolf
feature_image: posts/2018-11-09-simple-slackbot/poster.jpg
---

Recently I've built a small slackbot that is posting with certain regularity in a specified Slack channel. I will tell you about the idea behind it and also share some technical details.


## The Idea

The idea to build such a bot came from one colleague of mine - [Jacek Smolak][jacek]. At that point he was reading the book ["97 Things Every Programmer Should Know"][book-link]. In order to share those programmer tips with others and also remind them to himself, he came up with idea of posting each of them one by one on a daily basis in appropriate Slack channel. For us this Slack channel is #craft, you probably have something similar amoung your channels as well.


## Implementation

It is dead simple. As it was written in JavaScript, the easiest way was to use the official [slack npm package][slack-npm]. Posting something in specific channel is just a one-liner that returns a Promise that we can handle depending if it is success or failure:

<em class="snippet-description">Post message to Slack</em>
```js
slackClient.chat.postMessage({
    channel: '#craft',
    message: '...'
});
```

The very same interface is used for sending direct messages, so without changing anything you can specify your own Slack-name instead of channel. In this case you will be getting the messages from the bot directly. It can be quite handy when you want to test it manually.

Let's have a look on how we are going to pick the quotes that should be posted. The simpliest source would be a json file, that can look like this:

<em class="snippet-description">JSON file with quotes</em>
```js
    [
        "quote 1",
        "quote 2",
        ...
    ]
```
We have to pick one quote at a time to post it, but in this case we don't want to pick a random quote, but rather to relate those quotes to specific days. In other words, every day has its own quote. Doesn't matter how often we run the script during the day, this quote will be the only one for this day. That was easy to achieve by picking a quote based on a current day of the year.


## Scheduling

In our case we run this on [Kubernetes][kubernetes], so scheduling is just a part of deployment configuration. For instance to post Slack messages everyday at 9:15 from Monday to Friday is just a cron instruction that look like this `15 9 * * 1-5`. You will probably use something your infrastructure provides you for this manner.
Other option would be to use one of the many js-scheduler packages, which provide this functionality, for example  [cron-scheduler][cron-scheduler].
If setting schedule with cron-syntax looks not very friendly, you can use this nice [web interface][cron-generator] to define time period and make it generate it for you.


## Try it

As I've mentioned before, this project is open sourced, so you can actually try it out and run for your Slack as well. You can find the source code [here][github-quote-bot]. What needs to be specified is a name of the json file which serves as a source for information that has to be posted, and a name of a Slack channel where it should be posted. This customization allows you to use the same bot for very different purposes. For instance, with other sources of data it could serve you as a bot that post a word of the day in a channel of German learners. You can probably come up with many other scenarios when it can be used. Feel free to open pull requests and make suggestions on how to improve it as well.


[jacek]: http://techblog.holidaycheck.com/author/jaceksmolak/
[book-link]: http://shop.oreilly.com/product/9780596809492.do
[slack-npm]: https://www.npmjs.com/package/slack
[cron-scheduler]: https://www.npmjs.com/package/cron-scheduler
[github-quote-bot]: https://github.com/HeeL/quote-bot
[cron-generator]: https://crontab-generator.org/
[kubernetes]: https://kubernetes.io/
