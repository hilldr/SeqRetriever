
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

    ## dir.count is a string for the count table location
    dir.count <- paste(dir, "/genes.count_table", sep="")

    ## read in the count table from dir.count
    library(readr)
    counts <- read_delim(dir.count, delim = "\t")
    counts$tracking_id <- NULL

    ## Read in data attributes from genes.attr_table file
    dir.attr <- paste(dir,"/genes.attr_table", sep="")
    cn.attr <- read_delim(dir.attr, delim = "\t")

    ## Bind the gene_short_name from the attr.table to data1,
    gene_short_name <- cn.attr[,"gene_short_name"]
    data1 <- cbind(gene_short_name, counts)
    data1$gene_short_name <- as.character(data1$gene_short_name)

    ## load libraries 
    library(dplyr)
    library(magrittr)
    
    ## Sum counts for gene isoforms
    data1 <- data1 %>%
        group_by(gene_short_name) %>%
        summarise_each(funs(sum)) %>%
        as.data.frame()
    
    rownames(data1) <- data1$gene_short_name  
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
