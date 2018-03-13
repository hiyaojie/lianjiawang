## 开发环境
 1. pycharm
 2. mongodb
 3. Rstudio
## 爬虫功能

爬取[链家网](https://sz.lianjia.com/ershoufang/)上深圳二手房数据，保存在mongodb数据中，并进行分析。

## 运行及介绍

 1. 安装mongodb，打开一个命令行，输入mongod打开服务器
 2. 运行getwebdata.py文件，会依次抓取房屋数据，写入数据库
 3. 在命令行输入以下命令保存数据到temp.csv
 4. 已解决页面删除后返回404异常问题
 5. 已实现断点续传

    `mongoexport -d housedb -c house_info --type=csv -f  
    id,decorate,link,last_time,price,name,square,total_price,
    location,direction,right,style,lift,stair -o G:\temp.csv`
    
## 数据分析
#### 比较每个区在售房屋数量，并可视化展示
 
| 区域 | 在售数量 |
| :-: | :-: |
|    宝安区 | 179 |
|    福田区 | 273 |
|    龙岗区 | 378 |
|    龙华区 | 109 |
|    罗湖区 | 112 |
|    南山区 | 230 |
|    盐田区 |  13 |

![每区在售数量](https://github.com/hiyaojie/python/raw/master/imgs/Rplot05.png)
#### 比较每种户型在售房屋数量，并可视化展示
| 户型 | 在售数量 |
| :-: | :-: |
| 1室1厅 |  46 |
| 2室1厅 | 261 |
| 2室2厅 | 163 |
| 3室1厅 | 148 |
| 3室2厅 | 353 |
| 4室1厅 |  34 |
| 4室2厅 | 193 |
| 5室2厅 |  50 |
| 其他 |  46 |

![户型在售数量](https://github.com/hiyaojie/python/raw/master/imgs/Rplot04.png)

#### 比较每种楼层在售房屋数量
| 户型 | 在售数量 |
| :-: | :-: |
| 低楼层 | 416 |
| 高楼层 | 396 |
| 中楼层 | 482 |

#### 分类汇总每个区房屋均价并可视化展示

![户型在售数量](https://github.com/hiyaojie/python/raw/master/imgs/Rplot06.png)

#### 聚类分析
 1.  选择变量集
``` r
standrad <- data.frame(scale(house_info[,c('square','price','total_price')]))
```
2. 为K-means选择最佳的K值 
![](https://github.com/hiyaojie/python/raw/master/imgs/Rplot07.png) 
选择K=5
3. 执行聚类分析

``` r
  km<-kmeans(standrad,5)
  house_info$cluster<-as.factor(km$cluster)  
  head(house_info$cluster)
```

    ## [1] 2 4 4 2 2 2
    ## Levels: 1 2 3 4 5
 4. 分析聚类结果
 
  1. 每类房房型分布
  ![](https://github.com/hiyaojie/python/raw/master/imgs/Rplot08.png) 
  2. 每类房的面积、价格

    ##   cluster price.mean square.mean total_price.mean time2now.mean
    ## 1       1   89850.89   123.23794        1095.5714      13.19841
    ## 2       2   43502.05    79.63481         346.2278      13.96139
    ## 3       3  111692.03   214.94138        2417.8086      10.62069
    ## 4       4   64652.74    75.48422         483.9787      12.42022
    ## 5       5   53835.40   158.97449         842.8571      12.43537

  3. 每类房的数量
    ## 
    ##   1   2   3   4   5 
    ## 126 518  58 445 147

    观察每1类的特征可以发现：

    第一类：年代较久（平均年龄在13年以上）的“豪宅”，主要分布在南山、福田，面积中等，均价较高；数量126
    第二类：经济房（平均年龄将近14年），主要分布在龙岗、罗湖、龙华，80平左右；数量518
    第三类：深圳最好的“豪宅”，主要在南山，福田，面积大，均价高；数量58
    第四类：平民房，面积和年龄教经济房相差不打，但是地段更好，主要在福田、南山、宝安；数量445
    第五类：平民大房，面积较平民房更大，龙岗最多，盐田最少，其他区较均匀，有趣的是房子越大，每平米均价越少；数量147


#### 挖掘小区名的信息
    1. 绘制前200个出现次数最多的字的词云
          ![小区名词云1](https://github.com/hiyaojie/python/raw/master/imgs/Rplot02.png)
          
          
    2. 出现次数前5都是后缀，故绘制6到200个出现次数最多的字的词云
          ![小区名词云2](https://github.com/hiyaojie/python/raw/master/imgs/Rplot03.png)
       
   

   
   
