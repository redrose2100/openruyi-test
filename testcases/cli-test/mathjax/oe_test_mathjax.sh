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
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023-12-12
# @License   :   Mulan PSL v2
# @Desc      :   mathjax basic function
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "texlive httpd"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > test.tex << EOF
\documentclass{article}
 \usepackage{amsmath}
 \begin{document}
 Hello, MathJax!
 \[ \int_{0}^{\infty} e^{-x^2} \, dx = \frac{\sqrt{\pi}}{2} \]
 \end{document}
EOF
    CHECK_RESULT $? 0 0 "File creation failed"
    pdflatex test.tex
    CHECK_RESULT $? 0 0 "File creation failed"
    test -f test.pdf
    CHECK_RESULT $? 0 0 "File generation failed"
    systemctl start httpd
    systemctl status httpd
    CHECK_RESULT $? 0 0 "Service startup failed"
    cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>MathJax测试</title>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
    <script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
</head>
<body>
    <h1>MathJax测试</h1>
    <p>下面是一些数学公式的示例：</p>
    <div id="mathjax-container">
        <p>行内公式：\(E = mc^2\)</p>
        <p>块级公式：</p>
        <div>
            \[
            \int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
            \]
        </div>
    </div>
</body>
</html>
EOF
    CHECK_RESULT $? 0 0 "File creation failed"
    curl http://localhost |grep "E = mc"
    CHECK_RESULT $? 0 0 "Web pages viewing Web"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test.tex test.pdf
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"