setwd("J:\\project")
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)
library(C50)
library(ggplot2) # Loading library
library(dplyr)
US_visa<-read.csv("us_perm_visas.csv",stringsAsFactors = FALSE,strip.white = TRUE)# Loading data set
# Filtering Data based on status being "Certified" and calss of admission being "H1B"
na.omit(US_visa)# omitting nas
nrow(US_visa)
US_visa_2<-US_visa%>%filter(case_status=="Certified" & class_of_admission=="H-1B")%>% group_by(country_of_citzenship)%>%summarise(count=length(unique(case_no)))
# Ordering the data based on total H1B count (order=descending)
US_visa_2<-US_visa_2[order(US_visa_2$count,decreasing = TRUE),]
US_visa_2[1,c(1)]<-"Not Listed"#for some case no, countries were not listed
Us_visa_plot<-US_visa_2[c(1:11),]#top 12 countries
colnames(Us_visa_plot)<-c("Listed Country of Citizenship","Count of H-1B visas certified/accepted")
Us_visa_plot<-Us_visa_plot[-c(1),]
head(US_visa)
Company_listings<-US_visa%>%filter(case_status=="Certified" & class_of_admission=="H-1B")%>%group_by(employer_name)%>%summarise(count=length(unique(case_no)))
#Company1<-US_visa%>%filter(wage_offer_unit_of_pay_9089=="yr")%>%group_by(wage_offer_from_9089)%>%summarise(count=length(unique(case_no)))
#Company1 <- Company1[c(1:20),]

Company_listings<-Company_listings[order(Company_listings$count,decreasing = TRUE),]
Company_listings<-Company_listings[c(1:10),]
#suggesting appropriate column names
colnames(Company_listings)<-c("Names of major employers","Number of H-1B visas certified/accepted")
ggplot(Us_visa_plot,aes(`Listed Country of Citizenship`,`Count of H-1B visas certified/accepted`))+geom_col()+coord_flip()+ggtitle('                Country of citizenship vs H1B Visas')
ggplot(Company_listings,aes(`Names of major employers`,`Number of H-1B visas certified/accepted`))+geom_col(fill = 'dark red')+coord_flip()+ggtitle('           Major Employers vs H1B Visas')
ggplot(aes(`Names of States`,`Number of H-1B visas certified/accepted`))+geom_col(fill = 'Black')+coord_flip()+ggtitle('                   Major States vs H1B Visas')

prop.table(table(US_visa$case_status,US_visa$country_of_citizenship),1)
US_visa$case_status= as.factor(US_visa$case_status)
US_visa$case_status
fit <- C5.0(case_status~ class_of_admission+country_of_citizenship+employer_name,data=US_visa,rules=TRUE)
fit
summary(fit)

