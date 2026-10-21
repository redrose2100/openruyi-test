
#!/usr/bin/bash
# 请填写测试用例描述：测试libdoc命令的show功能，展示库的文档信息

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-robotframework"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个简单的库文件用于测试
    cat > ./MyLibrary.py << EOF
class MyLibrary:
    def __init__(self):
        self.name = "MyLibrary"
        self.version = "1.0"

    def keyword1(self):
        """This is keyword1"""
        return "Keyword1 executed"

    def keyword2(self):
        """This is keyword2"""
        return "Keyword2 executed"
EOF
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    libdoc ./MyLibrary.py show
    CHECK_RESULT $? 0 0 "libdoc show command failed"
    libdoc ./MyLibrary.py show keyword1
    CHECK_RESULT $? 0 0 "libdoc show keyword1 command failed"
    libdoc ./MyLibrary.py show intro
    CHECK_RESULT $? 0 0 "libdoc show intro command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        DNF_REMOVE "python-robotframework"
        # 清理测试中间产物文件
    rm -f ./MyLibrary.py
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
