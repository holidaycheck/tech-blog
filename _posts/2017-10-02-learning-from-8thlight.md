---
layout: post
title:  "Learning from 8th Light, Day 1"
date: 2017-10-02 10:03:00 +0200
categories: how-we-learn 
author_name: Wolfram Kriesing
author_url : /author/wolframkriesing
author_avatar: wolframkriesing
show_avatar : true
show_related_posts: false
square_related: recommend-wolf
feature_image: posts/2017-10-02-8thlight-1/8thlight.jpg
---

It all started at [BusConf], this August. Tobias Pflug (a colleague from HolidayCheck) asked [Daniel Irvine] (from [8th Light London]) if we could come over to London to learn from 8th Light about their apprenticeship program.
Why? Because we want to be attractive to talent to stay competitive. Therefore we want to attract talent and stay competitive.
Very simple :).

[Daniel Irvine]: https://twitter.com/d_ir
[BusConf]: http://www.bus-conf.org
[8th Light London]: https://8thlight.com/locations/london/

## Boarding the 8th Light plane

So Tobias and I boarded to London last Tuesday, to spend at least three full days with the 8th Lighters.
On Wednesday we met at 8:30 in front of the hotel, had a typical english breakfast and went to the 8th Light office. Since it was a nice 20 minutes walk from the hotel to the office, we got to "smell" some London flair. I always liked London.

Arriving at the office. It was a bit hidden in a side road. Katerina, Gabi, Matt, Mollie, Jim, Daniel, Sarah, Enrique and Rabea warmly welcomed us. We shook everyone’s hand introduced ourselves, had been shown around and were told to grab any seat we like. In the 8th Light office you find your desk via hot desking, which means you choose to sit any of the available desks. Most of them have a monitor and two keyboards, more about that later.
Everyone who came later went around and either shook everyone’s hand or fist-bumped with each other in the office. Later Amelia came with Noa, and the office began lightning up even more when the 9 months old crawled around the office. So cute.

We got to the office around 9:30, because we heard that at 9:45 8th Light has an office-wide standup. So we got together and everyone shortly said what was the plan for the day. We thanked 8th Light for giving us the opportunity to join them for a couple of days and learn for our upcoming apprenticeship program. We offered ourselves as pairing partners and had been welcomed again.

Katerina mentioned in the standup she wanted to fix her vimrc. Katerina is in her resident apprenticeship, once she graduates to become a crafter she will work with 8th Light clients.
I am an occasional vi user, so I had no clue about vimrc. But Tobias did and sat beside her and they both fixed the vim setup. Katerina had had written down lots of keyboard shortcuts for vi in her notebook and she seemed to be quite familiar with vim already. As we learned later vim and the terminal multiplexer tmux are the essentials [everyone learns][chris-learns-vim] early on in 8th Light. I like that, it will challenge me too.  
She had also mentioned in the standup, she was about to dive into MySQL and is looking forward to create her first table. Since I like relational databases I was curious to sit down with her. She opened the MySQL shell and started typing her `CREATE TABLE` statement. It didn’t take long until she had created and adjusted the table. Every once in a while she spoke a short sentence of joy like “what a joy” or “exciting”. It was really energising to watch her succeed step by step.
Later I asked her why she is learning MySQL. And it turned out that she is working off some exercises from the book [Exercises for programmers][exercises-for-programmers]. Her current task is building a song collection application. It started out to be a collection of songs in an array, later the songs got written into a file and now she was about to read and write them in a database. This way she starts with a simple core and extends the application, the technologies to learn, the APIs and also the ways to test the application.

[chris-learns-vim]: http://c-j-j.github.io/2015/01/07/transitioning-from-intellij-to-vimtmux.html
[exercises-for-programmers]: https://pragprog.com/book/bhwb/exercises-for-programmers

