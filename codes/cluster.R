tot.wssplot <- function(data, nc, seed=1234){
  #假设分为一组时的总的离差平方和              
  tot.wss <- (nrow(data)-1)*sum(apply(data,2,var)) 
  for (i in 2:nc){
    #必须指定随机种子数
    set.seed(seed) 
    tot.wss[i] <- kmeans(data, centers=i, iter.max = 100)$tot.withinss
  }
  plot(1:nc, tot.wss, type="b", xlab="Number of Clusters",
       ylab="Within groups sum of squares",col = 'blue',
       lwd = 2, main = 'Choose best Clusters')
}