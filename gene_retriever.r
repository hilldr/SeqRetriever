## DATE: 6/2/15
## AUTHOR: Shrikar Thodla
## PURPOSE: To format gene expression data in a table and plot the data as box plots to provide a easy to read visual representation of the data.
#
#
#Function name is gene_analysis and it takes 2 arguments (can add more). One argument is a vector of gene names (as strings) and the other is how many rows should be shown in the .pdf file
gene_analyzer <- function(gene_names,nrow=3, input_file, output_csv, output_pdf) {

    #Read in data from .txt file
	data1 <- read.table(input_file,header=TRUE,sep="\t")
        
    #Start making the table that will contain the gene expression data of the gene given to the function. Start with the first gene in the vector
	data.defa <- subset(data1, data1$gene_short_name == gene_names[1])
        
    #Get the length of the vector containing gene names to use in a for loop
	len_gen_names = length(gene_names)
        
    #Use a for loop that starts at 2 (because we already got the data for the first gene in the vector) and goes till the end of the vector
	for (i in 2:len_gen_names) {
    #For each gene, get the data from the .txt file using the subset function and then use rbind to add the data from the nth gene to the table for the first gene
		data.gene <- subset(data1, data1$gene_short_name == gene_names[i])
		data.defa <- rbind(data.defa, data.gene)
	}
    
    col_use = ncol(data.defa) - 2

    #Make a table with 3 columns and 6 rows for each gene
	data.defb <- matrix(nrow = len_gen_names * (col_use), ncol = 3)
        
    #Convert the gene_short_name column into strings
	data.defa[,2] <- sapply(data.defa[, 2], as.character)
    col_names <- c(colnames(data.defa))
    
    #For loop to fill in data for each gene
	for (i in 1:len_gen_names) {
		gsn <- data.defa[i,2]
        x = 1
    	for (j in ((col_use*i)-col_use+1):(col_use*i)	) {
    		data.defb[j,1] = gsn
    		data.defb[j,2] = col_names[x]
    		data.defb[j,3] = data.defa[i,x+2]
            x = x + 1
    	}
	}
        
    #Add column names to the formatted table
	colnames(data.defb) <- c("gene", "group", "fpkm")
        
    #Export table as a .csv file
	write.csv(data.defb,file=output_csv, row.names = FALSE)
        
    #Make box plots and export them as a .pdf file
	data <- read.table(output_csv, header=TRUE, sep=",")
	library(ggplot2)
	pdf(file=output_pdf,width=8,height=8)
	plot <- ggplot(data,aes(x=group,y=fpkm,fill=factor(group)))+
            geom_boxplot(color="black") +
            geom_point(aes(fill=factor(group)),color="black",shape=21,size=10) +
            facet_wrap(~ gene,scales="free_y",nrow=nrow) +
            theme(legend.position="none",
                  axis.text.x=element_text(size=22,face="bold",color="black"),
                  axis.text.y=element_text(size=16,face="bold"),
                  axis.title.y=element_text(size=22,face="bold",vjust=1.5),
                  strip.text.x=element_text(size=20,face="bold")) +
	    xlab("") + ylab("Normalized FPKM")
	print(plot)
	dev.off()
}
