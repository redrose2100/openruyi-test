#!/bin/bash


# 比较两个三位版本号的大小
# 版本号格式: X.YY.Z (例如 1.31.1)
# 返回值: 
#   0 - v1 == v2
#   1 - v1 > v2
#   2 - v1 < v2
compareversions() {
    local v1=$1
    local v2=$2

    # 检查版本号格式
    if [[ ! "$v1" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || [[ ! "$v2" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "错误: 版本号格式不正确，应为 X.Y.Z (例如 1.31.1)"
        return 3
    fi

    # 分割版本号
    IFS='.' read -r -a v1_parts <<< "$v1"
    IFS='.' read -r -a v2_parts <<< "$v2"

    # 比较主版本号
    if (( v1_parts[0] > v2_parts[0] )); then
        return 1
    elif (( v1_parts[0] < v2_parts[0] )); then
        return 2
    fi

    # 比较次版本号
    if (( v1_parts[1] > v2_parts[1] )); then
        return 1
    elif (( v1_parts[1] < v2_parts[1] )); then
        return 2
    fi

    # 比较修订号
    if (( v1_parts[2] > v2_parts[2] )); then
        return 1
    elif (( v1_parts[2] < v2_parts[2] )); then
        return 2
    fi

    # 版本号相同
    return 0
}
