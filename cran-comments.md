## Resubmission

This is a resubmission. In this version, I have implemented the following in
response to feedback/comments from CRAN:

* reduce test timings

I have reviewed the different tests I use and have trimmed down the longest
running test to use smaller toy data to run faster. The tests now run for less
than 100 seconds on `winbuilder`

* address CRAN status checks erros

Fixed CRAN check issue where internet resources sometimes become unavailable and
therefore causes errors. CRAN policy specifies that such scenarios should
"exit gracefully" notifying user that resource is unavailable rather than
throw a check warning or error. This has been implemented in this patch version
by using the `try()` function whenever an internet resource is required and then
return a message that resource is unavailable instead of a warning or an error.
I have implemented these in the earlier submission but may have not been noted
by automated CRAN checks.

## Test environments
* macOS, local R installation, R 4.0.5
* ubuntu 20.04, local R installation, R 4.0.5
* ubuntu 20.04 (on github actions), R 4.0.5
* windows latest (on github actions), R 4.0.5
* macOS latest (on github actions), R 4.0.5
* win-builder (devel, oldrelease, release)
* rhub windows ubuntu, fedora (devel, release)

## R CMD check results

0 errors | 0 warnings | 1 note

The NOTE says:

* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Ernest Guevarra <ernest@guevarra.io>’

CRAN repository db overrides:
  X-CRAN-Comment: Archived on 2021-05-09 for policy violation.

  On Internet access

This is related to the issue discussed above. Given that the time provided by
CRAN to revise package to address policy violation has elapsed today and my 
attempt to correct this yesterday was not adequate and needed further revision,
This note is triggered. I am re-submitting to hopefully rectify these issues
and be back on track with CRAN policies.

## Reverse dependencies
`ennet` doesn't have any downstream / reverse dependencies 
(see https://github.com/katilingban/ennet/tree/master/revdep)
