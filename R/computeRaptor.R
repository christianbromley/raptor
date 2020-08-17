#'
#' Get a gene expression matrix with genes as colnames, and samples as rownames.
#'
#' This function will score the likelihood of patient response to immune checkpoint blockade based on 4 different pipelines.
#' 1. RAPTOR - based on a set of immune genes
#' 2. COXIS - based on a 25-gene set defined by Bonavtia et al., in review
#' 3. TIS - based on an 18 gene signature from Ayers et al., JCI, 2017
#' 4. Random - a random set of genes to which identical steps were applied as for the other pipelines
#'
#'If more than 50% of variables are missing then the exercise should be halted
#'
#' @param expr a data frame of gene expression data with genes as column names and samples as rownames.
#' Ideally expression will be in log2(TPM+1) format. The data frame should also include columns for the MSKCC prognostic score
#' if the data is from renal cancer patients (column name = "mskcc").
#' @param coefs a named numeric vector of gene weights.
#' @param predictor_name the name of the probability of response score estimator, for example "RAPTOR"
#' @param constant a constant to add to the scores. We will use the minimum value of the sum of the weighted gene expressions
#' in the training data multiplied by -1 if less than 0.
#' @return dataframe with sample as rowname and column as predictor score
#' @export


compute_risk_score <- function(expr,coefs, predictor_name, constant){

  #get names of columns to score
  vars <- names(coefs)
  expr2 <- expr[,colnames(expr) %in% vars]


  #which genes are missing? and keep those that match
  missing_genes <- setdiff(vars, colnames(expr))
  if(length(missing_genes) > 0){
    print(paste(missing_genes, "is missing", sep=" "))
  }
  if(length(missing_genes) > ((length(vars)/2)*100)){
    stop("greater than 50% of variables are missing from the data")
  }

  vars <- intersect(vars, colnames(expr))

  #align the coefs and the data matrix
  coefs <- coefs[which(names(coefs) %in% vars)]
  coefs <- coefs[match(colnames(expr2), names(coefs))]

  #normalise by the coefficients, and add on the constant
  expr2 <- t(expr2)
  expr2 <- expr2 * coefs
  scores <- colSums(expr2) + constant


  #save the output
  df <- as.data.frame(scores)
  rownames(df) <- colnames(expr2)
  colnames(df)[ncol(df)] <- predictor_name
  return(df)

}

#' score4models is a wrapper for the compute_risk_score function enabling it to be run over all 4 of the models
#' @param expr a data frame of gene expression data with genes as column names and samples as rownames.
#' Ideally expression will be in log2(TPM+1) format. The data frame should also include columns for the MSKCC prognostic score
#' if the data is from renal cancer patients (column name = "mskcc").
#' @return dataframe with variables sample name and a column for each predictor method, with the continuous variable, the stratifier based on log2tpm expression data cutoff, and a stratifier based on the proportion of high/low patients in training.
#' @export

score4models <- function(expr){

  results <- data.frame(Pt = rownames(expr))
  for(i in 1:length(coefficients)){
    coef <- coefficients[[i]]
    const <- constant_list[[i]]
    nam <- names(coefficients)[i]
    cutoff <- log2tpmplusone_cutoffs[[i]]
    prop_cutoff <- proportions[[i]]

    score <- compute_risk_score(expr,
                                       coefs = coef,
                                       constant = const,
                                       predictor_name = nam)

    score[,ncol(score)+1] <- ifelse(score[,1] > cutoff, "High", "Low")
    names(score)[ncol(score)+1] <- paste(nam, "_tpm.cut")

    score[,ncol(score)+1] <- ifelse(score[,1] > quantile(score[,1], probs = prop_cutoff), "High", "Low")
    names(score)[ncol(score)+1] <- paste(nam, "_proportion.cut")

    results <- merge(results,score,by.x="Pt",by.y="row.names")
  }
  return(results)
}





