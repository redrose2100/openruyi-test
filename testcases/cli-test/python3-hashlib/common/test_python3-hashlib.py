# -*- coding: utf-8 -*-
import hashlib

def encry(passwd):
	password = hashlib.sha512(passwd.encode()).hexdigest()
	print("Test Passed")
	return password

if __name__ == "__main__":
	pwd = encry('1')
	print(pwd)