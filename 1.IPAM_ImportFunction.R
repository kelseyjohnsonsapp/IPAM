setwd("/Users/kelseyjohnson-sapp/Desktop/RSMAS/Projects/LMR/Acerv/IPAM/Acerv/08_22_2019/Data")

Import_YII<- function (dir)  {
  
# 1. Read all the .csv files (; delimited) and consolidate them in a single data frame
  # dir: folder containing the .csv files. The data in the dir can be separated in subfolders, 
  # recursive = TRUE will find the .csv files inside the subfolders
  # You can use the subfolders names to later extract information with the option full.names=TRUE
  
  IPAM.data<-plyr::ldply (list.files(path=dir, pattern="*.csv", 
                                full.names=TRUE, recursive = TRUE),
                     function(filename) {
                       dum=(read.csv(filename, sep = ";", blank.lines.skip=T))
                       dum$filename=filename
                       return(dum)
                     })  
      
# 2. Select the columns that contain the file path and the YII values (remove F0 and Fm values)
  YII.data<-IPAM.data[,grep("filename|Y.II.", names(IPAM.data))]
  
  # Change to long format
  YII.data <- na.omit(reshape2::melt(IPAM.data, id=c("filename")))
  
# 3.separate folder and file information contained in "filename"
  # In this example each subfolder correspond to different dates, but it could be treatments, locations...
  # Followed for the specific file name
  
  file.picture <- plyr::rbind.fill(lapply(strsplit(as.character(IPAM.data$filename), split="/"), 
                                    function(X) data.frame(t(X))))
  colnames(file.picture) <- c("Folder", "Date", "File")
  
  YII <- cbind(file.picture[,-1], IPAM.data[,-1])
  return(YII)
  
}
Import_YII
