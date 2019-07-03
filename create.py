#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import MySQLdb

# 打开数据库连接
db = MySQLdb.connect("172.17.0.2", "root", "123456", "huawei", charset='utf8' )

# 使用cursor()方法获取操作游标 
cursor = db.cursor()

# 如果数据表已经存在使用 execute() 方法删除表。
#cursor.execute("DROP TABLE IF EXISTS EMPLOYEE")

# 创建数据表SQL语句
sql = """CREATE TABLE shop(
         url CHAR(200) NOT NULL,
         name CHAR(200))"""

cursor.execute(sql)

# 关闭数据库连接
db.close()
