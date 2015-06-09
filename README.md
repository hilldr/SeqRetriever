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

R installation instructions for Mac OSX and Windows:
    http://cran.r-project.org/mirrors.html will lead you to a list of mirrors through which you can download R. Click on a mirror (anyone works) and then click on the download link that is appropriate for your operating system (Linus, Mac, or Windows). Follow instructions in order to install R.

List of required packages (e.g. 'ggplot2') and all R commands necessary for installation:
    In order to use gene_retriever, there is one package you must install ggplot2. In order to install ggplot2 open up R and a window called R console should open up. Type install.package("ggplot2") and choose a mirror if asked.

Instructions for downloading 'gene retriever' from GitHub:


Navigation to working directory in R:
    When you open up R use the getwd() function to get the directory you are currently located. The console should pring something like "/Users/Username". In order to move to a different directory use the setwd() function. For example if I want to move form "/Users/Username" to "/Users/Username/Desktop/Gene/Gene_data" I would do setwd("Desktop/Gene/Gene_data").

How to load 'gene retriever' into R:
    In order to load gene_retriever, navigate to your working directory (directions above) and then type source("gene_retriever.r")

How to call gene_retriever() and what each of the options specifies:
    After you load gene_retriever, you can now use the gene_retriever function. In order to use the gene_retriever function just type gene_retriever(...) where ... are your arguments. the default arguments are gene_retriever(gene_names,nrow=3, dir= "./",csv.out="output.csv",pdf= "gr_output.pdf").
    gene_names is a list of strings that are the names of the genes you want to retrieve. This argument is required for the function to work
    nrow is the number of rows you want in the output file containing the tables
    dir is the directory you are currently in
    csv.out is the name of the .csv file that will be exported from the function
    pdf is the name of the .pdf file that will be exported from the function

    The values for the arguments given above are the default values, so if you don't input the dir argument, the function will just use your working directory. If you want to change the dir argument simply call gene_retriever like so gene_retriever(gene_names, dir="...")


Explanation of output files:
    This function outputs 2 files, a csv file and a pdf (or png) file. The csv file contains all the data from the cufflinks output that is related to the gene you input into the function. The pdf/png file contains a boxplots of the data. Here is a link to help you understand box plots http://www.wellbeingatschool.org.nz/information-sheet/understanding-and-interpreting-box-plots
