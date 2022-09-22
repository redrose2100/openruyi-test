#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   guheping
#@Contact   :   867559702@qq.com
#@Date      :   2022/9/15
#@License   :   Mulan PSL v2
#@Desc      :   Test "speech-dispatcher" command
###################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "speech-dispatcher"
    LOG_INFO "End to prepare the test environment"
}
##########################################################
#Usage: speech-dispatcher [-{d|s}] [-l {1|2|3|4|5}] [-c com_method] [-S socket_path] [-p port] [-t timeout] | [-v] | [-h]
#Speech Dispatcher -- Common interface for Speech Synthesis (GNU GPL)
#
#-d, --run-daemon	Run as a daemon
#-s, --run-single	Run as single application
#-a, --spawn		Start only if autospawn is not disabled
#-l, --log-level		Set log level (between 1 and 5)
#-L, --log-dir		Set path to logging
#-c, --communication-method	Communication method to use ('unix_socket' or 'inet_socket')
#-S, --socket-path	Socket path to use for 'unix_socket' method (filesystem path or 'default')
#-p, --port		Specify a port number for 'inet_socket' method
#-t, --timeout		Set time in seconds for the server to wait before it shuts down,
#			if it has no clients connected
#-P, --pid-file		Set path to pid file
#-C, --config-dir	Set path to configuration
#-m, --module-dir	Set path to modules
#-v, --version		Report version of this program
#-D, --debug		Output debugging information into $TMPDIR/speechd-debug if TMPDIR is exported, otherwise to /tmp/speechd-debug
#-h, --help		Print this info
#
#Copyright (C) 2002-2012 Brailcom, o.p.s.
#This is free software; you can redistribute it and/or modify it
#under the terms of the GNU General Public License as published by
#the Free Software Foundation; either version 2, or (at your option)
#any later version. Please see COPYING for more details.
#
#Please report bugs to speechd@lists.freebsoft.org
##########################################################
function run_test() {
    LOG_INFO "Start to run testcase:oe_test_pyjunitxml."
    ### -h ###
    speech-dispatcher -h | grep "Usage: speech-dispatcher"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### -v ###
    speech-dispatcher -v | grep "speech-dispatcher"
    CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
    ### -d ###
    speech-dispatcher -d | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -d No Pass"
    ### -s ###
    speech-dispatcher -s | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
    ### -a ###
    speech-dispatcher -a | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -a No Pass"
    ### -l ###
    speech-dispatcher -l 1 | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### -L ###
    speech-dispatcher -L ./ | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -L No Pass"
    ### -c ###
    speech-dispatcher -c unix_socket | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -c No Pass"
    ### -S ###
    speech-dispatcher -S default | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -S No Pass"
    ### -p ###
    speech-dispatcher -p 789 | grep "starting"
    CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
