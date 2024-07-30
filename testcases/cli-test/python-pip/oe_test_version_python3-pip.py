# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2024/5/9
# @License   :   Mulan PSL v2
# @Desc      :   test version
# ############################################

import subprocess  
  
def check_pip_version(): 
    try:  
        result = subprocess.run(['pip', '--version'], check=True, stdout=subprocess.PIPE, universal_newlines=True)  
        return result.stdout  
    except subprocess.CalledProcessError:  
        return "pip not installed or unable to execute。"  
  
pip_version = check_pip_version()  
print("pip successfully returns the version information")
print(pip_version)
