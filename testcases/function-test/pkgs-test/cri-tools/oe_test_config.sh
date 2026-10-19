
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl config 命令的参数功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --get 参数
    crictl config --get runtime-endpoint
    CHECK_RESULT $? 0 0 "failed to get runtime-endpoint"
    
    # 测试 --set 参数
    crictl config --set debug=true
    CHECK_RESULT $? 0 0 "failed to set debug=true"
    
    # 测试 --set 参数组合
    crictl config --set timeout=2s,pull-image-on-create=true
    CHECK_RESULT $? 0 0 "failed to set timeout and pull-image-on-create"
    
    # 测试 --help 参数
    crictl config --help
    CHECK_RESULT $? 0 0 "failed to show help"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        DNF_REMOVE "cri-tools"
        # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
