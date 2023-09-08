---
layout: post
title: "Leveraging Large Language Models for Sentiment Classification in hotel reviews"
date: 2023-08-25 00:00:00 +0200
categories: machine-learning
author_name: Thomas Mayer
read_time : 13
feature_image: posts/2023-08-25-sentiment-analysis-llms/network-sentiment.jpg
---

Large Language Models (LLMs) are a transformative force in NLP due to their ability to understand and generate human-like text. They have shown remarkable capabilities in areas such as text completion, where they can generate meaningful and coherent sentences that can be extended into paragraphs, articles, or even entire stories. They have also shown significant promise in more complex applications, such as drafting emails or other forms of written communication, coding assistance, tutoring in various subjects, and even in creative fields like poetry and script writing.

LLMs are trained on vast amounts of text data, enabling them to pick up intricate patterns and structures in human language. Their capacity for understanding context and semantics is particularly essential for tasks such as classification and information extraction, where understanding the subtle nuances of text is crucial. In this respect, models like GPT-3 and GPT-4 stand out with their powerful comprehension capabilities, providing a rich toolbox for various NLP tasks.

Information extraction from hotel reviews using LLMs is an exciting application in the hospitality industry. Reviews are often long, unstructured, and cover a broad range of topics, making them ideal candidates for LLMs' advanced natural language understanding capabilities. Using a few-shot learning approach, an LLM can be instructed to extract valuable information such as overall sentiment, ratings for specific amenities like cleanliness or service, and even to identify recurring issues mentioned by customers.

## Sentiment Analysis

Sentiment analysis (or classification) is the task of determining the emotional tone or subjective opinion expressed in a piece of text. It's typically categorized into positive, negative, or neutral sentiments. This understanding helps businesses to gauge customer satisfaction, policymakers to understand public opinion, and content creators to align with their audience's feelings. In the realm of hotel reviews, sentiment classification plays a vital role in offering customers a snapshot of a hotel's strengths and weaknesses.

