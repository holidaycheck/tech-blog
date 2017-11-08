---
layout: post
title:  "Adapting DevOps culture with C.A.L.M.S."
date: 2017-01-17 08:03:00 +0200
categories: culture
author_name: Łukasz Przybył
author_url : /author/luprzybyl
author_avatar: luprzybyl
show_avatar : true
feature_image: posts/2017-07-adapting-devops-culture-with-calms/sparks.jpg
show_related_posts: false
square_related: 
---

*DevOps* is still quite a buzzword. There are already plenty of articles describing what it is and what it isn’t. I think we can agree that it’s a culture, a way of work. I'm also sure that most of us have a general impression about what it should look like: development and operations working together, breaking down silos, deliver faster, automate, etc. All of these are important and true, but still only seem to be a partial description. I started looking for a more complex description. And I found a very interesting model describing the culture. It’s C.A.L.M.S.

C.A.L.M.S. is an acronym for five major points describing a DevOps culture. Let's have a quick look at them:

## C – Culture

This is something you cannot implement. First, you should start with people having a proper mindset and it should concern ALL team members. Everyone should be focused on a common goal and help others achieve it whether it’s within your specialization area or not. Stepping out of your comfort zone and leaning towards becoming a full-stack engineer is encouraged.

## A – Automation

We want to do as little boring stuff as possible. Therefore everything that can be automated should be done this way. And that's not only writing scripts for testing and deployment but also adapting the idea of programmable infrastructure and having everything written down, versioned, and automatically managed.

## L – Lean

Automating everything can be a pitfall that overcomplicates the infrastructure. Therefore engineers should focus on keeping everything minimal, yet useful. That doesn’t concern only automation – code deployments to production environment should be small and frequent and whole applications being developed – simple and easy to understand. It also applies to team size: larger teams find it more difficult to agree on something.

## M – Measurement

Frequent releases give great flexibility but also can put the production environment in danger. That’s why a developed application should be equipped with useful metrics and monitored in real time. In case of problems the team can be notified quickly and is able to develop a fix. Teams can also monitor how new features influence user behavior.

## S – Sharing

Sharing is essential for improving the communication flow and making people work together. Therefore it’s important to share ideas, experiences, thoughts: inside the team, among teams, and even outside the company.

What I like most about this model is how these points interact with each other. Automation should always be lean and robust. Providing an automated CI/CD pipeline helps teams to stay lean. While setting up monitoring it’s better to choose only valuable metrics and set up handy dashboards and alerts. The metrics can be shared among teams to set up a more complex application analysis tool that would automatically provide some wider context into the data we collect, which can be automatically analyzed and trigger lean changes in features …

The foundation for all these things is Culture. In my opinion that’s the most difficult point of all five. Without it, the other four points are just minor improvements to everyday work.
