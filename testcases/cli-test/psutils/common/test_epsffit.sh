#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   linjianbo
# @Contact   :   jianbo.lin@outlook.com
# @Date      :   2023/07/28
# @License   :   Mulan PSL v2
# @Desc      :   helper function for oe_test_epsffit
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function test_epsffit() {
  local opts="$1"
  local box_llx="$2" 
  local box_lly="$3"
  local box_urx="$4"
  local box_ury="$5"
  local filename="$6"

  boundingBoxSize=$(epsffit "${opts}" "$box_llx" "$box_lly" "$box_urx" "$box_ury" "$filename" | grep -i -a "boundingbox" | awk '{print $2, $3, $4, $5}')

  read -r llx lly urx ury <<<"$boundingBoxSize"

  if [ "$llx" -gt "$box_llx" ] && [ "$lly" -gt "$box_lly" ] && [ "$urx" -lt "$box_urx" ] && [ "$ury" -lt "$box_ury" ]; then
    CHECK_RESULT $? 0 0 "epsffit ${opts} ${llx} ${lly} ${urx} ${ury} ${filename} failed."
  fi
}