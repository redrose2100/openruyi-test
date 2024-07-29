import ctypes
import time
import sys, os
import tempfile
import threading
import subprocess
from threading import Thread

DATA_LEN = 1024

secDetectorsdklib = ctypes.cdll.LoadLibrary('/usr/lib64/secDetector/libsecDetectorsdk.so')

g_cli_reader = ctypes.c_void_p
g_cli_reader_lock = threading.Lock()

secDetectorsdklib.secSub.argtypes = [ctypes.c_int]
secDetectorsdklib.secSub.restype = ctypes.c_void_p
secDetectorsdklib.secUnsub.argtypes = [ctypes.c_void_p]
secDetectorsdklib.secUnsub.restype = None
secDetectorsdklib.secReadFrom.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_int]
secDetectorsdklib.secReadFrom.restype = None

reader_state = False

def thread_func_sub(num):
    global reader_state
    cli_reader = secDetectorsdklib.secSub(num)
    if cli_reader == None:
        print("sub fail")
    else:
        print("sub success")
    print("client thread_func_sub end")
    reader_state = True

    return cli_reader


def thread_func_read(cli_reader):
    global reader_state
    print("client thread_func_read start")

    data = ctypes.create_string_buffer(DATA_LEN)
    data_len = ctypes.c_int(DATA_LEN)
    #secDetectorsdklib.secReadFrom(cli_reader, data, data_len)
    #print("client read data:{}".format(data.value.decode()))

    while reader_state:
        if data.value.decode() == 'end':
            print("client received end")
            break
        #time.sleep(1)
        secDetectorsdklib.secReadFrom(cli_reader, data, data_len)
        #print("client while read data:{}".format(data.value.decode()))

    print("client thread_func_read end")
    print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())))

def thread_func_unsub(num, cli_reader):
    global reader_state
    print("client thread_func_unsub start")
    print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())))
    secDetectorsdklib.secUnsub(cli_reader)

    print("client thread_func_unsub end")
    print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())))
    reader_state = False

def file_check():
    fd, path = tempfile.mkstemp()
    try:
        with os.fdopen(fd, 'w+') as tmp:
            # do stuff with temp file
            tmp.write('stuff')
            s = tmp.readline()
    finally:
        os.utime(path, (1602179630, 1602179630))
        os.remove(path)

def process_check():
    os.system("id")
    subprocess.run(["su", "tester", "-c", "id"])

def behav_check():
    os.system('id | grep uid')



def expect_eq(left, right):
    if left == right:
        print("check success!!")
    else:
        print("check fail!!")

def expect_ne(left, right):
    if left == right:
        print("check fail!!")
    else:
        print("check success!!")
