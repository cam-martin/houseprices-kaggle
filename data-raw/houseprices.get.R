require(RCurl)

endpoint <- "https://extras.gabrielebaldassarre.com/datascience/kaggle/houseprices"
download.files <- c("train.csv", "test.csv")

houseprices.data <- getURL(unlist(lapply(download.files, function(x){
  URLencode(paste(endpoint, x, sep="/"))
})), ssl.verifypeer=FALSE)

houseprices.train <- read.csv(text = houseprices.data[1])
houseprices.test <- read.csv(text = houseprices.data[2])

### houseprices.train adjustments
houseprices.train$MSSubClass <- as.factor(houseprices.train$MSSubClass)
houseprices.train$OverallQual <- factor(houseprices.train$OverallQual, levels=c("*MISSING*","1","2","3","4","5","6","7","8","9","10"), ordered = TRUE)
houseprices.train$OverallCond <- factor(houseprices.train$OverallCond, levels=c("*MISSING*","1","2","3","4","5","6","7","8","9","10"), ordered = TRUE)

houseprices.train$ExterQual <- factor(houseprices.train$ExterQual, levels=rev(c("Ex","Gd","TA","Fa","Po","*MISSING*")), ordered=TRUE)
houseprices.train$ExterCond <- factor(houseprices.train$ExterCond, levels=rev(c("Ex","Gd","TA","Fa","Po","*MISSING*")), ordered=TRUE)

houseprices.train$BsmtQual <- factor(houseprices.train$BsmtQual, levels=rev(c("Ex","Gd","TA","Fa","Po","NA","*MISSING*")), ordered=TRUE)
houseprices.train$BsmtCond <- factor(houseprices.train$BsmtCond, levels=rev(c("Ex","Gd","TA","Fa","Po","NA","*MISSING*")), ordered=TRUE)
houseprices.train$BsmtExposure <- factor(houseprices.train$BsmtExposure, levels=rev(c("Gd","Av","Mn","No","NA","*MISSING*")), ordered=TRUE)
houseprices.train$BsmtFinType1 <- factor(houseprices.train$BsmtFinType1, levels=rev(c("GLQ","ALQ","BLQ","Rec","LwQ","Unf","NA","*MISSING*")), ordered=TRUE)
houseprices.train$BsmtFinType2 <- factor(houseprices.train$BsmtFinType2, levels=rev(c("GLQ","ALQ","BLQ","Rec","LwQ","Unf","NA","*MISSING*")), ordered=TRUE)

houseprices.train$HeatingQC <- factor(houseprices.train$HeatingQC, levels=rev(c("Ex","Gd","TA","Fa","Po","*MISSING*")), ordered=TRUE)
houseprices.train$KitchenQual <- factor(houseprices.train$KitchenQual, levels=rev(c("Ex","Gd","TA","Fa","Po","*MISSING*")), ordered=TRUE)
houseprices.train$FireplaceQu <- factor(houseprices.train$FireplaceQu, levels=rev(c("Ex","Gd","TA","Fa","Po","NA","*MISSING*")), ordered=TRUE)

houseprices.train$GarageQual <- factor(houseprices.train$GarageQual, levels=rev(c("Ex","Gd","TA","Fa","Po","NA","*MISSING*")), ordered=TRUE)
houseprices.train$GarageCond <- factor(houseprices.train$GarageQual, levels=rev(c("Ex","Gd","TA","Fa","Po","NA","*MISSING*")), ordered=TRUE)

houseprices.train$PoolQC <- factor(houseprices.train$PoolQC, levels=rev(c("Ex","Gd","TA","Fa","NA","*MISSING*")), ordered=TRUE)
houseprices.train$Fence <- factor(houseprices.train$Fence, levels=rev(c("GdPrv","MnPrv","GdWo","MnWw","NA","*MISSING*")), ordered=TRUE)

