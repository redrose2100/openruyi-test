
#!/usr/bin/bash
# 请填写测试用例描述：测试 tig stash 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "tig"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./test_repo
    cd ./test_repo
    git init
    echo "test content" > testfile.txt
    git add testfile.txt
    git commit -m "initial commit"
    echo "modified content" > testfile.txt
    git stash
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 tig stash 命令
    tig stash
    CHECK_RESULT $? 0 0 "tig stash command failed"
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
