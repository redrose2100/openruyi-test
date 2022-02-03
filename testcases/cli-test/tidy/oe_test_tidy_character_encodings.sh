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
# @Desc      :   Test tidy character encodings
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL tidy
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    # -raw
    # 不转换为实体而直接输出
    # For raw, Tidy will output values above 127 without translating them into entities.
    echo '&yen;' | tidy -raw | grep '¥'
    CHECK_RESULT $? 1 0 "Failed to use option: -raw"
    # -ascii
    # 用 ISO-8859-1 作为输入编码，用 US-ASCII 输出
    # 用 US-ASCII 输出,其实就是以实体标签名的形式进行输出
    # 通过 iconv 将字符转换为 ISO-8859-1 编码格式,再通过 tidy 处理
    echo '½' | iconv -f UTF-8 -t ISO-8859-1 | tidy -ascii | grep '&frac12;'
    CHECK_RESULT $? 0 0 "Failed to use option: -ascii"
    # -latin0
    # 用 ISO-8859-15 作为输入编码, US-ASCII 作为输出
    echo 'Š' | iconv -f UTF-8 -t ISO-8859-15 | tidy -latin0 | grep '&Scaron;'
    CHECK_RESULT $? 0 0 "Failed to use option: -latin0"
    # -latin1
    # 将 ISO-8859-1 作为输入和输出编码
    # 使用 uchardet 对输出结果的编码格式进行检查,ISO-8859-1 会被检出 WINDOWS-1252 的结果
    echo '&#167;' | tidy -latin1 | grep '&sect;'
    echo '½' | iconv -f UTF-8 -t ISO-8859-1 | tidy -f /dev/null -latin1 | grep '<body>' -A 1 --text | uchardet | grep 'WINDOWS-1252'
    CHECK_RESULT $? 0 0 "Failed to use option: -latin1"
    # -iso2022
    # 将 ISO-2022 作为输入和输出编码
    # 选用遵从 ISO 2022 规范的 ISO-2022-KR 作为编码
    echo '도깨비' | iconv -t ISO-2022-KR | tidy -iso2022 -f /dev/null | grep '<body>' -A 1 | uchardet | grep 'ISO-2022-KR'
    CHECK_RESULT $? 0 0 "Failed to use option: -iso2022"
    # -utf8
    # 将 UTF-8 作为输入和输出编码
    echo 'ε' | iconv -t UTF-8| tidy -utf8 -f /dev/null | grep '<body>' -A 1 | uchardet | grep 'UTF-8'
    CHECK_RESULT $? 0 0 "Failed to use option: -utf8"
    # -mac   
    #  用 MacRoman 作为输入编码, US-ASCII 作为输出编码
    echo '¶' | iconv -t MAC-CENTRALEUROPE | tidy -mac | grep '&para;'
    CHECK_RESULT $? 0 0 "Failed to use option: -mac"
    #TODO: check below


    # -win1252
    # 用 Windows-1252 作为输入编码, US-ASCII 作为输出编码
    echo 'œ' | tidy -win1252 | grep '&Aring;&OpenCurlyDoubleQuote;'
    CHECK_RESULT $? 0 0 "Failed to use option: -win1252"
    # -ibm858
    # 用 IBM-858 作为输入编码, US-ASCII 作为输出编码
    echo '&#180;' | tidy -ibm858 | grep '&DiacriticalAcute;'
    CHECK_RESULT $? 0 0 "Failed to use option: -ibm858"

    # -utf16le
    # 用 UTF-16 作为输入和输出编码
    echo 'Ѕ' | tidy -utf16le | grep --text 'Ѕ'
    CHECK_RESULT $? 0 0 "Failed to use option: -utf16le"


    #   -utf16be
    #          use UTF-16BE for both input and output

    #   -utf16 use UTF-16 for both input and output

    #   -big5  use Big5 for both input and output

    #   -shiftjis
    #          use Shift_JIS for both input and output


    # Miscellaneous 部分
    # -v, --version
    tidy -v | grep 'HTML Tidy for Linux version' | grep '[[:digit:]]*'
    CHECK_RESULT $? 0 0 "Failed to use option: -v"
    tidy -version | grep 'HTML Tidy for Linux version' | grep '[[:digit:]]*'
    CHECK_RESULT $? 0 0 "Failed to use option: -version" 

    # -h, -help, -help-config
    tidy -h | grep -F 'tidy [options...] [file...] [options...] [file...]'
    CHECK_RESULT $? 0 0 "Failed to use option: -h"
    tidy -help | grep -F 'tidy [options...] [file...] [options...] [file...]'
    CHECK_RESULT $? 0 0 "Failed to use option: -help"
    exit 0
    tidy -? | grep 'tidy [options...] [file...] [options...] [file...]'
    CHECK_RESULT $? 0 0 "Failed to use option: -?"
    tidy -help-config | grep 'HTML Tidy Configuration Settings'
    CHECK_RESULT $? 0 0 "Failed to use option: -help-config"

    # -help-env, -help-option
    # 与 tidy 有关的环境变量
    tidy -help-env | grep 'Tidy can configure its option values from multiple sources'
    CHECK_RESULT $? 0 0 "Failed to use option: -help-env"
    tidy -help-option add-meta-charset | grep 'This option, when enabled'
    CHECK_RESULT $? 0 0 "Failed to use option: -help-option"

    # -export-default-config
    # 导出默认的配置
    tidy -export-default-config | grep 'add-meta-charset' | grep 'no'
    CHECK_RESULT $? 0 0 "Failed to use option: -export-default-config"

    # -show-config
    # 展示当前的配置
    echo 'add-meta-charset: yes' > ./tidyrc
    tidy -config ./tidyrc -show-config | grep 'add-meta-charset' | grep 'yes'
    CHECK_RESULT $? 0 0 "Failed to use option: -show-config"

    # -export-config
    # 以配置文件的格式展示当前的配置
    tidy -config ./tidyrc -export-config | grep 'add-meta-charset' | grep 'yes'
    CHECK_RESULT $? 0 0 "Failed to use option: -export-config"

    # -language
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
