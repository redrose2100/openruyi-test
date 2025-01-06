
#!/usr/bin/bash
# 本测试脚本用于验证jruby命令的基本功能，包括版本信息输出、脚本执行、语法检查、环境变量设置等。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "jruby"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    echo "puts 'Hello, World!'" > ./test_script.rb
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    jruby --version
    CHECK_RESULT $? 0 0 "failed to run jruby --version"
    jruby -v
    CHECK_RESULT $? 0 0 "failed to run jruby -v"
    jruby -e 'puts "Hello, World!"'
    CHECK_RESULT $? 0 0 "failed to run jruby -e"
    jruby -c ./test_script.rb
    CHECK_RESULT $? 0 0 "failed to run jruby -c"
    jruby -I./test_script.rb -e 'puts "Hello, World!"'
    CHECK_RESULT $? 0 0 "failed to run jruby -I"
    jruby -J-Xmx512m -e 'puts "Hello, World!"'
    CHECK_RESULT $? 0 0 "failed to run jruby -J"
    jruby --disable-gems -e 'puts "Hello, World!"'
    CHECK_RESULT $? 0 0 "failed to run jruby --disable-gems"
    jruby --enable=frozen-string-literal -e 'puts "Hello, World!"'
    CHECK_RESULT $? 0 0 "failed to run jruby --enable"
    jruby --disable=frozen-string-literal -e 'puts "Hello, World!"'
    CHECK_RESULT $? 0 0 "failed to run jruby --disable"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "jruby"
    rm -f ./test_script.rb
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
