#' SeqBoxplot
#'
#' This function searches cuffnorm format gene expression data for user specified genes and generates a ggplot2 format facet grid with normalized FPKM boxplots
#' @param df Name of the SeqGenes format dataframe to plot
#' @param nrow The number of rows in boxplot array. Default 3
#' @param scales Determines how scales are set: "fixed", free ("free"), or free in one dimension ("free_x", "free_y"). Default is "free_y". See ggplot2 facet_wrap() documentation.
#' @param size Integer. Point size points mapped by geom_point(). Set to 0 for box and whiskers plots only. Default 5
#' @return ggplot 2 facet_wrap() opject
#' @export
#' @examples
#' getSRexample() # Downloads and unpacks example dataset in working directory
#' testdf <- SeqDataframe(dir = "./norm_out")
#' genes <- SeqGenes(gene.names = c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"), df = testdf)
#' plot <- SeqBoxplot(genes)
#' print(plot)

SeqBoxplot <- function(df,
                       nrow = 3,
                       scales = "free_y",
                       size = 5)
{

###############
## BOX PLOTS ##
###############
# reformat data.sub.sum for easy boxplot in ggplot2
library(reshape)
melt.data <- melt(df, id = "gene_short_name")
# trim # from sample ID to create group label
melt.data$variable <- gsub('.{2}$', '', melt.data$variable)
# Add column names to the melted table
colnames(melt.data) <- c("gene", "group", "fpkm")
#melt.data <- melt.data[order(melt.data$gene),]
# Change plot order to facet wrap
#melt.data$gene <- factor(melt.data$gene, levels = unique(df$gene_short_name))    
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
