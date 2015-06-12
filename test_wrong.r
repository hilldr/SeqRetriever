## Test case 4
# Load function "Gene Retriever"
#Tests to see if gene retriever function provides an error message that specifies which genes were not found
source("gene_retriever.r")
gene_retriever_pdf(gene_names=c("O5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"),nrow=2,dir="./DATA/norm_out", csv.out= "output_wrong.csv", pdf= "gr_output_wrong.pdf")
