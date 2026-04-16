# 嵌入式OS Mugen测试框架补丁

## 概述

本补丁用于对嵌入式OS测试进行定制化修改。在测试嵌入式OS之前，建议优先对Mugen测试框架应用此补丁。

## 补丁内容

补丁文件 `0001-make-customized-modifications-for-embedded-OS.patch` 包含以下修改：

### 1. SDK环境配置
- 修改 `libs/locallibs/combination.py`，导出 `SDK_PATH` 环境变量
- 修改 `mugen.sh`，在构建/运行测试前加载SDK环境配置脚本

### 2. 测试用例适配
- **kernel_hello_world_test**: 禁用内核模块编译步骤（使用预编译模块）
- **initscripts_test_001**: 添加systemctl检测，在systemd系统上跳过测试
- **net-tools_test_001**: 修复route命令输出解析，添加 `-n` 参数
- **system_service_sshd**: 同时支持init.d和systemctl服务管理方式
- **version_ltp_test_001** 和 **version_posix_suite_test_001**: 移除调试输出

## 打补丁方法

### 前提条件
- 确保已安装 `patch` 命令
- 进入Mugen根目录

### 应用补丁

```bash
# 进入Mugen根目录
cd /path/to/mugen

# 应用补丁
patch -p1 < patchs/embedded-os/0001-make-customized-modifications-for-embedded-OS.patch
```

### 验证补丁是否成功

```bash
# 检查补丁应用状态
git status
# 或检查特定文件
grep "SDK_PATH" mugen.sh
```

### 移除补丁（如需要）

```bash
# 移除补丁
patch -p1 -R < patchs/embedded-os/0001-make-customized-modifications-for-embedded-OS.patch
```

## 环境变量

应用补丁后，运行测试前请确保设置以下环境变量：

```bash
export SDK_PATH=/path/to/your/sdk
```

SDK路径应包含 `environment-setup-*` 脚本，用于交叉编译环境配置。

## 注意事项

1. 运行嵌入式OS测试前务必应用此补丁
2. 补丁会修改核心框架文件，请谨慎应用
3. 如需运行标准（非嵌入式）测试，建议先移除补丁
