
#!/usr/bin/bash
# 测试用例描述：测试 opencv_test_calib3d 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "opencv"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    # 测试 --help 参数
    opencv_test_calib3d -h
    CHECK_RESULT $? 0 0 "failed to run opencv_test_calib3d with --help option"

    # 测试 --ipp 参数
    opencv_test_calib3d --ipp
    CHECK_RESULT $? 0 0 "failed to run opencv_test_calib3d with --ipp option"

    # 测试 --skip_unstable 参数
    opencv_test_calib3d --skip_unstable
    CHECK_RESULT $? 0 0 "failed to run opencv_test_calib3d with --skip_unstable option"

    # 测试 --test_bigdata 参数
    opencv_test_calib3d --test_bigdata
    CHECK_RESULT $? 0 0 "failed to run opencv_test_calib3d with --test_bigdata option"

    # 测试 --test_debug 参数
    opencv_test_calib3d --test_debug 1
    CHECK_RESULT $? 0 0 "failed to run opencv_test_calib3d with --test_debug option"

    # 测试 --test_require_data 参数
    opencv_test_calib3d --test_require_data
    CHECK_RESULT $? 0 0 "failed to run opencv_test_calib3d with --test_require_data option"

    # 测试 --test_seed 参数
    opencv_test_calib3d --test_seed 12345
    CHECK_RESULT $? 0 0 "failed to run opencv_test_calib3d with --test_seed option"

    # 测试 --test_tag 参数
    opencv_test_calib3d --test_tag tag1,tag2
    CHECK_RESULT $? 0 0 "failed to run opencv_test_calib3d with --test_tag option"

    # 测试 --test_tag_enable 参数
    opencv_test_calib3d --test_tag_enable tag1,tag2
    CHECK_RESULT $? 0 0 "failed to run opencv_test_calib3d with --test_tag_enable option"

    # 测试 --test_tag_force 参数
    opencv_test_calib3d --test_tag_force tag1,tag2
    CHECK_RESULT $? 0 0 "failed to run opencv_test_calib3d with --test_tag_force option"

    # 测试 --test_tag_print 参数
    opencv_test_calib3d --test_tag_print
    CHECK_RESULT $? 0 0 "failed to run opencv_test_calib3d with --test_tag_print option"

    # 测试 --test_tag_skip 参数
    opencv_test_calib3d --test_tag_skip tag1,tag2
    CHECK_RESULT $? 0 0 "failed to run opencv_test_calib3d with --test_tag_skip option"

    # 测试 --test_threads 参数
    opencv_test_calib3d --test_threads 2
    CHECK_RESULT $? 0 0 "failed to run opencv_test_calib3d with --test_threads option"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "opencv"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
