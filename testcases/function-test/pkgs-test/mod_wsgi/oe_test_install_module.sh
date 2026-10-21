
#!/usr/bin/bash
# 本测试用例用于测试 mod_wsgi-express-3 install-module 命令及其参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mod_wsgi"
    # 准备测试数据等
    mkdir -p ./test_modules_directory
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 install-module 命令
    mod_wsgi-express-3 install-module --modules-directory=./test_modules_directory
    CHECK_RESULT $? 0 0 "mod_wsgi-express-3 install-module failed"
    # 测试 --help 参数
    mod_wsgi-express-3 install-module --help
    CHECK_RESULT $? 0 0 "mod_wsgi-express-3 install-module --help failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "mod_wsgi"
    # 清理测试中间产物文件
    rm -rf ./test_modules_directory
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
