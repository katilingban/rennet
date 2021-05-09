################################################################################
#
#'
#' Retrieve data from ennet_db GitHub repository
#'
#' @param repo A character value for the GitHub user and repository name
#'   combination identifying the GitHub location for ennet_db. Default is
#'   `katilingban/ennet_db`.
#' @param branch A character value for the branch name from which to retrieve
#'   data. Default is `main`.
#' @param id A character value for data identifier. Possible choices are
#'   *daily*, *weekly*, *monthly*, or *yearly*.
#'
#' @return A tibble of the specified dataset
#'
#' @author Ernest Guevarra
#'
#' @examples
#' \donttest{
#'   ## Retrieve discussions dataset
#'   get_db_discussions()
#' }
#'
#' @export
#' @rdname get_db
#'
#
################################################################################

get_db_discussions <- function(repo = "katilingban/ennet_db",
                               branch = "main") {
  ## Retrieve discussions from main
  x <- try(
    read.csv(paste("https://raw.githubusercontent.com/",
                   repo, "/", branch,
                   "/data/ennet_discussions.csv",  sep = "")),
    silent = TRUE
  )

  ## Return message if try-error
  if (class(x) == "try-error") {
    x <- NULL
    message(
      paste(
        strwrap(x = "Repository, branch, and/or file cannot be found. Please
                     check your specifications and try again. Returning NULL.",
                width = 80),
        collapse = "\n"
      )
    )
  } else {
    ## Convert to tibble
    x <- tibble::tibble(x)
  }

  ## Return discussions
  return(x)
}


################################################################################
#
#'
#' @examples
#' ## Retrieve en-net topics yearly interactions dataset
#' get_db_topics(id = "yearly")
#'
#' @export
#' @rdname get_db
#'
#
################################################################################

get_db_topics <- function(repo = "katilingban/ennet_db",
                          branch = "main",
                          id = c("daily", "weekly", "monthly", "yearly")) {
  ## Get id
  id <- match.arg(id)

  ## Retrieve specified topics dataset
  x <- try(
    suppressWarnings(
      read.csv(paste("https://raw.githubusercontent.com/",
                     repo, "/", branch,
                     "/data/ennet_topics_", id,
                     "_interactions.csv",  sep = ""))),
    silent = TRUE
  )

  ## Return message if try-error
  if (class(x) == "try-error") {
    x <- NULL
    message(
      paste(
        strwrap(x = "Repository, branch, and/or file cannot be found. Please
                     check your specifications and try again. Returning NULL.",
                width = 80),
        collapse = "\n"
      )
    )
  }

  ## If x is data.frame
  if (class(x) == "data.frame") {
    ## Conver to tibble
    x <- x %>% tibble::tibble()

    ## Edit names
    names(x) <- names(x) %>%
      stringr::str_replace_all(pattern = "\\.", replacement = " ")

    ## Convert dates in character to dates as.Date()
    y <- names(x)[stringr::str_detect(string = names(x), pattern = "Extract")]
    x[y] <- as.Date(x[[y]])
  }

  ## Return interactions
  return(x)
}


################################################################################
#
#'
#' Create daily topics dataset for the ennet_db
#'
#' @param repo A character value of the GitHub user and repository name
#'   combination identifying the GitHub location for ennet_db. Default is
#'   `katilingban/ennet_db`.
#' @param branch A character value for the branch name from which to retrieve
#'   data. Default is `main`.
#' @param .date A character value or vector of date/dates for which to create
#'   a topics dataset for the ennet_db
#' @param fn A character value or vector of filenames for hourly topics dataset
#'   found in ennet_db
#'
#' @return A tibble of daily topics dataset created from data in the
#'   ennet_db
#'
#' @author Ernest Guevarra
#'
#' @examples
#' ##
#' fn <- c("ennet_topics_2021-01-17_00:54:48.csv")
#'
#' create_db_topics_daily(.date = "2021-01-17", fn = fn)
#'
#' @export
#'
#
################################################################################

