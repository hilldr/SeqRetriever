#' GeneRetriever
#'
#' This function searches cuffnorm format gene expression data for user specified genes and generates a normalized FPKM table and box plots and/or a heatmap with hierarchical clustering.
#' @param gene.names This first argument is a vector of gene names (as string). Genenames MUST be NCBI Genbank format.
#' @param nrow The number of rows in boxplot array. Default 3
#' @param dir The directory containing CuffNorm format output files. 
#' @param csv.out Name and location of the CSV file output. Default "gr_output.csv"
#' @param gr.name Name of boxplot pdf output. Default "gr_output.pdf"
#' @param w Width in inches of the boxplot output. Default 8
#' @param h Height in inches of the boxplot output. Default 11
#' @param pdf Boolean operator controlling PDF output. FALSE returns PNG output. Default TRUE
#' @param heatmap Boolean operator controlling heatmap output. TRUE returns heatmap plot. Default is FALSE
#' @param hm.name Name of heatmap output. Default is "gr_heatmap.pdf"
#' @param cellwidth Heatmap cell width in px. Default 30
#' @param cellheight Heatmap cell height in px. Default 30
#' @return Normalized FPKM matrix containing the specified subset of genes accross all samples. Additional options will plot expression of individual genes as box plots and/or a heatmap with hierarchical clustering
#' @export
#' @examples
#' GeneRetriever(gene.names=c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"),nrow=3,dir="./DATA/norm_out", pdf = TRUE, heatmap = TRUE)

