---
layout: post
title:  "Thoughts on Value Stream Mapping and Theory of Constraints"
date: 2017-10-20 14:03:00 +0200
categories: event
author_name: Nikolay Sturm
author_url : /author/nikolaysturm
author_avatar: nikolaysturm
show_avatar : true
read_time : 4
show_related_posts: false
square_related:
feature_image:
---

We had an internal event with [J.B. Rainsberger](http://www.jbrains.ca/)
recently, where he presented
[Value Stream Mapping](https://en.wikipedia.org/wiki/Value_stream_mapping) and
[Theory of Constraints](https://en.wikipedia.org/wiki/Theory_of_constraints)
as a viable approach for improving development team performance.

In this post, I will comment on that approach from a perspective shaped by
[Complex Adaptive Systems](https://en.wikipedia.org/wiki/Complex_adaptive_system)
and the
[Cynefin framework](https://en.wikipedia.org/wiki/Cynefin_framework).

*Theory of Constraints* has its roots in industrial process optimization, where
individual process steps are usually pretty well understood and repeatable. In
Cynefin terms, this sounds very much like the *Complicated Domain*. Cynefin's
recommended actions for this domain are sense--analyze--respond. Applied to
*Value Stream Mapping* and *Theory of Constraints* this would be:
- **Sense**: map the value stream and gather data
- **Analyze**: identify the bottleneck
- **Respond**: intervene with good operating practices to dissolve the bottleneck

As a first order approximation, this view makes sense for software development.
There, we also have pretty clearly identifiable steps that could be mapped by a
value stream. And indeed, this is basically how you get started with
[Kanban](https://en.wikipedia.org/wiki/Kanban_%28development%29) in software
development.

However, software development lacks a critical feature of industrial processes,
it is not a repeating process. Developers continuously build *new* features,
they *invent* new solutions, their work is *creative* in nature. This
strongly questions the applicability of *Theory of Constraints* for software
development and suggests that it is not a *Complicated Domain* process.

If we look closer at the process of software development, we see a few
interesting properties:
1. There are certain process constraints like choice of programming
   language or a time budget for specific features, but developers are
   generally free to implement solutions freely within these constraints.
   In Cynefin terms, these would be *enabling constraints*.
1. Similarly to the first point, the implementation of a new feature is
   often times unclear until work starts. It *emerges* from the interaction
   of the developer with the existing code base.
1. This interaction also has qualities of *coevolution*. Developers, their
   techniques, and the code often change in interdependence.
1. The path from pre-feature code base to post-feature code base is often
   only clear in hindsight. We observe *retrospective coherence*.

The properties described above are the cornerstones of a *Complex Domain*
process in Cynefin. Suggested actions are
- **Probe** with parallel, safe-to-fail experiments
- **Sense** the system's reaction to the probe
- **Respond** by reinforcing positive reactions and dampening negative ones

However, that is not the whole picture either. Sometimes features are well
understood and it is pretty clear what to do. The code base is in good shape
and there are no surprises. There actually are features that can be implemented
with a *Complicated Domain* approach.

Now, what does this tell us? Actually, there is not a single process of
software development, but there are features of varying degrees of complexity
that require different approaches for successful implementation. If we
understand which of our features are deeply in the *Complex Domain*, which ones
are pretty clear and "just" complicated, we can manage our features and the
team's workload appropriately. We can manage feature velocity by not
overwhelming the team with uncertain, *Complex Domain* features but can balance
these explicitly with well understood, *Complicated Domain* features and even
some *Obvious Domain* quick wins.

So, my final take on *Theory of Constraints* and *Value Stream Mapping* is
this: they may have their value optimizing processes in the
*Complicated Domain*, but big picture they focus on the wrong thing.

> Think effectiveness with people and efficiency with things.
> Stephen Covey

In software development, we shouldn't concern ourselves too much with
*efficiency*. The interesting question is rather that of *effectiveness*.

If I could spark your interest in the Cynefin framework and you want to learn
more, in particular how to apply it to software development, I suggest you
go over to Liz Keogh's blog and take a look at
[Cynefin for developers](https://lizkeogh.com/cynefin-for-developers/).
