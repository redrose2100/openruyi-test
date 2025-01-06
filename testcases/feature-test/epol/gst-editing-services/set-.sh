
#!/usr/bin/bash
# 测试用例描述：测试 ges-launch-1.0 的 set- 命令，设置属性值

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gst-editing-services"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建测试媒体文件
    touch ./test_media.mp4
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    # 测试设置 alpha 属性
    ges-launch-1.0 +clip ./test_media.mp4 set-alpha 0.5
    CHECK_RESULT $? 0 0 "Failed to set alpha property"
    
    # 测试设置其他属性
    ges-launch-1.0 +clip ./test_media.mp4 set-volume 0.8
    CHECK_RESULT $? 0 0 "Failed to set volume property"
    
    # 测试设置多个属性
    ges-launch-1.0 +clip ./test_media.mp4 set-alpha 0.5 set-volume 0.8
    CHECK_RESULT $? 0 0 "Failed to set multiple properties"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        DNF_REMOVE "gst-editing-services"
        # 清理测试中间产物文件
        rm -f ./test_media.mp4
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
