
#!/usr/bin/bash
# 请填写测试用例描述：测试 stestr slowest 命令，验证其显示最近测试运行中最慢的测试

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-stestr"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个简单的测试文件
    cat > ./test_example.py << EOF
import unittest

class TestExample(unittest.TestCase):
    def test_one(self):
        self.assertEqual(1, 1)

    def test_two(self):
        self.assertEqual(2, 2)
EOF
    # 运行测试以生成测试数据
    stestr-3 run ./test_example.py
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 stestr slowest 命令的基本用法
    stestr-3 slowest
    CHECK_RESULT $? 0 0 "stestr slowest command failed"

    # 测试 stestr slowest 命令的 --all 参数
    stestr-3 slowest --all
    CHECK_RESULT $? 0 0 "stestr slowest --all command failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "python-stestr"
    # 清理测试中间产物文件
    rm -f ./test_example.py
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
