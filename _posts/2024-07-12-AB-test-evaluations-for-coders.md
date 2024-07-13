---
layout: post
title: "A/B Test Evaluations for Software Engineers"
date: 2024-07-12 00:00:00 +0200
categories: machine-learning
author_name: Thomas Mayer
read_time : 15
feature_image: posts/2024-07-12-AB-test-evaluations-for-software-engineers/hero-image.jpg
---


At HolidayCheck, [A/B testing](https://en.wikipedia.org/wiki/A/B_testing) is a cornerstone of our decision-making process, allowing us to innovate and enhance our customers' experience continuously. However, interpreting A/B test results can be challenging, even for experienced professionals. In this post, we'll demystify key concepts to help you make more informed decisions based on your test results.
There is 
a lot of jargon around statistical tests and countless remarks on what you need to pay 
attention to, which makes it harder for non-experts to focus on the core aspects of the 
whole endeavor: why do we even need the statistical framework to answer the question 
whether an A/B test was successful or not? What does the result of the statistical test
actually mean intuitively? 

## Goal: what can you take away from this blog post?

In this blog post, I want to shed some light on these questions. The aim is to provide an intuitive understanding for the following points without resorting to any statistical concepts but only to intuition:

- Why do we even need a (statistical) hypothesis test? Why is it not enough to count the results and see which variant obtained a higher metric?
- Why do statisticians keep talking about a [Null Hypothesis](https://en.wikipedia.org/wiki/Null_hypothesis) when evaluating the results? 
- What does the [p-value](https://en.wikipedia.org/wiki/P-value) in an A/B test actually represent? Why does it need to be smaller than a certain threshold (usually 5%) for the result to be significant?

The good news is that I can provide answers to these questions with only one tool: a random number generator! If you know how to code and use a random number generator, you should be able to fully grasp the intuition behind these concepts. 

*Brief Disclaimer:* This post is not a thorough description of how to conceive of and run an A/B test. It also does not give a detailed explanation of the underlying statistical methods that are typically applied when evaluating an A/B test. Rather, it is an attempt to provide an intuitive understanding of the basic principles and thus will only scratch the surface. But I hope that the interested reader will see it as an invitation to embark on further investigation into the subject.

For the rest of this blog post, we will assume a simple A/B test setup for illustration. You want to find out if a new version A (test version) performs better or worse than the old version B (control version). As an example, we take the average basket value (ABV) of a customer in an e-com setup as an illustration and want to check whether the test variant leads customers to buy more expensive items. 

## Why do we need statistical knowledge to evaluate an A/B test?

To answer this question, let's take a simple coin toss as an example. We throw a coin 100 times and count the number of heads. If we repeat this experiment a hundred times, we get the following counts for heads for each of the individual experiments:

```python
import numpy as np

nr_tosses = 100
heads = np.random.binomial(n=nr_tosses, p=0.5, size=100)
heads
```

```python
array([53, 41, 47, 53, 51, 52, 56, 49, 48, 47, 54, 44, 45, 59, 50, 56, 50,
       55, 50, 47, 37, 53, 50, 50, 51, 49, 54, 43, 41, 53, 47, 54, 53, 55,
       50, 47, 56, 48, 46, 42, 49, 55, 51, 41, 48, 59, 56, 54, 49, 45, 38,
       52, 51, 47, 50, 66, 42, 55, 53, 47, 48, 54, 55, 48, 54, 49, 56, 46,
       44, 51, 52, 45, 57, 52, 51, 54, 58, 61, 51, 49, 50, 44, 47, 55, 49,
       52, 55, 53, 68, 48, 51, 50, 56, 54, 48, 52, 45, 52, 56, 52])

```

We use the random number generator from `numpy` for generating `binomial` random numbers (which is either 0 or 1 with equal probability `0.5`) and sum them up for `size=100`. If we plot the result in a histogram, we see that most experiments cluster around the expected value of 50. After all, this is what you expect from a single experiment if you throw a fair coin 100 times!

```python
import matplotlib.pyplot as plt

plt.hist(heads, bins=100);
```

<figure>
    <img src="img/posts/2024-07-12-AB-test-evaluations-for-software-engineers/histogram.png" alt="Histogram for coin tosses" class="centered" />
    <figcaption>Histogram for coin tosses</figcaption>
</figure>

However, you can also easily see that for some of the experiments, the result deviates quite substantially from the exected value of 50. The most extreme results are 37 on the lower end and 68 on the upper end of the spectrum. So if we had been unlucky and only had seen this single experiment of 68, we might have assumed that it was not a fair coin toss at all. 

The problem with A/B testing (and similar cases for hypothesis testing) is that we can't afford to run these experiments so many times. We need to come to a conclusion from one experiment only and judge from this whether the difference is significant. But how do we know when a given result is too extreme to be just one of the outliers seen above?

Ultimately, the statistical approach provides us with a means to get a standardized score to see how likely such a scenario could happen due to chance. And there is an easy way to achieve this. If you know how to code, use loops and a random number generator, you are good to go.

Let's take the results for these two variants (goupA and groupB). For better illustration, we keep the number of elements per group small, but the same method can be applied to much bigger numbers (as they are typical in A/B test evaluations). The means for both groups are different (groupA has mean 76.75 and groupB has mean 66.67). The difference in their means is 10.08. The question is whether this difference in their means is significant. Put differently, how likely is it that we encounter such a difference merely by chance? 

```python
groupA = np.array([84, 72, 57, 71, 63, 76, 99, 91, 74, 50, 94, 90])
groupB = np.array([81, 69, 74, 61, 56, 87, 68, 65, 66, 44, 62, 67])

delta = groupA.mean() - groupB.mean()
delta
```

```python
10.083333333333329
```

The basic assumption of our approach to answer this question is very intuitive. Just assume that both variants A and B are the same, i.e., there is no difference between boths groups. If they are the same, we can also shuffle the results between groups. In other words, we take all elements from both groups as one pool of potential results and then take random samples from the whole pool and group them into A and B (after all, both of them are the same based on our assumption, therefore it should not make a difference where we draw it from). Then we can see what differences we typically get and how these relate to the observed difference of 10.08. Let's look at the individual steps:

1. Assume that A and B are actually the same (which is typically called the Null Hypothesis)
2. Since A and B are the same, we can shuffle the results from both groups (Step 1) and randomly pick a new selection for both A and B (Step 2)
    - Take the same number of elements for variant A and B, respectively
    - Only take elements from the original test and shuffle them (don't introduce new values that don't exist in the test)
1. Compute the means for A and B (meanA and meanB, Step 3)
1. Write down the difference between meanA and meanB (Step 3)
1. Plot the difference on a chart (Step 3)
1. Go back to step 2 and iterate

In Python, we can use the following code to implement the steps above:

```python
import pandas as pd

iterations = 10000

groupAB = np.concatenate([groupA, groupB])
sizeA = len(groupA)
sizeB = len(groupB)

means_deltas = []

for _ in range(iterations):
  groupAB = np.random.permutation(groupAB)      # Step 1
  iterA = groupAB[:sizeA]                       # Step 2
  iterB = groupAB[sizeA:]                       # Step 2
  means_delta = iterA.mean() - iterB.mean()     # Step 3
  means_deltas.append(means_delta)              # Step 3

means_deltas = pd.Series(means_deltas)
```

If we run this code, we gradually build up a distribution for the differences in means based on the assumption that both variants A and B are the same (and thus that there is no difference in their performance). 

<figure>
    <img src="img/posts/2024-07-12-AB-test-evaluations-for-software-engineers/steps.gif" width=700 alt="The 3 steps in detail" class="centered" />
    <figcaption>One iteration with the 3 steps in detail</figcaption>
</figure>

Compare the animation to the steps we outlined above. The three major steps are as follows:

1. Shuffle the numbers (here indicated with the different colors for group A and B).
1. Rearrange the numbers accordingly to group A and B.
1. Take the (new) means of groups A and B based on the newly arranged numbers. Plot the difference between the means on the histogram on the right-hand side. 

<figure>
    <img src="img/posts/2024-07-12-AB-test-evaluations-for-software-engineers/steps-hist.gif" width=700 alt="Building up the distribution" class="centered" />
    <figcaption>Running the code above for a number of iterations</figcaption>
</figure>

If we follow these steps for a number of iterations, we gradually build up a distribution as in the animated plot above. The more often we see a certain difference in the means the higher the point in the histogram plot. With more iterations, the histogram resembles more and more a normal distribution. 

In the end, we get a distribution that looks like the blue histogram below. The peak of the distribution is around 0, which makes sense as we assumed that both variants are the same and therefore their differences should cluster around 0. But we also see that there are more extreme values both to the left and the right, similar to the coin toss experiment above. 

<figure>
    <img src="img/posts/2024-07-12-AB-test-evaluations-for-software-engineers/histogram-iterations-absolute.png" alt="Histogram for coin tosses" class="centered" />
    <figcaption>Histogram for coin tosses</figcaption>
</figure>

In the histogram for the results we also plotted the original observed difference in means (10.08) that we saw in the A/B experiment for the two groups. Then we compare this value with the rest of the simulated differences (based on the assumption that both variants are the same). If we take the whole area for this distribution as 100% and calculate the percentage of the area that is equal or larger than the 10.08 difference plotted with the red line, we get a percentage of 4.11%. In other words, in slightly more than 4% of the 10,000 simulated experiments where groups A and B were treated the same we saw a difference of 10.08 or larger. And now comes the interesting part: The 4.11% represents the p-value for the statistical test! It is the percentage of times we would see such or a more extreme difference between the groups based on the assumption that both groups are the same.


<figure>
    <img src="img/posts/2024-07-12-AB-test-evaluations-for-software-engineers/histogram-iterations-relative.png" alt="Histogram for coin tosses" class="centered" />
    <figcaption>Histogram for coin tosses</figcaption>
</figure>

As a comparison, take the typical approach of computing the t-test statistics for the same numbers and compare their results with the 4.11% that we calculated above. Using the statsmodels `ttest_ind_stats` we get the following result.

```python
from statsmodels.stats.weightstats import ttest_ind as ttest_ind_stats

t, p, dof = ttest_ind_stats(groupA, groupB, alternative='larger')
p
```

```python
0.03935
```

Why is slightly different? Keep in mind that we take a different approach with the t-test statistic where we assume a general t-student distribution, which is not exactly the same distribution that we simulated with our approach above. If we want to use the same approach, this can be achieved with the `scipy.stats` function `ttest_ind` and the `permutations` parameter. 

```python
from scipy.stats import ttest_ind as ttest_ind_scipy

res = ttest_ind_scipy(groupA, groupB, alternative='greater', permutations=iterations)
res.pvalue
```

```python
0.0406
```

Again, we don't get exactly the same p-value of 4.11%, which is due to the random component of the approach. Numbers vary slightly from one simulation to the next. This variation can also be observed if we run the code above a couple of times. Most likely, we wouldn't get exactly the same result of 4.11% again!

## Recap: What is the intuition behind the p-value?

- We assume that both groups are the same.
- Therefore we can use a trick and shuffle all the values for this group (as they are the same!).
- Then we can compute the difference in means between the shuffled groups.
- We plot the difference in means and iterate the previous steps to have a sufficient test sample.
- Then we plot how many times the differences we see with the simulated iterations are actually the same or bigger than the value we got from the original test.
- We take this value and divide by the overall number of iterations to get the percentage of cases where the bootstrap sampled difference was bigger than the observed value.
- This is the p value!

To get back to our initial goals for this blog post, we should now be able to answer the following questions:

*Question 1:* Why do we even need a (statistical) hypothesis test? Why is it not enough to count the results and see which variant obtained a higher metric?
    
We need to account for random factors in the result and see how likely it is that the observed result could have happened due to chance. For this, we need to get an overview of how the results would look like if there were only chance events, i.e., when there is no difference in the two groups.

*Question 2:* Why do statisticians keep talking about a Null Hypothesis when evaluating the results? 

This is a trick that makes it possible to compute the chance events mentioned above. With the assumption that both groups are the same we can draw randomly from both groups and see what differences we might get purely by chance. Only this Null Hypothesis makes it possible to compute the expected distribution by chance.

*Question 3:* What does the p-value in an A/B test actually represent? Why does it need to smaller than a certain threshold (usually 5%) for the result to be significant?

The p-value is a key concept in interpreting A/B test results. It represents the probability of observing a result as extreme as, or more extreme than, what we saw in our experiment, assuming there's no difference between the control and treatment groups. In essence, the p-value quantifies how surprising our result is under the assumption of no effect. A smaller p-value suggests that our observed difference is less likely due to chance alone, providing stronger evidence against the null hypothesis of no difference between the groups.

To transform a gradual difference into a binary decisions (yes/no), we define a threshold upfront (usually 5%) and then take the decision based on whether the p-value lies below that threshold or not. The threshold is an arbitrary cut-off point. The idea is that you define the threshold before you run the experiment so that you are not biased by the outcome when making the decision. It should be clear to you already upfront how much chance you're willing to accept in your evaluation. 

## Conclusion

In this post, we've explored the underlying inutution behind the fundamental concepts of statistical significance, p-values and the Null Hypothesis. Understanding these concepts enables us to make more informed decisions about product changes and feature rollouts. However, it's crucial to remember that while statistics guide our decisions, they don't make them for us. We must always consider the broader context, including the practical significance of our results and their alignment with our overall business strategy. 

Since you made it to the end of this blog post, I would encourage you to play around with the code snippets above and compare your next A/B test evaluations with this approach. This might help you to get a better understanding of the underlying assumptions. 

### Credit

This blog post was inspired by Jake Vanderplas's excellent Pycon 2016 talk about ["Statistics for Hackers"](https://www.youtube.com/watch?v=Iq9DzN6mvYA&t=2057s), which I highly recommend.

