% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/database.R
\name{create_db_topics_dailies}
\alias{create_db_topics_dailies}
\title{Create daily topics datasets for the ennet_db}
\usage{
create_db_topics_dailies(hourlies)
}
\arguments{
\item{hourlies}{A tibble of topics data usually produced by using the
\code{\link[=create_db_topics_hourlies]{create_db_topics_hourlies()}} function}
}
\value{
A tibble of specified topics dataset created from data in the
ennet_db
}
\description{
Create daily topics datasets for the ennet_db
}
\examples{
themes <- ennet_themes$themes
x <- ennet_hourlies[ennet_hourlies$Theme == themes[3], ]
create_db_topics_dailies(hourlies = x)

}
\author{
Ernest Guevarra
}