create_db_topics_daily <- function(repo = "katilingban/ennet_db",
                                   branch = "main",
                                   .date = Sys.Date() - 1,
                                   fn = NULL) {
  ## Check .date
  if (is.na(lubridate::ymd(.date))) {
    stop(
      paste(
        strwrap(x = ".date values are not in the expected YYYY-MM-DD format.
                     Please check and try again.",
                width = 80),
        collapse = "\n"
      )
    )
  }

  ## Check fn is specified
  if (is.null(fn)) {
    stop(
      paste(
        strwrap(x = "fn has no default value but is required. Please specify
                     expected filenames of hourly topics datasets to be
                     searched from the ennet_db",
                width = 80
        ),
        collapse = "\n"
      )
    )
  }

  ## Convert .date
  .date <- as.Date(.date, format = "%Y-%m-%d")

  ## Detect filenames of hourly datasets in ennet_db required based on .date
  fn <- fn[fn %>% stringr::str_detect(pattern = paste(.date, collapse = "|"))]

  if (length(fn) > 0) {
    fn <- paste("https://raw.githubusercontent.com/",
                repo, "/", branch, "/data/", fn, sep = "")

    x <- lapply(
      X = fn,
      FUN = function(fn) {
        ## Create timestamp
        ts <- fn %>%
          stringr::str_remove_all(pattern = "ennet_topics_|.csv") %>%
          lubridate::as_datetime() %>%
          stringr::str_replace_all(pattern = " ", replacement = "_")

        ## Read first file in list
        x <- try(read.csv(file = fn), silent = TRUE)

          if (class(x) == "try-error") {
            x <- NULL
            message(
              paste(
                strwrap(x = "Repository, branch, and/or file cannot be found.
                             Please check your specifications and try again.
                             Returning NULL.",
                        width = 80),
                collapse = "\n"
              )
            )
          } else {
            ## re-order columns and rename
            x <- x[c(1, 2, 4, 5, 6, 3, 7)]
            names(x)[6:7] <- paste(names(x)[6:7], ts, sep = "_")
          }

        return(x)
      }
    )

    x <- Reduce(f = merge, x = x)

    ## Rename fields
    names(x) <- names(x) %>%
      stringr::str_replace_all(pattern = "\\-|\\:", replacement = "")

    ## Convert to tibble
    x <- tibble::tibble(x)
  } else {
    x <- NULL
    message(
      paste(
        strwrap(x = "None of the filenames provided are from the date specified.
                     Verify filenames and/or date specified and try again.
                     Returning NULL.",
                width = 80),
        collapse = "\n"
      )
    )
  }

  ## Return x
  return(x)
}


################################################################################
#
#'
#' Create monthly topics dataset for the ennet_db
#'
#' @param repo A character value of the GitHub user and repository name
#'   combination identifying the GitHub location for ennet_db. Default is
#'   `katilingban/ennet_db`.
#' @param branch A character value for the branch name from which to retrieve
#'   data. Default is `main`.
#' @param .date A character value or vector of date/dates for which to create
#'   a topics dataset for the ennet_db
#'
#' @return A tibble of monthly topics dataset created from data in the
#'   ennet_db
#'
#' @author Ernest Guevarra
#'
#' @examples
#' create_db_topics_monthly(.date = "2021-01-01")
#'
#' @export
#'
#
################################################################################

