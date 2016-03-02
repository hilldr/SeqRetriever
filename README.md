Aims
====

High throughput RNA sequencing is an incredibly powerful tool for
characterizing gene expression events ranging in scale from the complete
transcriptome of an organism or tissue to the expression of a single
rare RNA isoform accounting for the tiniest fraction of all
trancriptional activity in a cell.

SeqRetriever is designed to extract gene abundance data from the raw
output of the
[Tophat/Cufflinks](http://cole-trapnell-lab.github.io/cufflinks/)
transcriptome assembly and abundance estimation suite and convert it
into R dataframes, commonly used plots, and universal CSV output files.
This allows you to ask simple questions about differences in gene
expression and generate output that you can share with your colleagues,
advisors, collaborators, and reviewers without requiring a degree in
computer science or lengthy immersion in boring programming blogs. We
get it - you have papers that needed to be written yesterday and you
don't have time to learn to program. We're even okay with you analyzing
these output files in Excel if you want.

There are a variety of tools available for analyzing RNA-seq datasets in
the R environment, including the outstanding
[CummeRbund](http://compbio.mit.edu/cummeRbund/) package designed for
analyzing Cufflinks output which we highly recommend. SeqRetriever has
far fewer features, focusing exclusively on differential expression
analysis of assembled RNA-seq datasets. SeqRetriever aims to be the
first R package you run to answer a brand new question about gene
expression differences, but probably not the last one. This package is
designed to get you asking, answering, refining, and re-asking your
questions as quickly as possible.

Design criteria
===============

All functions in the SeqRetriever package are designed with the
following criteria in mind:

1.  Approachable - Anyone can generate meaningful, high quality data
    from RNA-seq datasets.
2.  Productive - Functions should be simple and intuitive. You shouldn't
    have to pull up ?SeqDataframe in every R session. SeqRetriever
    functions should free your mind to think about science,
    not programming.
3.  Readable - Good R script is easy to follow and, therefore, easier to
    share and debug. While discrete functions in SeqRetriever can be
    sequenced together in a pipeline to perform complex tasks, the
    induvidual SeqRetriever functions perform simple tasks and can be
    used independently of other SeqRetriever functions.

Work flow
=========

![Workflow diagram](file:workflow.png)

Examples
========

Setup database
--------------

``` {.r .rundoc-block rundoc-language="R" rundoc-session="*R*" rundoc-exports="code" rundoc-eval="yes"}
library(SeqRetriever)
getSRexample() # Downloads and unpacks example dataset in working directory
testdf <- SeqDataframe(dir = "./norm_out") # format dataframe
```

Select genes
------------

``` {.r .rundoc-block rundoc-language="R" rundoc-session="*R*" rundoc-exports="code" rundoc-eval="yes"}
genes <- SeqGenes(gene.names = c("OR4F5","SAMD11","AJAP1","SKI","ESPN", "CNKSR1"), df = testdf)
```

``` {.r .rundoc-block rundoc-language="R" rundoc-session="*R*" rundoc-exports="both" rundoc-results="graphics" rundoc-file="boxplots.png" rundoc-width="800" rundoc-height="800" rundoc-eval="yes"}
plot <- SeqBoxplot(genes)
print(plot)
```

![](file:boxplots.png)

Print Heatmap
-------------

``` {.r .rundoc-block rundoc-language="R" rundoc-session="*R*" rundoc-exports="both" rundoc-results="graphics" rundoc-file="heatmap.png" rundoc-eval="yes"}
SeqHeatmap(genes, hm.name = "heatmap.png")
```

![](file:heatmap.png)

Print boxplot showing only genes that differ significantly between "HLO" and "Lung~A~"
--------------------------------------------------------------------------------------

``` {.r .rundoc-block rundoc-language="R" rundoc-session="*R*" rundoc-exports="both" rundoc-results="graphics" rundoc-file="sig-boxplots.png" rundoc-width="800" rundoc-height="400" rundoc-eval="yes"}
sig.genes <- SeqStatSubset(genes, limit = 0.001, group1 = "HLO", group2 = "Lung_A")
plot2 <- SeqBoxplot(sig.genes, nrow = 1)
print(plot2)
```

![](file:sig-boxplots.png)

Installation
============

If you have not installed the development tools package you will first
need to install "devtools" in R to access the SeqRetriever repository on
GitHub

``` {.r .rundoc-block rundoc-language="R" rundoc-session="*R*" rundoc-eval="no"}
install.packages("devtools")
```

Then, install SeqRetriever as follows:

``` {.r .rundoc-block rundoc-language="R" rundoc-session="*R*" rundoc-eval="no"}
library("devtools")
devtools::install_github("hilldr/SeqRetriever/SeqRetriever")
```

Required packages
-----------------

SeqRetriever requires installation of several additional R packages.
-   ggplot2
-   pheatmap
-   RColorBrewer
-   dplyr
-   reshape
-   readr

You will be prompted to install these packages during the SeqRetriever
installation process. Alternately, you may run the following command in
the R console prior to installing SeqReriever:

``` {.r .rundoc-block rundoc-language="R" rundoc-session="*R*" rundoc-eval="no"}
    install.packages(c("ggplot2","pheatmap","RColorBrewer","dplyr","reshape","readr"))
```

### R installation instructions for Mac OSX and Windows:

<http://cran.r-project.org/mirrors.html> will lead you to a list of
mirrors through which you can download R. Click on a mirror and then
click on the download link that is appropriate for your operating system
(Linux, Mac, or Windows). Follow instructions to install R.

Please report all errors
========================

Please report all errors to David Hill at hilldr@med.umich.edu with
"SeqRetriever error" as the subject.
