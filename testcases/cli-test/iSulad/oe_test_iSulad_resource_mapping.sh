#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   huang_rong2@hoperun.com
# @Date      :   2022/01/06
# @License   :   Mulan PSL v2
# @Desc      :   resource mapping
# #############################################
# shellcheck disable=SC1091

source "./common/common_lib.sh"


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL hostname
    iSulad_install
    if [ "${NODE1_FRAME}" == "riscv64" ]; then
        TEST_IMAGE=debian
        TEST_TAG=trixie
    else
        TEST_IMAGE=centos
        TEST_TAG=7
    fi

    localhostname=$(hostname)
    hostname test
    LOG_INFO "Start to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    isula run -itd -h "$(hostname)" --name volume -v vol:/vol:rw,nocopy "${TEST_IMAGE}":"${TEST_TAG}"
    CHECK_RESULT $? 0 0 "create container failed"
    expect <<EOF
        spawn isula exec -it volume /bin/bash
        expect {
            "root@$(hostname)" {
                send "cd /vol\n"
            }
        }
        expect {
            "root@$(hostname)" {
                send "echo 'hello world' > test\n"
            }
        }
        expect {
            "root@$(hostname)" {
                send "exit\n"
            }
        }
        expect eof
EOF
    grep "hello world" /var/lib/isulad/volumes/vol/_data/test
    CHECK_RESULT $? 0 0 "resource mapping failed"
    isula run -itd -h "$(hostname)" --name volume1 --mount type=volume,src=vol1,dst=/vol1,volume-nocopy=true "${TEST_IMAGE}":"${TEST_TAG}"
    CHECK_RESULT $? 0 0 "create container failed"
    expect <<EOF
        spawn isula exec -it volume1 /bin/bash
        expect {
            "root@$(hostname)" {
                send "cd /vol1\n"
            }
        }
        expect {
            "root@$(hostname)" {
                send "echo 'hello world' > test\n"
            }
        }
        expect {
            "root@$(hostname)" {
                send "exit\n"
            }
        }
        expect eof
EOF
    grep "hello world" /var/lib/isulad/volumes/vol1/_data/test
    CHECK_RESULT $? 0 0 "resource mapping failed"
    isula run -itd -h "$(hostname)" --name volume2 --volumes-from volume --volumes-from volume1 "${TEST_IMAGE}":"${TEST_TAG}"
    CHECK_RESULT $? 0 0 "create container failed"
    expect <<EOF
        log_file /tmp/log_volume
        spawn isula exec -it volume2 /bin/bash
        expect {
            "root@$(hostname)" {
                send "grep 'hello world' /vol/test\n"
            }
        }
        expect {
            "root@$(hostname)" {
                send "grep 'hello world' /vol1/test\n"
            }
        }
        expect {
            "root@$(hostname)" {
                send "exit\n"
            }
        }
        expect eof
EOF
    test "$(grep -c 'hello world' /tmp/log_volume)" -eq 4
    CHECK_RESULT $? 0 0 "resource mapping failed"
    isula stop volume volume1 volume2
    isula rm volume volume1 volume2
    grep "hello world" /var/lib/isulad/volumes/vol/_data/test
    CHECK_RESULT $? 0 0 "resource mapping failed"
    grep "hello world" /var/lib/isulad/volumes/vol1/_data/test
    CHECK_RESULT $? 0 0 "resource mapping failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    hostname "${localhostname}"
    isula rmi "${TEST_IMAGE}":"${TEST_TAG}"
    iSulad_remove
    rm -rf /tmp/log_volume
    LOG_INFO "End to restore the test environment"
}

main "$@"