houseprices.train$Alley <- factor(houseprices.train$Alley, levels=c("Grvl", "Pane", "*MISSING*"))
houseprices.train$MasVnrType <- factor(houseprices.train$MasVnrType, levels=c("BrkCmn", "BrkFace", "None", "Stone", "*MISSING*"))
houseprices.train$Electrical <- factor(houseprices.train$Electrical, levels=c("FuseA", "FuseF", "FuseP", "Mix","SBrkr", "*MISSING*"))
houseprices.train$GarageType <- factor(houseprices.train$GarageType, levels=c("2Types", "Attchd", "Basment", "BuiltIn","CarPort", "Detchd", "*MISSING*"))
houseprices.train$GarageFinish <- factor(houseprices.train$GarageFinish, levels=c("RFn", "Unf", "Fin", "*MISSING*"))
houseprices.train$MiscFeature <- factor(houseprices.train$MiscFeature, levels=c("Gar2", "Othr", "Shed", "*MISSING*"))


#YearBuilt
#YearRemodAdd
#MoSold
#YrSold

### houseprices.test adjustments
houseprices.test$MSSubClass <- as.factor(houseprices.test$MSSubClass)
houseprices.test$OverallQual <- factor(houseprices.test$OverallQual, levels=c("1","2","3","4","5","6","7","8","9","10"), ordered = TRUE)
houseprices.test$OverallCond <- factor(houseprices.test$OverallCond, levels=c("1","2","3","4","5","6","7","8","9","10"), ordered = TRUE)

houseprices.test$ExterQual <- factor(houseprices.test$ExterQual, levels=rev(c("Ex","Gd","TA","Fa","Po")), ordered=TRUE)
houseprices.test$ExterCond <- factor(houseprices.test$ExterCond, levels=rev(c("Ex","Gd","TA","Fa","Po")), ordered=TRUE)

houseprices.test$BsmtQual <- factor(houseprices.test$BsmtQual, levels=rev(c("Ex","Gd","TA","Fa","Po","NA")), ordered=TRUE)
houseprices.test$BsmtCond <- factor(houseprices.test$BsmtCond, levels=rev(c("Ex","Gd","TA","Fa","Po","NA")), ordered=TRUE)
houseprices.test$BsmtExposure <- factor(houseprices.test$BsmtExposure, levels=rev(c("Gd","Av","Mn","No","NA")), ordered=TRUE)
houseprices.test$BsmtFinType1 <- factor(houseprices.test$BsmtFinType1, levels=rev(c("GLQ","ALQ","BLQ","Rec","LwQ","Unf","NA")), ordered=TRUE)
houseprices.test$BsmtFinType2 <- factor(houseprices.test$BsmtFinType2, levels=rev(c("GLQ","ALQ","BLQ","Rec","LwQ","Unf","NA")), ordered=TRUE)

houseprices.test$HeatingQC <- factor(houseprices.test$HeatingQC, levels=rev(c("Ex","Gd","TA","Fa","Po")), ordered=TRUE)
houseprices.test$KitchenQual <- factor(houseprices.test$KitchenQual, levels=rev(c("Ex","Gd","TA","Fa","Po")), ordered=TRUE)
houseprices.test$FireplaceQu <- factor(houseprices.test$FireplaceQu, levels=rev(c("Ex","Gd","TA","Fa","Po","NA")), ordered=TRUE)

houseprices.test$GarageQual <- factor(houseprices.test$GarageQual, levels=rev(c("Ex","Gd","TA","Fa","Po","NA")), ordered=TRUE)
houseprices.test$GarageCond <- factor(houseprices.test$GarageQual, levels=rev(c("Ex","Gd","TA","Fa","Po","NA")), ordered=TRUE)

houseprices.test$PoolQC <- factor(houseprices.test$PoolQC, levels=rev(c("Ex","Gd","TA","Fa","NA")), ordered=TRUE)
houseprices.test$Fence <- factor(houseprices.test$Fence, levels=rev(c("GdPrv","MnPrv","GdWo","MnWw","NA")), ordered=TRUE)

#YearBuilt
#YearRemodAdd
#MoSold
#YrSold

rm(endpoint, download.files, houseprices.data)

db <- dbConnect(SQLite(), dbname="inst/Tableau/houseprices.sqlite")

dbWriteTable(db, "housepricesTrain", houseprices.train)
dbWriteTable(db, "housepricesTest", houseprices.test)

dbDisconnect(db)

