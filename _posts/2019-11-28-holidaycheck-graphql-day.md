---
layout: post
title:  "HolidayCheck GraphQL Day"
categories:
author_name: Sebastian Bruckner
author_url : /author/sebastianbruckner
author_avatar: sebruck
read_time : 10
feature_image: /posts/2019-11-28-holidaycheck-graphql-day/graphqllogo.png
---

This week we had an internal GraphQL Day at HolidayCheck in the Munich office. In this article I
will share with you why we did it, what we talked about and the outcomes.

## The State of GraphQL at HolidayCheck
As of 2019 we have several first experiments with GraphQL running in production. For example on the 
"[Pauschalreisen Page](https://www.holidaycheck.de/urlaub/pauschalreisen)" to query data from our
CMS or inside the "My HolidayCheck" area, to query your bookings and contributions (e.g. hotel reviews).

However the knowledge gap between the teams is quite high and we have no shared strategy for a streamlined
usage of GraphQL.

## The goal
One goal was sharing the existing knowledge regarding GraphQL company wide and getting new knowledge
from the outside in. For that we invited Simon from our sister company Xing to
show us how they do GraphQL since 2017 on a large scale. I was very happy when Simon agreed to come,
a big thank you again Simon!

The other goals were to have discussions if, how and when we think it would make sense to use GraphQL
and of course to have a great day together.

## What happened

In total 34 Software & Platform Engineers from our three main locations (Bottighofen/CH, Munich/DE and Poznan/PL)
joined the day, we had five talks, a lively discussion and a lot of coffee ☕️.

After some welcome words from my side [Daniel Bolivar](https://twitter.com/ddanielbee) gave an 
introduction to GraphQL for absolute beginners, since for some attendees it was the first contact with
GraphQL. After a short introduction what GraphQL is and what it promises, the major parts of his
talk was live coding inside the great [GraphQL Playground](https://github.com/prisma-labs/graphql-playground).

The next talk was already the highlight of the day. Simon showed us how they do GraphQL at Xing
company wide with a team of hundreds of engineers. After that he held a Q&A, were he answered all our 
questions. Unfortunately, due to our time schedule, we had to stop the session after two hours, 
otherwise we could have easily asked him questions for hours 😉. The main lesson I took from his 
session is, that it is essential that everyone can easily contribute to the Graph, no
matter what programming language or tech stack they know. If you want to know more about GraphQL at Xing
I recommend to check the articles on their [Xing Engineering Blog](https://tech.xing.com/tagged/graphql).

After the lunch break [Dejan](https://twitter.com/dejanr) showed us how _API First with GraphQL_ led to
great success in his former company. They managed to largely decouple the development processes of different
agencies contributing to the same product by agreeing on a schema at the very beginning.

Then [Ian](https://twitter.com/IoCxe) showed us a concept he calls _UserQL_, it makes User Data
accessible and manageable in the age of GDPR and ePrivacy. He also gave us a quick introduction into
GraphQL Subscriptions and [HyperGraphQL](https://www.hypergraphql.org/).

The final talk of the day was called _One Company, One Schema_, held by [Francesco](https://twitter.com/zanini_me) and
Frank. They explained why it makes sense to have only one Graph as a company and how that relates to
DDD (Domain Driven Design). Finally they showed use the concept of a GraphQL Gateway which allows to combine
the advantages of having one Graph while still maintaining the independence which is provided by a Micro
Service architecture. The two projects they showed us are [Apollo Federation](https://www.apollographql.com/docs/apollo-server/federation/introduction/)
and the [nautilus gateway](https://gateway.nautilus.dev/). Their conclusion was that Gateways are a 
very interesting and new technology but not quite there yet. It is good to have them in mind for next
year.

The last session of the day was a round table discussion in which we discussed and shared opinions about
the future of GraphQL at HolidayCheck. The large majority of attendees had the opinion that GraphQL
would let us deliver value for our users faster and wanted to follow up on the topic. The most
interesting discussion were those around how to get priority for it within HolidayCheck and how a 
team/organisational setup could look like.

# Conclusion
I enjoyed the day a lot and it was great to see so much interest for the topic. I learned a lot and am
already excited where our journey with GraphQL will lead us to. 

Thanks to everyone who was there and made it such a great day!