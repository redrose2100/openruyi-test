
#!/usr/bin/bash
# 请填写测试用例描述：测试 tig status 命令

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
    echo "test content" > test_file.txt
    git add test_file.txt
    git commit -m "Initial commit"
    cd ..
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 tig status 命令
    tig status
    CHECK_RESULT $? 0 0 "tig status command failed"
    # 测试 tig status 命令加上 -C 选项
    tig -C ./test_repo status
    CHECK_RESULT $? 0 0 "tig status with -C option failed"
    # 测试 tig status 命令加上 -h 选项
    tig status -h
    CHECK_RESULT $? 0 0 "tig status with -h option failed"
    # 测试 tig status 命令加上 --help 选项
    tig status --help
    CHECK_RESULT $? 0 0 "tig status with --help option failed"
    # 测试 tig status 命令加上 -v 选项
    tig status -v
    CHECK_RESULT $? 0 0 "tig status with -v option failed"
    # 测试 tig status 命令加上 --version 选项
    tig status --version
    CHECK_RESULT $? 0 0 "tig status with --version option failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "tig"
    # 清理测试中间产物文件
    rm -rf ./test_repo
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
