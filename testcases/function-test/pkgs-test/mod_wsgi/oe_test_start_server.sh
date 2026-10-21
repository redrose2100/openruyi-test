
#!/usr/bin/bash
# 测试用例描述：测试 mod_wsgi-express-3 start-server 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mod_wsgi"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个简单的测试文件
    echo "Hello, World!" > ./test.html
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 mod_wsgi-express-3 start-server 命令
    mod_wsgi-express-3 start-server --port 8000 --url-alias / ./test.html --user nobody --group nobody &
    sleep 10
    CHECK_RESULT $? 0 0 "mod_wsgi-express-3 start-server command failed"
    # 检查服务器是否启动成功
    curl -s http://localhost:8000/ | grep "Hello, World!"
    CHECK_RESULT $? 0 0 "Failed to access the server"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "mod_wsgi"
    # 清理测试中间产物文件
    rm -f ./test.html
    # 停止服务器
    pkill -f "mod_wsgi-express-3 start-server"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
