
#!/usr/bin/bash
# 测试ffmpegthumbnailer命令的基本用法和各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ffmpegthumbnailer"
    # 准备测试数据
    touch "./input_video.mp4"
    touch "./output_thumbnail.jpg"
    touch "./output_thumbnail.png"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    ffmpegthumbnailer -i "./input_video.mp4" -o "./output_thumbnail.jpg" -s 128 -t 10% -q 8
    CHECK_RESULT $? 0 0 "ffmpegthumbnailer basic usage failed"

    # 测试不同的缩略图大小
    ffmpegthumbnailer -i "./input_video.mp4" -o "./output_thumbnail.jpg" -s 256 -t 10% -q 8
    CHECK_RESULT $? 0 0 "ffmpegthumbnailer different size failed"

    # 测试不同的时间点
    ffmpegthumbnailer -i "./input_video.mp4" -o "./output_thumbnail.jpg" -s 128 -t 30% -q 8
    CHECK_RESULT $? 0 0 "ffmpegthumbnailer different time failed"

    # 测试不同的图像质量
    ffmpegthumbnailer -i "./input_video.mp4" -o "./output_thumbnail.jpg" -s 128 -t 10% -q 10
    CHECK_RESULT $? 0 0 "ffmpegthumbnailer different quality failed"

    # 测试覆盖图像格式
    ffmpegthumbnailer -i "./input_video.mp4" -o "./output_thumbnail.png" -s 128 -t 10% -q 8 -c png
    CHECK_RESULT $? 0 0 "ffmpegthumbnailer override image format failed"

    # 测试忽略宽高比
    ffmpegthumbnailer -i "./input_video.mp4" -o "./output_thumbnail.jpg" -s 128 -t 10% -q 8 -a
    CHECK_RESULT $? 0 0 "ffmpegthumbnailer ignore aspect ratio failed"

    # 测试创建电影条纹叠加
    ffmpegthumbnailer -i "./input_video.mp4" -o "./output_thumbnail.jpg" -s 128 -t 10% -q 8 -f
    CHECK_RESULT $? 0 0 "ffmpegthumbnailer create movie strip overlay failed"

    # 测试优先使用嵌入的图像元数据
    ffmpegthumbnailer -i "./input_video.mp4" -o "./output_thumbnail.jpg" -s 128 -t 10% -q 8 -m
    CHECK_RESULT $? 0 0 "ffmpegthumbnailer prefer embedded metadata failed"

    # 测试旧版本的ffmpeg问题
    ffmpegthumbnailer -i "./input_video.mp4" -o "./output_thumbnail.jpg" -s 128 -t 10% -q 8 -w
    CHECK_RESULT $? 0 0 "ffmpegthumbnailer workaround old ffmpeg failed"

    # 测试打印版本号
    ffmpegthumbnailer -v
    CHECK_RESULT $? 0 0 "ffmpegthumbnailer print version failed"

    # 测试显示帮助信息
    ffmpegthumbnailer -h
    CHECK_RESULT $? 0 0 "ffmpegthumbnailer display help failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "ffmpegthumbnailer"
    # 清理测试中间产物文件
    rm -f "./input_video.mp4"
    rm -f "./output_thumbnail.jpg"
    rm -f "./output_thumbnail.png"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
