#!/usr/bin/env python3

import requests 
import re

def main():
  url = "https://list.tmall.com/search_product.htm?q=huawei&type=p&vmarket=&spm=a222t.7794920.a2227oh.d100&from=3c..pc_1_searchbutton"
  header = {
    "User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:67.0) Gecko/20100101 Firefox/67.0",
  }
  resp = requests.get(url, headers=header)
  data = resp.content.decode("gbk")
  
  with open("07.html", "w", encoding = "gbk") as f:
    f.write(data)

  pattern = re.compile("""<em title="(.*)">""")
  ret = pattern.findall(data)
  print(ret)
if __name__ == "__main__":
  main()
