---
layout: post
title: "Harnessing the Power of Large Language Models for Insightful Review Analysis "
date: 2024-04-01 00:00:00 +0200
categories: machine-learning
author_name: Team HolidayCheck
read_time : 8
feature_image: posts/2024-04-01-review-topic-sentiment-overview/hero-image.jpg
---

In our latest efforts towards enhancing user experience and offering deeper insights into our expansive collection of travel reviews, HolidayCheck is thrilled to unveil a cutting-edge feature powered by Large Language Models (LLMs). This innovative tool transcends traditional review analysis by extracting topics and their corresponding sentiments from the treasure chest of reviews on our platform. It not only signifies a leap in our technological dedication to put AI to good use but also demonstrates our commitment to understanding and catering to the nuanced preferences of our diverse user base. By leveraging the advanced capabilities of LLMs, we are now able to dissect the vast ocean of user-generated content, distilling it into actionable insights and transparent feedback for our users.  

## Motivation

At HolidayCheck, we believe in the importance of accurately capturing the voice of our users. While summarizing reviews using LLMs could offer a quick snapshot, we've decided to take a more nuanced route. Recognizing the complexity and depth of user reviews, our goal is to first dissect these into their core topics and associated sentiments. This method allows us to construct a more representative and comprehensive overview of user opinions, ensuring that no critical detail is overlooked or – even worse – sentiments about a specific topic are misrepresented. Our initial step in sharing these insights is to cluster reviews by topic, providing our users with clear statistics on sentiments. This feature is designed to enhance transparency and trust, giving both new and seasoned travelers an informed glimpse into the experiences of others. We want to provide full transparency to the hotel owners and our users alike on how these overall summaries can be reconstructed from the review sources. For us, this also entails to be able to filter for the reviews where the specific topics are mentioned.  

<figure>
    <img src="img/posts/2024-04-01-review-topic-sentiment-overview/review-topic-screenshot.jpg" alt="Review topic feature" class="centered" />
    <figcaption>Example sentiment analysis for a review (red indicates negative sentiments, green positive sentiments, grey represents a neutral sentiment.</figcaption>
</figure>

The screenshot shows the feature for a particular hotel with all topics expanded and the topic “Schlafqualität” selected. Topics are shown in pills where a green thumb indicates that most sentiments for this topic are positive. Behind the topic name we show the number of times the specific topic was mentioned in the most frequent reviews. If a specific topic is selected (as in the screenshot), more detailed information is provided below the pills. We show the percentages and absolute numbers for the three categories of positive, neutral and negative sentiments. In addition, for the reviews the same topic filter is applied (see the blue pill at the very bottom) so that only reviews containing the specific topic are shown to the user. Snippets within the review that mention the topic are also highlighted to the user for easier reference.  

Currently, we gradually roll out the feature for our top hotels and for their most recent reviews. 

## Topic extraction and sentiment classification 

Both topic extraction and sentiment classification are provided with the help of an LLM. To this end, we devised a specific prompt that takes as input a given review and extracts the relevant topics. The prompt features relevant examples in a few-shot learning approach ([https://arxiv.org/abs/2005.14165](https://arxiv.org/abs/2005.14165)). The extracted topics are then simultaneously classified for their sentiment (see [https://techblog.holidaycheck.com/post/2023/08/24/sentiment-analysis-llms](https://techblog.holidaycheck.com/post/2023/08/24/sentiment-analysis-llms) for more information on sentiment analysis with LLMs). 

The LLM then generates the output in JSON format. With the help of the LangChain library ([https://www.langchain.com/](https://www.langchain.com/)), we provide the expected schema for the output format and pipe the prompt through the respective chain to generate the response. From a cost and quality trade-off, we currently use GPT 3.5 Turbo as our preferred LLM, but we also investigate other options to provide even better quality (at lower costs) to our users. We focused also on avoiding reprocessing in case of errors happening in mid of batch processing (so if a review was processed successfully, it won’t be reprocessed after the restart again). Similary, we also experimented in finding the optimal number of parallel requests that would still satisfy our OpenAI quota restrictions for a specific region.

The results of our processing are meticulously logged in our Data Lake. We not only track the raw output of the LLM but also potential error messages from OpenAI. The logging enables us to keep a full overview of the whole processing steps afterwards.   

## Making it accessible to the frontend 

The extracted topics, along with their associated sentiment analyses and quotes, are added to our Elasticsearch database. This addition enables the execution of quick aggregations for searches and displaying aggregated data on the frontend. Combined with our current pagination logic, it permits filtering by topics and incorporating other filters, such as sun ratings, while at the same time maintaining system performance. 

The integration of Elasticsearch into our topic analysis significantly simplified the frontend development in React. By leveraging Elasticsearch's powerful aggregation capabilities, we can easily showcase the required data aggregations on our pages. This allows for a seamless user experience; when a user selects a topic filter, we promptly display a detailed breakdown for that specific topic. Additionally, we utilize these aggregations to efficiently query and present the most relevant reviews, complete with quotations, highlighting key insights. 

## Challenges 

Using LLMs to extract review topics and sentiments also has some challenges. A notable hurdle is the model's inclination to "correct" the UGC text, altering verbatim snippets in ways that makes it harder for us to detect the snippet in the original review. Additionally, navigating OpenAI's content filtering poses its own set of challenges. At times, certain reviews are filtered out for reasons that are not immediately apparent. While there might be some underlying sexual connotations in some reviews that are filtered, with others it is entirely weird why this input should be filtered out. For example, the following review does not pass OpenAI’s content filter: 

*“Sehr schönes Hotel mit freundlichen Personal, sehr Hilfsbereit und sehr freundlich und sehr Sauber schöner Pool. Sehr schön Zimmer.”* (translation: *Very nice hotel with friendly staff, very helpful and very friendly and very clean, beautiful pool. Very nice room.*) 

These challenges underscore the complexities of leveraging advanced AI technologies in a way that respects the authenticity and diversity of user experiences. 

## Evaluation 

We invite you to read our tech blog post ([https://techblog.holidaycheck.com/post/2023/08/24/sentiment-analysis-llms](https://techblog.holidaycheck.com/post/2023/08/24/sentiment-analysis-llms)) where we outline how we test our sentiment analysis approaches. Within our teams, manual checks are a cornerstone of our evaluation process, providing a hands-on approach to refining and enhancing our models. We are committed to continuous improvement, relying on these meticulous reviews to polish our algorithms. Moreover, the feature's introduction to our users follows a strategic, gradual roll-out. This phased approach allows us to monitor the quality closely, make adjustments, and ensure that the insights we provide are both accurate and representative of the original review. 

## Conclusion 

By leveraging LLMs to extract and analyze topics and sentiments from user reviews, HolidayCheck is not only enhancing the travel planning experience but also fostering a deeper connection within our community. This is a testament to our commitment to leveraging cutting-edge technology to truly understand and meet the needs of travelers worldwide. 