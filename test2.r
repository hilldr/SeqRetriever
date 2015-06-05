## Test case 2
# Load function "Gene Retriever"
#Tests to see if new gene retriever function works (no input file name argument and new wd argument)
source("gene_retriever.r")
gene_retriever(gene_names=c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"),nrow=2,dir="./DATA/norm_out", csv.out= "output2.csv", pdf= "gr_output3.pdf")
