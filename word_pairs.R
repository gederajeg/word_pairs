#' @title word_pair_match
#' @description Extracting sentences that contain a pair of words.
#'     The current version of the code accepts a character vector whose elements represent text of sentences (as in the corpus files from the Leipzig Corpora Collection).
#' @param corpus A character vector of sentences.
#' @param word_pairs A character vector whose elements are regular expressions for each of the word pairs.
#'     The current version of the code accepts a two-word pair.
#'
#' @return A character vector of the matched sentences in which the searched word pair appears together.
#'
#' @examples
#' word_pairs <- c("\\bhari\\b", "\\bdepan\\b")
#' corpus_path <- "/Users/Primahadi/Documents/Corpora/_corpusindo/Leipzig Corpora/ind_news_2008_300K-sentences.txt"
#' corpus <- readLines(corpus_path, encoding = "UTF-8")
#' word_pair_out <- word_pair_match(corpus, word_pairs)
#' @references Rajeg, Gede Primahadi Wijaya. (2018). word_pair_match: An R function to retrieve word pair in sentences of the (Indonesian) Leipzig Corpora.
word_pair_match <- function(corpus, word_pairs) {
  word_pairs_backref <- paste("(", word_pairs, ")", sep = "")
  word_pairs_rgx <- paste(word_pairs_backref, collapse = "(.+?)")
  matches <- grep(word_pairs_rgx, corpus, perl = TRUE, value = TRUE)
  
  backref_elements <- unlist(strsplit(word_pairs_rgx, "[()]"))
  backref_elements <- backref_elements[nzchar(backref_elements)]
  backref_seq <- seq(length(backref_elements))
  backref_with_words <- grep("[a-zA-Z]+", backref_elements, perl = T)
  backref_rgx <- ifelse(backref_seq %in% backref_with_words, 
                        paste("<w", backref_seq, ">\\", backref_seq, "</w", backref_seq, ">", sep = ""), 
                        paste("\\", backref_seq, sep = ""))
  backref_rgx <- paste(backref_rgx, collapse = "")
  matches_tag <- gsub(word_pairs_rgx, backref_rgx, matches, perl = TRUE)
  return(matches_tag)
}

#' @title Detect word pairs in text
#' 
#' @description \code{word_pairs} searches for the occurrences of a pair of words in sentences. These words can be separated by intervening strings (viz. other in-between words), which is also handled by \code{word_pairs}.
#' @param corpus A character vector of sentences.
#' @param word_1 A regular expressions for the first word. The regex must enclose the word with word boundary character (i.e. \code{"\\b"}).
#' @param word_2 A regular expressions for the second word. The regex must enclose the word with word boundary character (i.e. \code{"\\b"}).
#' @param min_intervening Number of minimum occurrence of the intervening word.
#' @param max_intervening Number of minimum occurrence of the intervening word.
#'
#' @return A list object with the following elements:
#' \itemize{
#' \item{\code{pattern}: the extracted pattern spanning from the first word to the second word.}
#' \item{\code{pattern_tagged}: the version of \code{pattern} containing tags for the first and the second word.}
#' \item{\code{matches}: the sentence matches containing the word pairs that are tagged for the first and the second word.}
#' }
#' @export
#'
#' @examples
#' word_1 <- "\\bmenanyakan\\b"
#' word_2 <- "\\bkepada\\b"
#' corpus_path <- "/Users/Primahadi/Documents/Corpora/_corpusindo/Leipzig Corpora/ind_news_2008_300K-sentences.txt"
#' corpus <- readLines(corpus_path, encoding = "UTF-8")
#' m <- word_pairs(corpus, word_1 = word_1, word_2 = word_2, min_intervening = 0, max_intervening = 3)
#' @references Rajeg, Gede Primahadi Wijaya. (2018). word_pairs: An R function to retrieve word pair in sentences of the (Indonesian) Leipzig Corpora.
word_pairs <- function(corpus, word_1 = NULL, word_2 = NULL, min_intervening = 0, max_intervening = 3) {
  
  # design grouped regex for `word_1`
  w_1 <- paste("(", word_1, ")", sep = "")
  
  # design regex for the preceeding string of `word_2`
  pre_word_2_rgx <- "([^.a-zA-Z0-9-]+]?)"
  w_2 <- paste(pre_word_2_rgx, "(", word_2, ")", sep = "")
  
  # design regex for the intervening string between `word_1` and `word_2`
  intervening_quant <- paste("{", min_intervening, ",", max_intervening, "}", sep = "")
  in_between_rgx <- paste("([^.a-zA-Z0-9-]+[a-zA-Z0-9-]+)", intervening_quant, sep = "")
  
  # put together the regex for `word_1`, intervening string, and `word_2`
  wp_rgx <- paste(w_1, in_between_rgx, w_2, sep = "")
  
  # extract the corresponding sentences containing the word pair
  sent <- grep(pattern = wp_rgx, x = corpus, perl = TRUE, value = TRUE)
  
  # get the attribute of the matched pattern
  m_attr <- gregexpr(pattern = wp_rgx, text = sent, perl = TRUE)
  m_length <- sapply(m_attr, length)
  sent <- rep(sent, m_length)
  
  # get the starting character-position of the pattern in `wp_rgx`
  m_start <- unlist(m_attr) 
  
  # get the character-length of the pattern in `wp_rgx`
  m_span <- sapply(m_attr, attr, "match.length")
  
  # get the ending character-position of the pattern in `wp_rgx`
  m_end <- m_start + m_span
  
  # extract the pattern
  m_ptrn <- substr(sent, m_start, m_end-1)
  
  # get the remaining strings to the left of the pattern
  m_left_ctx <- substr(sent, 1, (m_start-1))
  
  # get the remaining strings to the right of the pattern
  m_right_ctx <- substr(sent, m_end, nchar(sent))
  
  # tag `word_1` and `word_2` in the pattern
  m_ptrn_tagged <- gsub("(\\b[a-zA-Z0-9-]+$)", "<w id='2'>\\1</w>", m_ptrn, perl = TRUE)
  m_ptrn_tagged <- gsub("(^[a-zA-Z0-9-]+\\b)", "<w id='1'>\\1</w>", m_ptrn_tagged, perl = TRUE)
  
  # combine the left string, matched pattern, and the right string
  m_tagged <- paste(m_left_ctx, "<m>", m_ptrn_tagged, "</m>", m_right_ctx, sep = "")
  
  # generate a list-output for the pattern
  matches <- list(pattern = m_ptrn,
                  pattern_tagged = m_ptrn_tagged,
                  matches = m_tagged)
  
  # return the output
  return(matches)
  
}