GeneRetriever <- function(gene.names,
                           nrow = 3,
                           dir = "./",
                           csv.out ="GRoutput.csv",
                           gr.name = "GRoutput.pdf",
                           w = 8,
                           h = 11,
                           pdf = TRUE,
                           heatmap = FALSE,
                           hm.name = "GRheatmap.pdf",
                           cellwidth = 30,
                           cellheight = 30)
{
  # Read in data from genes.count_table file
  # dir.count is the string that results from concatenating the directory
  # location and file name
  dir.count <- paste(dir, "/genes.count_table", sep="")
  data1 <- read.table(dir.count, header=TRUE, sep="\t")
  # Set 1st column to NULL because it is not needed, effectively deletes the column
  data1$tracking_id <- NULL
  # Read in data from genes.attr_table file
  dir.attr <- paste(dir,"/genes.attr_table", sep="")
  attr.table <- read.table(dir.attr, header=TRUE, sep="\t")
  # Bind the gene_short_name column from the attr.table to data1,
  # this will put the gene_short_name column as the first column in data1
  data1 <- cbind(attr.table$gene_short_name, data1)
  colnames(data1)[1] <- "gene_short_name"
    
  # Start making the table that will contain the gene expression data of the gene
  # given to the function. Start with the first gene in the vector
  data.sub <- subset(data1, data1[, 1] == gene.names[1])
    
  # Get the length of the vector containing gene names to use in a for loop
  len.gen.names <- length(gene.names)
    
  # Use a for loop that starts at 2 (because we already got the data
  # for the first gene in the vector) and goes till the end of the vector
  for (i in 2:len.gen.names) {
    # For each gene, get the data from the .txt file using the subset function
    # and then use rbind to add the data from the nth gene to the table
    #for the first gene
    data.gene <- subset(data1, data1[, 1] == gene.names[i])
    data.sub <- rbind(data.sub, data.gene)
  }
  # Convert the gene_short_name column into strings
  data.sub[, 1] <- sapply(data.sub[, 1], as.character)
  # Number of rows in data.sub is how many genes there are in actuality.
  # Variable gene.names may contain mispelled genes or genes
  # that are not found in the specific data set.
  new.len.gen <- nrow(data.sub)
  # If there is a difference in length between the amount of genes subsetted
  # and the amount of genes given,then print out the genes
  # that were not subsetted and update variables
  if (new.len.gen != len.gen.names) {
    # new.gene.names contains all the genes that were subsetted
    new.gene.names <- data.sub$gene_short_name
    # Go through each gene in the gene.names variable and see which one(s)
    # is/are missing
    for (z in 1:len.gen.names) {
      if (!(gene.names[z] %in% new.gene.names)) {
        error <- paste(gene.names[z], "was not found or was misspelled", sep=" ")
        print(error)
      }
    }
    # Update variables
    gene.names = new.gene.names
    len.gen.names = new.len.gen
  }  
  #Export subsetted data as a .csv file
  print(paste("Writing retrieved FPKM table as",csv.out))
  write.csv(data.sub,file=csv.out, row.names = FALSE)
  # data.sub will have multiple different columns,
  # but the first column is just gene names, which we don't care about.
  # That's why we subtract 1 from the number of columns in data.defa
  col.use = ncol(data.sub) - 1
  # Make a table with 3 columns and (len.gen.names * col.use) rows
  # data from each column in data.defa will be a
  # new row in data.defb for each gene
  data.for <- data.frame(matrix(nrow=(len.gen.names * col.use), ncol=3))
  # Make a vector with the column names of data.defa,
  # will be used later to fill in data.defb
  col.names <- c(colnames(data.sub))
  # Remove the first elements of col.names because
  # it is just a columns containing names
  col.names <- col.names[-1]
  # Remove the last 2 characters from col.names
  # convert sample_# to sample aka group
  col.names <- gsub('.{2}$', '', col.names)
    
  # For loop to fill in data for each gene
  for (i in 1:len.gen.names) {
    # Get the name of the gene, will be used to fill in data.defb
    gsn <- data.sub[i, 1]
    # x is a index to access the col.names vector and the fpkm data from data.defa
    x <- 1
    # The outer for loop iterates once for each gene that is being analyzed.
    # The inner for loop (below) iterates enough times to
    # fill in all the rows needed for a gene.
    # For example if there are 5 different experession data groups,
    # then each gene needs 5 rows, one for each group.
    # Continuing with 5 group example, if we are looking at the first gene,
    # this for loop will fill in rows 1-5 in data.defb.
    # If you are looking at the second gene, it fills in rows 6-10 and so on.
    for (j in (((col.use*i)-col.use)+1):(col.use*i)) {
      data.for[j, 1] <- gsn
      data.for[j, 2] <- col.names[x]
      data.for[j, 3] <- data.sub[i, x+1]
      x <- x + 1
    }
  }
  # Add column names to the formatted table
  colnames(data.for) <- c("gene", "group", "fpkm")
  #Make box plots and export them as a .pdf or .png file
  library(ggplot2)
  if (pdf == TRUE) {
    print("Generating boxplot(s) as PDF")
    #Export file is a pdf file
    pdf(file=gr.name,height=h, width=w)
  }
  else {
    #Export file is a png file
    print("Generating boxplot(s) as PNG")
    png(file=gr.name, width=w, height=h, units="in", res=144)
  }
  plot <- ggplot(data.for,aes(x=group,y=fpkm,fill=factor(group)))+
  geom_boxplot(color="black") +
  geom_point(aes(fill=factor(group)),color="black",shape=21,size=10/length(gene.names)) +
  facet_wrap(~ gene,scales="free_y",nrow=nrow) +
  theme(legend.position="none",
  axis.text.x=element_text(size=(22/length(gene.names)*2),face="bold",color="black",angle=45,vjust=1,hjust=1),
  axis.text.y=element_text(size=16,face="bold"),
  axis.title.y=element_text(size=22,face="bold",vjust=1.5),
  strip.text.x=element_text(size=20,face="bold")) +
  xlab("") + ylab("Normalized FPKM")
  print(plot)
  if (heatmap == TRUE) {
    library(pheatmap)
    library(RColorBrewer)
    #Need matrix. Make rownames the names of the genes
    rownames(data.sub) <- gene.names
    #Next get rid of the gene_short_name column
    data.sub$gene_short_name <- NULL
    if (pdf == TRUE) {
    #Export file is a pdf file
    print("Generating heatmap as PDF")  
    pdf(file=hm.name)
  }
    else {
    #Export file is a png file
    print("Generating heatmap as PNG")  
    png(file =hm.name, width=w, height=h, units="in", res=144)
   }
    # subset dataframe 'data.1' to rows where SD != 0, ignoring NA values
    data.sub2 <- data.sub[apply(data.sub, 1, sd, na.rm = TRUE) != 0,]
    heat <- pheatmap(data.sub2,
             scale="row",
             clustering_method="average",
             color=colorRampPalette(rev(brewer.pal(n=7, name="RdYlBu")))(300),
             main="Gene Retriever Heatmap",
             border_color="black",
             cellwidth=cellwidth,
             cellheight=cellheight,
             show_rownames=TRUE,
             fontsize=12,
             filename=hm.name)
  }
  else {
    print("Heatmap output disabled.")
    print("Set heatmap = TRUE to generate heatmap")
  }
  dev.off()
}


## GeneRetriever
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




