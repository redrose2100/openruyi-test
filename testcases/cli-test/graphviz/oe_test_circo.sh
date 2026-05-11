#!/usr/bin/bash

# Copyright (c) 2025 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2025.06.23
# @License   :   Mulan PSL v2
# @Desc      :   circo command test, for generating graphs
# ############################################


source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "graphviz"

    cat > test_graph.dot << 'EOF'
digraph test {
    A;
    B;
    C;
    D;
    A -> B;
    B -> C;
    C -> D;
    D -> A;
}
EOF
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    # Test if circo is installed
    which circo
    CHECK_RESULT $? 0 0 "circo command not found"

    # Test circo version
    circo -V 2>&1 | grep "circo"
    CHECK_RESULT $? 0 0 "circo version check failed"

    # Test generate PNG output
    circo -Tpng test_graph.dot -o test_circo.png
    CHECK_RESULT $? 0 0 "circo PNG generation failed"
    test -f test_circo.png
    CHECK_RESULT $? 0 0 "circo PNG output file not created"

    # Test circo with SVG output
    circo -Tsvg test_graph.dot -o test_circo.svg
    CHECK_RESULT $? 0 0 "circo SVG generation failed"
    test -f test_circo.svg
    CHECK_RESULT $? 0 0 "circo SVG output file not created"

    # Test circo with PDF output
    circo -Tpdf test_graph.dot -o test_circo.pdf
    CHECK_RESULT $? 0 0 "circo PDF generation failed"
    test -f test_circo.pdf
    CHECK_RESULT $? 0 0 "circo PDF output file not created"

    # Test circo with different layout options
    circo -Gstart=random test_graph.dot -o test_circo_random.png
    CHECK_RESULT $? 0 0 "circo with random start failed"
    test -f test_circo_random.png
    CHECK_RESULT $? 0 0 "circo random output file not created"

    # Test circo help
    circo -? 2>&1 | grep -i "usage\|help"
    CHECK_RESULT $? 0 0 "circo help not working"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    rm -f test_graph.dot test_circo.png test_circo.svg test_circo.pdf test_circo_random.png
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
