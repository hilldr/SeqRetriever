
SeqANOVA <- function(df){
    library(matrixStats)

    group_names <- function(df){
        names <- unique(gsub("\\_[0-9]*$", "",colnames(df)[grep("gene", colnames(df),invert = TRUE)]))
        return(names)
    }
    
    get_matrices <- function(df){

        get_groups <- function(df){		
            list <- lapply(group_names(df),
                           function(x) {grep(x, colnames(df))})
            list[[length(list)+1]] <- grep("gene", colnames(df),invert = TRUE)
            return(list)
        }
        
        x <- get_groups(df)
        matrices <- sapply(x, function(x){df[,x]})
        return(matrices)
    }
    
    test <- get_matrices(df)
    test2 <- test[-length(test)]
    sst.1 <- lapply(test2, function(test2){rowSums((test2), na.rm = TRUE)})
    sst.2 <- lapply(test2, function(test2){rowSums((test2^2), na.rm = TRUE)})
    sst.1 <- data.frame(matrix(unlist(sst.1), nrow=unique(sapply(sst.1, length)), byrow=FALSE))
    sst.2 <- data.frame(matrix(unlist(sst.2), nrow=unique(sapply(sst.2, length)), byrow=FALSE))
    get_sst <- function(sst.1,sst.2, df){
        sst <- rowSums(sst.2) - (rowSums(sst.1)^2)/length(unique(colnames(df)[grep("gene", colnames(df),invert = TRUE)]))
        return(sst)
    }
    sst <- get_sst(sst.1,sst.2, df)
    ssa <- sum((sst.1^2)/unlist(lapply(test2, function(x) length(x)))) -  (rowSums(sst.1)^2)/length(unique(colnames(df)[grep("gene", colnames(df),invert = TRUE)]))
    ssw <- sst - ssa
                                        # https://people.richland.edu/james/lecture/m170/ch13-1wy.html
    fstat <- (ssa/(length(test2)-1))/(ssw/(length(unique(colnames(df)[grep("gene", colnames(df),invert = TRUE)]))-length(test2)))
                                        # correct to this point
                                        # http://web.mst.edu/~psyworld/anovaexample.htm
                                        # express f-statistic as p-value
    df$anova.p <- pf(fstat, length(test2)-1, (length(unique(colnames(df)[grep("gene", colnames(df),invert = TRUE)]))-length(test2)), lower.tail = FALSE)
    df$anova.p.adj <- p.adjust(df$anova.p, method = "BH", n = length(df$anova.p))
    return(df)
}