create_db_topics_monthly <- function(repo = "katilingban/ennet_db",
                                     branch = "main",
                                     .date = Sys.Date() - 1) {
  ## Check .date
  if (is.na(lubridate::ymd(.date))) {
    stop(
      paste(
        strwrap(x = ".date values are not in the expected YYYY-MM-DD format.
                     Please check and try again.",
                width = 80),
        collapse = "\n"
      )
    )
  }

  ## Check .date is not earlier than 27 December 2020
  if (lubridate::ymd(.date) < as.Date("2020-12-27")) {
    stop(
      paste(
        strwrap(x = "Earliest dataset available from ennet_db is for December
                     2020. Please provide .date value for December 2020 or
                     later.",
                width = 80),
        collapse = "\n"
      )
    )
  }

  ## Convert .date
  .date <- as.Date(.date, format = "%Y-%m-%d")

  data_dates <- paste(year(.date),
                      stringr::str_pad(month(.date),
                                       width = 2,
                                       side = "left",
                                       pad = "0"),
                      stringr::str_pad(seq(from = 1,
                                           to = lubridate::mday(.date),
                                           by = 1),
                                       width = 2,
                                       side = "left",
                                       pad = "0"),
                      sep = "-")

  ## Detect filenames of hourly datasets in ennet_db required based on .date
  fn <- paste("https://raw.githubusercontent.com/",
              repo, "/", branch, "/data/ennet_topics_",
              data_dates, ".csv", sep = "")

  ## Read each dataset
  x <- lapply(
    X = fn,
    FUN = function(fn) {
      try(read.csv(fn))
    }
  )

  ## Merge items on the list
  x <- Reduce(f = merge, x = x)

  ## Convert to tibble
  x <- tibble::tibble(x)

  ## Return x
  return(x)
}


################################################################################
#
#'
#' Create hourly topics datasets for the ennet_db
#'
#' @param repo A character value of the GitHub user and repository name
#'   combination identifying the GitHub location for ennet_db. Default is
#'   `katilingban/ennet_db`.
#' @param branch A character value for the branch name from which to retrieve
#'   data. Default is `main`.
#' @param .date A character value or vector of date/dates for which to create
#'   a topics dataset for the ennet_db
#'
#' @return A tibble of specified topics dataset created from data in the
#'   ennet_db
#'
#' @author Ernest Guevarra
#'
#' @examples
#' create_db_topics_hourlies(.date = "2020-12-31")
#'
#' @export
#'
#
################################################################################

create_db_topics_hourlies <- function(repo = "katilingban/ennet_db",
                                      branch = "main",
                                      .date = Sys.Date()) {
  ## Check .date
  if (is.na(lubridate::ymd(.date))) {
    stop(
      paste(
        strwrap(x = ".date values are not in the expected YYYY-MM-DD format.
                     Please check and try again.",
                width = 80),
        collapse = "\n"
      )
    )
  }

  ## Check .date is not earlier than 27 December 2020
  if (lubridate::ymd(.date) < as.Date("2020-12-27")) {
    stop(
      paste(
        strwrap(x = "Earliest dataset available from ennet_db is for December
                     2020. Please provide .date value for December 2020 or
                     later.",
                width = 80),
        collapse = "\n"
      )
    )
  }

  ## Get current month and year
  current_year <- .date %>% lubridate::year()
  current_month <- .date %>% lubridate::month()

  if (current_month == 12 & current_year == 2020) {
    all_months_years <- "December_2020"
  } else {
    ##
    all_months_years <- c("December_2020",
                          paste(month.name[1:current_month],
                                current_year, sep = "_"))
  }

  ##
  fn <- paste("https://raw.githubusercontent.com/", repo, "/", branch,
              "/data/ennet_topics_", all_months_years, ".csv", sep = "")

  x <- lapply(X = fn,
              FUN = function(x) {
                y <- read.csv(x)

                names(y) <- names(y) %>%
                  stringr::str_replace(pattern = "_", replacement = " ")

                ## Tidy the dataset and conver to long format
                y <- y %>%
                  tidyr::pivot_longer(
                    cols = dplyr::starts_with(match = c("Views", "Replies")),
                    names_to = c("Interaction", "Extraction"),
                    names_sep = " ",
                    values_to = "n") %>%
                  dplyr::mutate(Extraction = lubridate::ymd_hms(Extraction))
              }
       )

  ## Convert to tibble
  hourlies <- x %>%
    dplyr::bind_rows() %>%
    dplyr::mutate(n = ifelse(is.na(n), 0, n))

  ## Return hourlies
  return(hourlies)
}


