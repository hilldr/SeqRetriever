#' SeqHeatmap
#'
#' This function searches cuffnorm format gene expression data for user specified genes and returns a heatmap with hierarchical clustering as a ggplot2 object
#' @param df SeqDataframe object to plot.
#' @param dist.method Method for deterining distance measurements for axis clustering. Accepts methods specified in ?dist. Default = "euclidean"
#' @param hclust.method Clustering method for ordering genes and samples on axis. Acceppts methods specified in ?hclust. Default = "ward.D"
#' @return Normalized expression heatmap containing the specified genes accross all samples and clustered according to distance on both axis. Returns ggplot2 object for plotting or further user modification.
#' @export
#' @examples
#' getSRexample() # Downloads and unpacks example dataset in working directory
#' testdf <- SeqDataframe(dir = "./norm_out")
#' genes <- SeqGenes(gene.names = c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"), df = testdf)
#' heatmap <- SeqHeatmap(genes)
#' plot(heatmap)
#'
#' # Example customization
#' # Match 'pheatmap' style color scheme
#' heatmap <- SeqHeatmap(genes)
#' library(RColorBrewer)
#' colors <- colorRampPalette(rev(brewer.pal(n=7, name="RdYlBu")))(300)
#' heatmap <- heatmap + scale_fill_gradient2(low=colors[1], high=colors[300], mid=colors[150])
#' plot(heatmap)


SeqHeatmap <- function(df,
                       dist.method = "euclidean",
                       hclust.method = "ward.D")
{
    df <- df[apply(df, 1, sd, na.rm = TRUE) != 0,] # remove genes when Std. Dev. = 0
    rownames(df) <- df$gene_short_name
    df$gene_short_name <- NULL
                                        # scale gene expression by gene (Z-score)
    df <- as.data.frame(t(scale(t(df))))     
                                        # determine order for axis clustering
    ord <- hclust(dist(df, method = dist.method), method = hclust.method)$order
    ord2 <- hclust(dist(t(df), method = dist.method), method = hclust.method)$order
                                        # reformat dataframe for ggplot2
    df.plot <- data.frame(sample = rep(colnames(df),
                                       each = nrow(df)),
                          gene = rownames(df),
                          expression = unlist(df))
                                        # fix order of genes and samples according to clustering
    df.plot$gene <- factor(df.plot$gene, levels = df.plot$gene[ord])
    df.plot$sample <- factor(df.plot$sample, levels = unique(df.plot$sample)[ord2])
                                        # default plot parameters
    library(ggplot2)
    library(scales) # needed for "muted" colors
    plot <- ggplot(df.plot, aes(x = sample, y = gene, fill = expression)) +
        geom_tile() +
        scale_fill_gradient2("Z-score",low = muted("blue"), high = muted("red")) +
       # coord_fixed(ratio = 1) + # fix aspect ratio
       # geom_tile(color = "black", lwd = 0.5) + # set color and size of grid
        theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
              panel.background = element_blank()) # reasonable defaults

    return(plot) # return ggplot2 object for futher modification by user
}
