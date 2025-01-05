
#!/usr/bin/bash
# 测试用例描述：测试mpv的基本选项，包括 --start, --no-audio, --no-video, --fs, --sub-file, --playlist

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mpv"
    # 准备测试数据
    touch "./test_video.mp4"
    touch "./test_audio.mp3"
    touch "./test_subtitle.srt"
    touch "./test_playlist.m3u"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --start 参数
    mpv --start=10 "./test_video.mp4"
    CHECK_RESULT $? 0 0 "failed to start at 10 seconds"
    
    # 测试 --no-audio 参数
    mpv --no-audio "./test_video.mp4"
    CHECK_RESULT $? 0 0 "failed to disable audio"
    
    # 测试 --no-video 参数
    mpv --no-video "./test_audio.mp3"
    CHECK_RESULT $? 0 0 "failed to disable video"
    
    # 测试 --fs 参数
    mpv --fs "./test_video.mp4"
    CHECK_RESULT $? 0 0 "failed to enable fullscreen"
    
    # 测试 --sub-file 参数
    mpv --sub-file="./test_subtitle.srt" "./test_video.mp4"
    CHECK_RESULT $? 0 0 "failed to specify subtitle file"
    
    # 测试 --playlist 参数
    mpv --playlist="./test_playlist.m3u"
    CHECK_RESULT $? 0 0 "failed to specify playlist file"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "mpv"
    rm -f "./test_video.mp4" "./test_audio.mp3" "./test_subtitle.srt" "./test_playlist.m3u"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
