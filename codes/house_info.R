library("doBy")
library("tmcn")
library("ggplot2")
library("Rwordseg")
library("wordcloud2")

#��ȡ��������
house_info<-read.csv("temp.csv",header = T) 

#�������ݸ�ʽ
house_info$built_time<-as.factor(apply(house_info["built_time"],1,function(x) substr(x,1,4)))
house_info$price<-as.numeric(apply(house_info["price"],1,function(x) substr(x,1,nchar(x)-4)))
house_info$square<-as.numeric(apply(house_info["square"],1,function(x) substr(x,1,nchar(x)-1)))
house_info$location<-as.factor(apply(house_info["location"],1,function(x) substr(x,1,3)))
house_info$stair1<-as.factor(apply(house_info["stair"],1,function(x) substr(x,1,3)))
house_info$stair2<-as.factor(apply(house_info["stair"],1,function(x) substr(x,7,nchar(x)-2)))
house_info$style1<-as.factor(apply(house_info["style"],1,function(x) substr(x,1,4)))
#��id��link�ֶ�ɾ��
drops<-names(house_info) %in% c("id","link","lift","right","decorate","stair")
house_info<-house_info[!drops] 

#�Ƚ�ÿ�������۷��������������ӻ�չʾ
table(house_info$location)
plot(house_info$location)
#�Ƚ�ÿ�ֻ������۷��������������ӻ�չʾ
table(house_info$style1)
plot(house_info$style1)
#�Ƚ�ÿ��¥�����۷��������������ӻ�չʾ
table(house_info$stair1)
plot(house_info$stair1)

#�������ÿ�������ݾ��۲����ӻ�չʾ
mean_price<-summaryBy(price~location,data = house_info,FUN = mean)
bar=barplot(mean_price[,2],names.arg = mean_price[,1],main="���ڸ������۱Ƚ�",col=rainbow())
text(bar,mean_price[,2],labels = round(mean_price[,2]),adj = c(0.5,1))
summaryBy(price~location+stair1,data = house_info,FUN = mean)

#�ھ�С��������Ϣ
community<-as.vector(house_info$name)
thewords <-unlist(Rwordseg::segmentCN(community,nature=T))  
invalid_words <-c("һ��","����","����","����","����")
insertWords(c("����","����","��Ծͤ"))
theflags<-thewords %in% invalid_words
thewords<-thewords[!theflags]
word_freq<-createWordFreq(thewords)
#����ǰ200�����ִ��������ֵĴ���
#wordcloud2(word_freq[1:200,],size = 1.5)
#����6��200�����ִ��������ֵĴ���
#wordcloud2(word_freq[6:200,],size = 0.35)



