#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
import requests 
import pymysql
pymysql.install_as_MySQLdb()
import re
import MySQLdb

def main():
  url = "https://list.tmall.com/search_product.htm?q=huawei&type=p&vmarket=&spm=a222t.7794920.a2227oh.d100&from=3c..pc_1_searchbutton"
  header = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36",
  }
  resp = requests.get(url, headers=header)
  data = resp.content.decode("gbk")
  
  pattern = re.compile("""<a href="(.*)" target="_blank" title="(.*)" data-p=""")
  ret = pattern.findall(data)
  lst = []
  db = MySQLdb.connect("172.17.0.2", "root", "123456", "huawei", charset='utf8')
  cursor = db.cursor()
  insert_stmt = (
    "INSERT INTO shop(url,name)" 
    "VALUES (%s, %s)"
  )
  for i in ret:
    x = (i[0],i[-1])
    lst.append(x)
    print(x)
    try:
      cursor.execute(insert_stmt,x)
      db.commit()
    except:
      print("insert error")
      db.rollback()
  db.close()

  html = """<html>
<head></head>
<body>
<ul>
"""
  for i in lst:
    html += """<p>"""
    html += """<a href=http:"""
    html += i[0]
    html += """>""" 
    html += i[1]
    html += """</a></p>""" 
  html += """</ul></body></html>""" 
  with open("06.html", "w", encoding = "utf-8") as f:
    f.write(html)
if __name__ == "__main__":
  main()
