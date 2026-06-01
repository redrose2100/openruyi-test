#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/05/21
# @License   :   Mulan PSL v2
# @Desc      :   Test tune-mcpserver.service restart
# #############################################
# shellcheck disable=SC1091,SC2119
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "copilot-tune krb5-devel python3-devel python3-ruamel-yaml gcc"
    pip install -i https://repo.huaweicloud.com/repository/pypi/simple/ fastapi numpy openai paramiko pydantic pyyaml scikit-learn tqdm uvicorn requests langchain langchain-openai email-validator httpx tabulate gssapi pandas faiss-cpu pyfiglet mcp wcwidth colorama json5
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution tune-mcpserver.service
    test_reload tune-mcpserver.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop tune-mcpserver.service
    pip uninstall -y fastapi openai pydantic tqdm uvicorn requests langchain langchain-openai email-validator httpx tabulate gssapi faiss-cpu pyfiglet mcp wcwidth json5
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
