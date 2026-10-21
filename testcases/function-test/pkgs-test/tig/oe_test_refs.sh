
#!/usr/bin/bash
# 请填写测试用例描述：测试 tig refs 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "tig"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    git init ./test_repo
    cd ./test_repo
    touch file1.txt
    git add file1.txt
    git commit -m "Initial commit"
    git branch branch1
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 tig refs 命令的基本用法
    tig refs
    CHECK_RESULT $? 0 0 "tig refs command failed"

    # 测试 tig refs 命令的选项 -v
    tig refs -v
    CHECK_RESULT $? 0 0 "tig refs -v command failed"

    # 测试 tig refs 命令的选项 -h
    tig refs -h
    CHECK_RESULT $? 0 0 "tig refs -h command failed"

    # 测试 tig refs 命令的选项 -C
    tig refs -C ./test_repo
    CHECK_RESULT $? 0 0 "tig refs -C ./test_repo command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "tig"
    # 清理测试中间产物文件
    cd ..
    rm -rf ./test_repo
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
