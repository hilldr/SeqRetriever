**GENE RETRIEVER**

**AUTHORS:** Shrikar Thodla and David Hill

**PURPOSE:** To format gene expression data in a table and plot the data as box plots to provide an easy to read visual representation of the data. 


**REQUIREMENTS**: Input File's first column must be NCBI format gene names and the remaining columns must be fpkm data

In order to use this function, you must have access to R. The function name is gene_retriever().

##R installation instructions for Mac OSX and Windows:

    http://cran.r-project.org/mirrors.html will lead you to a list of mirrors through which you can download R. Click on a mirror (anyone works) and then click on the download link that is appropriate for your operating system (Linus, Mac, or Windows). Follow instructions in order to install R.

##List of required packages (e.g. 'ggplot2') and all R commands necessary for installation:

    In order to use gene_retriever, there is one package you must install ggplot2. In order to install ggplot2 open up R and a window called R console should open up. Type install.package("ggplot2") and choose a mirror if asked.

##Instructions for downloading 'gene retriever' from GitHub:


##Navigation to working directory in R:

    When you open up R use the getwd() function to get the directory you are currently located. The console should pring something like "/Users/Username". In order to move to a different directory use the setwd() function. For example if I want to move form "/Users/Username" to "/Users/Username/Desktop/Gene/Gene_data" I would do setwd("Desktop/Gene/Gene_data").

##How to load 'gene retriever()' into R:

    In order to load gene_retriever, navigate to your working directory (directions above) and then type source("gene_retriever.r")

##How to call gene_retriever() and what each of the options specifies:

After you load gene_retriever(), you can now use the gene_retriever function. There are two different gene retriever functions one that exports a pdf file and one that exports a png file (gene_retriever_pdf() and gene_retriever_png()). In order to use the gene_retriever() function just type gene_retriever_pdf(...) (or gene_retriever_png()) where ... are your arguments. the default arguments are gene_retriever(gene_names,nrow=3, dir= "./",csv.out="output.csv",pdf= "gr_output.pdf").
>>>>>>> output_format
1. gene_names is a list of strings that are the names of the genes you want to retrieve. This argument is required for the function to work
2. nrow is the number of rows you want in the output file containing the tables
3. dir is the directory you are currently in
4. csv.out is the name of the .csv file that will be exported from the function
5. pdf (or png) is the name of the .pdf (or .png) file that will be exported from the function
6. For gene_retriever_pdf() there are two more arguments, w and h (in that order) that specify the size of the page that is exported as a pdf file. the default is 8 x 11.

The values for the arguments given above are the default values, so if you don't input the dir argument, the function will just use your working directory. If you want to change the dir argument simply call gene_retriever() like so gene_retriever(gene_names, dir="...")


##Explanation of output files:

This function outputs 2 files, a csv file and a pdf (or png) file. The csv file contains all the data from the cufflinks output that is related to the gene you input into the function. The pdf/png file contains a boxplots of the data. Here is a link to help you understand box plots http://www.wellbeingatschool.org.nz/information-sheet/understanding-and-interpreting-box-plots

##Possible Error Messages:
    ```
    Error in `$<-.data.frame`(`*tmp*`, "weight", value = 1) : 
      replacement has 1 row, data has 0
    Error in seq.default(from = best$lmin, to = best$lmax, by = best$lstep) : 
      'from' must be of length 1
    In addition: Warning message:
    In loop_apply(n, do.ply) :
      Removed 23 rows containing non-finite values (stat_boxplot).
    ```
    The message above (numbers may vary)  is an error that is given when a gene is not found/spelled incorrectly

As of now, this is the only error message I have received. If you get another error message, please message me at sthodla@umich.edu with gene_retriever error as the subject.
