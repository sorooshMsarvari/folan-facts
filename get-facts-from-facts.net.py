import requests
from bs4 import BeautifulSoup
import json

url = 'https://facts.net/random-facts/'
res = requests.get(url)

html = BeautifulSoup(res.text, 'html.parser')
fact_divs =  html.select('div.single-title-desc-wrap')

facts = []

for fact_div in fact_divs:
  title = fact_div.select_one('h2').get_text()
  desc = fact_div.select_one('p').get_text()
  facts.append({
    "fact": title,
    "desc": desc
  })

f = open('folan-facts.json', 'w')
f.write(json.dumps(facts, indent=2))
f.close()