import requests

print(requests.__dict__)

def run_tests():
    test_send_requests()

def test_send_requests():
    r = requests.get('http://www.baidu.com')
    assert r.status_code == 200
    print("Test Passed: test_send_requests")

run_tests()
