## Test case 3
# Load function "gene_retriever_png"
#Tests to see if new gene retriever png works
source("gene_retriever.r")
gene_retriever_png(gene_names=c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"),nrow=2,dir="./DATA/norm_out", csv.out= "output3.csv", png= "gr_output4.png")

