## Test case 5
# Load function "Gene Retriever"
#Tests to see if gene retriever function provides an error message that specifies which genes were not found
source("gene_retriever.r")
#Mistakes: PD should be PGD, UBEB should be UBE4B
gene_retriever_png(gene_names=c("PD","PDPN","KAZN","UBEB","CTRC", "ALPL", "FAM54B"),nrow=2,dir="./DATA/norm_out", csv.out= "output_wrong2.csv", png= "gr_output_wrong2.png")
