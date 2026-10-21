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
# @Date      :   2023/11/02
# @License   :   Mulan PSL v2
# @Desc      :   Test exempi function
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "exempi exempi-devel exempi-help"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat >test.xmp<<EOF
<?xpacket begin="?" id="W5M0MpCehiHzreSzNTczkc9d"?>
<x:xmpmeta xmlns:x="adobe:ns:meta/">
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="" xmlns:xmp="http://ns.adobe.com/xap/1.0/">
<xmp:CreatorTool>PyGIF</xmp:CreatorTool>
</rdf:Description>
</rdf:RDF>
</x:xmpmeta>
EOF
    test -f test.xmp
    CHECK_RESULT $? 0 0 "Create test.xmp file fail"
    exempi -o test.xml test.xmp && test -f test.xml
    CHECK_RESULT $? 0 0 "Create test.xml file fail"
    exempi -x test.xml | grep "dump_xmp for file test.xml"
    CHECK_RESULT $? 0 0 "Execution failed"
    exempi -R test.xml
    CHECK_RESULT $? 0 0 "Execution failed"
    exempi -x -p test.xml |grep "dump_xmp for file test.xml"
    CHECK_RESULT $? 0 0 "Execution failed"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf test.xml test.xmp
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
