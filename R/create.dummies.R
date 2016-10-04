#' Decode dummy variables
#'
#' This function will create the dummy variables for the given col.
#'
#' @param dataset the original dataset
#' @param col character the variable to decode
#' @param drop logical TRUE to drop the original column
#'
#' @importFrom splitstackshape cSplit_e
#' @importFrom dplyr select
#'
#' @export
create.dummies <- function(dataset, col, drop = TRUE){
  
  dataset.dummy <- cSplit_e(dataset, col, type="character", fill = 0, drop = drop)
  
  colnames(dataset.dummy) <- gsub(" ", "", colnames(dataset.dummy))
  colnames(dataset.dummy) <- gsub("/", "-", colnames(dataset.dummy))
  colnames(dataset.dummy) <- gsub("_", ".", colnames(dataset.dummy))
  
  return(dataset.dummy)
  
}