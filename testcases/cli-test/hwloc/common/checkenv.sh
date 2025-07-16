#!/bin/bash


# 判断 hwloc 版本是否为1.11.9, 如果不是skip退出
checkversion1119() {
    HWLOC_VERSION=$(yum info hwloc 2>/dev/null  | grep -E '^Version' | awk '{print $NF}' | head -1)
    REQUIRED_VERSION=1.11.9
    if [[ "$HWLOC_VERSION" != "$REQUIRED_VERSION" ]]; then
        echo "当前仓库 hwloc 版本为 ${HWLOC_VERSION}，不等于${REQUIRED_VERSION}，跳过测试"
        exit 255
    fi
}

