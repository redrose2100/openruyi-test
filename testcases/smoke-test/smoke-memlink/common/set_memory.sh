#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   fanlirong
#@Contact   	:   fanlirong1@h-partners.com
#@Date      	:   2025-12-06
#@License   	:   Mulan PSL v2
#@Desc      	:   Set memory
#####################################

VM_NAME=$1
TMPFS_SIZE=${2:-1}

export VM_NAME
export TMPFS_SIZE

/usr/bin/expect << 'EOF'
    set timeout 20
    spawn virsh console $env(VM_NAME)
    expect {
        "Ctrl + ]" {
            send "\r"
            exp_continue
        }
        "Connected to domain" {
            send "\r"
            exp_continue
        }
        "*login*" {
            send "root\r"
            exp_continue
        }
        "Password" {
            send "openEuler12#$\r"
            exp_continue
        }
        "*#" {
            send "mkdir -p /mnt/tmpfs\r"
            expect "*#"

            send "mount -t tmpfs -o size=$env(TMPFS_SIZE)G tmpfs /mnt/tmpfs\r"
            expect "*#"

            send "dd if=/dev/zero of=/mnt/tmpfs/largefile bs=$env(TMPFS_SIZE)M count=1024\r"
            expect {
                "*#" { }
                timeout { puts "dd timeout"; exit 1 }
            }
            exit 0
        }
        timeout {
            exit 1
        }
        eof {
            exit 1
        }
    }
EOF