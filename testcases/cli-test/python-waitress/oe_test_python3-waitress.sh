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
# @Author    :   caowenqian
# @Contact   :   caowenqian@uniontech.com
# @Date      :   2024/01/16
# @License   :   Mulan PSL v2
# @Desc      :   Test python3-waitress function
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "python3-waitress python3-flask python3-requests"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat >pss_app.py<<EOF
import logging
from flask import Flask

app = Flask(__name__)


@app.route('/')
def index():
# 这样写日志
    logging.info("myendpoint We are computering now")
    return 'We are computering now'


@app.route('/server_status_code')
def server_status_code():

    return "ok"
EOF
    test -f  pss_app.py
    CHECK_RESULT $? 0 0 "Create pss_app.py file fail"
    cat >pss_waitress.py<<EOF
import logging.handlers
import logging
LOG_FILE = "test_log.log"
log_format = "[%(levelname)s] %(asctime)s [%(filename)s:%(lineno)d, %(funcName)s] %(message)s"
logging.basicConfig(filename=LOG_FILE,
filemode="a",
format=log_format,
level=logging.INFO)
time_hdls = logging.handlers.TimedRotatingFileHandler(
    LOG_FILE, when='D', interval=1, backupCount=7)
logging.getLogger().addHandler(time_hdls)

logging.info("begin service")

import requests
from pss_app import app
from waitress import serve

DEPLOY_PORT = 8080


def process_is_alive():

    try:
        r = requests.get(f"http://127.0.0.1:{DEPLOY_PORT}/server_status_code")
        if r.status_code == 200 and r.text == "ok":
            return True
        return False
    except Exception as e:
        return False


if __name__ == "__main__":
    logging.info("try check and start app, begin")
    if process_is_alive():
        logging.info("process_is_alive_noneed_begin")
    else:
        logging.info("process_is_not_alive_begin_new")
        serve(app, host='0.0.0.0', port=DEPLOY_PORT, threads=30) # WAITRESS!

    logging.info("try check and start app, end")
EOF
    test -f pss_waitress.py
    CHECK_RESULT $? 0 0 "Create pss_waitress.py file fail"
    timeout 10s python3 pss_waitress.py
    test -f test_log.log
    CHECK_RESULT $? 0 0 " pss_waitress.py file not exit"
    grep "Serving on http://0.0.0.0:8080" test_log.log
    CHECK_RESULT $? 0 0 "Execution fail"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf pss_app.py pss_waitress.py test_log.log
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
