# https://docs.snowflake.com/en/user-guide/python-connector.html

import snowflake.connector
import json

with open('config.json','r') as file:
    data = json.load(file)
    user = data['user']
    password = data['password']
    account = data['account']

con = snowflake.connector.connect(
    user = user,
    password = password,
    account = account
)

result = con.cursor().execute("USE WAREHOUSE PUBLIC;") 
result = con.cursor().execute("SELECT * FROM PUBLIC.INFORMATION_SCHEMA.TABLES;") 
result_list = result.fetchall() 
print(result_list) 