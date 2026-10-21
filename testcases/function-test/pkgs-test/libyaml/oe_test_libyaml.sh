#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2024.5.13
# @License   :   Mulan PSL v2
# @Desc      :   libyaml formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start environment preparation." 
    mkdir /tmp/libyaml_test   
    cat > /tmp/libyaml_test/yaml_parser.c << EOF
#include <stdio.h>
#include <yaml.h>

int main() {
    yaml_parser_t parser;
    yaml_token_t token;

    // Initialize parser
    yaml_parser_initialize(&parser);
    FILE *file = fopen("example.yaml", "rb");
    yaml_parser_set_input_file(&parser, file);

    // Start parsing
    do {
        yaml_parser_scan(&parser, &token);
        switch (token.type) {
            case YAML_STREAM_START_TOKEN:
                printf("STREAM START\n");
                break;
            case YAML_STREAM_END_TOKEN:
                printf("STREAM END\n");
                break;
            case YAML_KEY_TOKEN:
                printf("KEY: %s\n", token.data.scalar.value);
                break;
            case YAML_VALUE_TOKEN:
                printf("VALUE: %s\n", token.data.scalar.value);
                break;
            case YAML_BLOCK_SEQUENCE_START_TOKEN:
                printf("BLOCK SEQUENCE START\n");
                break;
            case YAML_BLOCK_ENTRY_TOKEN:
                printf("BLOCK ENTRY\n");
                break;
            case YAML_BLOCK_END_TOKEN:
                printf("BLOCK END\n");
                break;
            case YAML_NO_TOKEN:
                printf("NO TOKEN\n");
                break;
            default:
                break;
        }
        if (token.type != YAML_STREAM_END_TOKEN)
            yaml_token_delete(&token);
    } while (token.type != YAML_STREAM_END_TOKEN);

    // Cleanup
    yaml_parser_delete(&parser);
    fclose(file);
    return 0;
}
EOF

    cat > /tmp/libyaml_test/example.yaml<< EOF
key1: value1
key2:
  - item1
  - item2
  - item3
EOF

    DNF_INSTALL "libyaml libyaml-devel libyaml-help gcc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep libyaml
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp/libyaml_test && gcc -o yaml_parser yaml_parser.c -lyaml
    test -f /tmp/libyaml_test/yaml_parser
    CHECK_RESULT $? 0 0 "compile yaml_parser.c fail"
    ./yaml_parser > /tmp/libyaml_test/yaml.txt
    grep "STREAM END" /tmp/libyaml_test/yaml.txt
    CHECK_RESULT $? 0 0 "execute yaml.txt fail"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/libyaml_test
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
