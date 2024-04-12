# Copyright (c) KylinSoft  Co., Ltd. 2023-2024.All rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wuzhaomin
# @Contact   :   wuzhaomin@kylinos.cn
# @Date      :   2024/4/12
# @License   :   Mulan PSL v2
# @Desc      :   test hasher
# ############################################

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