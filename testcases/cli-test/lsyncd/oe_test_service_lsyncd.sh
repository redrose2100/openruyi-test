#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test lsyncd.service restart
# #############################################

source "../common/common_lib.sh"

function config_params() {
  LOG_INFO "Start to config params of the case."
  mkdir $OET_PATH/testcases/cli-test/lsyncd/source_dir
  mkdir $OET_PATH/testcases/cli-test/lsyncd/target_dir
  mkdir /var/log/lsyncd
  mkdir /etc/lsyncd
  echo "settings {
  logfile = "\"/var/log/lsyncd/lsyncd.log"\",
	statusFile = "\"/var/log/lsyncd/lsyncd.status"\"
}
sync {
	default.rsyncssh,
	source = "\"$OET_PATH/testcases/cli-test/lsyncd/source_dir/"\",
	host = "\"${NODE1_IPV4}"\",
	targetdir = "\"$OET_PATH/testcases/cli-test/lsyncd/target_dir/"\",
	delete = true,
	delay = 0,
	exclude={
	  "\".txt"\"
	},
	rsync = {
	binary = "\"/usr/bin/rsync"\",
	archive = true,
  compress = true,
  verbose = true,
	owner = true,
  perms = true,
  _extra = {"\"--bwlimit=2000"\"},
  },
  ssh = {
    port = ${NODE1_SSH_PORT}
    }
}" >>/etc/lsyncd.conf
  mkdir /var/log/lsyncd
  touch /var/log/lsyncd/lsyncd.{log,status}
  mkdir /etc/lsyncd
  LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL lsyncd
    expect <<EOF
    spawn ssh-keygen
    expect "Generating public/private rsa key pair. Enter file in which to save the key"
    send "\n"
    expect "Enter passphrase (empty for no passphrase):"
    send "\n"
    expect "Enter same passphrase again:"
    send "\n"
    expect eof
EOF
    expect <<EOF
        spawn ssh-copy-id ${NODE1_USER}@${NODE1_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
            }
        }
        expect {
            "password" {
                send "${NODE1_PASSWORD}\\r"
            }
        }
        expect eof
EOF
    mkdir -p /var/www/html/
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution lsyncd.service
    test_reload lsyncd.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop lsyncd.service
    DNF_REMOVE
    ssh-keygen -R ${NODE1_IPV4}
    rm -rf /root/.ssh
    rm -rf /var/www/
    rm -rf /var/log/lsyncd
    rm -rf /etc/lsyncd
    rm -rf /etc/lsyncd.conf
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