Throughout many discussions we discovered this is a common pattern and it makes a lot of sense, I think. Apprentices in 8th Light learn to solve the core of a problem as simple and as fast as possible. Might it be Tic Tac Toe, a song collection or the famous HTTP server, that everyone in 8th Light builds as part of the apprenticeship. The next step is to add other technologies into the game, like different storages or frontends, or alikes. And by this the core problem stays the same but the supporting technologies become more complex. There might be a server-client scenario, a command line tool or a web frontend that needs to be written. Each of the combinations adds a different level of complexity and its` own challenges, just like in real life. Continuous Deployment is also added into the game early on.
That underlined a common theme we learned, during an apprenticeship every 8th Lighter does not only learn multiple programming languages but everything you need to get a product idea from the board to production.

## Learn about Apprenticeship

After the great lunch (I don’t think you can eat bad in London) I sat aside Mollie and Katerina. Before lunch Katerina didn’t want to hook up the database yet to her Ruby code, since she expected to refactor the code a bit first. That’s what Mollie now helped Katerina with. They opened the tests she had written and dived deep into mocks, spies, fakes and the alikes. It was amazing to see how easily Mollie explained what they are and how the RSpec implementation of them ticks. She didn’t talk all the time. Mollie used most of the time to allow Katerina to think. It was amazing to see and just underlines what Daniel describes in [his blog post][4-tips-mentoring]: “a mentor is like being a tour guide […] go too fast and they won't take everything in; go too slow and they'll be bored”. Mollie did a great job I think. It was fun to watch the two.

[4-tips-mentoring]: https://dev.to/d_ir/4-tips-for-mentoring-developers-894

Later [Rabea] took the time to answer all of our questions about apprenticeship and surrounding things. She had [graduated][rabea-graduates] in August 2016. From her we learned all the things about the schedule of an apprentice and that the apprenticeship is modelled after a real software project, which means there are weekly iterations, there is a planning and retrospective, the tasks have to be estimated and you are responsible for handling your “project”, which is your apprenticeship.
Let’s wind time back a little bit. It was in June 2015 that [Rabea wrote][rabea-becomes-developer] on her blog: “If you had told me a year ago that I would be working as a developer now, I wouldn’t have believed you. A developer? Me?”. She is a developer and not just that, she is going beyond and teaching us how to setup an apprenticeship program. The apprenticeship program is what other companies would call onboarding, but in a way more dedicated and focused way. You get to learn the technologies, techniques and mechanisms that make up professional software development. This is not a course you go to, sit on a bench, fall asleep on your table and hopefuly pass an exam at the end of it. No, not at all. This apprenticeship is a hands-on learning experience where you have a mentor and co-mentor assigned to you. They help you structuring your apprenticeship. You have regular checkins with them, you exchange learnings with other apprentices and everyone around in the office. And you graduate to become a crafter, which means you have learned all the basics. By no means you know all the things. But you surely know how to help yourself in all kinds of situations. Oh, right … there are not only technology skills involved, absolutely correct. There is soft skills, agile basics and communication skills involved. The apprenticeship is what 8th Light sets as the initial bar you have to want to take. If you don’t, you probably never even make it all the way to graduation.

[Rabea]: https://twitter.com/aebaR
[rabea-graduates]: https://twitter.com/8thLightInc/status/766669001317646336
[rabea-becomes-developer]: http://rabea.co.uk/blog/personal/my-first-job-as-a-developer

## IPM

After having learned from Rabea we had been invited to the IPM, the Iteration Planning Meeting for Gabi. Gabi had started at 8th Light in the administration (not as a developer!) and is now switching to be an apprentice full-time. That means she is changing careers, basically. We sat down with Rabea, Georgina and her for this iteration planning meeting. This meeting is the weekly catch-up meeting every apprentice has. It is like sprint review and planning. Gabi went through a list of java koans she had been working on in the last week, explained which ones she had finished and which ones not yet. She manages the expectations of her mentors well. Later her mentors prioritised which of the koans left she can skip, since they don’t add much value. In her last iteration she finished mostly everything and she reported that she enjoyed it a lot but still feels like there is a huge mountain to learn before her. I got the impression that she is making good progress but feels challenged enough to not be bored. Some bits and pieces of what she is learning might only fall into place the more she uses them, but that is a normal thing when learning. Not every detail needs to be crystal clear yet. The apprenticeship is for learning and practicing. And the mentors are there for guidance.
Next step in the IPM was to figure out what is coming up next week. There was a backlog of some items, maybe enough for 2 weeks or so. Gabi selected some items that she sees as possible for the next iteration. Among them was reading the book [Extreme Programming Explained]. Another important book that I saw mentioned quite often in the 8th Light apprenticeship was [TDD by Example].

[TDD by Example]: https://www.goodreads.com/book/show/387190.Test_Driven_Development
[Extreme Programming Explained]: https://www.goodreads.com/book/show/67833.Extreme_Programming_Explained

## Pairing with Sarah

As the last thing for day 1 I paired with Sarah on a react app she was working on. The backend was a sinatra (ruby) app. She stepped through the code a bit with me and I tried to understand what was going on. I was no big help, but it was interesting to see how the tests were structured, how they wrote their application and how finding the bug works. She added “TODO” comments in the code, that she always works off before finishing the branch, so she can’t forget things. Sounds definitely much better than leaving the to-dos in the code :).
This was real life and a real project, and I saw that there is no magic going on behind the scenes. The react code was tested with react-tools, no enzyme yet, because it hadn’t existed at the time. But what I observed as significant was that all the tests ran in no time. They served as the feedback loop you need in order to change and adapt code fast and have your back covered by tests.
We didn’t get much done, I wanted Sarah write some tests, run them and removing all the to-do comments. 

## Call it a Day - Day 1

And then it was pub-time. That seems to be standard in London. The pubs are all crowded around 6pm. It seems that all offices spit out people and they go to the pub after work. So we also went around the corner for a beer and kept discussing apprenticeship programs and experiences. It was our main theme for those days. Thanks for all the learnings.
