
#' SeqDataframe
#'
#' This function accepts cuffnorm format fpkm counts and returns a formatted R dataframe
#' @param dir The directory containing CuffNorm format output files. 
#' @return Normalized FPKM dataframe of FPKM counts and gene metadata accross all samples. 
#' @export
#' @examples
#' getSRexample() # Downloads and unpacks example dataset in working directory
#' SeqDataframe(dir="./norm_out")

SeqDataframe <- function(dir = "./"){
  ######################################
  ## IMPORT DATA FROM CUFFNORM OUTPUT ##
  ######################################
  # dir.count is a string for the count table location
  dir.count <- paste(dir, "/genes.count_table", sep="")
  # read in the count table from dir.count
  counts <- read.table(dir.count, header=TRUE, sep="\t", stringsAsFactors = FALSE)
  counts$tracking_id <- NULL
  # Read in data attributes from genes.attr_table file
  dir.attr <- paste(dir,"/genes.attr_table", sep="")
  cn.attr <- read.table(dir.attr, header=TRUE, sep="\t", stringsAsFactors = FALSE)
  # Bind the gene_short_name from the attr.table to data1,
  # gene_short_name is the first column in data1
  data1 <- cbind(cn.attr, counts)
  return(data1)
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
