library("doBy")
library("tmcn")
library("ggplot2")
library("Rwordseg")
library("wordcloud2")
source("G:/R语言学习目录/advanced/cluster.r")

#读取房屋数据
house_info<-read.csv("G:/R语言学习目录/深圳二手房项目/temp.csv",header = T) 

#整理数据格式
house_info$built_time<-apply(house_info["built_time"],1,function(x) substr(x,1,4))
house_info$built_time[house_info$built_time=="未知年建"]<-"2003"
house_info<-transform(house_info,time2now=2018-as.integer(built_time))
house_info$price<-as.numeric(apply(house_info["price"],1,function(x) substr(x,1,nchar(x)-4)))
house_info$square<-as.numeric(apply(house_info["square"],1,function(x) substr(x,1,nchar(x)-1)))
house_info$location<-as.factor(apply(house_info["location"],1,function(x) substr(x,1,3)))
house_info$stair1<-apply(house_info["stair"],1,function(x) substr(x,1,3))
house_info$stair2<-apply(house_info["stair"],1,function(x) substr(x,7,nchar(x)-2))
house_info$style1<-apply(house_info["style"],1,function(x) substr(x,1,4))
#将id、link字段删掉
drops<-names(house_info) %in% c("id","link","lift","right","decorate","stair","built_time","direction","style","stair2")
house_info<-house_info[!drops] 

#比较每个区在售房屋数量，并可视化展示
location_freq<-data.frame(table(house_info$location))
ggplot(data = location_freq, mapping = aes(x = reorder(Var1, -Freq),y = Freq)) + geom_bar(stat = 'identity', fill = 'steelblue') + theme(axis.text.x  = element_text(angle = 30, vjust = 0.5)) + xlab('区域') + ylab('套数')
#比较每种户型在售房屋数量，并可视化展示

style_freq <- data.frame(table(house_info$style1))
house_info$style1<-ifelse(house_info$style1 %in% as.vector(style_freq[style_freq$Freq>10,1]),house_info$style1,"其他")
table(house_info$style1)
style_freq <- data.frame(table(house_info$style1))
ggplot(data = style_freq, mapping = aes(x = reorder(Var1, -Freq),y = Freq)) + geom_bar(stat = 'identity', fill = 'steelblue') + theme(axis.text.x  = element_text(angle = 30, vjust = 0.5)) + xlab('户型') + ylab('套数')


#比较每种楼层在售房屋数量，并可视化展示
prop.table(table(house_info$stair1))*100
pie(table(house_info$stair1))


#分类汇总每个区房屋均价并可视化展示
mean_price<-data.frame(summaryBy(price~location,data = house_info,FUN = mean)) 
names(mean_price)<-c("Var1","Freq")
ggplot(data = mean_price, mapping = aes(x = reorder(Var1, -Freq),y = Freq)) + geom_bar(stat = 'identity', fill = 'steelblue') + theme(axis.text.x  = element_text(angle = 30, vjust = 0.5)) + xlab('区域') + ylab('均价')
#bar=barplot(mean_price[,2],names.arg = mean_price[,1],main="深圳各区房价比较",col=rainbow(7))
#text(bar,mean_price[,2],labels = round(mean_price[,2]),adj = c(0.5,1))


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


#聚类分析
#以面积、均价、总价三个变量进行分类
standrad <- data.frame(scale(house_info[,c('square','price','total_price')]))
tot.wssplot(standrad,nc=15)
km<-kmeans(standrad,5)
house_info$cluster<-as.factor(km$cluster) 

ggplot(house_info,aes(cluster,fill=location))+geom_bar(position = "fill")
summaryBy(price+square+total_price+time2now~cluster,data = house_info,FUN = mean)
table(house_info$cluster)

#table(house_info$location,house_info$cluster)
#table(house_info$style1,house_info$cluster)
#table(house_info$time2now,house_info$cluster)
#table(house_info$cluster)
