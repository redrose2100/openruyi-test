#!/bin/bash

UBTURBO_TEST_PLUGIN_NAME="turbotest"

UBTURBO_TEST_SO_NAME="libturbotest_ubturbo_plugin.so"
UBTURBO_TEST_PATH="/home/ubturbo/api"
UBTURBO_TEST_NAME="ubturbo_test"
UBTURBO_WARK_PATH="/opt/ubturbo"
UBTURBO_TEST_CONF_NAME="plugin_$UBTURBO_TEST_PLUGIN_NAME"
UBTURBO_LOG_PATH="/var/log/ubturbo"

UBTURBO_CONF_PATH="$UBTURBO_WARK_PATH/conf"
UBTURBO_LIB_PATH="$UBTURBO_WARK_PATH/lib"
UBTURBO_PLUGIN_CONF_NAME="ubturbo_plugin_admission.conf"
UBTURBO_PLUGIN_CONF_PATH="$UBTURBO_CONF_PATH/$UBTURBO_PLUGIN_CONF_NAME"
UBTURBO_TEST_CONF_PATH=""$UBTURBO_CONF_PATH/$UBTURBO_TEST_CONF_NAME.conf

UBTURBO_TEST_FILE_NAME="ubturbo_call_sayhello"
UBTURBO_MAIN_SO_NAME="ubturbo_client"
UBTURBO_INCLUDE_PATH="/usr/include/ubturbo"

source ${OET_PATH}/libs/locallibs/common_lib.sh

function INSTALL_UBTURBO() {
    LOG_INFO "Start to install ubturbo..."
    DNF_INSTALL "ubturbo"
    rpm -q ubturbo &>dev/null
    CHECK_RESULT $? 0 0 "UBTurbo is not installed"
}

function REMOVE_UBTURBO() {
    LOG_INFO "Start to remove ubturbo..."
    DNF_REMOVE
    rpm -q ubturbo &>dev/null
    CHECK_RESULT $? 1 0 "UBTurbo is not installed"
}

function START_UBTURBO_SERVICE() {
    LOG_INFO "Start ubturbo service..."
    
    systemctl start ubturbo
    CHECK_RESULT $? 0 0 "Failed to start ubturbo service"

    systemctl is-active ubturbo &>/dev/null
    CHECK_RESULT $? 0 0 "UBTurbo service is not activce"
}

function STOP_UBTURBO_SERVICE() {
    LOG_INFO "Stop ubturbo service..."
    
    systemctl stop ubturbo
    CHECK_RESULT $? 0 0 "Failed to start ubturbo service"

    systemctl is-active ubturbo &>/dev/null
    CHECK_RESULT $? 3 0 "UBTurbo service is not activce"
}

function INIT_UBTURBO_API_ENV() {
    LOG_INFO "Step1: Copying test files to target directory..."

    mkdir -p "${UBTURBO_TEST_PATH}"

    file_path=$(FIND_FILE_PATH $UBTURBO_TEST_FILE_NAME.cpp)
    cp "$file_path" "${UBTURBO_TEST_PATH}"
    CHECK_RESULT $? 0 0 "Copy failed"

    file_path=$(FIND_FILE_PATH "ubturbo_get_conf_api_call.cpp")
    cp "$file_path" "${UBTURBO_TEST_PATH}"
    CHECK_RESULT $? 0 0 "Copy failed"

    ubturbo_test_src=$(FIND_DIR_PATH "$UBTURBO_TEST_NAME")
    cp -r "$ubturbo_test_src" "${UBTURBO_TEST_PATH}"

    LOG_INFO "Step2: Installing required packages"
    DNF_INSTALL "libboundscheck"
    CHECK_RESULT $? 0 0 "Failed to install libboundscheck"

    DNF_INSTALL "cmake"
    CHECK_RESULT $? 0 0 "Failed to install cmake"

    LOG_INFO "Step3: Build ubturbo_test project"
    BUILD_UBTURBO_TEST "${UBTURBO_TEST_PATH}/${UBTURBO_TEST_NAME}"

    cp "${UBTURBO_TEST_PATH}/${UBTURBO_TEST_NAME}/build/lib/${UBTURBO_TEST_SO_NAME}" "${UBTURBO_LIB_PATH}"
    CHECK_RESULT $? 0 0 "Failed to copy shared object to ${UBTURBO_LIB_PATH}"

    chmod 777 "${UBTURBO_LIB_PATH}/${UBTURBO_TEST_SO_NAME}"

    LOG_INFO "Step4：Enable turbotest"
    file_path=$(FIND_FILE_PATH "${UBTURBO_TEST_CONF_NAME}.conf")
    cp "$file_path" "$UBTURBO_CONF_PATH"
    ADD_CONF_TEXT $UBTURBO_PLUGIN_CONF_PATH "turbotest=776"
}

