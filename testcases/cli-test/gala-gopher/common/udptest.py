#!/bin/env python
# Copyright (C), 2023-2023, Huawei Tech. Co., Ltd.
# Description: udp 打流工具
# Author: qiangxiaojun<qiangxiaojun@huawei.com>
# Create: 2023/04/04

import socket
import time
import random
import argparse
import string

DEFAULT_PORT = 3008

parser = argparse.ArgumentParser()
parser.add_argument('-s', '--serverip', type=str, help='server ip')
parser.add_argument('-c', '--clientip', type=str, help='client ip')
parser.add_argument('-p', '--port', type=int, help='server ip')


def server_recv(serverip, port):
    ssocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    serveraddr = (serverip, port)
    ssocket.bind(serveraddr)
    while True:
        data = ssocket.recvfrom(1024)
        print('recv data:', data)


def client_send(serverip, port):
    csocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    serveraddr = (serverip, port)
    while True:
        data = ''.join(random.choice('abcd') for i in range(2))
        csocket.sendto(data.encode(), serveraddr)


def main():
    args = parser.parse_args()
    port = DEFAULT_PORT
    if args.port:
        port = args.port
    if args.serverip:
        print('listen ip:', args.serverip, 'listen port:', port)
        server_recv(args.serverip, port)
    if args.clientip:
        client_send(args.clientip, port)


if __name__ == "__main__":
    main()
