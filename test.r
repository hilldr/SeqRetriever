## Test case 
# Load library
#library(GeneRetriever)
# Run gene_retriever using sample data
gene_retriever(gene_names=c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"),
               nrow=3,dir="~/development/gene_retriever/DATA/norm_out",
               pdf = TRUE,
               heatmap = TRUE)

