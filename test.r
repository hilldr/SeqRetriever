## Test case
# Load function "Gene Retriever"
source("gene_retriever.r")
gene_retriever(gene_names=c("A1CF","AADAC","AAGAB","AASS","AATK","AACS"),nrow=2,data.file="./DATA/CtlHIO_v_EcoliHIO_v_HIO_v_HuSI.Duo.A_v_HuSI.Dist.A_v_HuSI.F_repFpkms.csv")
