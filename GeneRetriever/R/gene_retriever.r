#' GeneRetriever
#'
#' This function formats cuffdiff format gene expression data into a table and plot the data as box plots or heatmaps to provide a easy to read visual representation of the data.
## DATE: 6/2/15
## AUTHOR: Shrikar Thodla and David Hill
#' param gene_names This first argument is a vector of gene names (as string),
#' param nrow The number of rows in boxplot array
#' @export
#' @examples
#' gene_retriever()

gene_retriever <- function(gene_names,nrow=3, dir= "./",csv.out="output.csv",gr_name= "gr_output.pdf", w=8, h=11, pdf=TRUE, heatmap=0, hw=15, hh=15) {
    
    #Read in data from genes.count_table file
    #wd_cound is the string that results from concatenating the directory location and file name
    dir_count <- paste(dir,"/genes.count_table", sep="")
    data1 <- read.table(dir_count,header=TRUE,sep="\t")
    #Set 1st column to NULL because it is not needed, effectively deletes the column
    data1$tracking_id <- NULL
    #Read in data from genes.attr_table file
    dir_attr <- paste(dir,"/genes.attr_table", sep="")
    attr.table <- read.table(dir_attr,header=TRUE, sep="\t")
    #Bind the gene_short_name column from the attr.table to data1, this will put the gene_short_name column as the first column in data1
    data1 <- cbind(attr.table$gene_short_name, data1)
    colnames(data1)[1] <- "gene_short_name"
    
    #Start making the table that will contain the gene expression data of the gene given to the function. Start with the first gene in the vector
    data_sub <- subset(data1, data1[,1] == gene_names[1])
    
    #Get the length of the vector containing gene names to use in a for loop
    len_gen_names = length(gene_names)
    
    #Use a for loop that starts at 2 (because we already got the data for the first gene in the vector) and goes till the end of the vector
    for (i in 2:len_gen_names) {
        #For each gene, get the data from the .txt file using the subset function and then use rbind to add the data from the nth gene to the table for the first gene
        data.gene <- subset(data1, data1[,1] == gene_names[i])
        data_sub <- rbind(data_sub, data.gene)
    }
    #Convert the gene_short_name column into strings
    data_sub[,1] <- sapply(data_sub[,1], as.character)
    #Number of rows in data_sub is how many genes there are in actuality. Variable gene_names may contain mispelled genes or genes that are not found in the specific data set.
    new_len_gen <- nrow(data_sub)
    #If there is a difference in length between the amount of genes subsetted and the amount of genes given, then print out the genes that were not subsetted and update variables
    if (new_len_gen != len_gen_names) {
        #new_gene_names contains all the genes that were subsetted
        new_gene_names <- data_sub$gene_short_name
        #Go through each gene in the gene_names variable and see which one(s) is/are missing
        for (z in 1:len_gen_names) {
            if (!(gene_names[z] %in% new_gene_names)) {
                error <- paste(gene_names[z], "was not found or was misspelled", sep = " ")
                print(error)
            }
        }
        #Update variables
        gene_names = new_gene_names
        len_gen_names = new_len_gen
    }
    #Export subsetted data as a .csv file
    write.csv(data_sub,file=csv.out, row.names = FALSE)
    #data.defa will have multiple different columns, but the first column is just gene names, which we don't care about. That's why we subtract 1 from the number of columns in data.defa
    col_use = ncol(data_sub) - 1
    #Make a table with 3 columns and (len_gen_names * col_use) rows (data from each column in data.defa will be a new row in data.defb for each gene
    data_for <- data.frame(matrix(nrow = (len_gen_names * col_use), ncol = 3))
    #Make a vector with the column names of data.defa, will be used later to fill in data.defb
    col_names <- c(colnames(data_sub))
    #Remove the first elements of col_names because it is just a columns containing names
    col_names <- col_names[-1]
    ### REMOVE LAST 2 CHARACTERS from col_names (convert sample_# to sample aka group)
    col_names <- gsub('.{2}$','',col_names)
    
    #For loop to fill in data for each gene
    for (i in 1:len_gen_names) {
        #Get the name of the gene, will be used to fill in data.defb
        gsn <- data_sub[i,1]
        #x is a index to access the col_names vector and the fpkm data from data.defa
        x = 1
        #The outer for loop iterates once for each gene that is being analyzed. The inner for loop (below) iterates enough times to fill in all the rows needed for a gene. For example if there are 5 different experession data groups, then each gene needs 5 rows, one for each group. Continuing with 5 group example, if we are looking at the first gene, this for loop will fill in rows 1-5 in data.defb. If you are looking at the second gene, it fills in rows 6-10 and so on.
        for (j in (((col_use*i)-col_use)+1):(col_use*i)	) {
            data_for[j,1] = gsn
            data_for[j,2] = col_names[x]
            data_for[j,3] = data_sub[i,x+1]
            x = x + 1
        }
    }
    #Add column names to the formatted table
    colnames(data_for) <- c("gene", "group", "fpkm")
    #Make box plots and export them as a .pdf or .png file
    library(ggplot2)
    if (pdf == TRUE) {
        #Export file is a pdf file
        pdf(file=gr_name,height=h, width=w)
    }
    else {
        #Export file is a png file
        png(file=gr_name, width=w, height=h, units="in", res=144)
    }
    plot <- ggplot(data_for,aes(x=group,y=fpkm,fill=factor(group)))+
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
    if (heatmap != 0) {
        library(pheatmap)
        library(RColorBrewer)
        #Need matrix. So first make rownames the names of the genes
        rownames(data_sub) <- gene_names
        #Next get rid of the gene_short_name column
        data_sub$gene_short_name <- NULL
        png(file=heatmap, width=w, height=h, units="in", res=144)
        # subset dataframe 'data.1' to rows in which standard deviation is not equal to 0, ignoring NA values
        data_sub2 <- data_sub[apply(data_sub, 1, sd, na.rm=TRUE) != 0,]
        heat<-pheatmap(data_sub2,scale="row",clustering_method="average",color=colorRampPalette(rev(brewer.pal(n = 7, name ="RdYlBu")))(300),main="Gene Retriever Heatmap",border_color="black",cellwidth=hw,cellheight=hh,show_rownames=TRUE,fontsize=12,filename=heatmap)
        print(heat)
    }
    dev.off()
}