################################################################################
#
#'
#' Create daily topics datasets for the ennet_db
#'
#' @param hourlies A tibble of topics data usually produced by using the
#'   [create_db_topics_hourlies()] function
#'
#' @return A tibble of specified topics dataset created from data in the
#'   ennet_db
#'
#' @author Ernest Guevarra
#'
#' @examples
#' themes <- ennet_themes$themes
#' x <- ennet_hourlies[ennet_hourlies$Theme == themes[3], ]
#' create_db_topics_dailies(hourlies = x)
#'
#' @export
#'
#
################################################################################

create_db_topics_dailies <- function(hourlies) {
  ## Process dailies topics data
  dailies <- hourlies %>%
    dplyr::group_by(Theme, Topic, Author, Posted, Link, Interaction,
                    `Extraction Date` = as.Date(Extraction)) %>%
    dplyr::filter(Extraction == max(Extraction, na.rm = TRUE)) %>%
    dplyr::ungroup()

  ## return dailies
  return(dailies)
}

################################################################################
#
#'
#' Create various topics interactions datasets for the ennet_db
#'
#' @param dailies A tibble of topics data usually produced by using the
#'   [create_db_topics_dailies()] function
#' @param id A character value for data identifier. Possible choices are
#'   *daily*, *weekly*, *monthly*, or *yearly*.
#'
#' @return A tibble of specified topics dataset created from data in the
#'   ennet_db
#'
#' @author Ernest Guevarra
#'
#' @examples
#' themes <- ennet_themes$themes
#' x <- ennet_dailies[ennet_dailies$Theme == themes[3], ]
#' create_db_topics_interactions(dailies = x, id = "yearly")
#'
#' @export
#'
#
################################################################################

