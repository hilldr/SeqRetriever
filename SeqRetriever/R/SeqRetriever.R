
#' SeqRetriever
#'
#' This function searches cuffnorm format gene expression data for user specified genes and generates a normalized FPKM table and box plots and/or a heatmap with hierarchical clustering.
#' @param gene.names This first argument is a vector of gene names (as string). Genenames MUST be NCBI Genbank format.
#' @param nrow The number of rows in boxplot array. Default 3
#' @param dir The directory containing CuffNorm format output files. 
#' @param csv.out Name and location of the CSV file output. Default "gr_output.csv"
#' @param bp.name Name of boxplot pdf output. Default "gr_output.pdf"
#' @param w Width in inches of the boxplot output. Default 8
#' @param h Height in inches of the boxplot output. Default 11
#' @param boxplot Boolean operator controlling boxplot output. TRUE returns boxplot. FALSE bypasses boxplot generation. Default TRUE
#' @param heatmap Boolean operator controlling heatmap output. TRUE returns heatmap plot. FALSE bypasses heatmap geneation. Default is TRUE
#' @param hm.name Name of heatmap output. Default is "gr_heatmap.pdf"
#' @param cellwidth Heatmap cell width in px. Default 30
#' @param cellheight Heatmap cell height in px. Default 30
#' @return Normalized FPKM matrix containing the specified subset of genes accross all samples. Additional options will plot expression of individual genes as box plots and/or a heatmap with hierarchical clustering
#' @export
#' @examples
#' getSRexample() # Downloads and unpacks example dataset in working directory
#' GeneRetriever(gene.names=c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"),nrow=3,dir="./norm_out", boxplot = TRUE, heatmap = TRUE)

SeqRetriever <- function(gene.names,
                           nrow = 3,
                           dir = "./",
                           csv.out ="SRoutput.csv",
                           bp.name = "SRoutput.png",
                           w = 8,
                           h = 11,
                           boxplot = TRUE,
                           heatmap = TRUE,
                           hm.name = "SRheatmap.png",
                           cellwidth = 15,
                           cellheight = 15)

{
  ######################################
  ## IMPORT DATA FROM CUFFNORM OUTPUT ##
  ######################################
  # dir.count is a string for the count table location
  dir.count <- paste(dir, "/genes.count_table", sep="")
  # read in the count table from dir.count
  data1 <- read.table(dir.count, header=TRUE, sep="\t")
  # Delete tracking ID colum
  data1$tracking_id <- NULL
  # Read in data from genes.attr_table file
  dir.attr <- paste(dir,"/genes.attr_table", sep="")
  attr.table <- read.table(dir.attr, header=TRUE, sep="\t")
  # Bind the gene_short_name from the attr.table to data1,
  # gene_short_name is the first column in data1
  data1 <- cbind(attr.table$gene_short_name, data1)
  # Restore gene_short_name
  colnames(data1)[1] <- "gene_short_name"

##############################
## SUBSET TO MATCHING GENES ##
##############################
# Search for gene_short_name matching input query (as vector)
# returns vector of matching rownames
matches <- which(data1$gene_short_name %in% as.vector(gene.names))
# Subset data to rownames matching query
data.sub <- data1[matches,]
## Sum counts for gene isoforms
# load library plyr
library(plyr)
data.sub.sum <- ddply(data.sub, "gene_short_name", numcolwise(sum))
rownames(data.sub.sum) <- data.sub.sum$gene_short_name
# Notify user and Export search results as a .csv file
print(paste("Writing retrieved FPKM table as",csv.out))
write.csv(data.sub.sum,file=csv.out, row.names = FALSE)

###############
## BOX PLOTS ##
###############
# reformat data.sub.sum for easy boxplot in ggplot2
library(reshape)
melt.data <- melt(data.sub.sum, id = "gene_short_name")
# trim # from sample ID to create group label
melt.data$variable <- gsub('.{2}$', '', melt.data$variable)
# Add column names to the melted table
colnames(melt.data) <- c("gene", "group", "fpkm")
melt.data <- melt.data[order(melt.data$gene),]
# Make box plots and export as .png file
library(ggplot2)
if (boxplot == TRUE) {
    #Export file is a png file
    print(paste("Generating boxplot(s) and saving as",bp.name))
    png(file = bp.name, width = w, height = h, units = "in", res = 144)
  } else {
    print("Boxplot output disabled. Set boxplot = TRUE to enable")
  }
plot <- ggplot(melt.data,aes(x = group, y = fpkm, fill = factor(group)))+
        geom_boxplot(color = "black") +
        geom_point(aes(x = group, y = fpkm, fill = factor(group)),
                   color = "black", shape = 21, size = 18/length(gene.names)) +
        facet_wrap(~ gene, scales = "free_y",nrow = nrow) +
        theme(legend.position = "none",
              axis.text.x = element_text(size = (42/length(gene.names)*2),
                                       face = "bold",
                                       color = "black",
                                       angle = 45,
                                       vjust = 1,hjust = 1),
              axis.text.y = element_text(size = 18,
                                       face = "bold"),
              axis.title.y = element_text(size = 22,
                                        face = "bold",
                                        vjust = 1.5),
              strip.text.x = element_text(size = 22,
                                        face = "bold")) +
        xlab("") +
        ylab("Normalized FPKM")
print(plot)

#############
  ## HEATMAP ##
  #############
  if (heatmap == TRUE) {
      ## Need matrix. Remove non-numeric
      # Test is numeric
      num <- sapply(data.sub.sum, is.numeric)
      # Subset to TRUE columns
      data.sub.sum.num <- data.sub.sum[,num]
      # Subset to rows where SD != 0, ingnoring NA values
      hm.df <- data.sub.sum.num[apply(data.sub.sum.num, 1, sd, na.rm = TRUE) != 0,]
      ## Begin heatmap plotting
      # Notify user
      print(paste("Generating heatmap and saving as", hm.name))  
      # Open PNG device
      png(file = hm.name, width=w, height=h, units="in", res=144)
      library(pheatmap)
      library(RColorBrewer)
      pheatmap(hm.df,
               scale = "row",
               clustering_method = "average",
               color=colorRampPalette(rev(brewer.pal(n=7, name="RdYlBu")))(300),
               main = "",
               border_color = "black",
               cellwidth = cellwidth,
               cellheight = cellheight,
               show_rownames = TRUE,
               fontsize = 12,
               filename = hm.name)
      dev.off()
  } else {
      print("Heatmap output disabled.")
      print("Set heatmap = TRUE to generate heatmap")
      dev.off()
    }
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
