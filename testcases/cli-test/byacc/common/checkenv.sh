# 版本号格式: X.Y.Z  (支持 2.0.20230219 这种长数字)
# 返回值:
#   0 - v1 == v2
#   1 - v1 > v2
#   2 - v1 < v2
compareversions() {
    local v1=$1
    local v2=$2

    # 检查版本号格式（支持 数字.数字.数字）
    if [[ ! "$v1" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || [[ ! "$v2" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "错误: 版本号格式不正确，应为 X.Y.Z"
        return 3
    fi

    # 分割三段版本号
    IFS='.' read -r v1_major v1_minor v1_patch <<< "$v1"
    IFS='.' read -r v2_major v2_minor v2_patch <<< "$v2"

    # 比较第1段
    if (( v1_major > v2_major )); then
        return 1
    elif (( v1_major < v2_major )); then
        return 2
    fi

    # 比较第2段
    if (( v1_minor > v2_minor )); then
        return 1
    elif (( v1_minor < v2_minor )); then
        return 2
    fi

    # 比较第3段（支持超大数字：20230219 这种）
    if (( v1_patch > v2_patch )); then
        return 1
    elif (( v1_patch < v2_patch )); then
        return 2
    fi

    # 完全相同
    return 0
}
