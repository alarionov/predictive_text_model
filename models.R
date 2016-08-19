options(java.parameters = "-Xmx8192m")
library(rJava)
library(tm)
library(RWeka)
library(SnowballC)  
library(stringr)

prepareString <- function (x) {
  x <- iconv(x, 'latin1', 'ASCII', sub='')
  x <- tolower(x)
  x <- removePunctuation(x)
  x <- removeNumbers(x)
  x <- stripWhitespace(x)
  str_trim(x)
}

getLastNgram <- function (str, n) {
  sentence <- tail(unlist(strsplit(str, '[[:punct:]]')), n = 1)
  sentence <- prepareString(sentence)
  tail(unlist(strsplit(sentence, ' ')), n = n)
}

buildPattern <- function (ngram, n) {
  paste0('^', paste(tail(ngram, n=n), collapse = ' '), '*')
}

buildDTMatrix <- function (corpus, n, language = 'english') {
  DocumentTermMatrix(
    corpus, 
    control = list(
      tokenize = function(x) {
        NGramTokenizer(x, Weka_control(min = n, max = n))
      },
      language = language,
      stemWords = FALSE
    )
  )
}

setwd('~/coursera/capstone')

blogs  <- readLines('final/en_US/en_US.blogs.txt', skipNul = TRUE)
news   <- readLines('final/en_US/en_US.news.txt', skipNul = TRUE)
tweets <- readLines('final/en_US/en_US.twitter.txt', skipNul = TRUE)

all <- c(blogs, news, tweets)

inTrain  <- sample(length(all), 100000)
training <- all[inTrain]

corpus <- Corpus(VectorSource(paste(training, collapse = ' ')))
corpus <- tm_map(corpus, prepareString)
corpus <- tm_map(corpus, PlainTextDocument)

options(mc.cores=1)

unigram_sparse_dtm <- buildDTMatrix(corpus, 1)
bigram_sparse_dtm  <- buildDTMatrix(corpus, 2)
trigram_sparse_dtm <- buildDTMatrix(corpus, 3)

matrix <- as.matrix(unigram_sparse_dtm)
uni_sorted <- matrix[1,order(matrix[1,], decreasing = TRUE)]
save(uni_sorted, file='uni_freq.rds')
uni_normalized <- uni_sorted/(max(uni_sorted) - min(uni_sorted))

matrix <- as.matrix(bigram_sparse_dtm)
bi_sorted <- matrix[1,order(matrix[1,], decreasing = TRUE)]
save(bi_sorted, file='bi_freq.rds')
bi_normalized <- bi_sorted/(max(bi_sorted) - min(bi_sorted))

matrix <- as.matrix(trigram_sparse_dtm)
tri_sorted <- matrix[1,order(matrix[1,], decreasing = TRUE)]
save(tri_sorted, file='tri_freq.rds')
tri_normalized <- tri_sorted/(max(tri_sorted) - min(tri_sorted))

barplot(uni_sorted[1:200])
barplot(bi_sorted[1:200])
barplot(tri_sorted[1:200])

c(1600 / length(uni_sorted), sum(uni_sorted[1:1600])/sum(uni_sorted))
c(250000 / length(bi_sorted), sum(bi_sorted[1:250000])/sum(bi_sorted))
c(1160000 / length(tri_sorted),sum(tri_sorted[1:1160000])/sum(tri_sorted))

library(rsconnect)
deployApp(account = 'alarionov', appName = 'word-predictor')
