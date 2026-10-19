
#!/usr/bin/bash
# 请填写测试用例描述：测试botan config命令的不同参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试config命令的不同参数组合
    botan config prefix
    CHECK_RESULT $? 0 0 "botan config prefix failed"
    
    botan config cflags
    CHECK_RESULT $? 0 0 "botan config cflags failed"
    
    botan config ldflags
    CHECK_RESULT $? 0 0 "botan config ldflags failed"
    
    botan config libs
    CHECK_RESULT $? 0 0 "botan config libs failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
