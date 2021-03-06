% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ImportDataframe.R
\name{ImportDataframe}
\alias{ImportDataframe}
\title{ImportDataframe}
\usage{
ImportDataframe(file = "*.csv")
}
\arguments{
\item{file}{The csv file to import. Must contain the following headings: "gene_short_name" containing the names of the genes with associated data; unique sample/group names, e.g. "Treated_0, Treated_1, Treated_2, Control_0, Control_1, Control_2". Note that replicate samples MUST end in "_N" where N is a number identifying a unique sample.}
}
\description{
This function imports a csv file as a SeqRetriever format dataframe. This is useful for importing data from non-Cufflinks RNA-seq software, qPCR data, microarray datasets or any set of normalized gene expression data.
}
\examples{
#' getSRexample() # Downloads and unpacks example dataset in working directory
test <- SeqDataframe(dir="./norm_out")
write.csv(test, file = "test.csv", row.names = FALSE)
example <- ImportDataframe(file = "text.csv")
}

