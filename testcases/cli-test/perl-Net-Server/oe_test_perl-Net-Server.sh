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
# @Author    :   blackgaryc
# @Contact   :   blackgaryc@gmail.com
# @Date      :   2022/5/6
# @License   :   Mulan PSL v2
# @Desc      :   Test perl-Net-Server
# #############################################
# shellcheck disable=SC2046
source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "perl-Net-Server perl-Socket6 net-tools"
    port=$(GET_FREE_PORT 127.0.0.1)
    cat <<EOF >app.cgi
#!/bin/bash
echo "Content-type: text/html"
echo ""
echo "Test success"
EOF
    chmod u+x app.cgi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    # Fork mode in *:$port
    net-server Fork port "$port" 2>&1 &
    SLEEP_WAIT 1
    netstat -nltp | grep "$port"
    CHECK_RESULT $? 0 0 "L$LINENO: Fork No Pass "
    kill -9 $(pgrep -f "/bin/net-server")
    # INET mode
    echo helloTest | net-server INET 2>&1 | grep "net_server:.*You said \"helloTest\""
    CHECK_RESULT $? 0 0 "L$LINENO: INET No Pass. Output Error."
    netstat -nltp | grep "$port"
    CHECK_RESULT $? 1 0 "L$LINENO: INET No Pass. Port $port still in use."
    # MultiType mode in *:$port
    net-server MultiType port "$port" 2>&1 &
    SLEEP_WAIT 1
    netstat -nltp | grep "$port"
    CHECK_RESULT $? 0 0 "L$LINENO: MultiType No Pass"
    kill -9 $(pgrep -f "/bin/net-server")
    # Multiplex mode in *:$port
    net-server Multiplex port "$port" 2>&1 &
    SLEEP_WAIT 1
    netstat -nltp | grep "$port"
    CHECK_RESULT $? 0 0 "L$LINENO: Multiplex No Pass"
    kill -9 $(pgrep -f "/bin/net-server")
    # PreForkSimple mode in *:$port
    net-server PreForkSimple port "$port" 2>&1 &
    SLEEP_WAIT 1
    netstat -nltp | grep "$port"
    CHECK_RESULT $? 0 0 "L$LINENO: PreForkSimple No Pass"
    kill -9 $(pgrep -f "/bin/net-server")
    # PreFork mode in *:$port
    net-server PreFork port "$port" 2>&1 &
    SLEEP_WAIT 1
    netstat -nltp | grep "$port"
    CHECK_RESULT $? 0 0 "L$LINENO: PreFork No Pass"
    kill -9 $(pgrep -f "/bin/net-server")
    # Single mode in *:$port
    net-server Single port "$port" 2>&1 &
    SLEEP_WAIT 1
    netstat -nltp | grep "$port"
    CHECK_RESULT $? 0 0 "L$LINENO: Single No Pass"
    kill -9 $(pgrep -f "/bin/net-server")
    # HTTP mode in *:$port
    net-server HTTP port "$port" 2>&1 &
    SLEEP_WAIT 1
    netstat -nltp | grep "$port"
    CHECK_RESULT $? 0 0 "L$LINENO: Http No Pass"
    kill -9 $(pgrep -f "/bin/net-server")
    # -app
    net-server HTTP port "$port" app "$PWD"/app.cgi 2>&1 &
    SLEEP_WAIT 1
    netstat -nltp | grep "$port"
    CHECK_RESULT $? 0 0 "L$LINENO: app No Pass"
    curl 127.0.0.1:"$port" 2>&1 | grep "Test success"
    CHECK_RESULT $? 0 0 "L$LINENO: app No Pass. Failed to get data from net-server"
    kill -9 $(pgrep -f "/bin/net-server")
    # ipv4 only
    net-server host localhost/IPv4 port "$port" app app.cgi 2>&1 &
    SLEEP_WAIT 1
    netstat -nltp | grep "$port"
    CHECK_RESULT $? 0 0 "L$LINENO: IPv4 No Pass"
    kill -9 $(pgrep -f "/bin/net-server")
    # ipv6 only
    net-server host localhost/IPv6 port "$port" 2>&1 &
    SLEEP_WAIT 1
    netstat -nltp | grep "$port" | grep "::1"
    CHECK_RESULT $? 0 0 "L$LINENO: IPv6 No Pass"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    kill -9 $(pgrep -f "/bin/net-server")
    DNF_REMOVE "$@"
    rm -rf app.cgi
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
