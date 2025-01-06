
#!/usr/bin/bash
# 测试 nmstatectl commit 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "nmstate"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个无效的 checkpoint 文件
    echo "invalid checkpoint" > ./invalid_checkpoint
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 nmstatectl commit 命令
    nmstatectl commit ./invalid_checkpoint
    CHECK_RESULT $? 1 0 "nmstatectl commit should fail with invalid checkpoint"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "nmstate"
    # 清理测试中间产物文件
    rm -f ./invalid_checkpoint
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
