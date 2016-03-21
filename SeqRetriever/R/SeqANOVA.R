
SeqANOVA <- function(df){
    library(matrixStats)
                                        # Get the unique group names
    group_names <- function(df){
        names <- unique(gsub("\\_[0-9]*$", "",colnames(df)[grep("gene|.p", colnames(df),invert = TRUE)]))
        return(names)
    }
                                        # Get the total samples, N
    get_n <- function(df){
        n <- length(unique(colnames(df)[grep("gene|.p", colnames(df),invert = TRUE)]))
        return(n)
    }
    
    get_matrices <- function(df){

        get_groups <- function(df){		
            list <- lapply(group_names(df),
                           function(x) {grep(x, colnames(df))})
            list[[length(list)+1]] <- grep("gene|.p", colnames(df),invert = TRUE)
            return(list)
        }
        
        x <- get_groups(df)
        matrices <- sapply(x, function(x){df[,x]})
        return(matrices)
    }
    
    mats <- get_matrices(df)[-length(get_matrices(df))]
    sst.1 <- lapply(mats,
                    function(mats){rowSums((mats), na.rm = TRUE)})
    sst.2 <- lapply(mats,
                    function(mats){rowSums((mats^2), na.rm = TRUE)})
    sst.1 <- data.frame(matrix(unlist(sst.1),
                               nrow = unique(sapply(sst.1, length)),
                               byrow = FALSE))
    sst.2 <- data.frame(matrix(unlist(sst.2),
                               nrow = unique(sapply(sst.2, length)),
                               byrow = FALSE))
    
    get_sst <- function(sst.1,sst.2, df){
        sst <- rowSums(sst.2) - (rowSums(sst.1)^2)/get_n(df)
        return(sst)
    }
    
    sst <- get_sst(sst.1,sst.2, df)
    ssa <- rowSums((sst.1^2)/unlist(lapply(mats, function(x) length(x)))) -  (rowSums(sst.1)^2)/get_n(df)
    
    ssw <- sst - ssa
                                        # https://people.richland.edu/james/lecture/m170/ch13-1wy.html
    fstat <- (ssa/(length(mats)-1))/(ssw/(get_n(df)-length(mats)))
                                        # correct to this point
                                        # http://web.mst.edu/~psyworld/anovaexample.htm
                                        # express f-statistic as p-value
    df$anova.p <- pf(q = fstat,
                     df1 = length(mats)-1,
                     df2 = (get_n(df)-length(mats)), lower.tail = FALSE)
    
    df$anova.p.adj <- p.adjust(df$anova.p,
                               method = "BH",
                               n = length(df$anova.p))
    return(df)
}
