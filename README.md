
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis build status](https://travis-ci.org/gederajeg/wordpairs.svg?branch=master)](https://travis-ci.org/gederajeg/wordpairs) [![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/gederajeg/wordpairs?branch=master&svg=true)](https://ci.appveyor.com/project/gederajeg/wordpairs) [![Coverage status](https://codecov.io/gh/gederajeg/wordpairs/branch/master/graph/badge.svg)](https://codecov.io/github/gederajeg/wordpairs?branch=master)

wordpairs
=========

The goal of wordpairs is to retrieve the occurrences of a pair of words in sentences. This is still under development and it is designed with sentence-based corpus of the Indonesian [Leipzig Corpora Collection](http://wortschatz.uni-leipzig.de/en/download) as the input. Further testing with different corpus-input is a work-in-progress.

Installation
------------

You can install the development version of wordpairs from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("gederajeg/wordpairs")
```

Example
-------

Here is an example to search for the occurrences of Indonesian words with *me- -kan* confix, which indicate (di)transitive verbs, and the preposition *kepada* 'to(wards) sb.'. The package comes with a random sample of 25,000 sentences from one corpus file of the Indonesian Leipzig Corpora (i.e. the `"ind_news_2008_300K-sentences.txt"`).

``` r
library(wordpairs)
word_1 <- "\\bmen[a-z]{3,}kan\\b"
word_2 <- "\\bkepada\\b"
corpus <- my_leipzig_sample
m <- word_pairs(corpus,
                word_1 = word_1,
                word_2 = word_2,
                min_intervening = 0L,
                max_intervening = 3L)
```

Next, we can inspect snippets of the output as follows.

``` r
str(m)
#> List of 3
#>  $ pattern       : chr [1:222] "menyampaikan secara langsung kepada" "mengutamakan pemberian kredit kepada" "menuangkan pikiran dan menyampaikan kepada" "mengembalikan ID card kepada" ...
#>  $ pattern_tagged: chr [1:222] "<w id='1'>menyampaikan</w> secara langsung <w id='2'>kepada</w>" "<w id='1'>mengutamakan</w> pemberian kredit <w id='2'>kepada</w>" "<w id='1'>menuangkan</w> pikiran dan menyampaikan <w id='2'>kepada</w>" "<w id='1'>mengembalikan</w> ID card <w id='2'>kepada</w>" ...
#>  $ matches       : chr [1:222] "271940 Namun, Mensos Bachtiar Chamsyah mengatakan, ia sudah <m><w id='1'>menyampaikan</w> secara langsung <w id"| __truncated__ "232967 Dia menjelaskan bahwa selektif kredit ini untuk mengurangi resiko bank akan <m><w id='1'>mengutamakan</w"| __truncated__ "61079 Orang asing yang cinta Bali, yang memiliki gagasan positif untuk mengembangkan Bali, pasti merasa tidak s"| __truncated__ "79192 Inilah yang menyebabkan belasan wartawan yang sebelumnya diundang untuk meliput kegiatan tersebut kecewa,"| __truncated__ ...
```

The `pattern` consists of the extracted patterns for the co-occurrences of `word_1` and `word_2`. Note that `word_1` always precedes `word_2`, if they do co-occur in a sentence. To reverse the co-occurrence sequence, reverse the input for `word_1` with `word_2`, and *vice versa*.

The `pattern_tagged` is the tagged version of elements in `pattern`. The tags enclose `word_1` and `word_2`, but not the intervening strings.

The `matches` shows the occurrences of the `pattern` in the full sentential contexts in which they are found.

Next, we can create a frequency table for the detected co-occurrence patterns, using the [dplyr](https://dplyr.tidyverse.org) package from the [tidyverse](https://www.tidyverse.org).

``` r
# generate frequency table for the patterns using `dplyr` package
library(dplyr)
freq_tb <- 
  tibble(pattern = m$pattern_tagged) %>% 
  count(pattern, sort = TRUE)
head(freq_tb)
#> # A tibble: 6 x 2
#>   pattern                                                         n
#>   <chr>                                                       <int>
#> 1 <w id='1'>mengatakan</w> <w id='2'>kepada</w>                  56
#> 2 <w id='1'>mengingatkan</w> <w id='2'>kepada</w>                 6
#> 3 <w id='1'>mengucapkan</w> terima kasih <w id='2'>kepada</w>     5
#> 4 <w id='1'>menyampaikan</w> <w id='2'>kepada</w>                 5
#> 5 <w id='1'>mengemukakan</w> <w id='2'>kepada</w>                 4
#> 6 <w id='1'>mengusulkan</w> <w id='2'>kepada</w>                  4
```

Citation
--------

To cite wordpairs, please use:

-   Rajeg, Gede Primahadi Wijaya. (2018). *wordpairs*: An R package to retrieve word pair in sentences. Retrieved from: <https://gederajeg.github.io/wordpairs/>
