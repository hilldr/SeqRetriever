## DATE: 6/2/15
## AUTHOR: Shrikar Thodla and David Hill
## PURPOSE: To format gene expression data in a table and plot the data as box plots to provide a easy to read visual representation of the data. This function takes in 5 arguments. The first argument is a vector of gene names (as strings), the second argument is how many rows you want in the .pdf file. The third argument is the name of the input file (as a string) from where to get the data. The fourth argument is the name of .csv file that is exported from the program. The fifth (last) argument is the name of the .pdf file that will be exported from the program.
#
#REQUIRES: Input File's first column must be NCBI format gene names and the remaining columns must be fpkm data
#
#Function name is gene_retriever and it takes 2 arguments (can add more). One argument is a vector of gene names (as strings) and the other is how many rows should be shown in the .pdf file
gene_retriever <- function(gene_names,nrow=3, data.file="./DATA/*", csv.out="output.csv",pdf= "gr_output.pdf") {
    
    #Read in data from .txt file
    data1 <- read.table(data.file,header=TRUE,sep=",")
    
    #Start making the table that will contain the gene expression data of the gene given to the function. Start with the first gene in the vector
    data.defa <- subset(data1, data1[,1] == gene_names[1])
    
    #Get the length of the vector containing gene names to use in a for loop
    len_gen_names = length(gene_names)
    
    #Use a for loop that starts at 2 (because we already got the data for the first gene in the vector) and goes till the end of the vector
    for (i in 2:len_gen_names) {
        #For each gene, get the data from the .txt file using the subset function and then use rbind to add the data from the nth gene to the table for the first gene
        data.gene <- subset(data1, data1[,1] == gene_names[i])
        data.defa <- rbind(data.defa, data.gene)
    }
    #data.defa will have multiple different columns, but the first column is just gene names, which we don't care about. That's why we subtract 1 from the number of columns in data.defa
    col_use = ncol(data.defa) - 1
    
    #Make a table with 3 columns and (len_gen_names * col_use) rows (data from each column in data.defa will be a new row in data.defb for each gene
    data.defb <- matrix(nrow = len_gen_names * (col_use), ncol = 3)
    
    #Convert the gene_short_name column into strings
    data.defa[,1] <- sapply(data.defa[,1], as.character)
    #Make a vector with the column names of data.defa, will be used later to fill in data.defb
    col_names <- c(colnames(data.defa))
    #Remove the first elements of col_names because it is just a columns containing names
    col_names <- col_names[-1]
    ### REMOVE LAST 2 CHARACTERS from col_names (convert sample_# to sample aka group)
    col_names <- gsub('.{2}$','',col_names)
    
    #For loop to fill in data for each gene
    for (i in 1:len_gen_names) {
        #Get the name of the gene, will be used to fill in data.defb
        gsn <- data.defa[i,1]
        #x is a index to access the col_names vector and the fpkm data from data.defa
        x = 1
        #The outer for loop iterates once for each gene that is being analyzed. The inner for loop (below) iterates enough times to fill in all the rows needed for a gene. For example if there are 5 different experession data groups, then each gene needs 5 rows, one for each group. Continuing with 5 group example, if we are looking at the first gene, this for loop will fill in rows 1-5 in data.defb. If you are looking at the second gene, it fills in rows 6-10 and so on.
        for (j in (((col_use*i)-col_use)+1):(col_use*i)	) {
            data.defb[j,1] = gsn
            data.defb[j,2] = col_names[x]
            data.defb[j,3] = data.defa[i,x+1]
            x = x + 1
        }
    }
    
    #Add column names to the formatted table
    colnames(data.defb) <- c("gene", "group", "fpkm")
    
    #Export table as a .csv file
    write.csv(data.defb,file=csv.out, row.names = FALSE)
    
    #Make box plots and export them as a .pdf file
    data <- read.table(csv.out, header=TRUE, sep=",")
    library(ggplot2)
    pdf(file=pdf,paper="a4r")
    plot <- ggplot(data,aes(x=group,y=fpkm,fill=factor(group)))+
    geom_boxplot(color="black") +
    geom_point(aes(fill=factor(group)),color="black",shape=21,size=10/length(gene_names)) +
    facet_wrap(~ gene,scales="free_y",nrow=nrow) +
    theme(legend.position="none",
    axis.text.x=element_text(size=(22/length(gene_names)*2),face="bold",color="black",angle=45,vjust=1,hjust=1),
    axis.text.y=element_text(size=16,face="bold"),
    axis.title.y=element_text(size=22,face="bold",vjust=1.5),
    strip.text.x=element_text(size=20,face="bold")) +
    xlab("") + ylab("Normalized FPKM")
    print(plot)
    dev.off()
}

