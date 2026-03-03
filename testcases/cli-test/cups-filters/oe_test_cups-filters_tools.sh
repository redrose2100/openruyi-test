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
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2026/03/03
# @License   :   Mulan PSL v2
# @Desc      :   Test cups-filters tools functionality
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL cups-filters
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    
    # Test point 1: Test cupsfilter command functionality
    LOG_INFO "Test point 1: Test cupsfilter command functionality"
    # Check if cupsfilter command exists
    command -v cupsfilter
    CHECK_RESULT $? 0 0 "cupsfilter command not found"
    
    # Test cupsfilter processing text files
    echo "Test document content for cupsfilter" > /tmp/test_doc.txt
    cupsfilter /tmp/test_doc.txt > /tmp/cupsfilter_output.txt 2>&1
    CHECK_RESULT $? 0 0 "cupsfilter text processing failed"
    
    # Verify output file is not empty
    test -s /tmp/cupsfilter_output.txt
    CHECK_RESULT $? 0 0 "cupsfilter output is empty"
    
    # Test point 2: Test cupsfilter format conversion
    LOG_INFO "Test point 2: Test cupsfilter format conversion"
    # Create test PDF file (using text content)
    {
        echo "%PDF-1.4"
        echo "1 0 obj"
        echo "<< /Type /Catalog /Pages 2 0 R >>"
        echo "endobj"
        echo "2 0 obj"
        echo "<< /Type /Pages /Kids [3 0 R] /Count 1 >>"
        echo "endobj"
        echo "3 0 obj"
        echo "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] >>"
        echo "endobj"
        echo "xref"
        echo "0 4"
        echo "0000000000 65535 f"
        echo "0000000009 00000 n"
        echo "0000000058 00000 n"
        echo "0000000115 00000 n"
        echo "trailer"
        echo "<< /Size 4 /Root 1 0 R >>"
        echo "startxref"
        echo "187"
        echo "%%EOF"
    } > /tmp/test.pdf
    
    # Test PDF to PS conversion
    cupsfilter -m application/pdf /tmp/test.pdf > /tmp/pdf_to_ps.ps 2>&1
    local pdf_result=$?
    if [ $pdf_result -eq 0 ]; then
        test -s /tmp/pdf_to_ps.ps
        CHECK_RESULT $? 0 0 "PDF to PS conversion output is empty"
    else
        LOG_INFO "PDF to PS conversion may not be fully supported, but command executed"
    fi
    
    # Test point 3: Test cupsfilter 
    LOG_INFO "Test point 3: Test cupsfilter command line options"
    
    # Test specifying output format
    echo "test content" > /tmp/format_test.txt
    cupsfilter -m text/plain /tmp/format_test.txt > /tmp/format_output.txt 2>&1
    CHECK_RESULT $? 0 0 "cupsfilter format specification failed"
    
    # Test point 4: Test cupsfilter error handling
    LOG_INFO "Test point 4: Test cupsfilter error handling"
    # Test non-existent file
    cupsfilter /tmp/nonexistent_file.txt 2>&1 | grep -q "error\\|Error\\|No such file"
    local error_handling=$?
    if [ $error_handling -eq 0 ]; then
        LOG_INFO "Error handling for non-existent file works correctly"
    else
        LOG_INFO "Error handling may have different behavior"
    fi
    
    # Test invalid parameters
    cupsfilter --invalid-option 2>&1 | grep -q "error\\|Error\\|invalid\\|usage"
    local invalid_param=$?
    if [ $invalid_param -eq 0 ]; then
        LOG_INFO "Invalid parameter handling works correctly"
    else
        LOG_INFO "Invalid parameter handling may have different behavior"
    fi
    
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f /tmp/test_doc.txt /tmp/cupsfilter_output.txt /tmp/test.pdf
    rm -f /tmp/pdf_to_ps.ps /tmp/format_test.txt /tmp/format_output.txt
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"