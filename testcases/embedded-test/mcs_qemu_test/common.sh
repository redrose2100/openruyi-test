#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhangju
#@Contact       :   zhangju@iscas.ac.cn
#@Date          :   2026-09
#@License       :   Mulan PSL v2
#@Desc          :   check qemu mcs  
#####################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function check_env(){
   # 检测模块是否存在
   if ! find /lib/modules/$(uname -r) -name "mcs_km.ko*" 2>/dev/null | grep -q .; then
      LOG_INFO "Skip: mcs_km.ko module not installed"
      exit 255
   fi
}

