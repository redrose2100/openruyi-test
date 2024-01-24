import eventlet
from urllib.request import urlopen

def coroutine_func(url):
    with eventlet.Timeout(5, False):
        resp = urlopen(url)
        print(resp.read().decode('utf-8'))
pool = eventlet.GreenPool()
for url in ['http://www.baidu.com',  'http://www.yahoo.com']:
    pool.spawn(coroutine_func, url)
pool.waitall()