## Test case 4
# Load function "gene_retriever_png"
#Tests to see if new heatmap works works
source("gene_retriever.r")
gene_retriever(gene_names=c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"),nrow=2,dir="./DATA/norm_out", csv.out= "output4.csv", gr_name= "gr_output5.png", pdf=FALSE, heatmap="heat.png")

