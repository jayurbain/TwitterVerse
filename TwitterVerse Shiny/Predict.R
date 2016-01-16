require(stringr);

# remove any extra whitespace
trim <- function(x) {
  return(gsub("^ *|(?<= ) | *$", "", x, perl=T))
}

# convert input text to lowercase; remove numbers, punctuation, and extra whitespace
# return as string array of tokens
preprocessText <- function(s) {

  # remove numbers, punctuation
  ss <- gsub("[^a-zA-Z\n\']", " ", s)
  # lowercase
  ss <- tolower(ss)
  # remove extra space
  ss<-trim(ss)
  tokens <- unlist(str_split(s, " "))
  return(tokens)
}

# predict next ngram using Katz Backoff
predictNgramKB <- function(input, sortPS=FALSE){

  tokens <- preprocessText(input)
  len <- length(tokens)
  predictions <- c()
  if(len==1 && tokens[1]=='') {
    len=0
  }

  # trigram input (or more)
  if (len >= 3) {

    # predict quadgram from trigram
    t3 <- tokens[len-2]; t2 <- tokens[len-1]; t1 <- tokens[len]
    str<-paste(t3, t2, t1);
    s<-paste('^', str, sep='')
    ngrams<-df_quadGram[ grep(s, rownames(df_quadGram)), ]
    if( dim(ngrams)[1] > 0 ) {
      ngrams<-ngrams[with(ngrams, order(p, decreasing=T)),]
      ngrams<-specificity(ngrams, 4, sortPS)
      predictions<-c(predictions, word(rownames(ngrams), 4))
    }

    # predict trigram from bigram
    if(length(predictions) < 10) {
      str<-paste(t2, t1);
      s<-paste('^', str, sep='')
      ngrams<-df_triGram[ grep(s, rownames(df_triGram)), ]
      if( dim(ngrams)[1] > 0 ) {
        ngrams<-ngrams[with(ngrams, order(p, decreasing=T)),]
        ngrams<-specificity(ngrams, 3, sortPS)
        predictions<-c(predictions, word(rownames(ngrams), 3))
      }
    }

    # predict bigram from unigram
    if(length(predictions) < 10 ) {
      str<-paste(t1);
      s<-paste('^', str, sep='')
      ngrams<-df_biGram[ grep(s, rownames(df_biGram)), ]
      if( dim(ngrams)[1] > 0 ) {
        ngrams<-ngrams[with(ngrams, order(p, decreasing=T)),]
        ngrams<-specificity(ngrams, 2, sortPS)
        predictions<-c(predictions, word(rownames(ngrams), 2))
      }
    }
    predictions<-predictions[!duplicated(predictions)]
  }

  else if(len == 2) { # bigram input

    # predict trigram from bigram
    t2 <- tokens[len-1]; t1 <- tokens[len]
    str<-paste(t2, t1);
    s<-paste('^', str, sep='')
    ngrams<-df_triGram[ grep(s, rownames(df_triGram)), ]
    if( dim(ngrams)[1] > 0 ) {
      ngrams<-ngrams[with(ngrams, order(p, decreasing=T)),]
      ngrams<-specificity(ngrams, 3, sortPS)
      predictions<-c(predictions, word(rownames(ngrams), 3))
    }

    # predict bigram from unigram
    if(length(predictions) < 10 ) {
      str<-paste(t1);
      s<-paste('^', str, sep='')
      ngrams<-df_biGram[ grep(s, rownames(df_biGram)), ]
      if( dim(ngrams)[1] > 0 ) {
        ngrams<-ngrams[with(ngrams, order(p, decreasing=T)),]
        ngrams<-specificity(ngrams, 2, sortPS)
        predictions<-c(predictions, word(rownames(ngrams), 2))
      }
    }
    predictions<-predictions[!duplicated(predictions)]

  } else if(len==1) {

    # predict bigram from unigram
    t1 <- tokens[len]
    str<-paste(t1);
    s<-paste('^', str, sep='')
    ngrams<-df_biGram[ grep(s, rownames(df_biGram)), ]
    if( dim(ngrams)[1] > 0 ) {
      ngrams<-ngrams[with(ngrams, order(p, decreasing=T)),]
      ngrams<-specificity(ngrams, 2, sortPS)
      predictions<-c(predictions, word(rownames(ngrams), 2))
    }

    # predict unigram from nothing
    if(length(predictions) < 10 ) {
      ngrams<-head(rownames(df_biGram))
      #ngrams<-specificity(ngrams, 4, sortPS)
      predictions <- c(predictions, ngrams, 10)
    }

    if(length(predictions) > 0) {
      predictions<-predictions[!duplicated(predictions)]
      predictions <- predictions[!is.na(predictions)]
    }

  } else if(len==0) {

    # predict unigram
    predictions<-head(rownames(df_uniGram), 10)
  }
  return(head(predictions, 10))
}

specificity<-function(ngrams, n, sortPS=FALSE) {
  ngrams$countTotal<-0
  for ( ngram in rownames(ngrams) ) {
    ngrams[ngram,'countTotal']<-dim(df_quadGram[ grep(paste0(word(ngram, n), '$'), rownames(df_quadGram)), ])[1]
  }
  ngrams$pS<-ngrams$count/ngrams$countTotal
  if( sortPS==TRUE) {
    ngrams<-ngrams[with(ngrams, order(pS, decreasing=T)),]
  }
  return(ngrams)
}


