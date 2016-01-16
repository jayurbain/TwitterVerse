

dat <- read.table(text="TrxID Items Quant
Trx1 A 3
Trx1 B 1
Trx1 C 1
Trx2 E 3
Trx2 B 1
Trx3 B 1
Trx3 C 4
Trx4 D 1
Trx4 E 1
Trx4 A 1
Trx5 F 5
Trx5 B 3
Trx5 C 2
Trx5 D 1", header=T)

V <- crossprod(table(dat[1:2]))
V
diag(V) <- 0
V[upper.tri(V)] <- 0
V
VV<-as.vector(V)
VVnames<-sort(as.vector(outer(names(V[1,]),names(V[,1]), paste, sep="")))
names(VV)<-VVnames
VV
VV<-VV[which(VV!=0)]
VV

####################################
library(tm)
library(RWeka)
data(crude)

#Tokenizer for n-grams and passed on to the term-document matrix constructor
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
txtTdmBi <- TermDocumentMatrix(crude, control = list(tokenize = BigramTokenizer))

#Check that it worked by inspecting a random sample...
inspect(txtTdmBi[1000:1005, 10:15])

# Now use a lapply function to calculate the associated words for every
# item in the vector of terms in the term-document matrix. The vector of
# terms is most simply accessed with txtTdmBi$dimnames$Terms.
# For example txtTdmBi$dimnames$Terms[[1005]] is "foreign investment".

# Here I've used llply from the plyr package so we can have a progress
# bar (comforting for big jobs), but it's basically the same as the base
# lapply function.

library(plyr)
dat <- llply(txtTdmBi$dimnames$Terms, function(i) findAssocs(txtTdmBi, i, 0.5), .progress = "text" )

# The output is a list where each item in the list is a vector of named numbers where the name is
# the term and the number is the correlation value. For example, to see the terms associated with
# "foreign investment", we can access the list like so:

txtTdmBi$dimnames$Terms[1005]

txtTdmBi$dimnames$Terms[which(txtTdmBi$dimnames$Terms== 'foreign investment')]

txtTdmBi$dimnames$Terms[which(txtTdmBi$dimnames$Terms=='- saudi')]

dat[1005]
dat['foreign investment']
dat[[which(dat == 'foreign investment')]]
df<-as.data.frame(dat)

names(dat[[1005]])


head(dat)

str(dat[[2]])

class(dat[2])

dat[[2, 1]]

findAssocs(txtTdmBi, c("oil", "opec", "xyz"), c(0.7, 0.75, 0.1))

findAssocs(txtTdmBi, "foreign investment", 0.5)

tdm <- TermDocumentMatrix(crude)
findAssocs(tdm, c("oil", "opec", "xyz"), c(0.7, 0.75, 0.1))



data("crude")
tdm <- TermDocumentMatrix(crude)
findAssocs(tdm, c("oil", "opec", "xyz"), c(0.7, 0.75, 0.1))


#################
#################
# build corpus FROM Document-Term-Matrix
# Minimal Reproducible Example
library(tm)
data("crude")
dtm <- DocumentTermMatrix(crude,
                          control = list(weighting =
                                           function(x)
                                             weightTfIdf(x, normalize = FALSE),
                                         stopwords = TRUE))

## Convert tdm to a list of text
dtm2list <- apply(dtm, 1, function(x) {
  paste(rep(names(x), x), collapse=" ")
})

## convert to a Corpus
myCorp <- VCorpus(VectorSource(dtm2list))
inspect(myCorp)

## Stemming
myCorp <- tm_map(myCorp, stemDocument)
inspect(myCorp)


tdm<-tdm_triGram
## Convert tdm to a list of text
tdm2list <- apply(tdm, 1, function(x) {
  paste0(rep(names(x), x))
})

## convert tdm2list to a Corpus
myCorp <- VCorpus(VectorSource(tdm2list))
inspect(myCorp)

## Stemming
#myCorp <- tm_map(myCorp, stemDocument)
inspect(myCorp)



