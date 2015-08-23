
#' getSRexample
#'
#' This function downloads and unpacks an example dataset in the working directory. See ?SeqRetriever for additional examples.
#' @param url Specifies the URL path of the file to download.
#' @return Downloads an example dataset in the working directory
#' @export
#' @examples
#' getSRexample()

getGRexample <- function(url="https://github.com/hilldr/gene_retriever/raw/master/example_normout.tar.gz")

{
  # DOWNLOAD AND EXTRACT EXAMPLE CUFFNORM DATASET
  download.file(url=url,method="wget",destfile="example_normout.tar.gz")
  untar("example_normout.tar.gz")
}

## SeqRetriever
## Copyright (C) 2015  David R. Hill and Shrikar Thodla

## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License along
## with this program; if not, write to the Free Software Foundation, Inc.,
## 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
