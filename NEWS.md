# ennet 0.2.2

This is the fourth CRAN release of `ennet`. This is a patch release to fix a
CRAN check issue where internet resources sometimes become unavailable and
therefore causes errors. CRAN policy specifies that such scenarios should
"exit gracefully" notifying user that resource is unavailable rather than
throw a check warning or error. This has been implemented in this patch version.

# ennet 0.2.1

This is the third CRAN release of `ennet`. This is a patch release to fix a
test that uses an input that used to throw an error but now does not. This
test has now been fixed.

### Bug fixes

* Fixed test for `create_db_topics_monthly` that used an input for a date of
2021-02-01 which earlier would provide an error but now that it is already
February, this input doesn't throw an error. This was changed to
2020-01-01 instead.

# ennet 0.2.0

Second [CRAN](https://cran.r-project.org) release of `ennet` package.

### Bug fixes

* Fixed NOTE on CRAN checks for non-ASCII characters (192 marked UTF-8 strings)

* Removed `DiagrammeR` as a dependency package and removed the code chunk in 
respective vignette that creates the ennet workflow. The workflow diagram is
now done using an external drawing tool (OmniGraffle) instead of within R using
`DiagrammeR`. This prevents issues on CRAN when vignettes are produced.

### Enhancements/Improvements

* refactored the `count_topics` and `count_authors` functions into new more
coherent functions for counting topics and other related metrics (previous
functions have now been deprecated);

* added new functions to retrieve data from the [en-net database](https://github.com/katilingban/ennet_db);

* added new functions to process and handle data from the [en-net database](https://github.com/katilingban/ennet_db); and,

* updated documentation to reflect the enhancements/improvements implemented.

# ennet 0.1.0

First release of `ennet` package.

The `ennet` package has two key sets of functions:

1. The first set of functions facilitates the extraction of text data from the 
[**en-net** online forum](https://www.en-net.org). 

2. The second set of functions supports the analysis of the extracted datasets 
to produce summary measures and statistics of the 
[**en-net** online forum](https://www.en-net.org).
