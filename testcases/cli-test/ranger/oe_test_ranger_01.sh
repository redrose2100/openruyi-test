#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   zhangyili2
#@Contact   	:   yili@isrc.iscas.ac.cn
#@Date      	:   2022-03-26 09:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test for ranger
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "ranger"

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    ! ranger --verson 2>&1 | grep "invalid option" && ranger --version 2>&1 | grep "ranger version:"
    CHECK_RESULT $? 0 0 "Failed option: --version"

    ! ranger -h 2>&1 | grep "invalid option" && ranger -h 2>&1 | grep "Usage: ranger"
    CHECK_RESULT $? 0 0 "Failed option: -h"

    ! ranger --help 2>&1 | grep "invalid option" && ranger --help 2>&1 | grep "Usage: ranger"
    CHECK_RESULT $? 0 0 "Failed option: --help"

    if grep "set show_hidden true" /root/.config/ranger/rc.conf; then
        expect <<EOF
            spawn ranger -c
            expect "*root@localhost.localdomain" {
                send ":" 
                expect "*:*" {
                    send "cd ~\r" 
                    expect ".bashrc" {
                            exit 1
                    }
                    exit 0   
                }
            }
EOF
        CHECK_RESULT $? 0 0 "Failed option: -c"
    else
        CHECK_RESULT 0 1 0 "Failed option: -c, show_hidden is false"
    fi

    if grep "set show_hidden true" /root/.config/ranger/rc.conf; then
        expect <<EOF
            spawn ranger --clean
            expect "*root@localhost.localdomain" {
                send ":" 
                expect "*:*" {
                    send "cd ~\r" 
                    expect ".bashrc" {
                            exit 1
                    }
                    exit 0   
                }
            }
EOF
        CHECK_RESULT $? 0 0 "Failed option: --clean"
    else
        CHECK_RESULT 0 1 0 "Failed option: --clean, show_hidden is false"
    fi

    if [[ ! -e "/tmp/mylog.txt" ]]; then
        expect <<EOF
            spawn ranger --logfile=/tmp/mylog.txt
            expect eof {
                catch wait result
                exit [lindex \$result 3]
            }
EOF
    fi
    CHECK_RESULT $? 0 0 "Failed option: --logfile=file"
    cat /tmp/mylog.txt | grep "ranger version:"
    CHECK_RESULT $? 0 0 "Failed option: --logfile=file"
    rm -f /tmp/mylog.txt

    if [[ ! -d "/tmp/myconfig" ]]; then
        mkdir /tmp/myconfig
    fi
    expect <<EOF
        spawn ranger --copy-config=rc -r /tmp/myconfig
        expect eof {
            catch wait result
            exit [lindex \$result 3]
        }
EOF
    CHECK_RESULT $? 0 0 "Failed option: -r or --copy-config=which"
    test -f /tmp/myconfig/rc.conf
    CHECK_RESULT $? 0 0 "Failed option: -r or --copy-config=which"
    rm -rf /tmp/myconfig

    if [[ ! -d "/tmp/myconfig" ]]; then
        mkdir /tmp/myconfig
    fi
    expect <<EOF
        spawn ranger --copy-config=rc --confdir=/tmp/myconfig
        expect eof {
            catch wait result
            exit [lindex \$result 3]
        }
EOF
    CHECK_RESULT $? 0 0 "Failed option: --confdir=dir or --copy-config=which"
    test -f /tmp/myconfig/rc.conf
    CHECK_RESULT $? 0 0 "Failed option: --confdir=dir or --copy-config=which"
    rm -rf /tmp/myconfig


    if [[ ! -d "/tmp/mydata" ]]; then
        mkdir /tmp/mydata
    fi
    expect <<EOF
        spawn ranger --datadir=/tmp/mydata
        expect eof {
            catch wait result
            exit [lindex \$result 3]
        }
EOF
    CHECK_RESULT $? 0 0 "Failed option: --datadir=dir"
    test -f /tmp/mydata/bookmarks
    CHECK_RESULT $? 0 0 "Failed option: --datadir=dir"
    rm -rf /tmp/mydata

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