<figure>
    <img src="img/posts/2023-08-25-sentiment-analysis-llms/sentiment-example.jpg" alt="Sentiment example sentences" class="centered" />
    <figcaption>Example sentiment analysis for a review (red indicates negative sentiments, green positive sentiments, grey represents a neutral sentiment.</figcaption>
</figure>

## Illustration

In this section, we will provide some examples to illustrate the potential and advantages of using LLMs for sentiment classification. 

* Aspect-based classification: LLMs thrive at identifying fragments of sentences that contain individual statements, thus allowing to have an aspect-based classification for sentiments that goes beyond the full sentence segmentation. Since they are trained on large amounts of user generated content (UGC), they are particularly good at detecting these statements even in the absence of any punctuation or grammatical indicator (as is typical with UGC):
    * "Frühstück war super Säfte könnten besser sein." (Breakfast was great juices could be better, though)
* World knowledge: We don't want to get into the discussion whether or to what extent LLMs feature a certain knowledge about the world. Yet they are definitely able to infer certain sentiment classifications based on the context.
    * "Toilets are cleaned every month" => negative sentiment
    * "Toilets are cleaned every day" => positive sentiment
    * "Toilets are cleaned every second day" => neutral sentiment
    * "Bananas were green." => negative sentiment
    * "Salad was green." => positive sentiment
* Colloquial expressions: LLMs shine when it comes to identifying colloquial expressions for sentiments, not necessarily including any "sentiment words" (or tilting in the other direction)
    * "Das Personal war alles andere als freundlich" => negative sentiment (even though there is no direct negation word and a positive sentiment word
    * "Das Hotel ist in die Jahre gekommen" => 
    * "Die Animateure waren der Burner"
* LLMs take the whole context of the hotel review into account when deciding on the sentiment of a specific statement within the review.
    * "Das Hotel ist wirklich sehr einfach gehalten, und das hat mir sehr gefallen." => First part of the sentence is classified as positive
    * "Das Hotel ist wirklich sehr einfach gehalten, und das hat mich enttäuscht." => First part of the sentence is classified as negative

Due to these reasons we have found considerable performance boosts when applying LLMs to the task of sentiment classification. 

## Large Language Models and Sentiment Analysis

Large language models have become instrumental in sentiment analysis relatively recently. While the roots of sentiment analysis can be traced back to the early 2000s, the introduction of large pre-trained models like BERT, which was unveiled in 2018, marked a significant turning point. These sophisticated models brought unprecedented accuracy and efficiency to sentiment analysis, leveraging their deep understanding of language nuances and context. Since then, the field has seen rapid advancements, with successive models like GPT-3 further enhancing the capability to analyze and infer sentiments across diverse texts and domains.

An interesting side path in the development of sentiment analysis is the OpenAI paper on the Sentiment Neuron (2017).

## Sentiment Neuron

Even before BERT and its related models took over the field of NLP in 2018 HolidayCheck had been working with LLMs to infer sentiment classifications. One of the most interesting lines of research is the replication of OpenAI's Sentiment Neuron experiments (https://openai.com/research/unsupervised-sentiment-neuron) in 2017. 

<figure>
    <img src="img/posts/2023-08-25-sentiment-analysis-llms/sentiment-neuron-paper.jpg" alt="Sentiment Neuron paper" class="centered" />
    <figcaption>Arxiv screenshot for the Sentiment Neuron paper (2017)</figcaption>
</figure>

To this end, we trained a language model (a multiplicative LSTM https://arxiv.org/abs/1609.07959 with 4096 neurons) with HolidayCheck hotel review texts. The 4,096 neurons, essentially a vector of floating-point numbers, can be seen as a feature vector that symbolizes the string interpreted by the model. Once the mLSTM was trained, we transformed it into a sentiment classifier. This was achieved by forming a linear combination of these units and determining the combination's weights using the supervised data available.

Like in the OpenAI paper mentioned above, we also discovered a single neuron (number 2081) to be highly predictive of the sentiment value after we applied L1 regularization.

<figure>
    <img src="img/posts/2023-08-25-sentiment-analysis-llms/sentiment-neuron-l1-plot.jpg" alt="Sentiment neuron L1 plot" class="centered" />
    <figcaption>The sentiment neuron (2081) shows a huge spike in the L1 regularization plot for neuron weights.</figcaption>
</figure>

The current value of neuron 2081 could then be taken as an indicator of the current sentiment within a review or sentence, thus allowing for sentiment changes within sentences to be identified. The following visualization gives the value for the sentiment neuron as color code and illustrates when sentiments shift in between or across sentences within reviews. 

<figure>
    <img src="img/posts/2023-08-25-sentiment-analysis-llms/sentiment-neuron-visualization.jpg" alt="Sentiment neuron visualization" class="centered" />
    <figcaption>The visualization depicts the current values for the sentiment neuron (2081) in a processed review. You can see the coloring shifting from positive to negative sentiments (green to red) when the tone of the review becomes more negative.</figcaption>
</figure>

But the neuron could not only be used to predict the sentiment of the (current fragment of the) review. When tinkering with the weight of the neuron reviews with different sentiments could be generated in a prompt completion task. Setting a negative neuron value (where a negative value is just coincidence to denote negative sentiments) generates a sentence with a negative sentiment, while setting the same 2081 value to positive yields a completion with a positive sentiment.

<figure>
    <img src="img/posts/2023-08-25-sentiment-analysis-llms/sentiment-neuron-prompt-completion.jpg" alt="Sentiment neuron prompt completion" class="centered" />
    <figcaption>By changing the weight of the sentiment neuron (2081) we could influence the sentiment of the generated sentence completion.</figcaption>
</figure>

## BERT as a next step

We never actually used the sentiment neuron approach in production. The approach was very soon superseded by the advent of encoder-based language models, such as BERT, that are particularly well suited for classification tasks. These models also showed better results on our data. For a longer time, we therefore used Google's Sentiment API as the main method for inferring sentiments on a sentence level. We also tested Oliver Guhr's german-sentiment-BERT model (partly trained on HolidayCheck data, https://huggingface.co/oliverguhr/german-sentiment-bert) and achieved better results. 

## GPT-3 and 4

With the availabilities of larger language models from the GPT family (esp. GPT-3, 3.5 and finally 4), we shifted our focus again on using decoder-based models for sentiment classification, yet with a different approach. Prompt engineering and few-shot learning proved to be very successful in achieving our desired results (https://openai.com/research/language-models-are-few-shot-learners). There are a number of advantages of this method over older approaches:

* prototyping is much easier, you just need to adapt the prompt
* less training data is required, only a few labeled examples are enough
* you don't need to wait for long training or fine-tuning times
* you can use natural language to describe the desired output, esp. in cases where it's hard to define training examples for what you want to accomplish
* you don't need any special machine learning knowledge
* LLMs are well-versed in dealing with orthographic and grammatical styles typical for user generated content (UGC)
* LLMs excel at taking context into account
* LLMs have no issues with text that is (partly) in another language
* they yield better results on our test data (see below)

We didn't conduct ablation studies on the prompt ingredients. However, there's a couple of strategies that we employed in the prompt writing, some of which are listed below:

* write the prompt in English, even though the target language is German
* be concise and highlight important passages/word (by writing them in capital letters, for instance)
* use specific words to describe the desired output. Most importantly, using the word "statement" captured very well what we intended to extract from individual sentences
* provide good training examples for the few-shot learning

We tested the performance of the LLM approach on our test suite of 100 sentences. The evaluation on the test suite was exclusively on sentence level. The suite consists of a mixture of representative sentiment sentences with a focus on harder examples that proved to be difficult with previous sentiment classifiers. Overall, we observed a steady decline of errors in the test suite over the years. With the GPT-4 based sentiment classifier with our best prompt setup, we achieved an accuracy of 100%, i.e., not a single sentence in the test suite was classified incorrectly.

<figure>
    <img src="img/posts/2023-08-25-sentiment-analysis-llms/testsuite-results.jpg" alt="Testsuite evaluation" class="centered" />
    <figcaption>Testsuite evaluation on the different models. Red indicates a deviation from the gold standard (in the yellow) column. The GPT-4 based model (gray highlight) does not contain any errors. For the GPT models the same prompt was used.</figcaption>
</figure>

| Model                             | Number of incorrect test sentences |
|-----------------------------------|------------------------------------|
| Google Sentiment API (June 2023)  | 28                                 |
| German-sentiment-BERT             | 12                                 |
| GPT-3                             | 4                                  |
| GPT-3.5                           | 8                                  |
| GPT-4                             | 0                                  |


A test sentence that both Google and German-sentiment-BERT classified incorrectly is "WLAN-Empfang ist ausbaufähig" (wifi reception could be improved), while GPT-based models all classified them correctly as negative.

## Conclusion

Although it might not be their primary use case in the public discussion, LLMs such as GPT-4 thrive in certain classification tasks such as sentiment analysis. Their ability to take a larger context into account, deal with user generated content (UGC), esp. colloquial language and unorthodox punctuation, and infer sentiments on a sub-sentential level make them very powerful for extracting sentiments from hotel review texts. This is so far the best method we have seen at HolidayCheck. We need to extend our test suite to find cases where it doesn't work yet. For this purpose, we devised a tool called "Fool our sentiment classifier" where we ask colleagues to identify cases where the sentiment was incorrectly labeled. 

<figure>
    <img src="img/posts/2023-08-25-sentiment-analysis-llms/screenshot-sentiment-tool-hc.jpg" alt="Sentiment tool screenshot" class="centered" />
    <figcaption>Screenshot of our HolidayCheck Sentiment Tool (HC Stimmungsdetektor) where we ask users to find cases where the sentiment is incorrect.</figcaption>
</figure>

You can play with the tool yourself and give your feedback on the results. Link: [https://www.holidaycheck.de/stimmungsdetektor](https://www.holidaycheck.de/stimmungsdetektor)

## Acknowledgment

I would like to extend my gratitude to all those who have contributed their examples and input to improve the underlying sentiment model.
A special thank you goes to Konark Modi, Adrian Schmid and Bibin Raj for making the HolidayCheck Sentiment Tool available to people outside HC and Konark Modi for helpful advice on the setup. 
