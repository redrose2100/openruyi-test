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
# @Date      :   2022/03/18
# @License   :   Mulan PSL v2
# @Desc      :   cvs remote config
# #############################################

cd ${cvs_dir}/CVSROOT/
htpasswd -c -b passwd cvsuser cvs
sed -i 's/$/&:cvsroot/g' passwd
cat passwd
touch /etc/xinetd.d/cvspserver
echo "service cvspserver

{
disable = no
port = 2401
socket_type = stream
protocol = tcp
wait = no
user = root
passenv = PATH
server = /usr/bin/cvs
env = HOME=${cvs_dir}
server_args = -f --allow-root=${cvs_dir} pserver
# bind = 127.0.0.1
}" >> /etc/xinetd.d/cvspserver
systemctl restart xinetd.service
sleep 3
netstat -l | grep cvspserver | grep '.**:cvspserver *:* LISTEN'
firewall-cmd --permanent --add-port=2401/tcp 2>&1 | grep 'success'					
firewall-cmd --reload 2>&1 | grep 'success'	
firewall-cmd --permanent --query-port=2401/tcp 2>&1 | grep 'yes'

