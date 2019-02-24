corpus_path <- "/Users/Primahadi/Documents/Corpora/_corpusindo/Leipzig Corpora/ind_news_2008_300K-sentences.txt"

my_corpus <- readr::read_lines(corpus_path)

my_leipzig_sample <- my_corpus[sample(1:length(my_corpus), 25000)]

# read the text from Tabloid Bola files and skip headers
bola_corpus_path <- dir(path = "~/Documents/Corpora/CORPUS/BOLA", full.names = TRUE)
bola_corpus_text <- readr::read_lines(bola_corpus_path[1], skip = 6)
# bola_corpus_text <- purrr::map(bola_corpus_path, readr::read_lines, skip = 6)

# combine each file into one vector of text to be split into sentence
# using tokenizers package
# bola_corpus_text <- purrr::map(bola_corpus_text, paste, collapse = " ")
# bola_corpus_text <- purrr::map(bola_corpus_text,
#                                tokenizers::tokenize_sentences,
#                                simplify = TRUE)
# bola_corpus_text <- unlist(bola_corpus_text)

usethis::use_data(my_leipzig_sample, bola_corpus_text, internal = TRUE, overwrite = TRUE)
usethis::use_data(my_leipzig_sample, bola_corpus_text, overwrite = TRUE)
