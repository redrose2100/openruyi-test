#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2023/08/21
# @License   :   Mulan PSL v2
# @Desc      :   python-twisted test
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  DNF_INSTALL "python3-twisted"
  pip3 install PyHamcrest hyperlink Automat incremental constantly zope.interface
  LOG_INFO "Finish preparing the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  mkdir /opt/html
  path=/opt/html
  cat >${path}/index.html <<EOF
<html>
<body>
Hello World!
</body>
</html>
EOF
  cat >${path}/test.html <<EOF
<html>
<body>
Test!
</body>
</html>
EOF
  twistd web -n --port=tcp:8090 --path=/opt/html/
  CHECK_RESULT $? 0 0 "The twistd command is unavailable or port 8090 is occupied"
  curl http://localhost:8090/ | grep "Hello World!"
  CHECK_RESULT $? 0 0 "Unable to access index.html using port 8090"
  curl http://localhost:8090/test.html | grep "Test"
  CHECK_RESULT $? 0 0 "Unable to access test.html using port 8090"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  pid=$(lsof -i:8090 | awk NR==2 | awk '{print $2}')
  kill "$pid"
  pip3 uninstall PyHamcrest hyperlink Automat incremental constantly zope.interface -y
  rm -rf ${path}
  DNF_INSTALL "$@"
  LOG_INFO "Finish restoring the test environment."
}

main "$@"
