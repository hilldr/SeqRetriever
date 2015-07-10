## Test case 
# Load library
library(GeneRetriever)
# Run gene_retriever using sample data
gene_retriever(gene_names=c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"),
               nrow=2,dir="./DATA/norm_out",
               csv.out= "output.csv",
               gr_name= "gr_output.png",
               pdf=FALSE,
               heatmap="heat.png")

