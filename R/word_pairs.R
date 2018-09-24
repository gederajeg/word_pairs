#' @title Detect word pairs in text
#'
#' @description \code{word_pairs} searches for the occurrences of a pair of words in sentences. These words can be separated by intervening strings (viz. other in-between words).
#' @param corpus A character vector of sentences.
#' @param word_1 A regular expressions for the first word. The regex must enclose the word with word boundary character (i.e. \code{"\\\\b"}).
#' @param word_2 A regular expressions for the second word. The regex must enclose the word with word boundary character (i.e. \code{"\\\\b"}).
#' @param min_intervening Number of minimum occurrence of the intervening word.
#'     The default is \code{0L}.
#' @param max_intervening Number of minimum occurrence of the intervening word.
#'     The default is \code{3L}. Use \code{Inf} to get infinite intervening words after \code{word_1} and before the occurrence of \code{word_2}.
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
#' # co-occurrence of *me-X-kan* transitive verbs with *kepada*
#' word_1 <- "\\bmen[a-z]{3,}kan\\b"
#' word_2 <- "\\bkepada\\b"
#' corpus <- my_leipzig_sample
#' m <- word_pairs(corpus,
#'                 word_1 = word_1,
#'                 word_2 = word_2,
#'                 min_intervening = 0L,
#'                 max_intervening = 3L)
#'
#' # inspect the snippet of the results
#' head(m$pattern)
#' head(m$pattern_tagged)
#'
#' # generate frequency table for the patterns
#' freq_tb <- table(m$pattern_tagged)
#'
#' # sort in decreasing order of frequency
#' head(sort(freq_tb, decreasing = TRUE))
#'
#' @references Rajeg, Gede Primahadi Wijaya. (2018). wordpairs: An R package to retrieve word pair in sentences of the (Indonesian) Leipzig Corpora.
word_pairs <- function(corpus, word_1 = NULL, word_2 = NULL, min_intervening = 0L, max_intervening = 3L) {

  if (is.null(word_1)) {
    stop("Specify `word_1` argument!\n")
  }

  if (is.null(word_2)) {
    stop("Specify `word_2` argument!\n")
  }

  if (is.null(corpus)) {
    stop("Specify the input `corpus` argument!\n")
  }

  # design grouped regex for `word_1`
  w_1 <- paste("(", word_1, ")", sep = "")

  # design regex for the preceeding string of `word_2`
  pre_word_2_rgx <- "([^.!?:;a-zA-Z0-9-]+?)"
  w_2 <- paste(pre_word_2_rgx, "(", word_2, ")", sep = "")

  # design regex for the intervening string between `word_1` and `word_2`
  if (is.infinite(max_intervening)) {

    max_intervening <- ""

  }
  intervening_quant <- paste("{", min_intervening, ",", max_intervening, "}?", sep = "")
  ## below are the non-alphanumeric characters that should preceed the intervening words
  non_alphanum_rgx <- "[^.!?:;a-zA-Z0-9-]+?"
  in_between_rgx <- paste("(", non_alphanum_rgx, "[a-zA-Z0-9-]+)", intervening_quant, sep = "")

  # put together the regex for `word_1`, intervening string, and `word_2`
  wp_rgx <- paste(w_1, in_between_rgx, w_2, sep = "")

  # extract the corresponding sentences containing the word pair
  sent <- grep(pattern = wp_rgx, x = corpus, perl = TRUE, value = TRUE)

  if (length(sent) > 0) {

    # get the attribute of the matched pattern
    m_attr <- gregexpr(pattern = wp_rgx, text = sent, perl = TRUE)
    m_length <- sapply(m_attr, length)
    sent <- rep(sent, m_length)

    # get the starting character-position of the pattern in `wp_rgx`
    m_start <- unlist(m_attr)

    # get the character-length of the pattern in `wp_rgx`
    m_span <- unlist(sapply(m_attr, attr, "match.length"))

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

  } else {

    message("No match found!\n")

  }

}

