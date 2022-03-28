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

    #测试-c选项,在配置文件中改为默认显示隐藏文件，如果用-c命令的话，应该不显示
    if cat /root/.config/ranger/rc.conf | grep "set show_hidden true"; then
        expect <<EOF
            spawn ranger -c
            send ":cd /root\r"
            expect ".bashrc" {
                expect eof {
			        catch wait result
			        exit [lindex \$result 3]
		        }
            }
            exit 1   
EOF
        CHECK_RESULT $? 1 0 "Failed option: -c"
    else
        CHECK_RESULT $? 1 0 "Failed option: -c, show_hidden is false"
    fi

    if cat /root/.config/ranger/rc.conf | grep "set show_hidden true"; then
        expect <<EOF
            spawn ranger --clean
            send ":cd /root\r"
            expect ".bashrc" {
                expect eof {
			        catch wait result
			        exit [lindex \$result 3]
		        }
            }
            exit 1   
EOF
        CHECK_RESULT $? 1 0 "Failed option: --clean"
    else
        CHECK_RESULT $? 1 0 "Failed option: --clean, show_hidden is false"
    fi

    if [[ ! -e "/root/mylog.txt" ]]; then
        expect <<EOF
            spawn ranger --logfile=/root/mylog.txt
            expect eof {
                catch wait result
                exit [lindex \$result 3]
            }
EOF
    fi
    CHECK_RESULT $? 0 0 "Failed option: --logfile=file"
    cat /root/mylog.txt | grep "ranger version:"
    CHECK_RESULT $? 0 0 "Failed option: --logfile=file"
    rm -f /root/mylog.txt

    #如果命令有效，会在新建的myconfig目录下出现rc配置文件
    if [[ ! -d "/root/myconfig" ]]; then
        mkdir /root/myconfig
    fi
    expect <<EOF
        spawn ranger --copy-config=rc -r /root/myconfig
        expect eof {
            catch wait result
            exit [lindex \$result 3]
        }
EOF
    CHECK_RESULT $? 0 0 "Failed option: -r"
    ls /root/myconfig | grep "rc.conf"
    CHECK_RESULT $? 0 0 "Failed option: -r"
    rm -rf /root/myconfig

    if [[ ! -d "/root/myconfig" ]]; then
        mkdir /root/myconfig
    fi
    expect <<EOF
        spawn ranger --copy-config=rc --confdir=/root/myconfig
        expect eof {
            catch wait result
            exit [lindex \$result 3]
        }
EOF
    CHECK_RESULT $? 0 0 "Failed option: --confdir=dir or --copy-config=which"
    ls /root/myconfig | grep "rc.conf"
    CHECK_RESULT $? 0 0 "Failed option: --confdir=dir or --copy-config=which"
    rm -rf /root/myconfig

    if [[ ! -d "/root/mydata" ]]; then
        mkdir /root/mydata
    fi
    expect <<EOF
        spawn ranger --datadir=/root/mydata
        expect eof {
            catch wait result
            exit [lindex \$result 3]
        }
EOF
    CHECK_RESULT $? 0 0 "Failed option: --datadir=dir"
    ls /root/mydata | grep -E "bookmarks|history|tagged"
    CHECK_RESULT $? 0 0 "Failed option: --datadir=dir"
    rm -rf /root/mydata

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
