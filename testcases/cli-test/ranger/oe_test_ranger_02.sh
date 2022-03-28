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

    if [[ -e "/root/selectedFilename" ]]; then
        rm -f /root/selectedFilename
    fi
    expect <<EOF
        spawn ranger --choosefile=/root/selectedFilename
            send ":cd /root\r"
            expect ".bashrc" {
                send ":search .bashrc\r"
                send "\r"
                expect eof {
                    catch wait result
                    exit [lindex \$result 3]
                }
            }
EOF
    CHECK_RESULT $? 0 0 "Failed option: --choosefile=OUTFILE"
    cat /root/selectedFilename | grep "/root/.bashrc"
    CHECK_RESULT $? 0 0 "Failed option: --choosefile=OUTFILE"

    #输入ob是按名称排序，这样.bash_profile，.bash_history，.bash_logout会排列在一起，输入
    #V会进行选择，加上两个j共选择三个文件
    if [[  -e "/root/selectedFilename" ]]; then
        rm -f /root/selectedFilename
    fi
    expect <<EOF
        spawn ranger --choosefiles=/root/selectedFilename
            send ":cd /root\r"
            expect ".bash_profile|.bash_history|.bash_logout" {
                send "ob"
                send ":search .bash_history\r"
                send "V"
                send "j"
                send "j"
                send "\r"
                expect eof {
                    catch wait result
                    exit [lindex \$result 3]
                }
            }
EOF
    CHECK_RESULT $? 0 0 "Failed option: --choosefiles=OUTFILE"
    cat /root/selectedFilename | grep "/root/.bash_profile|/root/.bash_history|/root/.bash_logout"
    CHECK_RESULT $? 0 0 "Failed option: --choosefiles=OUTFILE"


    if [[  -e "/root/selectedFilename" ]]; then
        rm -f /root/selectedFilename
    fi
    if [[ -d /root/.cache ]]; then
        expect <<EOF
            spawn ranger --choosedir=/root/selectedFilename
            send ":cd /root\r"
            expect ".cache" {
                send ":search .cache\r"
                send "l"
                expect eof {
                    catch wait result
                    exit [lindex \$result 3]
                }
            }
EOF
        CHECK_RESULT $? 0 0 "Failed option: --choosedir=OUTFILE"
        cat /root/selectedFilename | grep "/root/.cache"
        CHECK_RESULT $? 0 0 "Failed option: --choosedir=OUTFILE"
    else
        CHECK_RESULT $? 1 0 "Failed option: --choosedir=OUTFILE"
    fi


    if [[ -d /root/.cache ]]; then
        expect <<EOF
            spawn ranger --selectfile=/root/.cache
            expect "/root/.cache" {
                expect eof {
                    catch wait result
                    exit [lindex \$result 3]
                }
            }
EOF
        CHECK_RESULT $? 0 0 "Failed option: --selectfile=filepath"
    else
        CHECK_RESULT $? 1 0 "Failed option: --selectfile=filepath"
    fi


    expect <<EOF
        spawn ranger --show-only-dirs
        send ":cd /root\r"
        expect ".bachrc" {
            exit 1
        }
        exit 0
EOF
    CHECK_RESULT $? 0 0 "Failed option: --show-only-dirs"


    expect <<EOF
        spawn ranger --list-unused-keys
        expect "<a-return>" {
            expect eof {
                    catch wait result
                    exit [lindex \$result 3]
                }
        }
        exit 1
EOF
    CHECK_RESULT $? 0 0 "Failed option: --list-unused-keys"


    if cat /root/.local/share/ranger/tagged | grep -E "/root/.bash_history"; then
        expect <<EOF
            spawn ranger --list-tagged-files=*
            expect "/root/.bash_history" {
                expect eof {
                    catch wait result
                    exit [lindex \$result 3]
                }
            }
            exit 1;
EOF
        CHECK_RESULT $? 0 0 "Failed option: --list-tagged-files=tag"
    else
        CHECK_RESULT $? 1 0 "Failed option: --list-tagged-files=tag"
    fi


    expect <<EOF
        spawn ranger --profile
        send "q" 
        expect "   Ordered by: cumulative time" {
            expect eof {
                    catch wait result
                    exit [lindex \$result 3]
                }
        }
        exit 1
EOF
    CHECK_RESULT $? 0 0 "Failed option: --profile"


    if [[ -e /root/test.txt ]]; then
        rm -f /root/test.txt
    fi
    expect <<EOF
        spawn ranger --cmd="cd /root" --cmd="touch test.txt"
        send "q"
        expect eof {
                    exit 0
                }
EOF
    ls /root | grep -E "test.txt"
    CHECK_RESULT $? 0 0 "Failed option: --cmd"

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
