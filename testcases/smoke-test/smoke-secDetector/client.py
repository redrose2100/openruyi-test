#!/usr/bin/python3
# -*- coding: utf-8 -*-

import ctypes
import time
import sys
import threading
from threading import Thread

sys.path.append("./common")
from common import *

def main():

    topic = int(0x00FFFFFF)

    reader = thread_func_sub(topic)

    threadlist = []

    tsub_read = Thread(target=thread_func_read,args=(reader,))
    tsub_read.start()

    threadlist.append(tsub_read)

    file_check()
    time.sleep(1)
    process_check()
    time.sleep(1)
    behav_check()
    time.sleep(1)

    thread_func_unsub(topic, reader)

    for t in threadlist:
        t.join()

    print("client end")

if __name__ == '__main__':
    main()

