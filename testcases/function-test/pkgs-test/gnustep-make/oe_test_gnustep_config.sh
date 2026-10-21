
#!/usr/bin/bash
# 请填写测试用例描述

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gnustep-make"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --variable 参数
    gnustep-config --variable=CC
    CHECK_RESULT $? 0 0 "Failed to get CC variable"
    gnustep-config --variable=CPP
    CHECK_RESULT $? 0 0 "Failed to get CPP variable"
    gnustep-config --variable=CXX
    CHECK_RESULT $? 0 0 "Failed to get CXX variable"
    gnustep-config --variable=OBJCXX
    CHECK_RESULT $? 0 0 "Failed to get OBJCXX variable"
    gnustep-config --variable=LDFLAGS
    CHECK_RESULT $? 0 0 "Failed to get LDFLAGS variable"
    gnustep-config --variable=GNUMAKE
    CHECK_RESULT $? 0 0 "Failed to get GNUMAKE variable"
    gnustep-config --variable=GNUSTEP_MAKEFILES
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_MAKEFILES variable"
    gnustep-config --variable=GNUSTEP_USER_DEFAULTS_DIR
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_USER_DEFAULTS_DIR variable"
    gnustep-config --variable=GNUSTEP_HOST
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_HOST variable"
    gnustep-config --variable=GNUSTEP_HOST_CPU
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_HOST_CPU variable"
    gnustep-config --variable=GNUSTEP_HOST_VENDOR
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_HOST_VENDOR variable"
    gnustep-config --variable=GNUSTEP_HOST_OS
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_HOST_OS variable"
    gnustep-config --variable=GNUSTEP_IS_FLATTENED
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_IS_FLATTENED variable"
    gnustep-config --variable=GNUSTEP_SYSTEM_APPS
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_SYSTEM_APPS variable"
    gnustep-config --variable=GNUSTEP_SYSTEM_TOOLS
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_SYSTEM_TOOLS variable"
    gnustep-config --variable=GNUSTEP_SYSTEM_LIBRARY
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_SYSTEM_LIBRARY variable"
    gnustep-config --variable=GNUSTEP_SYSTEM_HEADERS
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_SYSTEM_HEADERS variable"
    gnustep-config --variable=GNUSTEP_SYSTEM_LIBRARIES
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_SYSTEM_LIBRARIES variable"
    gnustep-config --variable=GNUSTEP_SYSTEM_DOC
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_SYSTEM_DOC variable"
    gnustep-config --variable=GNUSTEP_SYSTEM_DOC_MAN
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_SYSTEM_DOC_MAN variable"
    gnustep-config --variable=GNUSTEP_SYSTEM_DOC_INFO
    CHECK_RESULT $? 0 0 "Failed to get GNUSTEP_SYSTEM_DOC_INFO variable"

    # 测试其他参数
    gnustep-config --debug-flags
    CHECK_RESULT $? 0 0 "Failed to get debug flags"
    gnustep-config --objc-flags
    CHECK_RESULT $? 0 0 "Failed to get objc flags"
    gnustep-config --objc-libs
    CHECK_RESULT $? 0 0 "Failed to get objc libs"
    gnustep-config --base-libs
    CHECK_RESULT $? 0 0 "Failed to get base libs"
    gnustep-config --gui-libs
    CHECK_RESULT $? 0 0 "Failed to get gui libs"
    gnustep-config --host-dir
    CHECK_RESULT $? 0 0 "Failed to get host dir"
    gnustep-config --host-ldir
    CHECK_RESULT $? 0 0 "Failed to get host ldir"
    gnustep-config --installation-domain-for=xxx
    CHECK_RESULT $? 0 0 "Failed to get installation domain for xxx"
    gnustep-config --target-dir-for=xxx
    CHECK_RESULT $? 0 0 "Failed to get target dir for xxx"
    gnustep-config --target-ldir-for=xxx
    CHECK_RESULT $? 0 0 "Failed to get target ldir for xxx"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "gnustep-make"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
