
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis build status](https://travis-ci.org/gederajeg/wordpairs.svg?branch=master)](https://travis-ci.org/gederajeg/wordpairs) [![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/gederajeg/wordpairs?branch=master&svg=true)](https://ci.appveyor.com/project/gederajeg/wordpairs) [![Coverage status](https://codecov.io/gh/gederajeg/wordpairs/branch/master/graph/badge.svg)](https://codecov.io/github/gederajeg/wordpairs?branch=master) [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing) [![DOI](https://img.shields.io/badge/doi-10.26180/5ba868cee0ef4-blue.svg?style=flat)](http://dx.doi.org/10.26180/5ba868cee0ef4)

wordpairs
=========

The goal of wordpairs is to retrieve the occurrences of a pair of words in sentences. This is still under development and it is originally designed with sentence-based corpus of the Indonesian [Leipzig Corpora Collection](http://wortschatz.uni-leipzig.de/en/download) as the input. If each line of your corpus text does not correspond to one sentence as in the Leipzig Corpora (e.g., consisting of multiple sentences or split sentences between multiple lines), few tweaking is needed (read further below after the **Example** section).

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

Tweaking non-sentence corpus input
----------------------------------

As mentioned above, non-sentence corpus needs to be preprocessed before using it as input for `word_pairs()`. The package includes an example of typical input text where each line does not correspond to one sentence, or the sentence elements got split into two or more lines.

``` r
wordpairs::bola_corpus_text
#>  [1] "Namun, sejatinya tawaran yang lebih konkret justru datang dari klub Inggris dan"  
#>  [2] "dan Jerman. Sedangkan dua klub Italia itu baru sekedar mencari informasi."        
#>  [3] "\"Beberapa tawaran yang lebih konkret datang dari klub Inggris dan Jerman. Mereka"
#>  [4] "benar-benar menunjukkan ketertarikannya terhadap klien saya. Sedangkan klub-klub" 
#>  [5] "Italia sejauh ini baru sekedar mencari keterangan,\" ungkap Guerra."              
#>  [6] "Dua klub yang terlebih dahulu telah mengajukan tawaran adalah Newcastle United"   
#>  [7] "dan Wender Bremen. Kemungkinan besar dua klub asal Serie A itu akan menyusul"     
#>  [8] "untuk bersaing mendapatkan mantan pemain Olympique Lyon itu."                     
#>  [9] "Klub yang bermarkas di San Siro itu berpeluang besar jika serius mengejar Ben"    
#> [10] "Arfa. Pasalnya, pemain sayap kiri tersebut juga mulai menunjukkan"                
#> [11] "ketertarikannya kepada Milan. Secara terang-terangan agen itu juga berani"        
#> [12] "menyebutkan harga yang dipatok untuk merekrut kliennya sebesar 93,6 miliar"       
#> [13] "rupiah."                                                                          
#> [14] "\"Saya yakin ia merupakan sosok pemain penting dengan teknik yang bagus dan dapat"
#> [15] "meningkatkan kualitas lini tengah I Rossoneri. Ben Arfa juga akan mendapat"       
#> [16] "banyak keuntungan jika bermain dengan klub sebesar Milan dengan 75 ribu orang di" 
#> [17] "dalam stadion. Berapa nilai yang layak untuk seorang pemain seperti Ben Arfa? 8"  
#> [18] "juta Euro,\" tambahnya."
```

We can see, for instance, that the beginning of line two contains elements (i.e. the strings `"dan Jerman."`) of sentence in line one. The first step to handle this is to collapse elements of this character vector into one long character vector.

``` r
bola_corpus <- paste(wordpairs::bola_corpus_text, collapse = " ")
```

Next, we can use the `tokenize_sentences()` function from the [tokenizers](https://cran.r-project.org/web/packages/tokenizers/index.html) (Mullen, Benoit, Keyes, Selivanov, & Arnold, 2018) package to split the collapsed string into character vector whose elements correspond to one sentence. You first need to install the tokenizers package in R.

``` r
# install tokenizers if you have not done it.
# install.packages("tokenizers")

bola_corpus <- tokenizers::tokenize_sentences(bola_corpus, simplify = TRUE)
bola_corpus
#>  [1] "Namun, sejatinya tawaran yang lebih konkret justru datang dari klub Inggris dan dan Jerman."                                     
#>  [2] "Sedangkan dua klub Italia itu baru sekedar mencari informasi."                                                                   
#>  [3] "\"Beberapa tawaran yang lebih konkret datang dari klub Inggris dan Jerman."                                                      
#>  [4] "Mereka benar-benar menunjukkan ketertarikannya terhadap klien saya."                                                             
#>  [5] "Sedangkan klub-klub Italia sejauh ini baru sekedar mencari keterangan,\" ungkap Guerra."                                         
#>  [6] "Dua klub yang terlebih dahulu telah mengajukan tawaran adalah Newcastle United dan Wender Bremen."                               
#>  [7] "Kemungkinan besar dua klub asal Serie A itu akan menyusul untuk bersaing mendapatkan mantan pemain Olympique Lyon itu."          
#>  [8] "Klub yang bermarkas di San Siro itu berpeluang besar jika serius mengejar Ben Arfa."                                             
#>  [9] "Pasalnya, pemain sayap kiri tersebut juga mulai menunjukkan ketertarikannya kepada Milan."                                       
#> [10] "Secara terang-terangan agen itu juga berani menyebutkan harga yang dipatok untuk merekrut kliennya sebesar 93,6 miliar rupiah."  
#> [11] "\"Saya yakin ia merupakan sosok pemain penting dengan teknik yang bagus dan dapat meningkatkan kualitas lini tengah I Rossoneri."
#> [12] "Ben Arfa juga akan mendapat banyak keuntungan jika bermain dengan klub sebesar Milan dengan 75 ribu orang di dalam stadion."     
#> [13] "Berapa nilai yang layak untuk seorang pemain seperti Ben Arfa?"                                                                  
#> [14] "8 juta Euro,\" tambahnya."
```

Now, `bola_corpus` vector can be used as input for the `corpus` argument of `word_pairs()`.

Citation
--------

To cite wordpairs, please use:

-   Rajeg, Gede Primahadi Wijaya. (2018). *wordpairs*: An R package to retrieve word pair in sentences. Retrieved from: <https://gederajeg.github.io/wordpairs/>

References
----------

Mullen, L. A., Benoit, K., Keyes, O., Selivanov, D., & Arnold, J. (2018). Fast, consistent tokenization of natural language text. *Journal of Open Source Software*, *3*(23), 655. doi:[10.21105/joss.00655](https://doi.org/10.21105/joss.00655)
