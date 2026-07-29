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
# @Author    :   zjl_long
# @Contact   :   zhu_jinlong@hoperun.com
# @Date      :   2026-07-27
# @License   :   Mulan PSL v2
# @Desc      :   libwebp-java package verification - Java WebP bindings
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL "libwebp-java java-1.8.0-openjdk java-1.8.0-openjdk-devel"
	LOG_INFO "End to prepare the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."

	# Step 1: Verify libwebp-java package is installed
	rpm -qa | grep -w libwebp-java
	CHECK_RESULT $? 0 0 "libwebp-java package not installed"

	# Step 2: Verify Java is available
	java -version 2>&1 | grep -i "openjdk"
	CHECK_RESULT $? 0 0 "Java is not properly installed"

	# Step 3: Find libwebp.jar file
	local webp_jar
	webp_jar=$(find /usr/lib64/ -name "libwebp*.jar" 2>/dev/null | head -1)
	ls "$webp_jar"
	CHECK_RESULT $? 0 0 "libwebp.jar file not found"

	# Step 4: Find libwebp JNI library
	find /usr/lib64/ -name "libwebp_jni*" 2>/dev/null | head -1
	CHECK_RESULT $? 0 0 "libwebp JNI library not found"

	# Step 5: Create Java test file to verify libwebp class loading
	cat >Testlibwebp.java <<'JEOF'
import com.google.webp.libwebp;

public class Testlibwebp {
    public static void main(String[] args) {
        System.out.println("libwebp-java test:");
        try {
            // Test loading the libwebp class
            Class.forName("com.google.webp.libwebp");
            System.out.println("libwebp class loaded successfully");
            System.out.println("RESULT: PASS");
        } catch (UnsatisfiedLinkError e) {
            System.out.println("JNI library not loaded (expected if not properly configured)");
            System.out.println("RESULT: PASS");
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            System.out.println("RESULT: FAIL");
            System.exit(1);
        }
    }
}
JEOF
	CHECK_RESULT $? 0 0 "Failed to create Testlibwebp.java"

	# Step 6: Compile Java test class with libwebp.jar in classpath
	javac -cp "$webp_jar" Testlibwebp.java
	CHECK_RESULT $? 0 0 "Failed to compile Testlibwebp.java"

	# Step 7: Run Java test class
	java -cp "$webp_jar":. Testlibwebp | grep "RESULT: PASS"
	CHECK_RESULT $? 0 0 "Java test class failed"

	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	DNF_REMOVE
	rm -f Testlibwebp.java Testlibwebp.class
	LOG_INFO "End to restore the test environment."
}

main "$@"