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
# @Date      :   2024/4/26
# @License   :   Mulan PSL v2
# @Desc      :   test python3-gflags
# ############################################

import gflags  
import sys

# 定义命令行标志  
gflags.DEFINE_string('name', 'World', 'Your name.')  
gflags.DEFINE_integer('age', 0, 'Your age.')  
  
# 解析命令行参数  
FLAGS = gflags.FLAGS  
  
def main():  
    # 打印出标志的值  
    print(f"Hello, {FLAGS.name}! You are {FLAGS.age} years old.")  
  
if __name__ == '__main__':  
    # 解析命令行参数  
    FLAGS(sys.argv)  
    # 运行主函数  
    main()
