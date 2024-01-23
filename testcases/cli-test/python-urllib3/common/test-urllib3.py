import urllib3

http = urllib3.PoolManager()
response = http.request('GET', 'http://www.openeuler.org')
print(response.status)
data = response.data.decode('utf-8')
print(data)
