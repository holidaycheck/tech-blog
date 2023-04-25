---
layout: post
title: "AI-based Review Assistant: Your review is highly appreciated!"
date: 2023-04-18 00:00:00 +0200
categories: culture
author_name: Team HolidayCheck
read_time : 10
feature_image: posts/2023-04-18-ai-based-assistant/feature-image.jpeg
---

**AI-based Review Assistant: Your review is highly appreciated!**

With over 10 million reviews and more than 12 million holiday photos, [HolidayCheck](https://holidaycheck.de/) is the largest travel review portal in the German-speaking area. Everyday users upload their holiday impressions daily, guiding other holidaymakers to decide on and book their next trip - helping them get valuable insights on hotel environment, food, beach, entertainment etc.

This Additional information and transparency help decision-making when going through a wealth of offers. This tool aims to make the process of describing your experience even smoother. You can start with just a few words to evaluate the individual categories, including the location, surrounding area, rooms, food, entertainment, and hotel.

***Submit a test review: Writing reviews will be easier and faster in the future***

HolidayCheck is building an [AI assistant](https://holidaycheck.de/svc/hc-review-assistant/travel-escapes/welcome.html) to make it even easier for holidaymakers to write reviews in the future. This is still a beta version to be tested by as many passionate travellers as possible.

Therefore, we are calling on all of you to submit a test review using the HolidayCheck assistant with the beta version. The submitted reviews will not go online but will be used to make the functionality even better. All participants will be entered into a raffle: This is done automatically once you interact with the assistant, and it generates reviews for you.

[Submit your test review and you may win a prize](https://holidaycheck.de/svc/hc-review-assistant/travel-escapes/welcome.html)

***Generative AI can help people find the right way to express themselves***

This beta tool was developed as a joint project between Hubert Burda Media and HolidayCheck Group. [Jean-Paul Schmetz](https://de.linkedin.com/in/jpschmetz), Chief Scientist at Hubert Burda Media and [Konark Modi](https://de.linkedin.com/in/konarkmodi), Vice President Technology at HolidayCheck are leading the development of this AI assistant and answer the most important questions here. Jean-Paul Schmetz explains how AI can help with writing reviews: “Just like a calculator can help people make sure they calculate correctly, Generative AI can help people find the right way to express themselves. We have known for years that most of our users are somewhat insecure about their writing skills, and it prevents them from sharing their experiences with the rest of our users. While a lot of people focus on the ability to generate fake content with Generative AI, we focus on its ability to assist users in writing reviews that reflect their experience”, says Jean-Paul Schmetz.

We asked both experts for more information about the HolidayCheck review assistant. Here are their answers:

***Why did you develop your own AI assistant for HolidayCheck?***

We strive to reduce the barrier-to-entry for users wanting to write a review. One does not need to be an expert in any language to submit a review, nor does one have to spend hours finding the words to use or not use. The assistant comes in handy - Start speaking or typing, and the assistant helps to write a proper narrative with just a few words.

***Is it also possible to upload pictures?***

In the beta phase we are only collecting two types of content: text and audio. If you wish to submit pictures, they can still be uploaded via our regular system: https://www.holidaycheck.de/wcf

***Where can I give feedback directly?***

We are looking forward to your feedback! You can give your feedback directly either by using the Review Assistant or by clicking the “Feedback” button on the right side of the page.

***How long will it be before I can see the finished feature?***

We are still working on the technology and on the features. We plan to launch it later this year. For more information, please sign up to our newsletter: https://www.holidaycheck.de/newsletter


***Do we publish these reviews, and If we publish these reviews, do we mark them as AI-assisted?***

Reviews generated via this beta tool will not go online, and we only use the reviews collected to assess the quality of the questions, answers and final review generated.

With your feedback, you are helping to ensure that the HolidayCheck Review Assistant keeps getting better and can go live as soon as possible. [Please participate and submit your review here](https://holidaycheck.de/svc/hc-review-assistant/travel-escapes/welcome.html). Feel free to share the link with family and friends or on social media.

***Technical Setup***

The core component of the AI-Review assistant is the [ChatCompletion](https://platform.openai.com/docs/guides/chat) endpoint of the OpenAI API. However, during the early testing phase, we realised that prototyping is fun, but building any end-user-facing product with these APIs is still quite an effort.

- The user can answer either by typing or by Audio. For Audio, we host the [OpenAI Whisper model](https://github.com/openai/whisper).
- The browser will forward this text to our service.
- We select the few best possible prompts based on the users' text and previous answers. Example: To collect feedback about different aspects of the hotel, we ask a few questions; however, our strong emphasis is to filter out redundant answers, so if a user has already answered about a room, we do not want to ask about the room again.
- The service creates the prompt and then forwards it to the ChatCompletion endpoint.
- Answers from assistants will go to filtering for things like tone, words, and type of voice (first person, second person etc.). Example: The user says: "The room was bad" We don't want the assistant to reply, "I am glad to know".
- The service will forward it to the user.

It's just one example of a simple conversation - there are many different ways in which the users interact and answer or ask a question, and our system strives to adapt to it.

We are continuously working on adapting the system to improve the quality of questions and answers. Even a slight change in the prompt can completely change the whole experience. Therefore, it is vital that as we change our prompts while the system is live, we maintain the quality of the overall tool. We, therefore, built an in-house method of replaying a few hundred conversations and scoring them, giving us confidence in whether the change to the prompt is good, neutral or bad.

Even though there are a lot of improvements still necessary, we are very proud of what we have been able to put out in a short amount of time - The whole architecture behind the AI-Review assistant needs its blog post, where we will share our learnings and failures, so stay tuned :)
