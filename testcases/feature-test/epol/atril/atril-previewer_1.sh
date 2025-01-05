
#!/usr/bin/bash
# 本测试用例用于测试atril-previewer命令的参数功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "atril"
    # 准备测试数据
    echo "Test content" > ./testfile.pdf
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    atril-previewer --display=:0.0 ./testfile.pdf
    CHECK_RESULT $? 0 0 "atril-previewer basic usage failed"
    
    # 测试--unlink-tempfile参数
    atril-previewer --display=:0.0 -u ./testfile.pdf
    CHECK_RESULT $? 0 0 "atril-previewer --unlink-tempfile failed"
    
    # 测试--print-settings参数
    echo "print settings content" > ./printsettings.conf
    atril-previewer --display=:0.0 -p ./printsettings.conf ./testfile.pdf
    CHECK_RESULT $? 0 0 "atril-previewer --print-settings failed"
    
    # 测试--display参数
    atril-previewer --display=:0.0 ./testfile.pdf
    CHECK_RESULT $? 0 0 "atril-previewer --display failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "atril"
    # 清理测试中间产物文件
    rm -f ./testfile.pdf ./printsettings.conf
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