function DEINIT_UBTURBO_API_ENV() {
    rm -rf "${UBTURBO_TEST_PATH}"
    DEL_CONF_TEXT $UBTURBO_PLUGIN_CONF_PATH "turbotest=776"

    if [[ -z "${UBTURBO_LIB_PATH}" || -z "${UBTURBO_TEST_SO_NAME}" ]]; then
        LOG_ERROR "Error: UBUTURBO_LIB_PATH or UBUTURBO_TEST_SO_NAME is empty!"
        exit 1
    fi

    if [[ -z "${UBTURBO_CONF_PATH}" || -z "${UBTURBO_TEST_CONF_NAME}" ]]; then
        LOG_ERROR "Error: UBUTURBO_CONF_PATH or UBUTURBO_TEST_CONF_NAME is empty!"
        exit 1
    fi

    rm -rf "${UBTURBO_LIB_PATH}/${UBTURBO_TEST_SO_NAME}"
    rm -rf "${UBTURBO_CONF_PATH}/${UBTURBO_TEST_CONF_NAME}.conf"
}

function FIND_FILE_PATH(){
    local cur_path=$(cd "$(dirname ""$0)" && pwd)
    local par_path=$(dirname "$cur_path")
    local filename=$1
    local file_path
    file_path=$(find "$par_path" -type f -name "$filename" 2>/dev/null | head -n 1)

    test -z "$file_path"
    CHECK_RESULT $? 1 0 "File $filename not found"

    echo "$file_path"
    return 0
}

function FIND_DIR_PATH(){
    local cur_path=$(cd "$(dirname ""$0)" && pwd)
    local par_path=$(dirname "$cur_path")
    local dirname=$1
    local dir_path
    dir_path=$(find "$par_path" -type d -name "$dirname" 2>/dev/null | head -n 1)

    test -z "$dir_path"
    CHECK_RESULT $? 0 0 "File $dirname not found"

    echo "$dir_path"
    return 0
}

function BUILD_UBTURBO_TEST() {
    local build_dir=$1

    cd "$build_dir"
    CHECK_RESULT $? 0 0 "File to enter build dir"

    mkdir -p build
    CHECK_RESULT $? 0 0 "File to create build dir"

    cd build
    cmake ..
    CHECK_RESULT $? 0 0 "cmake failed"

    make
    CHECK_RESULT $? 0 0 "make failed"
    return 0
}

function CHECK_PLUGIN_LOADED()
{
    grep -E 'Plugin "turbotest" loaded successfully' $UBTURBO_LOG_PATH/ubturbo.log \
        | sed -n "/${start_time}/,\$p" >/dev/null
}

function WAIT_UNTIL() {
    local condition_func="$1"
    local check_sep="${2:-5}"
    local timeout="${3:-60}"
    local expect_times="${4:-1}"
    local msg="$5"

    local count=0
    local start_time=$(date +%s)
    local now elapsed

    while true; do
        if $condition_func; then
            count=$((count + 1))
        fi

        if [ "$count" -ge "$expect_times" ]; then
            return 0
        fi

        now=$(date +%s)
        elapsed=$((now - start_time))

        if [ "$elapsed" -ge "$timeout" ]; then
            return 1
        fi

        sleep "$check_sep"
    done
}

