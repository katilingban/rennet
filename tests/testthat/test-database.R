library(ennet)

x <- get_db_discussions()

test_that("x is a tibble", {
  expect_is(x, "tbl")
})

x <- get_db_topics()

test_that("x is a tibble", {
  expect_is(x, "tbl")
})

test_that("message", {
  expect_message(get_db_topics(branch = "Master"))
})

fn <- c("ennet_topics_2021-01-17_00:54:48.csv")

x <- create_db_topics_daily(.date = "2021-01-17", fn = fn)

test_that("x is a tibble", {
  expect_is(x, "tbl")
})

test_that("error message show", {
  expect_error(create_db_topics_daily(.date = NA))
})

test_that("error message show", {
  expect_error(create_db_topics_daily(.date = "2021-01-17"))
})

x <- create_db_topics_monthly(.date = "2021-01-03")

test_that("x is a tibble", {
  expect_is(x, "tbl")
})

test_that("error message show", {
  expect_error(create_db_topics_monthly(.date = NA))
})

test_that("date beyond current", {
  expect_error(create_db_topics_monthly(.date = "2020-01-01"))
})

x <- create_db_topics_hourlies(.date = "2020-12-31")

test_that("x is a tibble", {
  expect_is(x, "tbl")
})

#x <- create_db_topics_hourlies(.date = Sys.Date())

#test_that("x is a tibble", {
#  expect_is(x, "tbl")
#})

test_that("expect error", {
  expect_error(create_db_topics_hourlies(.date = NA))
})

test_that("expect error", {
  expect_error(create_db_topics_hourlies(.date = "2019-12-31"))
})

x <- create_db_topics_dailies(hourlies = ennet_hourlies)

test_that("x is a tibble", {
  expect_is(x, "tbl")
})

test_that("x is a tibble", {
  expect_is(create_db_topics_interactions(dailies = ennet_dailies,
                                          id = "daily"), "tbl")
  expect_is(create_db_topics_interactions(dailies = ennet_dailies,
                                          id = "weekly"), "tbl")
  expect_is(create_db_topics_interactions(dailies = ennet_dailies,
                                          id = "monthly"), "tbl")
  expect_is(create_db_topics_interactions(dailies = ennet_dailies,
                                          id = "yearly"), "tbl")
})
