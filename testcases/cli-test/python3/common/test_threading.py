import threading

count = 0
lock = threading.Lock()


def add():
    global count
    for i in range(1000000):
        with lock:
            count += 1


t1 = threading.Thread(target=add)
t2 = threading.Thread(target=add)
t1.start()
t2.start()
t1.join()
t2.join()
print("count = ", count)
assert count == 2000000
