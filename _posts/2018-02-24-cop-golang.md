---
layout: post
title:  "Go: The Beginning"
date: 2018-02-24 14:55:10 +0200
categories: how-we-learn
author_name: Sergii Paryzhskyi
author_url : /author/sergii
author_url : /author/sergii_paryzhskyi
author_avatar: sergii_paryzhskyi
read_time : 10
show_related_posts: false
square_related:
feature_image: posts/2018-02-24-cop-golang/poster.png
---

We've been already using Go at HolidayCheck for quite some time. There are some services written with Go and also the primary user of it is our infrastructure team. Apart from that there is a broad list of tooling in use such as Kubernetes or Traefik.  
Last week we had the first session of community of practices for Golang. Even though this initiative was started and organized by people who are using Golang on a daily basis, it was inclusive and very beginners friendly. It was even oriented on people who are either not familiar or know very little about the language. This bar will be certainly raised with following sessions, but that was a good start and it caught people attention.  
I would say the whole situation around it reminded me once again what HolidayCheck is about. People have opportunity  and willing to push topics they care about, contribute, share knowledge in different ways, without asking permission for doing good things.

## Introduction Talk

After a short intro to the new community of practices itself and clarifying some organizational questions, we've moved on to a technical part and started by looking at some basic code samples.   
Our colleague Robert Jacob prepared a talk with Introduction to Golang. He already gave similar talk at FFBW::camp recently. Here is the [repo][repo] with slides and code samples.  
He's actually modified it for us to include also a bit more advanced topics such as goroutines and also more interesting examples to these topics, which we actively discussed during the meeting. You can find all this at [holidaycheck branch][repo-hc] of the same repo.

[repo]: https://github.com/xperimental/go-intro
[repo-hc]: https://github.com/xperimental/go-intro/tree/holidaycheck

## Hello World & Co.

As usually, it all starts with basic program that outputs something on a screen. All the slides with code snippets were interactive and we could modify and try out things, by a principle "Run it or it never happened" :)

```go
package main

import "fmt"

func main() {
	fmt.Println("Hello World!")
}
```

As it was mentioned during presentation, it's not the shortest way of writing this program, but it's straightforward way.
<img src="{{site.baseurl}}/img/posts/2018-02-24-cop-golang/break.jpg" alt="Language basics" align="right" width="275" />
With this example we already can notice many things, like how to define functions, import packages and that we have main as an entry point in our program.  
We quickly went through basics of the language, briefly discussing typical attributes of nearly every programming language. So I guess everyone were just translating for themselves "how to do things in Go, that I'm already doing in my language X". And so it went as we've looked at functions, conditionals, iterators with different ways of how and what you can iterate through.  

## Goroutines & Channels

That's the area where Go seems to shine and we've spent quite some time understanding how it works and of course experiment with it in repl. Pretty neat that Go has native support for concurrency without using extra packages.  
<img src="{{site.baseurl}}/img/posts/2018-02-24-cop-golang/goroutines-and-channels.jpg" alt="Goroutines and Channels" title="Goroutines and Channels" align="left" width="300" />
By writing `go` before any function call, will create a goroutine to run concurrently. It's not the same as threads but rather functions that run concurrently with other functions and this is much lighter and cheaper in terms of cpu or memory usage. That is also a complexity that hidden from developer and solved at runtime by Go.

## What's Next?

We are finding ourselves in the situation where there is a small group of people with solid knowledge and experience with language itself and its tooling. On other hand there is much larger group of those who did extremely little or nothing with Go so far. Until this gap between two groups will be filled, it might be a bit boring for those who are more into the topic. Good news is, it should not take too long to catch up and get to the point where it will be fun for everyone.  
Another good thing is that the language doesn't introduce thousands of ways to do the same thing, which makes code written by Golang-Ninja not too different from what newcomers would come up with. There are already some plans for next meetings where we do coding sessions with mob programming.
