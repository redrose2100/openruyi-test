#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangxi
# @Contact   :   yangxi@uniontech.com
# @Date      :   2026-01-14
# @License   :   Mulan PSL v2
# @Desc      :   graphviz function verification
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8  
    DNF_INSTALL graphviz
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    cat > first.dot << \EOF
digraph first2{
a;
b;
c;
d;
a->b;
b->d;
c->d;
}
EOF
    test -e  first.dot    
    CHECK_RESULT $? 0 0  "check first.dot is fail"
    dot -Tpdf first.dot -o first.pdf
    CHECK_RESULT $? 0 0 "Failed to convert DOT to PDF"
    test -e first.pdf
    CHECK_RESULT $? 0 0 "PDF file not created"
    dot -Tsvg first.dot -o first.svg
    CHECK_RESULT $? 0 0 "Failed to convert DOT to SVG"
    test -e first.svg
    CHECK_RESULT $? 0 0 "SVG file not created"
    neato -Tpng first.dot -o first.png
    CHECK_RESULT $? 0 0 "Failed to use neato layout engine"
    test -e first.png
    CHECK_RESULT $? 0 0 "neato layout image not created"
    cat > complex.dot << \EOF
digraph complex_graph {
    node [shape=box, style=filled, fillcolor=lightblue];
    edge [color=red, penwidth=2.0];
    
    A [label="Start Node"];
    B [label="Process", shape=ellipse, fillcolor=yellow];
    C [label="Decision", shape=diamond];
    D [label="End Node", shape=doublecircle];
    
    A -> B [label="begin"];
    B -> C [label="process"];
    C -> D [label="yes"];
    C -> B [label="no"];
}
EOF
    dot -Tpng complex.dot -o complex.png
    CHECK_RESULT $? 0 0 "Failed to create complex graph"
    test -e complex.png
    CHECK_RESULT $? 0 0 "Complex graph image not created"
    dot -V 2>&1 | grep -q "dot - graphviz"
    CHECK_RESULT $? 0 0 "Failed to get graphviz version info"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    rm -rf first.*
    # shellcheck disable=SC2119
    DNF_REMOVE 
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

