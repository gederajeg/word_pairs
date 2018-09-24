context("test-word_pairs.R")

word_1 <- "\\bmen[a-z]{3,}kan\\b"
word_2 <- "\\bkepada\\b"
corpus <- my_leipzig_sample
test_that("NULL input for word_1, word_2, and corpus produce errors", {
  expect_error(m <- word_pairs(corpus = NULL,
                               word_1 = word_1,
                               word_2 = word_2,
                               min_intervening = 0L,
                               max_intervening = 3L),
               "^Specify.*?`corpus`")

  expect_error(m <- word_pairs(corpus,
                               word_1 = NULL,
                               word_2 = word_2,
                               min_intervening = 0L,
                               max_intervening = 3L),
               "^Specify.*?`word_1`")

  expect_error(m <- word_pairs(corpus,
                               word_1 = word_1,
                               word_2 = NULL,
                               min_intervening = 0L,
                               max_intervening = 3L),
               "^Specify.*?`word_2`")
})

test_that("No match found throws message", {

  expect_message(word_pairs(corpus, "\\bfhdjalfhlaks\\b", "\\bkepada\\b"), "No match found!")


})

m <- word_pairs(corpus,
                word_1 = word_1,
                word_2 = word_2,
                min_intervening = 1L,
                max_intervening = Inf)
test_that("matched co-occurrence produces a list of three elements", {

  expect_equal(length(m), 3L)
  expect_output(str(m), "^List of 3")

})
