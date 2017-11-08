---
layout: post
title:  "Keeping C.A.L.M.S. at HolidayCheck"
date: 2017-01-26 15:54:00 +0200
categories: culture
author_name: Łukasz Przybył
author_url : /author/luprzybyl
author_avatar: luprzybyl
show_avatar : true
feature_image: posts/2017-07-adapting-devops-culture-with-calms/sparks.jpg
show_related_posts: false
square_related: 
---

In the last article called "Adapting DevOps culture with C.A.L.M.S." I’ve described the C.A.L.M.S. model and showed its importance and usefulness for proper adaptation of DevOps culture.

At HolidayCheck we believe in DevOps culture and try to follow it on daily basis. As a DevOps Engineer, I’m a member of developer teams and provide them with support regarding infrastructure and system engineering. Having the ability to work with several different scrum teams in this company I have noticed that there are better and worse adaptations of DevOps culture. However, the most recent one I had a chance to work with did it surprisingly well and I would like to share my thoughts about last six months working with them.

### The challenge

Six months ago I was assigned to a newly formed squad with one focus: to integrate external user handling solution with our platform. At first, it sounds simple. However, if you have three different platforms, written in different tech stacks, some of them during migration, some considered legacy with lack of documentation or people knowing how it works –it can be more difficult than one could think. Apart from writing our own services, we were also meant to work with code owned by other teams. That meant sending pull requests and asking people to review and accept. It’s also worth mentioning that there was already one approach to rewrite user handling modules. It was very painful and did not finish, which made user handling the least pleasant part to be developed in the IT department. On top of that, the new team was assembled from people who hadn’t worked with each other before. They were taken from other teams and an external outsourcing company. It all made me a bit skeptical about this project.

### C - Culture 

Surprisingly, I have noticed that every team member independently brought elements of DevOps culture to the team. People had a strong sense of ownership, willingness to make a change despite the known UH reputation. Every sprint they focused on minimizing work-in-progress to deliver as much as possible, even if that caused their own tasks not to be delivered. But what I liked most was no fear of stepping out of one’s comfort zone and do stuff they were not specialized in.

### A - Automation 

The code we started to develop was kept as simple as possible, allowing people to take over development in case of someone else’s unexpected absence. Also, automation was kept lean. We chose Jenkins 2.X as our build/deployment server, set up a hook on whole GitHub repository and agreed that every repo, every branch will have a Jenkinsfile describing a pipeline. Although I was the one to set up the initial tool, the whole process of building and improving pipeline was quickly taken over by all team members adjusting it to their needs while I was providing support if needed. Demands, expectations, and being pushy were replaced here by pairing, contributing, and supporting to have it ready sooner.

### L - Lean

We remembered to stay lean. Having a continuous delivery pipeline, every change merged to the release branch was immediately deployed to production. Also, we focused on the absolute MVP to be able to go live and handle at least some test traffic. This gave us very important feedback regarding possible improvements. Pull requests to other repositories were prepared and posted in advance. Therefore we had our changes in foreign code already deployed to production, not interfering with current functionalities and waiting for a moment to take over user handling flow.

As we were a pretty small team with three developers, a product owner and a devop, we were trying to keep meetings brief. People didn’t need reminding to prepare for refinements or plannings, so the time needed to work out an agreement was also short.

### M - Monitoring

Before going live we started defining metrics and aggregating logs in one place. We had to put some extra effort to automatically pull logs from the provider but that paid off with detailed user monitoring and ability to cross check error logs with events delivered by a third party site. As the output, we got multiple dashboards and log filters analyzing almost every aspect of the running application: from pure system metrics like resource consumption, latency, and uptime, to detailed information about user behavior with an ability to trace errors back to few requests before to better understand the context. After exposing a new login to live traffic every 5xx error was immediately alerted on team’s Slack channel and, thanks to gathered links and dashboards, we could identify a root cause within a few minutes.

### S - Sharing

I also saved one more surprise for the end. Although the company policy was to have co-located teams, due to a shortage of personnel our team was partly distributed. Apart from me, all team members were sitting in the same room in Munich, DE and I was working from the office in Poznań, PL. Also due to other responsibilities I could not allocate more than 60% of my time for this team. Our internal communication, sharing opinions and ideas, was so good that most of the time I didn’t feel excluded at all. To be honest, working with them, even as a remote devop, was more enjoyable to me than working with some other teams co-located in one room.

Now that our goal is achieved and I am switching teams once again, I have decided to take a look back at the last 12 sprints and try to learn from it. And of course to share with you.

### Summary

Was it really that candy-sweet all the time? Of course not, we had our problems. Starting with me not being 100% in the team. I regret that I could not get more involved in coding. Sometimes, especially in the very middle of the project, our meetings were too long and seemed pointless to me. Out CI pipeline crashed several times, blocking the whole development process and causing lot of tension. We were dependent on other teams which sometimes weren’t willing to help us because it was not compliant with their OKRs. It all happened more than I’d like, but I’m happy that we did work it out together and fixed it instead of pointing fingers.

What I personally learned from it was that:

 * the proper mindset is an absolute foundation for good DevOps culture
 * having a smaller team of engineers inclined to be full-stack means it’s better at self-managing and does not suffer in case of someone being suddenly absent
 * automation should be lean and constantly improved. Don’t put too much overhead on it at the beginning.
 * we should treat our applications as our own piece of production cake, equip it with a number of useful metrics and get knowledge out of them
 * ideas for the technological process should not be turned down by product people, as they influence greater delivery speed in the end of the day

I hope that I can take this knowledge and use it in the new project I’m about to join.