function COMPILE_TEST_SCRIPT() {
    local cpp_func_name="$1"

    if [ ! -f "${UBTURBO_TEST_PATH}/${cpp_func_name}" ]; then
        g++ -I"$UBTURBO_TEST_PATH/ubturbo_test/src/ubturbo_plugin/include" -l"$UBTURBO_MAIN_SO_NAME" -l"boundscheck" "$UBTURBO_TEST_PATH/$cpp_func_name.cpp" -o "$UBTURBO_TEST_PATH/$cpp_func_name"
        return $?
    fi
    return 0
}

function RUN_TEST_SCRIPT() {
    local cpp_func_name="$1"
    local ele="$2"
    shift 2
    local exe_path="$UBTURBO_TEST_PATH/$cpp_func_name"

    local output
    output="$("$exe_path" "$@")"

    if [[ -n "$ele" && "$output" == *"$ele"* ]]; then
        LOG_INFO "test successfully"
        return 0
    elif [[ -z "$ele" ]]; then
        LOG_INFO "No element to check, test passed"
        return 0
    else
        return 1
    fi
}


function COMFORM_SYMBOL_PRESENT() {
    local func_name="$1"
    local so_path="${2:-$UBTURBO_LIB_PATH/$UBTURBO_TEST_SO_NAME}"

    if nm -D "$so_path" | grep -q "$func_name"; then
        return 0
    else 
        return 1
    fi
}

function RESTART_UBTURBO() {
    LOG_INFO "Step1: Restart ubturbo service"
    start_time=$(date "+%Y-%m-%d %H:%M:%S")
    systemctl restart ubturbo
    CHECK_RESULT $? 0 0 "Restart ubturbo failed"

    LOG_INFO "Step2: Checking plugin"
    WAIT_UNTIL CHECK_PLUGIN_LOADED 1 10 1 "plugin load check"
    CHECK_RESULT $? 0 0 "Plugin 'turbotest' failed to load"
}

function ADD_CONF_TEXT() {
    local file="$1"
    local test="$2"

    if [ ! -f "$file" ]; then
        return 1
    fi
    echo -e "\n$test" >> "$file"
}

function DEL_CONF_TEXT() {
    local file="$1"
    local pattern="$2"

    if [ ! -f "$file" ]; then
        return 1
    fi
    sed -i "/$pattern/d" "$file"
    return 0
}

function RUN_UBTURBO_TEST() {
    local cpp_name="$1"
    local conf_value="$2"         
    local test_api_func="$3"           
    local test_api_name="$4"          
    local expected_value="$5"

    ADD_CONF_TEXT "${UBTURBO_TEST_CONF_PATH}" "$conf_value"
    RESTART_UBTURBO
    COMPILE_TEST_SCRIPT "$cpp_name"
    RUN_TEST_SCRIPT "$cpp_name" "$expected_value" "$test_api_func" "$UBTURBO_TEST_CONF_NAME" "$test_api_name"
    CHECK_RESULT $? 0 0 "Test failed"
}

function COMFORM_KEY_LOG() {
    local start_time="$1"
    local keywords="$2"
    local log_name="${3:-$UBTURBO_TEST_PLUGIN_NAME}"
    local log_path="${UBTURBO_LOG_PATH}/${log_name}.log"
    local found=1

    local start_ts=$(date -d "$start_time" +%s)

    while IFS= read -r line; do
        log_time=$(echo "$line" | grep -oP '^\[\K[0-9:-\s]+' | sed 's/.$//')
        [[ -z "$log_name" ]] && continue

        log_ts=$(date -d "$log_time" +%s 2>/dev/null)
        [[ $log_ts -lt $start_ts ]] && continue

        echo "$line" | grep -q "SayHelloHandler"
        if [[ $? -eq 0 ]]; then
            found=0
            break
        fi
    done < "$log_path"  
    CHECK_RESULT $found 0 0 "Not find key_words"
}

function CASE_CALL_SAY_HELLO() {
    local cpp_name="$1"
    local keywords="$2"
    time_before_exec=$(date "+[%Y-%m-%d %H:%M:%S]")
    RUN_TEST_SCRIPT "$cpp_name"
    COMFORM_KEY_LOG "$time_before_exec" "$keywords"
}