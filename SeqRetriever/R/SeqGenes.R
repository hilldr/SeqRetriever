#' SeqGenes
#'
#' This function subsets a SeqDataframe based on a user-supplied gene list
#' @param gene.names This first argument is a vector of gene names (as string). Gene names MUST be NCBI Genbank format.
#' @param df SeqDataframe object to search
#' @param csv.out Name and location of the CSV file output. Default "SRoutput.csv"
#' @param csv Boolean operator controlling csv output. TRUE returns csv file with filename as specified by 'csv.out'. Default FALSE
#' @return dataframe
#' @export
#' @examples
#' getSRexample() # Downloads and unpacks example dataset in working directory
#' testdf <- SeqDataframe(dir = "./norm_out")
#' genes <- SeqGenes(gene.names = c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"), df = testdf)

SeqGenes <- function(gene.names,
                     df,
                     csv = FALSE,
                     csv.out = "SeqGenesOutput.csv")
{
    # Search for gene_short_name matching input query (as vector)
    # returns vector of matching rownames
    matches <- which(rownames(df) %in% as.vector(gene.names))
    # Subset data to rownames matching query
    data.sub <- df[matches,]
    data.sub$gene_short_name <- rownames(data.sub)
    # Change order to input order
    data.sub <- data.sub[order(data.sub$gene_short_name),]
    data.sub$gene_short_name <- factor(data.sub$gene_short_name,
                                       levels = unique(gene.names))
    if (csv == TRUE) {
    # Notify user and Export search results as a .csv file
        print(paste("Writing retrieved FPKM table as",csv.out))
        write.csv(data.sub.sum,file=csv.out, row.names = FALSE)
    } else {
        print("CSV ouput disabled. Set csv = TRUE to enable")
    }
    return(data.sub)
}


