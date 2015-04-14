rm(list = ls())

files <- list.files(path = "data/",full.names = TRUE)
vowel <- c("a","e","i","o","u")



for (i in 1:length(files)){
  data <- read.csv(files[i])
  names(data) <- c("trial","start","end","phon")
  
  new_data <- (data$end - data$start)/10e6
  new_data <- data.frame(data,new_data)
  names(new_data) <- c(names(data),"diff")
  data <- new_data  
  
  c_i <- order(data$trial,decreasing=FALSE)
  data <- data[c_i,]
  
  for (j in 1:length(vowel)){
    stat_mean <- NULL
    stat_std <- NULL
    stat_no <- NULL
    dur = subset(data,data$phon == vowel[j])
    t_5 <- subset(dur, grepl(paste('005', collapse= "|"), dur$trial))
    t_6 <- subset(dur, grepl(paste('006', collapse= "|"), dur$trial))
    t_7 <- subset(dur, grepl(paste('007', collapse= "|"), dur$trial))  
    t_8 <- subset(dur, grepl(paste('008', collapse= "|"), dur$trial))
    
    stat_mean <- c(stat_mean,mean(t_5$diff),mean(t_6$diff),mean(t_7$diff),mean(t_8$diff))  
    stat_std <- c(stat_std,sd(t_5$diff),sd(t_6$diff),sd(t_7$diff),sd(t_8$diff))
    stat_no <- c(stat_no,length(t_5$diff),length(t_6$diff),length(t_7$diff),length(t_8$diff))
    
    name <- files[i]
    name <- gsub(".csv", "", name)
    name <- gsub("data/", "", name)
    name <- paste("output/",name,"_",vowel[j],sep='')
    
    write.table(data.frame(stat_mean,stat_std,stat_no), name, sep=",",row.names=FALSE, col.names=c("mean","std","No"),quote = FALSE) 
    
  } 
  
}
