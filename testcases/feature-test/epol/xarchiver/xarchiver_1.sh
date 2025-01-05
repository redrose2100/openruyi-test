
#!/usr/bin/bash
# 请填写测试用例描述：测试 xarchiver 命令的基本功能，包括打开显示、提取和压缩文件等操作

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xarchiver"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./test_dir
    touch ./test_dir/test_file1.txt
    touch ./test_dir/test_file2.txt
    tar -czf ./test_dir/test_archive.tar.gz -C ./test_dir test_file1.txt test_file2.txt
    export DISPLAY=:0.0
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 xarchiver 命令的基本功能
    xarchiver --info
    CHECK_RESULT $? 0 0 "xarchiver --info failed"

    xarchiver --version
    CHECK_RESULT $? 0 0 "xarchiver --version failed"

    xarchiver --extract-to=./test_dir ./test_dir/test_archive.tar.gz
    CHECK_RESULT $? 0 0 "xarchiver --extract-to failed"

    xarchiver --compress=./test_dir/test_file1.txt ./test_dir/test_file2.txt
    CHECK_RESULT $? 0 0 "xarchiver --compress failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "xarchiver"
    # 清理测试中间产物文件
    rm -rf ./test_dir
    unset DISPLAY
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
