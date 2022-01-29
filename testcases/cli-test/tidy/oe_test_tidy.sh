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
# @Date      :   2022/1/24
# @License   :   Mulan PSL v2
# @Desc      :   Test iftop text mode
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL tidy
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    # 依据手册中的章节划分，编写测试样例
    # 不同章节间以双行间隔
    # 选项有两种用法，一是在命令行中直接使用，二是写进配置文件中
    # 选项在两种用法中的名称不尽相同
    # 在一些测试项中将警报和错误信息定向到了 /dev/null/ 中，避免过多信息涌入日志
    # 在一些测试中使用 grep -F，只匹配固定字符串，不使用正则表达式


    # File manipulation 部分
    # 将处理结果写入指定文件
    echo '<h1>hello' | tidy -o ./tidied.html
    grep -F '<h1>hello</h1>' ./tidied.html
    CHECK_RESULT $? 0 0 "Failed to use option: -o"
    echo '<h1>hello' | tidy -output ./tidied.html
    grep -F '<h1>hello</h1>' ./tidied.html
    CHECK_RESULT $? 0 0 "Failed to use option: -output"
    echo 'output-file: tidied.html' >./tidyrc
    echo '<h1>hello' | tidy -config ./tidyrc
    grep -F '<h1>hello</h1>' ./tidied.html
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: output-file"
    # 使用指定的配置文件
    # -config
    echo 'add-meta-charset: yes' > ./tidyrc
    echo '<h1>hello' | tidy -config ./tidyrc | grep '<meta charset=".*">'
    CHECK_RESULT $? 0 0 "Failed to use option: -config"
    # 将错误和警告写入指定文件
    # -f, -file, error-file
    echo '<h1>hello' | tidy -f ./errors_and_warnings
    grep -F 'Warning' ./errors_and_warnings
    CHECK_RESULT $? 0 0 "Failed to use option: -f"
    echo '<h1>hello' | tidy -file ./errors_and_warnings
    grep -F 'Warning' ./errors_and_warnings
    CHECK_RESULT $? 0 0 "Failed to use option: -file"
    echo 'error-file: errors_and_warnings' > ./tidyrc
    echo '<h1>hello' | tidy -config ./tidyrc
    grep -F 'Warning' ./errors_and_warnings
    CHECK_RESULT $? 0 0 "Failed to use option: -file"

    # 将处理过的结果写入源文件
    # -m, -modify, write-back
    echo '<h1>hello' > sample.html
    tidy -m ./sample.html
    grep -F '<h1>hello</h1>' ./tidied.html
    CHECK_RESULT $? 0 0 "Failed to use option: -m"
    echo '<h1>hello' > sample.html
    tidy -modify ./sample.html
    grep -F '<h1>hello</h1>' ./tidied.html
    CHECK_RESULT $? 0 0 "Failed to use option: -modify"
    echo 'write-back: yes' >./tidyrc 
    echo '<h1>hello' > sample.html
    tidy -config ./tidyrc ./sample.html
    grep -F '<h1>hello</h1>' ./tidied.html
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: write-back"


    # Processing directives 部分
    # 缩进代码
    # -indent, -i, indent
    # 缩进代码后，<h1> 标签的左侧被插入了一个空格
    # 将错误和警告写入 /dev/null，则不会影响后续的判断语句
    echo '<h1>hello' | tidy -i | grep -F ' <h1>hello</h1>'
    CHECK_RESULT $? 0 0 "Failed to use option: -i"
    echo '<h1>hello' | tidy -indent | grep -F ' <h1>hello</h1>'
    CHECK_RESULT $? 0 0 "Failed to use option: -indent"
    echo 'indent: auto' >./tidyrc
    echo '<h1>hello' | tidy -config ./tidyrc | grep -F ' <h1>hello</h1>'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: indent"
    # 以指定的长度折叠文本内容
    # 根据输出的结果中，单词 Tidy 的同一列，下一行的位置上是否为 application 判断折叠的效果
    # -w, -wrap, wrap
    echo 'Tidy is a console application for macOS, Linux, Windows, UNIX, and more. It corrects and cleans up HTML and XML documents by fixing markup errors and upgrading legacy code to modern standards.' | tidy -w 30 | grep -A 1 'Tidy' | grep 'application'
    CHECK_RESULT $? 0 0 "Failed to use option: -w"
    echo 'Tidy is a console application for macOS, Linux, Windows, UNIX, and more. It corrects and cleans up HTML and XML documents by fixing markup errors and upgrading legacy code to modern standards.' | tidy -wrap 30 | grep -A 1 'Tidy' | grep 'application'
    CHECK_RESULT $? 0 0 "Failed to use option: -wrap"
    echo 'wrap: 30' > ./tidyrc
    echo 'Tidy is a console application for macOS, Linux, Windows, UNIX, and more. It corrects and cleans up HTML and XML documents by fixing markup errors and upgrading legacy code to modern standards.' | tidy -config ./tidyrc | grep -A 1 'Tidy' | grep 'application'
    # 标签大写
    # -u, -upper, uppercase-tags
    echo '' | tidy -u | grep '<HTML>'
    CHECK_RESULT $? 0 0 "Failed to use option: -u"
    echo '' | tidy -upper | grep '<HTML>'
    CHECK_RESULT $? 0 0 "Failed to use option: -upper"
    echo 'uppercase-tags: yes' > ./tidyrc
    echo '' | tidy -config ./tidyrc | grep '<HTML>'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: uppercase-tags"
    # 清理已弃用的标签
    # -c, -clean, clean
    echo '<center>hello</center>' | tidy -c | grep 'text-align: center'
    CHECK_RESULT $? 0 0 "Failed to use option: -c"
    echo '<center>hello</center>' | tidy -clean | grep 'text-align: center'
    CHECK_RESULT $? 0 0 "Failed to use option: -clean"
    echo 'clean: yes' > ./tidyrc
    echo '<center>hello</center>' | tidy -config ./tidyrc | grep 'text-align: center'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: clean"
    # strip out smart quotes and em dashes, etc.
    # -b, -bare, bare
    echo '—' | tidy -b | grep '-'
    CHECK_RESULT $? 0 0 "Failed to use option: -b"
    echo '—' | tidy -bare | grep '-'
    CHECK_RESULT $? 0 0 "Failed to use option: -bare"
    echo 'bare: yes' > ./tidyrc
    echo '—' | tidy -config ./tidyrc | grep '-'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: bare"
    # -gdoc, -g, gdoc
    # produce clean version of html exported by Google Docs
    # 对比清理前后，文件的代码量，判断清理的效果
    source_code='<html><head><meta content="text/html; charset=UTF-8" http-equiv="content-type"><style type="text/css">ol{margin:0;padding:0}table td,table th{padding:0}.c2{color:#000000;font-weight:400;text-decoration:none;vertical-align:baseline;font-size:26pt;font-family:"Arial";font-style:normal}.c1{padding-top:0pt;padding-bottom:3pt;line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:center}.c0{background-color:#ffffff;max-width:451.4pt;padding:72pt 72pt 72pt 72pt}.title{padding-top:0pt;color:#000000;font-size:26pt;padding-bottom:3pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:left}.subtitle{padding-top:0pt;color:#666666;font-size:15pt;padding-bottom:16pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:left}li{color:#000000;font-size:11pt;font-family:"Arial"}p{margin:0;color:#000000;font-size:11pt;font-family:"Arial"}h1{padding-top:20pt;color:#000000;font-size:20pt;padding-bottom:6pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:left}h2{padding-top:18pt;color:#000000;font-size:16pt;padding-bottom:6pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:left}h3{padding-top:16pt;color:#434343;font-size:14pt;padding-bottom:4pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:left}h4{padding-top:14pt;color:#666666;font-size:12pt;padding-bottom:4pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:left}h5{padding-top:12pt;color:#666666;font-size:11pt;padding-bottom:4pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:left}h6{padding-top:12pt;color:#666666;font-size:11pt;padding-bottom:4pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;font-style:italic;orphans:2;widows:2;text-align:left}</style></head><body class="c0"><p class="c1 title" id="h.1osv7rxmcj4i"><span class="c2">Hello World</span></p></body></html>'
    # 原始 gdoc 文本的代码数量
    gdoc_char_num=$(echo "${source_code}" | wc -m)
    # 经过 tidy 后的代码数量
    tidied_char_num=$(echo "${source_code}" | tidy -g | wc -m)
    [[ $tidied_char_num -lt $gdoc_char_num ]]
    CHECK_RESULT $? 0 0 "Failed to use option: -g"
    tidied_char_num=$(echo "${source_code}" | tidy -gdoc | wc -m)
    [[ $tidied_char_num -lt $gdoc_char_num ]]
    CHECK_RESULT $? 0 0 "Failed to use option: -gdoc"
    echo 'gdoc: yes' > ./tidyrc
    tidied_char_num=$(echo "${source_code}" | tidy -config ./tidyrc | wc -m)
    [[ $tidied_char_num -lt $gdoc_char_num ]]
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: gdoc"
    # 是否以数字而非名字输出 HTML 实体
    # -numeric, -n, numeric-entities
    echo '&nbsp;' | tidy -n | grep '&#160'
    CHECK_RESULT $? 0 0 "Failed to use option: -n"
    echo '&nbsp;' | tidy -numeric | grep '&#160'
    CHECK_RESULT $? 0 0 "Failed to use option: -numeric"
    echo 'numeric-entities: yes' > ./tidyrc
    echo '&nbsp;' | tidy -config ./tidyrc | grep '&#160'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: numeric-entities"
    # 只输出错误信息
    # errors, -e, markup
    echo '' | tidy -e | grep '<html>'
    CHECK_RESULT $? 1 0 "Failed to use option: -e"
    echo '' | tidy -errors | grep '<html>'
    CHECK_RESULT $? 1 0 "Failed to use option: -errors"
    echo 'markup: no' > ./tidyrc
    echo '' | tidy -config ./tidyrc | grep '<html>'
    CHECK_RESULT $? 1 0 "Failed to use option in configuration: markup"
    # 关闭不重要的信息
    # -quiet, -q, quiet
    echo '' | tidy -q | grep 'Info'
    CHECK_RESULT $? 1 0 "Failed to use option: -q"
    echo '' | tidy -quiet | grep 'Info'
    CHECK_RESULT $? 1 0 "Failed to use option: -quiet"
    echo 'quiet: yes' > ./tidyrc
    echo '' | tidy -config ./tidyrc | grep 'Info'
    CHECK_RESULT $? 1 0 "Failed to use option in configuration: quiet"
    # 在输出中省略标签： <html>, <head>, <body>, </p>, </li>, </dt>, </dd>, </option>, </tr>, </td>, and </th>.
    # -omit, omit-optional-tags
    # 测试输出结果中是否不存在 <html> 标签，若不存在，则 grep 匹配不到，故 CHECK_RESULT $? 1 0
    echo '' | tidy -omit | grep '<html>'
    CHECK_RESULT $? 1 0 "Failed to use option: -omit"
    echo 'omit-optional-tags: yes' > ./tidyrc
    echo '' | tidy -config ./tidyrc | grep '<html>'
    CHECK_RESULT $? 1 0 "Failed to use option in configuration: omit-optional-tags"
    # 指定输入的内容是格式良好的 XML
    # -xml, input-xml
    echo '<note><body>hello</body></note>' | tidy -xml 2>&1 | grep 'No warnings or errors were found.'
    CHECK_RESULT $? 0 0 "Failed to use option: -xml"
    echo 'input-xml: yes' > ./tidyrc
    echo '<note><body>hello</body></note>' | tidy -config ./tidyrc 2>&1 | grep 'No warnings or errors were found.'
    CHECK_RESULT $? 0 0 "Failed to use option in configuration: input-xml"
    # 输出为 XML
    # -asxml, -asxhtml (output-xhtml: yes)
    # 让 tidy 将标签格式化为大写，XML 标准中严格规定元素名必须为小写，则最后的结果为小写
    echo '<p>hello</p>' | tidy -upper -asxml | grep '<p>hello</p>'
    CHECK_RESULT $? 0 0 "Failed to use option: -asxml"
    echo '<p>hello</p>' | tidy -upper -asxhtml | grep '<p>hello</p>'
    CHECK_RESULT $? 0 0 "Failed to use option: -asxhtml"
    echo 'output-xhtml: yes' > ./tidyrc
    echo '<p>hello</p>' | tidy -upper -config ./tidyrc | grep '<p>hello</p>'
    CHECK_RESULT $? 0 0 "Failed to use option: output-xhtml"


    # Miscellaneous 部分
    tidy -v | grep 'HTML Tidy for Linux version' | grep '[[:digit:]]*'
    CHECK_RESULT $? 0 0 "Failed to use option: -v"
    tidy -version | grep 'HTML Tidy for Linux version' | grep '[[:digit:]]*'
    CHECK_RESULT $? 0 0 "Failed to use option: -version" 
    # 帮助文档
    tidy -h | grep -F 'tidy [options...] [file...] [options...] [file...]'
    CHECK_RESULT $? 0 0 "Failed to use option: -h"
    tidy -help | grep -F 'tidy [options...] [file...] [options...] [file...]'
    CHECK_RESULT $? 0 0 "Failed to use option: -help"
    exit 0
    tidy -? | grep -F 'tidy [options...] [file...] [options...] [file...]'
    CHECK_RESULT $? 0 0 "Failed to use option: -?"
    tidy -help-config | grep 'HTML Tidy Configuration Settings'
    CHECK_RESULT $? 0 0 "Failed to use option: -help-config"
    # 与 tidy 有关的环境变量
    tidy -help-env | grep 'Tidy can configure its option values from multiple sources'
    CHECK_RESULT $? 0 0 "Failed to use option: -help-env"
    tidy -help-option add-meta-charset | grep 'This option, when enabled'
    CHECK_RESULT $? 0 0 "Failed to use option: -help-option"
    # 配置选项
    # 默认的配置
    tidy -export-default-config | grep 'add-meta-charset' | grep 'no'
    CHECK_RESULT $? 0 0 "Failed to use option: -export-default-config"
    # 自定义的配置
    echo 'add-meta-charset: yes' > ./tidyrc
    # 展示当前的配置
    tidy -config ./tidyrc -show-config | grep 'add-meta-charset' | grep 'yes'
    CHECK_RESULT $? 0 0 "Failed to use option: -show-config"
    # 以配置文件的格式展示当前的配置
    tidy -config ./tidyrc -export-config | grep 'add-meta-charset' | grep 'yes'
    CHECK_RESULT $? 0 0 "Failed to use option: -export-config"
    # 让 tidy 使用中文进行交互
    echo '<h1>你好</h1>' | tidy -language zh-cn 2>&1 | grep 'Info: 文档内容看起来像 HTML5'
    CHECK_RESULT $? 0 0 "Failed to use option: -language"


    LOG_INFO "Finish test!"
} 

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -f ./tidyrc
    rm -f ./tidied.html
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
