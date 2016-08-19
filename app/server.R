library(shiny)
library(stringr)
library(tm)

load('uni_freq.rds')
load('bi_freq.rds')
load('tri_freq.rds')

uni_normalized <- uni_sorted / (max(uni_sorted) - min(uni_sorted))
bi_normalized  <- bi_sorted  / (max(bi_sorted)  - min(bi_sorted))
tri_normalized <- tri_sorted / (max(tri_sorted) - min(tri_sorted))

N <- 3

prepareString <- function (x, trim = TRUE) {
  x <- iconv(x, 'latin1', 'ASCII', sub='')
  x <- tolower(x)
  x <- removePunctuation(x)
  x <- removeNumbers(x)
  x <- stripWhitespace(x)
  ifelse(trim, str_trim(x), x)
}

getLastNgram <- function (str, n) {
  sentence <- tail(unlist(strsplit(str, '[[:punct:]]')), n = 1)
  sentence <- prepareString(sentence, trim = FALSE)
  words <- unlist(strsplit(sentence, ' ', fixed = TRUE))
  if (str_sub(sentence, start = -1) == ' ') {
    words <- c(words, ' ')
  } 
  tail(words, n = n)
}

buildPattern <- function (ngram, n) {
  paste0('^', stripWhitespace(paste(tail(ngram, n=n), collapse = ' ')), '.*')
}

getMatrix <- function (n) {
  if (n == 1) return(uni_normalized)
  if (n == 2) return(bi_normalized)
  if (n == 3) return(tri_normalized)
}

findNgrams <- function (ngram, n) {
  pattern <- buildPattern(ngram, n)
  matrix  <- getMatrix(n)
  return(names(matrix[head(grep(pattern, names(matrix)))]))
}

predict.words <- function (text) {
  if (str_trim(text) == '') return('')
  
  ngram <- getLastNgram(text, n = N)  
  
  if (is.null(ngram)) return('')
  
  pred3 <- c()
  pred2 <- c()
  pred1 <- c()
  
  if (length(ngram) >= 3) {
    pred3 <-  findNgrams(ngram, 3)
  }
  
  if (length(ngram) >= 2) { 
    pred2 <- findNgrams(ngram, 2)
  }
  
  if (length(ngram) >= 1) {
    pred1 <- findNgrams(ngram, 1)
  }
  
  if (length(pred3) > 0) {
    return(pred3)
  }
  
  if (length(pred2) > 0) { 
    return(pred2)
  }
  
  if (length(pred1) > 0) {
    return(pred1)
  }
  
  c()
}

function (input, output) {
  output$predictions <- reactive({
    paste(head(predict.words(input$text), n = 3), collapse = ', ')
  })
}