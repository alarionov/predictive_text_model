Predictive Text Model
========================================================
author: Artem Larionov
date: 09/25/2016
autosize: true

Introduction
========================================================
The goal of this project is to develop a predictive text model and make user experience of typing better.
It is especially important for mobile devices, where [touch typing](https://en.wikipedia.org/wiki/Touch_typing) is not available.

The [application](https://alarionov.shinyapps.io/word-predictor/) analyses user's input and predict next word user is going to type.

Training Data
===
For training purposes, the [SwiftKey Dataset](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip) was used.
In particular, data for english language:

- en_US.blogs.txt
- en_US.news.txt
- en_US.twitter.txt

Algorithm
========================================================
Based on the [exploratory analysis](https://rpubs.com/alarionov/ngrams_freqs) it was decided to use Stupid Back-off algorithm, which is presented by formula: 

$$P(\omega_{i}|\omega^{i-1}_{i-k+1})= 
\begin{cases}
    p(\omega^{i}_{i-k+1}),& \text{if } (\omega^{i}_{i-k+1}) \text{ is found}\\
    \lambda(\omega^{i-1}_{i-k+1})P(\omega^{i}_{i-k+2}), & \text{otherwise} 
\end{cases}$$

where $p(\cdot)$ are pre-computed and stored probabilities, and $\lambda(\cdot)$ are back-off weights.

How to use
========================================================
The application is easy to use: just start typing and the application will predict what you are going to type next.

* if you finish typing with a letter, the application will try to find the possible current word
* if you finish with a space, the application will try to find the next possible word

<div>
<img width="400px" src="https://github.com/alarionov/predictive_text_model/blob/master/presentation/current_word.png?raw=true" alt="predicting the possible current" title="predicting the possible current">
<img width="400px" alt="predicting the possible next word" title="predicting the possible next word" src="https://github.com/alarionov/predictive_text_model/blob/master/presentation/next_word.png?raw=true">
</div>

Links
===

- [Data Science Capstone on Coursera](https://www.coursera.org/learn/data-science-project/)
- [SwiftKey Dataset](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)
- [Exploratory Analyses](https://rpubs.com/alarionov/ngrams_freqs)
- [Large Language Models in Machine Translation](http://www.aclweb.org/anthology/D07-1090.pdf)
- [GitHub Repository](https://github.com/alarionov/predictive_text_model)
- [The Application](https://alarionov.shinyapps.io/word-predictor/)
