#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   fuyahong
# @Contact   :   fuyahong@uniontech.com
# @Date      :   2025/06/23
# @License   :   Mulan PSL v2
# @Desc      :   Test enscript use 02
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
	LOG_INFO "Start environmental preparation."
	DNF_INSTALL "enscript"
	LOG_INFO "End of environmental preparation!"
}

function run_test() {
	LOG_INFO "Start testing..."
	# 标准输入
	echo "test stdin" | enscript -o output_stdin.ps
	CHECK_RESULT $? 0 0 "check stdin input failed"

	cat  > input.txt  << EOF
enscript-1.6.6-22.uel20	安全漏洞	CVE-2018-17942	8.8
git-2.27.0-22.uel20	       安全漏洞	CVE-2024-52005	7.5
rsync-3.1.3-11.uel20	安全漏洞	CVE-2024-12085	7.5
tinyxml-2.6.2-25.uel20	安全漏洞	CVE-2023-34194	7.5
EOF
	# 多栏输出
	enscript --columns=2 -o output_columns.ps input.txt
	CHECK_RESULT $? 0 0 "check --columns failed"
	# 横向输出
	enscript --landscape -o output_landscape.ps input.txt
	CHECK_RESULT $? 0 0 "check --landscape failed"
	# 行号
	enscript --line-numbers -o output_linenum.ps input.txt
	CHECK_RESULT $? 0 0 "check --line-numbers failed"
	# 错误输入文件
	enscript nofile.txt 2>&1 | grep -i "No such file"
	CHECK_RESULT $? 0 0 "check non-existent file failed"
	LOG_INFO "Finish test!"

}

function post_test() {
	LOG_INFO "start environment cleanup."
	rm -rf input.txt output*.ps 
	DNF REMOVE "$@"
	LOG_INFO "Finish environment cleanup!"
}

main "$@"
