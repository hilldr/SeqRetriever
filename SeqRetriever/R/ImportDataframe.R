#' ImportDataframe
#'
#' This function imports a csv file as a SeqRetriever format dataframe. This is useful for importing data from non-Cufflinks RNA-seq software, qPCR data, microarray datasets or any set of normalized gene expression data.
#' @param file The csv file to import. Must contain the following headings: "gene_short_name" containing the names of the genes with associated data; unique sample/group names, e.g. "Treated_0, Treated_1, Treated_2, Control_0, Control_1, Control_2". Note that replicate samples MUST end in "_N" where N is a number identifying a unique sample.
#' @export
#' @examples
#' #' getSRexample() # Downloads and unpacks example dataset in working directory
#' test <- SeqDataframe(dir="./norm_out")
#' write.csv(test, file = "test.csv", row.names = FALSE)
#' example <- ImportDataframe(file = "text.csv")

ImportDataframe <- function(file = "*.csv"){

    ## Read in csv file
    library(readr)
    data1 <- read_csv(file = file, col_names = TRUE)

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
