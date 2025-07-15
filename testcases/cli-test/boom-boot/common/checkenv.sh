#!/bin/bash


# 判断boom-boot版本是否为0.9, 如果不是skip退出 
checkversion09() {
    BOOMBOOT_VERSION=$(yum info boom-boot 2>/dev/null  | grep -E '^Version' | awk '{print $NF}' | head -1)
    REQUIRED_VERSION=0.9
    if [[ "$BOOMBOOT_VERSION" != "$REQUIRED_VERSION" ]]; then
        echo "当前仓库 boom-boot 版本为 ${BOOMBOOT_VERSION}，不等于${REQUIRED_VERSION}，跳过测试"
        exit 255
    fi
}

