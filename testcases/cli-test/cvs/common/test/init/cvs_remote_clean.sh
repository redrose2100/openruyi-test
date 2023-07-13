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
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/03/18
# @License   :   Mulan PSL v2
# @Desc      :   cvs remote config
# #############################################
systemctl stop xinetd.service
! netstat -l | grep cvspserver
firewall-cmd --permanent --remove-port=2401/tcp 2>&1 | grep 'success'
firewall-cmd --reload 2>&1 | grep 'success'
firewall-cmd --permanent --query-port=2401/tcp 2>&1 | grep 'no'
rm -rf /etc/xinetd.d/cvspserver