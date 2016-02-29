#' SeqBoxplot
#'
#' This function searches cuffnorm format gene expression data for user specified genes and generates a ggplot2 format facet grid with normalized FPKM boxplots
#' @param gene.names This first argument is a vector of gene names (as string). Genenames MUST be NCBI Genbank format.
#' @param nrow The number of rows in boxplot array. Default 3
#' @param dir The directory containing CuffNorm format output files. 
#' @param csv.out Name and location of the CSV file output. Default "SRoutput.csv"
#' @param csv Boolean operator controlling csv output. TRUE returns csv file with filename as specified by 'csv.out'. Default FALSE
#' @param scales Determines how scales are set: "fixed", free ("free"), or free in one dimension ("free_x", "free_y"). Default is "free_y". See ggplot2 facet_wrap() documentation.
#' @param size Integer. Point size points mapped by geom_point(). Set to 0 for box and whiskers plots only. Default 5
#' @return ggplot 2 facet_wrap() opject
#' @export
#' @examples
#' getSRexample() # Downloads and unpacks example dataset in working directory
#' example <- SeqBoxplot(gene.names=c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"),nrow=3,dir="./norm_out")
#' print(example)

SeqBoxplot <- function(gene.names,
                       nrow = 3,
                       dir,
                       csv = FALSE,
                       csv.out ="SRoutput.csv",
                       scales = "free_y",
                       size = 5)
{

##############################
## SUBSET TO MATCHING GENES ##
##############################
# Search for gene_short_name matching input query (as vector)
# returns vector of matching rownames
matches <- which(rownames(dir) %in% as.vector(gene.names))
# Subset data to rownames matching query
data.sub <- dir[matches,]
data.sub$gene_short_name <- rownames(data.sub)
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
melt.data <- melt(data.sub, id = "gene_short_name")
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
                       color = "black", shape = 21, size = size) +
            facet_wrap(~ gene, scales = scales, nrow = nrow) +
            xlab("") +
            ylab("Normalized FPKM")
    return(plot)
}
