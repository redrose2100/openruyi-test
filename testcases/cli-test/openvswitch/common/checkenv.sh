#!/bin/bash


# 比较两个 "版本号-release号" 格式的字符串
# 示例: ./compareversions.sh "3.3.1-4" "1.3.1-8"
compareversions() {
    local ver1=$1
    local ver2=$2

    # 提取版本号部分和 release 号部分
    local version_part1=${ver1%-*}
    local release_part1=${ver1#*-}
    local version_part2=${ver2%-*}
    local release_part2=${ver2#*-}

    # 比较版本号部分（按 . 分割后逐级比较）
    IFS='.' read -ra v1 <<< "$version_part1"
    IFS='.' read -ra v2 <<< "$version_part2"

    for i in "${!v1[@]}"; do
        # 如果 v2 的某级不存在，则默认为 0
        local num1=${v1[i]}
        local num2=${v2[i]-0}

        if (( num1 > num2 )); then
            return 1
        elif (( num1 < num2 )); then
            return 2
        fi
    done

    # 如果版本号相同，比较 release 号
    if (( release_part1 > release_part2 )); then
        return 1
    elif (( release_part1 < release_part2 )); then
        return 2
    else
        return 0
    fi
}



# 如果 openvswitch 版本大于等于 2.12.0-22，跳过ovn测试用例。 因为此版本后ovn被移除。
checkversion2120() {
    OPENVSWITCH_VERSION=$(yum list openvswitch 2>/dev/null| grep openvswitch | head -1 | awk '{print $2}' | awk -F'.oe' '{print $1}')
    REQUIRED_VERSION=2.12.0-22
    compareversions "$OPENVSWITCH_VERSION" "$REQUIRED_VERSION"
    result=$?
    if [ $result -eq 0 ] || [ $result -eq 1 ]; then
        echo "当前仓库 openvswitch 版本为 ${OPENVSWITCH_VERSION}，>=${REQUIRED_VERSION}，不包含ovn包, 跳过测试"
        exit 255
    fi
}

