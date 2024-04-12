from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend
		
# 待哈希的数据
data = b"This is the data to be hashed"
		
# 创建哈希算法对象并计算哈希值
hasher = hashes.Hash(hashes.SHA256(), default_backend())
hasher.update(data)
digest = hasher.finalize()  # 在1.4+版本中，需要调用finalize()来获取最终的摘要值
		
# 输出哈希值的十六进制表示
print(digest.hex())
