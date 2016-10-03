require(RCurl)

endpoint <- "https://extras.gabrielebaldassarre.com/datascience/kaggle/houseprices"
download.files <- c("train.csv", "test.csv")

houseprices.data <- getURL(unlist(lapply(download.files, function(x){
  URLencode(paste(endpoint, x, sep="/"))
})), ssl.verifypeer=FALSE)

houseprices.train <- read.csv(text = houseprices.data[1])
houseprices.test <- read.csv(text = houseprices.data[2])

rm(endpoint, download.files, houseprices.data)
