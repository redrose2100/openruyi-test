
#!/usr/bin/bash
# 本测试用例用于测试engrampa命令的基本功能，包括添加文件到归档文件、从归档文件中提取文件等。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "engrampa"
    # 准备测试数据
    mkdir -p ./test_dir
    touch ./test_dir/test_file1.txt
    touch ./test_dir/test_file2.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试添加文件到归档文件
    engrampa --add-to=./test_dir/test_archive.zip ./test_dir/test_file1.txt
    CHECK_RESULT $? 0 0 "Failed to add file to archive"
    # 测试从归档文件中提取文件
    engrampa --extract-to=./test_dir/extracted ./test_dir/test_archive.zip
    CHECK_RESULT $? 0 0 "Failed to extract files from archive"
    # 测试默认目录
    engrampa --default-dir=./test_dir --add ./test_dir/test_file2.txt
    CHECK_RESULT $? 0 0 "Failed to add file with default directory"
    # 测试强制创建目标目录
    engrampa --force --extract-to=./test_dir/force_extract ./test_dir/test_archive.zip
    CHECK_RESULT $? 0 0 "Failed to extract files with force option"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "engrampa"
    rm -rf ./test_dir
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
