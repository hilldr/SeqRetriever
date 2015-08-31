<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. Installation</a>
<ul>
<li><a href="#sec-1-1">1.1. Required packages</a>
<ul>
<li><a href="#sec-1-1-1">1.1.1. R installation instructions for Mac OSX and Windows:</a></li>
</ul>
</li>
</ul>
</li>
<li><a href="#sec-2">2. Example</a>
<ul>
<li><a href="#sec-2-1">2.1. FPKM matrix output</a></li>
<li><a href="#sec-2-2">2.2. Boxplot output</a></li>
<li><a href="#sec-2-3">2.3. Heatmap output</a></li>
<li><a href="#sec-2-4">2.4. Additional user options and examples</a></li>
</ul>
</li>
<li><a href="#sec-3">3. Please report all errors</a></li>
<li><a href="#sec-4">4. <span class="todo TODO">TODO</span> Write description of SeqRetriever</a></li>
</ul>
</div>
</div>


**AUTHORS:** David R. Hill and Shrikar Thodla

**PURPOSE:** An orgiginal R package designed to format gene expression data in a table and plot the data as box plots to generate an easy to read visual representation of the data.

# Installation<a id="sec-1" name="sec-1"></a>

If you have not installed the development tools package you will first need to install "devtools" in R to access the SeqRetriever repository on GitHub

    install.packages("devtools")

Then, install SeqRetriever as follows:

    library("devtools")
    devtools::install_github("hilldr/SeqRetriever/SeqRetriever")

## Required packages<a id="sec-1-1" name="sec-1-1"></a>

SeqRetriever requires installation of several additional R packages.
-   ggplot2
-   pheatmap
-   RColorBrewer
-   plyr
-   reshape

You will be prompted to install these pachages during the SeqRetriever installation process. Alternately, you may run the following command in the R console prior to installing SeqReriever:

    install.packages(c("ggplot2","pheatmap","RColorBrewer","plyr","reshape"))

### R installation instructions for Mac OSX and Windows:<a id="sec-1-1-1" name="sec-1-1-1"></a>

<http://cran.r-project.org/mirrors.html> will lead you to a list of
mirrors through which you can download R. Click on a mirror and then
click on the download link that is appropriate for your operating system
(Linux, Mac, or Windows). Follow instructions to install R.

# Example<a id="sec-2" name="sec-2"></a>

    library("SeqRetriever") # Loads the SeqRetriever function library
    getSRexample() # Downloads and unpacks example dataset in working directory
    SeqRetriever(gene.names=c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"),nrow=3,dir="./norm_out", boxplot = TRUE, heatmap = TRUE) # Generates output files in the working directory

## FPKM matrix output<a id="sec-2-1" name="sec-2-1"></a>

[Example FPKM matrix output](./SRoutput.csv)

## Boxplot output<a id="sec-2-2" name="sec-2-2"></a>

![img](./SRoutput.png)
This link will help you learn to interpret boxplots:
<http://www.wellbeingatschool.org.nz/information-sheet/understanding-and-interpreting-box-plots>

## Heatmap output<a id="sec-2-3" name="sec-2-3"></a>

![img](./SRheatmap.png)

## Additional user options and examples<a id="sec-2-4" name="sec-2-4"></a>

    ?SeqRetriever

# Please report all errors<a id="sec-3" name="sec-3"></a>

Please report all errors to David Hill at hilldr@med.umich.edu with
"SeqRetriever error" as the subject.

# TODO Write description of SeqRetriever<a id="sec-4" name="sec-4"></a>
