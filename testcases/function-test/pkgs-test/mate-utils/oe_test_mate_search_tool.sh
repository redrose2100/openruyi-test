
#!/usr/bin/bash
# 请填写测试用例描述

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-utils"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./test_dir
    touch ./test_dir/test_file1.txt
    touch ./test_dir/test_file2.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的参数组合
    mate-search-tool --version
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool --version"
    
    mate-search-tool --named="test_file" --path="./test_dir" --sortby=name --descending
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with named, path, sortby, and descending options"
    
    mate-search-tool --contains="test" --path="./test_dir"
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with contains and path options"
    
    mate-search-tool --mtimeless=1 --path="./test_dir"
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with mtimeless and path options"
    
    mate-search-tool --mtimemore=1 --path="./test_dir"
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with mtimemore and path options"
    
    mate-search-tool --sizemore=1 --path="./test_dir"
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with sizemore and path options"
    
    mate-search-tool --sizeless=1000 --path="./test_dir"
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with sizeless and path options"
    
    mate-search-tool --empty --path="./test_dir"
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with empty and path options"
    
    mate-search-tool --user=$(whoami) --path="./test_dir"
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with user and path options"
    
    mate-search-tool --group=$(id -gn) --path="./test_dir"
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with group and path options"
    
    mate-search-tool --nouser --path="./test_dir"
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with nouser and path options"
    
    mate-search-tool --notnamed="test_file" --path="./test_dir"
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with notnamed and path options"
    
    mate-search-tool --regex="test_file" --path="./test_dir"
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with regex and path options"
    
    mate-search-tool --hidden --path="./test_dir"
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with hidden and path options"
    
    mate-search-tool --follow --path="./test_dir"
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with follow and path options"
    
    mate-search-tool --mounts --path="./test_dir"
    CHECK_RESULT $? 0 0 "failed to run mate-search-tool with mounts and path options"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "mate-utils"
    # 清理测试中间产物文件
    rm -rf ./test_dir
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
