#!/usr/bin/bash
# Copyright (c) [2021] Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
# http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author : wuzhihao
# @email : zhihao@isrc.iscas.ac.cn
# @Date : 2022-02
# @License : Mulan PSL v2
# @Version : 1.0
# @Desc :
#####################################

function IF_FILE_EXIXT(){
	filename=$1
	if [ -d "/etc/tuned/$filename" ] || [ -f "/etc/tuned/$filename" ];then
		    return 0
	else
		    return 1
	fi
}


