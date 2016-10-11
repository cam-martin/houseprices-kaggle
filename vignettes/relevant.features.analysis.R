# In this script we're going to perform a relevant feature extraction and analysis
# using the popular Boruta package

invisible(lapply(c("caret", "Boruta", "plyr", "dtplyr", "pROC", "rpart", "effects"), function(pkg){
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

###########################
# Prepare data for Boruta #
###########################

response <- houseprices.train$SalePrice


sample.df <- houseprices.train[houseprices.candidates]

###########################
# IMPUTING MISSING VALUES #
###########################

# Electrical
electrical.train <- sample.df[!is.na(sample.df$Electrical),]
electrical.test <- sample.df[is.na(sample.df$Electrical),]

electrical.fit <-  rpart(Electrical ~ ., method="class", data=electrical.train)

electrical.test$Electrical <- predict(electrical.fit, newdata=electrical.test, type="class")

sample.df <- rbind(electrical.train, electrical.test)

# LotFrontage
lotfrontage.train <- sample.df[!is.na(sample.df$LotFrontage) & (sample.df$LotConfig=="Corner"),]
lotfrontage.test <- sample.df[is.na(sample.df$LotFrontage) & (sample.df$LotConfig=="Corner"),]
lotfrontage.else <- sample.df[sample.df$LotConfig!="Corner",]

lotfrontage.formula <- LotFrontage ~ MSSubClass + 
  LotArea + 
  LotShape + 
  LandContour + 
  Neighborhood +
  Condition1 +
  GrLivArea +
  TotRmsAbvGrd +
  GarageType +
  GarageArea +
  Condition1 +
  OverallQual


# TODO: cross-validation

lotfrontage.fit <- lm(lotfrontage.formula, lotfrontage.train, na.action=na.exclude)

lotfrontage.test$LotFrontage <- predict(lotfrontage.fit, newdata=lotfrontage.test)

plot(allEffects(lotfrontage.fit))

sample.df <- rbind(lotfrontage.train, lotfrontage.test, lotfrontage.else)



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
