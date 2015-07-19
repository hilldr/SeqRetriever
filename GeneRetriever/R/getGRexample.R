getGRexample <- function(dir="./")
 {
  download.file(url="https://raw.githubusercontent.com/hilldr/gene_retriever/master/DATA/CtlHIO_v_EcoliHIO_v_HIO_v_HuSI.Duo.A_v_HuSI.Dist.A_v_HuSI.F_repFpkms.csv",
                destfile="test.data.csv",
                method="wget")