create_db_topics_interactions <- function(dailies,
                                          id = c("daily", "weekly",
                                                 "monthly", "yearly")) {
  if (id == "daily") {
    ## Tally daily views
    x <- dailies %>%
      dplyr::group_by(Theme, Interaction, `Extraction Date`) %>%
      dplyr::count(Posted, name = "nPosts") %>%
      dplyr::summarise(nPosts = sum(nPosts), .groups = "drop") %>%
      tidyr::pivot_wider(names_from = Interaction, values_from = nPosts) %>%
      dplyr::select(Theme:Replies) %>%
      dplyr::rename(nPosts = Replies)

    ## Tally daily interactions
    y <- dailies %>%
      dplyr::group_by(Theme, Interaction, `Extraction Date`, .add = TRUE) %>%
      dplyr::summarise(nInteractions = sum(n), .groups = "drop") %>%
      tidyr::pivot_wider(names_from = Interaction,
                         values_from = nInteractions) %>%
      dplyr::group_by(Theme) %>%
      dplyr::mutate(`New Replies` = c(0, diff(Replies, 1)),
                    `New Views` = c(0, diff(Views, 1))) %>%
    ## Merge views with daily interactions
      dplyr::full_join(x) %>%
      dplyr::ungroup()
  }

  if (id == "weekly") {
    ## Process weeklies topics data
    weeklies <- dailies %>%
      dplyr::group_by(Theme, Topic, Author, Posted, Link, Interaction,
                      `Extraction Week` = cut(`Extraction Date`,
                                              breaks = "1 week",
                                              start.on.monday = FALSE) %>%
                        as.Date()) %>%
      dplyr::filter(Extraction == max(Extraction, na.rm = TRUE)) %>%
      dplyr::ungroup()

    ## Tally weekly views
    x <- dailies %>%
      dplyr::group_by(Theme, Interaction,
                      `Extraction Week` = cut(`Extraction Date`,
                                              breaks = "1 week",
                                              start.on.monday = FALSE) %>%
                        as.Date()) %>%
      dplyr::count(Posted, name = "nPosts") %>%
      dplyr::summarise(nPosts = sum(nPosts), .groups = "drop") %>%
      tidyr::pivot_wider(names_from = Interaction, values_from = nPosts) %>%
      dplyr::select(Theme:Replies) %>%
      dplyr::rename(nPosts = Replies)

    ## Tally weekly interactions
    y <- weeklies %>%
      dplyr::group_by(Theme, Interaction, `Extraction Week`, .add = TRUE) %>%
      dplyr::summarise(nInteractions = sum(n), .groups = "drop") %>%
      tidyr::pivot_wider(names_from = Interaction,
                         values_from = nInteractions) %>%
      dplyr::group_by(Theme) %>%
      dplyr::mutate(`New Replies` = c(0, diff(Replies, 1)),
                    `New Views` = c(0, diff(Views, 1))) %>%
      dplyr::full_join(x) %>%
      dplyr::ungroup()
  }

  if (id == "monthly") {
    ## Process monthlies topics data
    monthlies <- dailies %>%
      dplyr::group_by(Theme, Topic, Author, Posted, Link, Interaction,
                      `Extraction Month` = cut(`Extraction Date`,
                                               breaks = "1 month") %>%
                        as.Date()) %>%
      dplyr::filter(Extraction == max(Extraction, na.rm = TRUE)) %>%
      dplyr::ungroup()

    ## Tally monthly views
    x <- dailies %>%
      dplyr::group_by(Theme, Interaction,
                      `Extraction Month` = cut(`Extraction Date`,
                                               breaks = "1 month") %>%
                        as.Date()) %>%
      dplyr::count(Posted, name = "nPosts") %>%
      dplyr::summarise(nPosts = sum(nPosts), .groups = "drop") %>%
      tidyr::pivot_wider(names_from = Interaction, values_from = nPosts) %>%
      dplyr::select(Theme:Replies) %>%
      dplyr::rename(nPosts = Replies)

    ## Tally monthly interactions
    y <- monthlies %>%
      dplyr::group_by(Theme, Interaction, `Extraction Month`, .add = TRUE) %>%
      dplyr::summarise(nInteractions = sum(n), .groups = "drop") %>%
      tidyr::pivot_wider(names_from = Interaction, values_from = nInteractions) %>%
      dplyr::group_by(Theme) %>%
      dplyr::mutate(`New Replies` = c(0, diff(Replies, 1)),
                    `New Views` = c(0, diff(Views, 1))) %>%
      dplyr::full_join(x) %>%
      dplyr::ungroup()
  }

  if (id == "yearly") {
    ## Process yearlies topics data
    yearlies <- dailies %>%
      dplyr::group_by(Theme, Topic, Author, Posted, Link, Interaction,
                      `Extraction Year` = cut(`Extraction Date`,
                                              breaks = "1 year") %>%
                        as.Date()) %>%
      dplyr::filter(Extraction == max(Extraction, na.rm = TRUE)) %>%
      dplyr::ungroup()

    ## Tally yearly views
    x <- yearlies %>%
      dplyr::group_by(Theme, Interaction,
                      `Extraction Year` = cut(`Extraction Date`,
                                              breaks = "1 year") %>%
                        as.Date()) %>%
      dplyr::count(Posted, name = "nPosts") %>%
      dplyr::summarise(nPosts = sum(nPosts), .groups = "drop") %>%
      tidyr::pivot_wider(names_from = Interaction, values_from = nPosts) %>%
      dplyr::select(Theme:Replies) %>%
      dplyr::rename(nPosts = Replies)

    ## Tally yearly interactions
    y <- yearlies %>%
      dplyr::group_by(Theme, Interaction, `Extraction Year`, .add = TRUE) %>%
      dplyr::summarise(nInteractions = sum(n), .groups = "drop") %>%
      tidyr::pivot_wider(names_from = Interaction,
                         values_from = nInteractions) %>%
      dplyr::group_by(Theme) %>%
      dplyr::mutate(`New Replies` = c(0, diff(Replies, 1)),
                    `New Views` = c(0, diff(Views, 1))) %>%
      dplyr::full_join(x) %>%
      dplyr::ungroup()
  }

  ## Return y
  return(y)
}
