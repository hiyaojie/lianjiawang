from bs4 import BeautifulSoup
import requests
import time
import pymongo

clinet=pymongo.MongoClient("localhost",27017)
housedb=clinet["housedb"]
websites=housedb["websites"]
house_infos=housedb["house_info"]

start_url="https://sz.lianjia.com/ershoufang/"
urls=["https://sz.lianjia.com/ershoufang/pg{}/"
          .format(str(i)) for i in range(1,101)]



def getwebsites(url):
    time.sleep(2)
    webdata=requests.get(url)
    soup=BeautifulSoup(webdata.text,"lxml")
    links=soup.select("div.info.clear > div.title > a")
    for link in links:
        data={
            "link":link.get("href")
        }
        print(link.get("href"))
        websites.insert_one(data)

def gethousedata(url):
    time.sleep(2)
    page=requests.get(url)
    if page.status_code==404:
        pass
    else:
        soup=BeautifulSoup(page.text,"lxml")
        name=soup.select("a.info")[0].get_text()
        house_info=soup.select("div.content > ul > li")
        style=house_info[0].get_text()[4:]
        direction=house_info[6].get_text()[4:]
        square=house_info[2].get_text()[4:]
        stair=house_info[1].get_text()[4:]
        location=soup.select("span.info")[0].get_text()
        lift=house_info[10].get_text()[4:]
        price=soup.select("span.unitPriceValue")[0].get_text()
        total_price=soup.select("span.total")[0].get_text()
        decorate=house_info[8].get_text()[4:]
        right=house_info[13].get_text().replace("\n","")[4:]
        last_time=house_info[14].get_text().replace("\n","")[4:]
        data={
            "name":name,
            "style":style,
            "direction":direction,
            "square":square,
            "stair":stair,
            "location":location,
            "lift":lift,
            "price":price,
            "total_price":total_price,
            "decorate":decorate,
            "right":right,
            "last_time":last_time,
            "link":url
        }
        house_infos.insert_one(data)
        print("已爬取",house_infos.find().count(),"条数据！")

#为防止重复写入数据库，执行完一次之后注释掉！
for url in urls:
     getwebsites(url)


#以下实现断点续传功能，程序中断后可以从未爬取的页面继续爬取！
db_urls=[item["link"] for item in websites.find()]
index_urls=[item["link"] for item in house_infos.find()]
x=set(db_urls)
y=set(index_urls)
rest_of_urls=x-y

for item in rest_of_urls:
     gethousedata(item)
