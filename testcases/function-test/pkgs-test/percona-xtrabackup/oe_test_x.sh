
#!/usr/bin/bash
# 请填写测试用例描述：测试 xbstream -x 命令的提取功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "percona-xtrabackup"
    # 准备测试数据
    mkdir -p ./test_data
    touch ./test_data/file1.txt
    touch ./test_data/file2.txt
    cd ./test_data
    xbstream -c -v file1.txt file2.txt > ../test_data.xbs
    cd ..
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 xbstream -x 命令的基本功能
    xbstream -x -v < ./test_data.xbs
    CHECK_RESULT $? 0 0 "failed to extract files with xbstream -x"
    # 检查文件是否成功提取
    CHECK_RESULT $? 0 0 "failed to extract files with xbstream -x"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "percona-xtrabackup"
    # 清理测试中间产物文件
    rm -rf ./test_data
    rm -f ./test_data.xbs
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
