#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.4.4
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-httplib2
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."

    cat > /tmp/run.py  <<EOF
import unittest
import httplib2
class MyTestCase(unittest.TestCase):
    TEST_DOMAIN = "https://baidu.com"

    def test_get(self):
        h = httplib2.Http()
        resp, content = h.request(self.TEST_DOMAIN, "GET")
        #h.close()
        self.assertEqual(resp.status, 200)

    def test_put(self):
        h = httplib2.Http()
        resp, content = h.request(self.TEST_DOMAIN, "PUT")
        #h.close()
        self.assertEqual(resp.status, 405)

    def test_delete(self):
        h = httplib2.Http()
        resp, content = h.request(self.TEST_DOMAIN, "DELETE")
        #h.close()
        self.assertEqual(resp.status, 405)

    def test_post(self):
        h = httplib2.Http()
        resp, content = h.request(self.TEST_DOMAIN, "POST")
        #h.close()
        self.assertEqual(resp.status, 302)

    def test_unknow(self):
        h = httplib2.Http()
        resp, content = h.request(self.TEST_DOMAIN, "unknow")
        #h.close()
        self.assertEqual(resp.status, 302)

if __name__ == '__main__':
    unittest.main()
EOF
    DNF_INSTALL "python2-httplib2 python3-httplib2"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep httplib2
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && python3 run.py > /tmp/python3_test 2>&1 && python2 run.py > /tmp/python2_test 2>&1
    test -f /tmp/python2_test -a -f /tmp/python3_test
    CHECK_RESULT $? 0 0 "Generate test fail "
    grep "Ran 5 tests" /tmp/python2_test
    CHECK_RESULT $? 0 0 "python2_test is error"
    grep "Ran 5 tests" /tmp/python3_test
    CHECK_RESULT $? 0 0 "python3_test is error"   
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/run.py /tmp/python3_test /tmp/python2_test
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main $@

