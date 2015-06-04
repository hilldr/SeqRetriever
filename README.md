DATE: 6/2/15

AUTHORS: Shrikar Thodla And David Hill

PURPOSE: To format gene expression data in a table and plot the data as box plots to provide an easy to read visual representation of the data. 

This function takes in 5 arguments:
  1. Vector of gene names (as strings)
  2. # rows you want in the .pdf file (Default value is 3)
  3. The name of the directory and the path to where the output of the cufflinks program is (Default is home directory)
  4. The name of .csv file that is exported from the program (Default name is "output.csv")
  5. The name of the .pdf file that will be exported from the program (Default name is "gr_output.pdf")

REQUIRES: Input File's first column must be NCBI format gene names and the remaining columns must be fpkm data

In order to use this function, you must have access to R. The function name is gene_retriever().
