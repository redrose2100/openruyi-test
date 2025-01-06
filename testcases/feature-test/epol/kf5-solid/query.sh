
#!/usr/bin/bash
# 测试用例描述：测试solid-hardware5的query命令，包括不同参数组合和参数顺序

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-solid"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试query命令的基本用法
    solid-hardware5 query 'isDisk'
    CHECK_RESULT $? 0 0 "query command failed without parentUdi"
    
    # 测试query命令带parentUdi参数
    solid-hardware5 query 'isDisk' '/org/freedesktop/UDisks2/block_devices/sda'
    CHECK_RESULT $? 0 0 "query command failed with parentUdi"
    
    # 测试query命令参数顺序
    solid-hardware5 query '/org/freedesktop/UDisks2/block_devices/sda' 'isDisk'
    CHECK_RESULT $? 1 0 "query command should fail with incorrect parameter order"
    
    # 测试query命令帮助信息
    solid-hardware5 query --help
    CHECK_RESULT $? 0 0 "query command help failed"
    
    # 测试query命令版本信息
    solid-hardware5 query --version
    CHECK_RESULT $? 0 0 "query command version failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "kf5-solid"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
