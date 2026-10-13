# hfsplus-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/hfsplus-tools` |
| 注册用例数 | 4 |
| 环境约束 | add disk = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_fsck_hfs | Test fsck.hfs | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_fsck_hfsplus_01 | Test fsck.hfsplus | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_fsck_hfsplus_02 | Test fsck.hfsplus | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_mkfs_hfsplus | Test fsck.hfsplus | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_fsck_hfs

- 描述：Test fsck.hfs
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "test fsck.hfs -f failed"
  CHECK_RESULT $? 0 0 "test fsck.hfs -p failed"
  CHECK_RESULT $? 0 0 "test fsck.hfs -l failed"
  CHECK_RESULT $? 0 0 "test fsck.hfs -m failed"
  CHECK_RESULT $? 0 0 "test fsck.hfs -n failed"
  CHECK_RESULT $? 0 0 "test fsck.hfs -r failed"
  CHECK_RESULT $? 0 0 "test fsck.hfs -y failed"
  CHECK_RESULT $? 0 0 "test fsck.hfs -c failed"
  CHECK_RESULT $? 0 0 "test fsck.hfs -d failed"
  CHECK_RESULT $? 0 0 "test fsck.hfs -g failed"
  CHECK_RESULT $? 0 0 "test fsck.hfs -q failed"
```

- 涉及命令：fsck.hfs×11

#### oe_test_fsck_hfsplus_01

- 描述：Test fsck.hfsplus
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -u failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -v failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -b failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -B failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -c failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -d failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -g failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -x failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -q failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -E failed"
```

- 涉及命令：fsck.hfsplus×10

#### oe_test_fsck_hfsplus_02

- 描述：Test fsck.hfsplus
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -f failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -p failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -l failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -m failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -n failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -r failed"
  CHECK_RESULT $? 0 0 "test fsck.hfsplus -y failed"
```

- 涉及命令：fsck.hfsplus×7

#### oe_test_mkfs_hfsplus

- 描述：Test fsck.hfsplus
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "test mkfs.hfsplus -N failed"
  CHECK_RESULT $? 0 0 "test mkfs.hfsplus -J failed"
  CHECK_RESULT $? 0 0 "test mkfs.hfsplus -D failed"
  CHECK_RESULT $? 0 0 "test mkfs.hfsplus -G failed"
  CHECK_RESULT $? 0 0 "test mkfs.hfsplus -U failed"
  CHECK_RESULT $? 0 0 "test mkfs.hfsplus -M failed"
  CHECK_RESULT $? 0 0 "test mkfs.hfsplus -b failed"
  CHECK_RESULT $? 0 0 "test mkfs.hfsplus -c failed"
  CHECK_RESULT $? 0 0 "test mkfs.hfsplus -i failed"
  CHECK_RESULT $? 0 0 "test mkfs.hfsplus -n failed"
  CHECK_RESULT $? 0 0 "test mkfs.hfsplus -v failed"
```

- 涉及命令：mkfs.hfsplus×11
