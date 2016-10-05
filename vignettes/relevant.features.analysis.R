# In this script we're going to perform a relevant feature extraction and analysis
# using the popular Boruta package

invisible(lapply(c("caret", "Boruta", "plyr", "dtplyr", "pROC"), function(pkg){
  if(! require(pkg, character.only = TRUE)) install.packages(pkg, depend = TRUE)
  library(pkg, character.only = TRUE, logical.return = TRUE)
}))

data("houseprices.train")

houseprices.id <- "Id"
houseprices.target <- "SalePrice"

houseprices.candidates <- setdiff(names(houseprices.train),c(houseprices.id,houseprices.target))

data.classes <- sapply(houseprices.candidates,function(x){do.call(paste0, as.list(class(houseprices.train[[x]])))})

# Categorize by data type
#
# This is proven very useful to undestand how the data is structured
#
unique.classes <- unique(data.classes)

attr.data.types <- lapply(unique.classes,function(x){names(data.classes[data.classes==x])})
names(attr.data.types) <- unique.classes

# Prepare data for Boruta

response <- houseprices.train$SalePrice

# remove identifier and response variables
sample.df <- houseprices.train[houseprices.candidates]

# Recode missings in placeholder values

sample.df <- data.frame(
  do.call(cbind,lapply(attr.data.types$integer, function(x){
    s <- sample.df
    s[[x]][is.na(s[[x]])] <- -1
    return(s[x])
  })),
  do.call(cbind,lapply(attr.data.types$factor, function(x){
    s <- sample.df
    s[[x]][is.na(s[[x]])] <- "*MISSING*"
    return(s[x])
  })),
  do.call(cbind,lapply(attr.data.types$orderedfactor, function(x){
    s <- sample.df
    s[[x]][is.na(s[[x]])] <- "*MISSING*"
    return(s[x])
  })),
  stringsAsFactors = FALSE)

# Is the dataset complete?
# Boruta cannot run if there're NA in the input data!
apply(sample.df, 2, function(x) any(is.na(x)))


# Boruta analysis
set.seed(13)
bor.results <- Boruta(sample.df,response,
                      maxRuns=101,
                      doTrace=0)

plot(bor.results)

arrange(cbind(attr=rownames(attStats(bor.results)), attStats(bor.results)),desc(medianImp))
