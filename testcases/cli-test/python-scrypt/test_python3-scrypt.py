import scrypt
import os

# 定义要哈希的原始密码
password = b'my_secret_password'

# 生成随机 salt
salt = os.urandom(16)

# 生成密码哈希
hashed_password = scrypt.hash(password, salt=salt)

# 打印生成的哈希值
print("Hashed password:", hashed_password)

# 模拟密码验证
input_password = b'my_secret_password'
if scrypt.hash(input_password, salt=salt) == hashed_password:
    print("Password is correct!")
else:
    print("Incorrect password.")
