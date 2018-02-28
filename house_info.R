library("doBy")
library("tmcn")
library("ggplot2")
library("Rwordseg")
library("wordcloud2")

#读取房屋数据
house_info<-read.csv("temp.csv",header = T) 

#整理数据格式
house_info$built_time<-as.factor(apply(house_info["built_time"],1,function(x) substr(x,1,4)))
house_info$price<-as.numeric(apply(house_info["price"],1,function(x) substr(x,1,nchar(x)-4)))
house_info$square<-as.numeric(apply(house_info["square"],1,function(x) substr(x,1,nchar(x)-1)))
house_info$location<-as.factor(apply(house_info["location"],1,function(x) substr(x,1,3)))
house_info$stair1<-as.factor(apply(house_info["stair"],1,function(x) substr(x,1,3)))
house_info$stair2<-as.factor(apply(house_info["stair"],1,function(x) substr(x,7,nchar(x)-2)))
house_info$style1<-as.factor(apply(house_info["style"],1,function(x) substr(x,1,4)))
#将id、link字段删掉
drops<-names(house_info) %in% c("id","link","lift","right","decorate","stair")
house_info<-house_info[!drops] 

#比较每个区在售房屋数量，并可视化展示
table(house_info$location)
plot(house_info$location)
#比较每种户型在售房屋数量，并可视化展示
table(house_info$style1)
plot(house_info$style1)
#比较每种楼层在售房屋数量，并可视化展示
table(house_info$stair1)
plot(house_info$stair1)

#分类汇总每个区房屋均价并可视化展示
mean_price<-summaryBy(price~location,data = house_info,FUN = mean)
bar=barplot(mean_price[,2],names.arg = mean_price[,1],main="深圳各区房价比较",col=rainbow())
text(bar,mean_price[,2],labels = round(mean_price[,2]),adj = c(0.5,1))
summaryBy(price~location+stair1,data = house_info,FUN = mean)

#挖掘小区名的信息
community<-as.vector(house_info$name)
thewords <-unlist(Rwordseg::segmentCN(community,nature=T))  
invalid_words <-c("一期","二期","三期","四期","五期")
insertWords(c("祥云","新洲","贾跃亭"))
theflags<-thewords %in% invalid_words
thewords<-thewords[!theflags]
word_freq<-createWordFreq(thewords)
#绘制前200个出现次数最多的字的词云
#wordcloud2(word_freq[1:200,],size = 1.5)
#绘制6到200个出现次数最多的字的词云
#wordcloud2(word_freq[6:200,],size = 0.35)




