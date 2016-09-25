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

set.seed(1)
inTrain  <- sample(length(all), 50000)
training <- all[inTrain]

corpus <- Corpus(VectorSource(paste(training, collapse = ' ')))
corpus <- tm_map(corpus, prepareString)
corpus <- tm_map(corpus, PlainTextDocument)

options(mc.cores=1)

unigram_sparse_dtm  <- buildDTMatrix(corpus, 1)
bigram_sparse_dtm   <- buildDTMatrix(corpus, 2)
trigram_sparse_dtm  <- buildDTMatrix(corpus, 3)

uni_matrix <- as.matrix(unigram_sparse_dtm)
uni_sorted <- uni_matrix[1,order(uni_matrix[1,], decreasing = TRUE)]
uni_normalized <- uni_sorted/(max(uni_sorted) - min(uni_sorted))
save(uni_normalized, file='app/uni_freq.rds')

bi_matrix <- as.matrix(bigram_sparse_dtm)
bi_sorted <- bi_matrix[1,order(bi_matrix[1,], decreasing = TRUE)]
save(bi_sorted, file='app/bi_freq.rds')

tri_matrix <- as.matrix(trigram_sparse_dtm)
tri_sorted <- tri_matrix[1,order(tri_matrix[1,], decreasing = TRUE)]
save(tri_sorted, file='app/tri_freq.rds')
