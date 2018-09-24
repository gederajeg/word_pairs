corpus_path <- "/Users/Primahadi/Documents/Corpora/_corpusindo/Leipzig Corpora/ind_news_2008_300K-sentences.txt"

my_corpus <- readr::read_lines(corpus_path)

my_leipzig_sample <- my_corpus[sample(1:length(my_corpus), 25000)]

devtools::use_data(my_leipzig_sample, internal = TRUE, overwrite = TRUE)
devtools::use_data(my_leipzig_sample, overwrite = TRUE)
