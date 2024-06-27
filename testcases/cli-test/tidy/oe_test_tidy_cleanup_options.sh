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
# @Author    :   shangyingjie
# @Contact   :   yingjie@isrc.iscas.ac.cn
# @Date      :   2022/2/8
# @License   :   Mulan PSL v2
# @Desc      :   Test tidy clean options
# #############################################

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL tidy
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    # --bare
    # strip out smart quotes and em dashes, etc.
    echo '—' | tidy --bare true | grep '-'
    CHECK_RESULT $? 0 0 "Failed to use option: --bare"
    echo 'bare: true' >./tidyrc
    echo '—' | tidy -config ./tidyrc | grep '-'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: bare"
    # --clean
    # 清理已弃用的标签
    echo '<center>hello</center>' | tidy --clean true | grep 'text-align: center'
    CHECK_RESULT $? 0 0 "Failed to use option: --clean"
    echo 'clean: true' >./tidyrc
    echo '<center>hello</center>' | tidy -config ./tidyrc | grep 'text-align: center'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: clean"
    # --drop-empty-elements
    # 移除空元素，默认开启
    echo '<h1></h1>' | tidy --drop-empty-elements false | grep '<h1></h1>'
    CHECK_RESULT $? 0 0 "Failed to use option: --drop-empty-elements"
    echo 'drop-empty-elements: false' >./tidyrc
    echo '<p></p>' | tidy -config ./tidyrc | grep '<p></p>'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: drop-empty-elements"
    # --drop-empty-paras
    # 移除空段落（<p> 标签），默认开启
    echo '<p></p>' | tidy --drop-empty-paras false | grep '<p></p>'
    CHECK_RESULT $? 0 0 "Failed to use option: --drop-empty-paras"
    echo 'drop-empty-paras: false' >./tidyrc
    echo '<p></p>' | tidy -config ./tidyrc | grep '<p></p>'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: drop-empty-paras"
    # --drop-proprietary-attributes
    # 丢弃专有特性
    echo '<p what="yes">hi</p>' | tidy --drop-proprietary-attributes true | grep 'what'
    CHECK_RESULT $? 1 0 "Failed to use option: --drop-proprietary-attributes"
    echo 'drop-proprietary-attributes: true' >./tidyrc
    echo '<p what="yes">hi</p>' | tidy -config ./tidyrc | grep 'what'
    CHECK_RESULT $? 1 0 "Failed to use option in configuration: drop-proprietary-attributes"
    # --gdoc
    # 对比清理前后，文件的代码量，判断清理的效果
    source_code='<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>This is title tag</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .content { margin: 20px; }
        .header, .footer { background-color: #f8f8f8; padding: 10px; }
        .main { padding: 10px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>THis is h1 tag</h1>
        <nav>
            <ul>
                <li><a href="#section1">Section 1</a></li>
                <li><a href="#section2">Section 2</a></li>
                <li><a href="#section3">Section 3</a></li>
            </ul>
        </nav>
    </div>
    <div class="content main">
        <section id="section1">
            <h2>Section 1</h2>
            <p>This is a section tag</p>
            <ul>
                <li>Item 1</li>
                <li>Item 2</li>
                <li>Item 3</li>
            </ul>
        </section>
        <section id="section2">
            <h2>Section 2</h2>
            <p>This is section 2</p>
            <img src="example.jpg" alt="Example Image">
            <table>
                <thead>
                    <tr>
                        <th>Header 1</th>
                        <th>Header 2</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Data 1</td>
                        <td>Data 2</td>
                    </tr>
                    <tr>
                        <td>Data 3</td>
                        <td>Data 4</td>
                    </tr>
                </tbody>
            </table>
        </section>
        <section id="section3">
            <h2>Section 3</h2>
            <p>This is section 3</p>
            <form action="/submit" method="post">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email">
                <button type="submit">Submit</button>
            </form>
        </section>
    </div>
    <div class="footer">
        <p>This is a footer tag</p>
    </div>
</body>
</html>
'
    # 原始 gdoc 文本的代码数量
    gdoc_char_num=${#source_code}
    # 经过 tidy 后的代码数量
    tidied_char_num=$(echo "${source_code}" | tidy -gdoc | wc -m)
    [[ $tidied_char_num -lt $gdoc_char_num ]]
    CHECK_RESULT $? 0 0 "Failed to use option: --gdoc"
    echo 'gdoc:yes' >./tidyrc
    tidied_char_num=$(echo "${source_code}" | tidy -config ./tidyrc | wc -m)
    [[ $tidied_char_num -lt $gdoc_char_num ]]
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: gdoc"
    # --logical-emphasis
    # 将 <i>、<em> 和 <b> 标签替换为 <strong> 标签
    echo '<b>hi</b>' | tidy --logical-emphasis true | grep '<strong>hi</strong>'
    CHECK_RESULT $? 0 0 "Failed to use option: --logical-emphasis"
    echo 'logical-emphasis: true' >./tidyrc
    echo '<b>hi</b>' | tidy -config ./tidyrc | grep '<strong>hi</strong>'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: logical-emphasis"
    # --merge-divs
    # 与 -clean 搭配使用，默认开启，用于清理嵌套的 <div> 标签
    echo '<div><div>hi</div></div>' | tidy -clean --merge-divs no | grep -c '/div' | grep '2'
    CHECK_RESULT $? 0 0 "Failed to use option: --merge-divs"
    echo 'merge-divs: no' >./tidyrc
    echo '<div><div>hi</div></div>' | tidy -config ./tidyrc | grep -c '/div' | grep '2'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: merge-divs"
    # -merge-spans
    # 与 -clean 搭配使用，默认开启，用于清理嵌套的 <span> 标签
    echo '<span><span>hi</span></span>' | tidy -clean --merge-spans false | grep '<span><span>hi</span></span>'
    CHECK_RESULT $? 0 0 "Failed to use option: --merge-spans"
    echo 'merge-spans: false' >./tidyrc
    echo '<span><span>hi</span></span>' | tidy -config ./tidyrc | grep '<span><span>hi</span></span>'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: merge-spans"
    # --word-2000
    # 无法使用
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -f ./tidyrc
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
