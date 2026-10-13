# sysmonitor

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `$OET_PATH/testcases/feature-test/sysmonitor` |
| 注册用例数 | 13 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_sysmonitor_cpu | sysmonitor cpu监控测试 | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_sysmonitor_custom | sysmonitor 自定义监控测试 | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_sysmonitor_disk | sysmonitor 磁盘分区监控测试 | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_sysmonitor_file | sysmonitor 文件监控测试 | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_sysmonitor_filesystem | sysmonitor 文件系统监控测试 | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_sysmonitor_handles | sysmonitor 系统句柄监控测试 | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_sysmonitor_inode | sysmonitor 磁盘inode监控测试 | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_sysmonitor_iodelay | sysmonitor 本地磁盘io延时监控测试 | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_sysmonitor_memory | sysmonitor 内存监控测试 | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_sysmonitor_netcard | sysmonitor 网卡监控测试 | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_sysmonitor_process | sysmonitor 关键进程监控测试 | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_sysmonitor_pscnt | sysmonitor 进程数监控测试 | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_sysmonitor_zombie | sysmonitor 僵尸进程监控测试 | pre_test/run_test/post_test | 0 |  |  |  |

### 断言与命令明细

#### oe_test_sysmonitor_cpu

- 描述：sysmonitor cpu监控测试
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×4, pkill×3, dnf×1

#### oe_test_sysmonitor_custom

- 描述：sysmonitor 自定义监控测试
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×2, grep×2, pgrep×1

#### oe_test_sysmonitor_disk

- 描述：sysmonitor 磁盘分区监控测试
- 函数：`pre_test, run_test, post_test`
- 涉及命令：mkdir×3, umount×1

#### oe_test_sysmonitor_file

- 描述：sysmonitor 文件监控测试
- 函数：`pre_test, run_test, post_test`
- 涉及命令：dmesg×1

#### oe_test_sysmonitor_filesystem

- 描述：sysmonitor 文件系统监控测试
- 函数：`pre_test, run_test, post_test`
- 涉及命令：umount×2, sed×1, grep×1, mkdir×1

#### oe_test_sysmonitor_handles

- 描述：sysmonitor 系统句柄监控测试
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3

#### oe_test_sysmonitor_inode

- 描述：sysmonitor 磁盘inode监控测试
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3, grep×1

#### oe_test_sysmonitor_iodelay

- 描述：sysmonitor 本地磁盘io延时监控测试
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×8

#### oe_test_sysmonitor_memory

- 描述：sysmonitor 内存监控测试
- 函数：`pre_test, run_test, post_test`
- 涉及命令：free×1

#### oe_test_sysmonitor_netcard

- 描述：sysmonitor 网卡监控测试
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_sysmonitor_process

- 描述：sysmonitor 关键进程监控测试
- 函数：`pre_test, run_test, post_test`
- 涉及命令：kill×1, pgrep×1

#### oe_test_sysmonitor_pscnt

- 描述：sysmonitor 进程数监控测试
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×5

#### oe_test_sysmonitor_zombie

- 描述：sysmonitor 僵尸进程监控测试
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3
