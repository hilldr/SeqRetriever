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

    ## reformat for easy boxplot in ggplot2

    ## Strip out all summary test columns and statistical tests
    strip_stats <- function(x){
        o <- x[,grep("\\.p|Mean\\.|log2\\.", colnames(df),invert = TRUE)]
        return(o)
    }
    
    library(reshape)
    melt.data <- melt(strip_stats(df), id = "gene_short_name")
    ## trim # from sample ID to create group label
    melt.data$variable <- gsub("\\_[0-9]*$", "", melt.data$variable)
    ## Add column names to the melted table
    colnames(melt.data) <- c("gene", "group", "fpkm")

    ## plotting
    library(ggplot2)
    ## update the user about what's going on
    print(paste("Generating boxplot(s) as ggplot2"))
    ## setup plot
    plot <- ggplot(melt.data,aes(x = group, y = fpkm, fill = factor(group)))+
        geom_boxplot(color = "black") +
        geom_point(aes(x = group, y = fpkm, fill = factor(group)),
                   color = "black", shape = 21, size = size) +
        facet_wrap(~ gene, scales = scales, nrow = nrow) +
        xlab("") +
        ylab("Normalized FPKM")
    return(plot)
}
