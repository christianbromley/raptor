#' Coefficients for 4 predictors of immunotherapy benefit
#'
#' The coefficents required to generate the 4 probability of response scores.
#'
#' @format A list of 4 named numeric vectors.
#' \describe{
#'  \item{coefficients}{Numeric values giving the weight of each gene within each signature}
#'
#' }
#' @source
"coefficients"

#' Constants for 4 predictors of immunotherapy benefit
#'
#' The constants required to generate the 4 probability of response scores.
#'
#' @format A list of 4 named numeric vectors.
#' \describe{
#'  \item{constant_list}{Numeric values giving the weight of each gene within each signature}
#'
#' }
#' @source
"constant_list"

#' Proportions of response/non-response to stratify based on 4 predictors of immunotherapy benefit
#'
#' The proportions of responders/NRs required to stratify based on the 4 probability of response scores.
#'
#' @format A list of 4 named numeric vectors.
#' \describe{
#'  \item{constant_list}{Numeric values giving the weight of each gene within each signature}
#'
#' }
#' @source
"proportions"

#' Cut-off values of predictor scores based on log2(TPM+1) gene expression data. Should not be used for expression data using other normalisation methods.
#'
#'
#'
#' @format A list of 4 numeric values.
#' \describe{
#'  \item{log2tpmplusone_cutoffs}{Numeric values giving the cutoff to define high vs low probability of response groups}
#'
#' }
#' @source
"log2tpmplusone_cutoffs"
