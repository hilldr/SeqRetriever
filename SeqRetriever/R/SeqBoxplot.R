#' SeqBoxplot
#'
#' This function searches cuffnorm format gene expression data for user specified genes and generates a ggplot2 format facet grid with normalized FPKM boxplots
#' @param gene.names This first argument is a vector of gene names (as string). Genenames MUST be NCBI Genbank format.
#' @param nrow The number of rows in boxplot array. Default 3
#' @param dir The directory containing CuffNorm format output files. 
#' @param csv.out Name and location of the CSV file output. Default "SRoutput.csv"
#' @param csv Boolean operator controlling csv output. TRUE returns csv file with filename as specified by 'csv.out'. Default FALSE
#' @param scales Determines how scales are set: "fixed", free ("free"), or free in one dimension ("free_x", "free_y"). Default is "free_y". See ggplot2 facet_wrap() documentation.
#' @return ggplot 2 facet_wrap() opject
#' @export
#' @examples
#' getSRexample() # Downloads and unpacks example dataset in working directory
#' example <- SeqBoxplot(gene.names=c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"),nrow=3,dir="./norm_out")
#' print(example)

SeqBoxplot <- function(gene.names,
                       nrow = 3,
                       dir = "./",
                       csv = FALSE,
                       csv.out ="SRoutput.csv",
                       scales = "free_y")
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
if (csv == TRUE) {
    # Notify user and Export search results as a .csv file
    print(paste("Writing retrieved FPKM table as",csv.out))
    write.csv(data.sub.sum,file=csv.out, row.names = FALSE)
} else {
    print("CSV ouput disabled. Set csv = TRUE to enable")
}

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
# Change plot order to facet wrap
melt.data$gene <- factor(melt.data$gene, levels = gene.names)    
# Make box plots and export as .png file
library(ggplot2)

 
    print(paste("Generating boxplot(s) as ggplot2"))
    plot <- ggplot(melt.data,aes(x = group, y = fpkm, fill = factor(group)))+
            geom_boxplot(color = "black") +
            geom_point(aes(x = group, y = fpkm, fill = factor(group)),
                       color = "black", shape = 21, size = 18/length(gene.names)) +
            facet_wrap(~ gene, scales = scales,nrow = nrow) +
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
    return(plot)
}
