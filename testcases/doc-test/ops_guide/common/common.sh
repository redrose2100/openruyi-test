#!/bin/bash
# check_downgrade.sh
# 功能：判断指定软件包是否有可降级版本
#
source "$OET_PATH/libs/locallibs/common_lib.sh"
function check_downgrade(){

  pkg="$1"
  if [ -z "$pkg" ]; then
    echo "Usage: $0 <package>"
    exit 1
  fi

  # 检查 rpmdev-vercmp 是否安装
  if ! command -v rpmdev-vercmp >/dev/null 2>&1; then
    dnf install -y rpmdevtools
  fi

  # 获取当前安装版本
  epoch=$(rpm -q --qf "%{EPOCH}" "$pkg" 2>/dev/null)
  version=$(rpm -q --qf "%{VERSION}" "$pkg" 2>/dev/null)
  release=$(rpm -q --qf "%{RELEASE}" "$pkg" 2>/dev/null)

  # 处理未定义 epoch
  if [ -z "$epoch" ] || [ "$epoch" == "(none)" ]; then
    epoch=0
  fi

  current="${epoch}:${version}-${release}"

  # 获取仓库可用版本，去掉重复
  versions=$(dnf --showduplicates list "$pkg" 2>/dev/null \
    | awk '/'"$pkg"'/ {print $2}' \
    | sort -u)


  # 将未定义 epoch 的可用版本补 0
  versions=$(echo "$versions" | sed -E 's/^([0-9]+:)/\1/; t; s/^/0:/')
  downgrades=()
  for v in $versions; do
    # 跳过当前安装版本
    if [ "$v" == "$current" ]; then
        continue
    fi

    rpmdev-vercmp "$v" "$current" >/dev/null
    ret=$?
    if [ $ret -eq 12 ]; then
        downgrades+=("$v")
    fi
  done

  if [ ${#downgrades[@]} -eq 0 ]; then
    echo "不需要降级：$pkg 没有可用更低版本"
    return 1
  else
    echo "$pkg有可降级版本"
    return 0
  fi
}
