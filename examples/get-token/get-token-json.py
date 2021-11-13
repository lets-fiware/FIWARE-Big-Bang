import requests
import json

url = 'https://keyrock.example.com/token'
payload = {'username':'admin@example.com', 'password': 'zVBSpufGQpg6eN2h'}
headers = {'Content-Type': 'application/json'}

res = requests.post(url, data=json.dumps(payload), headers=headers)

if (res.status_code == 200):
  print(res.text)
else:
  print(res.status_code)
