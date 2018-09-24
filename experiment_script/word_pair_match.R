#' @title word_pair_match
#' @description Extracting sentences that contain a pair of words.
#'     The current version of the code accepts a character vector whose elements represent text of sentences (as in the corpus files from the Leipzig Corpora Collection).
#' @param corpus A character vector of sentences.
#' @param word_pairs A character vector whose elements are regular expressions for each of the word pairs.
#'     The current version of the code accepts a two-word pair.
#'
#' @return A character vector of the matched sentences in which the searched word pair appears together.
#' @export
#'
#' @examples
#' word_pairs <- c("\\bhari\\b", "\\bdepan\\b")
#' corpus <- my_leipzig_sample
#' word_pair_out <- word_pair_match(corpus, word_pairs)
#' @references Rajeg, Gede Primahadi Wijaya. (2018). wordpairs: An R package to retrieve word pair in sentences of the (Indonesian) Leipzig Corpora.
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
