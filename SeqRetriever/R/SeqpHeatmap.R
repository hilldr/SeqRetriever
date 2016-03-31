#' SeqpHeatmap
#'
#' This function searches cuffnorm format gene expression data for user specified genes and generates a heatmap with hierarchical clustering using the "pheatmap" library.
#' @param hm.name Name of heatmap output. Default is "SRheatmap.png"
#' @param cellwidth Heatmap cell width in px. Default 30
#' @param cellheight Heatmap cell height in px. Default 30
#' @return Normalized FPKM matrix containing the specified subset of genes accross all samples. Additional options will plot expression of individual genes as box plots and/or a heatmap with hierarchical clustering
#' @export
#' @examples
#' getSRexample() # Downloads and unpacks example dataset in working directory
#' testdf <- SeqDataframe(dir = "./norm_out")
#' genes <- SeqGenes(gene.names = c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"), df = testdf)
#' SeqHeatmap(genes)


SeqpHeatmap <- function(df,
                       hm.name = "SRheatmap.png",
                       w = 8,
                       h = 11,
                       cellwidth = 15,
                       cellheight = 15)

{
    ## Strip out all summary test columns and statistical tests
    strip_stats <- function(x){
        o <- x[,grep(".p|Mean.|log2.", colnames(df),invert = TRUE)]
        return(o)
    }
    df <- strip_stats(df)
    
    ## Need matrix. Remove non-numeric
    ## Test is numeric
    num <- sapply(df, is.numeric)
    ## Subset to TRUE columns
    data.sub.sum.num <- df[,num]
    ## Subset to rows where SD != 0, ingnoring NA values
    hm.df <- data.sub.sum.num[apply(data.sub.sum.num, 1, sd, na.rm = TRUE) != 0,]
    ## Begin heatmap plotting
    ## Open PNG device
    png(file = hm.name, width=w, height=h, units="in", res=144)
    library(pheatmap)
    library(RColorBrewer)
    pheatmap(hm.df,
             scale = "row",
             clustering_method = "average",
             color = colorRampPalette(rev(brewer.pal(n=7, name="RdYlBu")))(300),
             main = "",
             border_color = "black",
             cellwidth = cellwidth,
             cellheight = cellheight,
             show_rownames = TRUE,
             fontsize = 12)
    dev.off()
}
