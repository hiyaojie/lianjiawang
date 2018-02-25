爬虫功能
======

爬取[链家网](https://sz.lianjia.com/ershoufang/)上深圳二手房数据，保存在mongodb数据中，并进行简单分析。

运行方法
======
0. 安装mongodb，打开一个命令行，输入mongod打开服务器
1. 运行getwebdata.py文件，会依次抓取房屋数据，写入数据库
2. 在命令行输入以下命令保存数据到temp.csv

    `mongoexport -d housedb -c house_info --type=csv -f  
    id,decorate,link,last_time,price,name,square,total_price,location,direction,right,style,lift,stair -o G:\temp.csv`
    
