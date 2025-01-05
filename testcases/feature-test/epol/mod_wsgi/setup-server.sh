
#!/usr/bin/bash
# 本测试用例用于验证 mod_wsgi-express-3 setup-server 命令的正确性

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mod_wsgi"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 mod_wsgi-express-3 setup-server 命令
    mod_wsgi-express-3 setup-server
    CHECK_RESULT $? 0 0 "mod_wsgi-express-3 setup-server command failed"

    # 检查生成的文件和目录是否存在
    test -d /tmp/mod_wsgi-localhost:8000:0
    CHECK_RESULT $? 0 0 "/tmp/mod_wsgi-localhost:8000:0 directory not found"

    test -f /tmp/mod_wsgi-localhost:8000:0/httpd.conf
    CHECK_RESULT $? 0 0 "/tmp/mod_wsgi-localhost:8000:0/httpd.conf file not found"

    test -f /tmp/mod_wsgi-localhost:8000:0/error_log
    CHECK_RESULT $? 0 0 "/tmp/mod_wsgi-localhost:8000:0/error_log file not found"

    test -f /tmp/mod_wsgi-localhost:8000:0/rewrite.conf
    CHECK_RESULT $? 0 0 "/tmp/mod_wsgi-localhost:8000:0/rewrite.conf file not found"

    test -f /tmp/mod_wsgi-localhost:8000:0/envvars
    CHECK_RESULT $? 0 0 "/tmp/mod_wsgi-localhost:8000:0/envvars file not found"

    test -f /tmp/mod_wsgi-localhost:8000:0/apachectl
    CHECK_RESULT $? 0 0 "/tmp/mod_wsgi-localhost:8000:0/apachectl file not found"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "mod_wsgi"
    # 清理测试中间产物文件
    rm -rf /tmp/mod_wsgi-localhost:8000:0
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
