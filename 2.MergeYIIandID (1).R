# Merge ID information with YII values from IPAM_ImportFunction

# 4. Get and save the YII data as a data frame 
#source() R must accept input from the file
#so we have just created a function that this script is then sourcing from?
  source("1.IPAM_ImportFunction.R")
  YII<-Import_YII("Data")

# 5. Get and save the ID info as a data frame  
  ID_AOI<-read.csv("ID_AOI.csv")
  ID_AOI$variable<-paste("Y.II.",ID_AOI$AOI, sep = "")

# 6. Merge YII and sample inf and check for missing data (Optional)
  YII.data<-plyr::join(ID_AOI, YII, by =c("Date", "File", "variable"), type="inner")

# 7. Check for missing data (Optional)
  ErrorI<-dplyr::anti_join(ID_AOI, YII, by =c("Date", "File", "variable"))
  ErrorII<-dplyr::anti_join(YII, ID_AOI, by =c("Date", "File", "variable"))

# 8. Get rid of file info and rename columns  
  head(YII.data)
  YII.Tall<-dplyr::select(YII.data, Time, Date, Treatment, Genotype, Fragment, Tank, Aquaria, value)
  colnames(YII.Tall) <- c("Time","Date","Treatment","Genotype", "Fragment", "Tank", "Aquaria", "YII")

# 9. Wide formating 
  # Check duplicated data
  YII.Tall$Sample<-paste(YII.Tall$Date, YII.Tall$Fragment, sep='_') 
  Duplicated <- YII.Tall[duplicated(YII.Tall$Sample),] 
  
  YII.Wide<- reshape(YII.Tall, idvar = "Fragment", timevar = "Time", direction = "wide")
  
# 10. Save the data 
  #saveRDS(YII.Tall, "Data/YII.Tall.rds")
  #saveRDS(YII.Wide, "Data/YII.Wide.rds")
  #write.csv(YII.Wide, "Data/YII_wide.csv")
  write.csv(YII.Tall, "Data/YII_tall.csv")# Add date to keep versions
  
