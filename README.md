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
 1. 比较每个区在售房屋数量，并可视化展示
 2. 比较每种户型在售房屋数量，并可视化展示
 3. 比较每种楼层在售房屋数量，并可视化展示
 4. 分类汇总每个区房屋均价并可视化展示
 5. 挖掘小区名的信息
    1. 绘制前200个出现次数最多的字的词云
   ![小区名词云](https://github.com/hiyaojie/python/raw/master/Rplot02.png)
