# openeuler-lsb

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/openeuler-lsb` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_openEuler-lsb_01 | openEuler-lsb test basic function of lsb_release | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_openEuler-lsb_02 | openEuler-lsb test to upgrade from 5.0-1 to lasted version | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_openEuler-lsb_01

- 描述：openEuler-lsb test basic function of lsb_release
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "lsb_release -v failed!"
  CHECK_RESULT $? 0 0 "lsb_release -i failed!"
  CHECK_RESULT $? 0 0 "lsb_release -d failed!"
  CHECK_RESULT $? 0 0 "lsb_release -r failed!"
  CHECK_RESULT $? 0 0 "lsb_release -c failed!"
  CHECK_RESULT $? 0 0 "lsb_release -s failed!"
  CHECK_RESULT $? 0 0 "lsb_release -a failed!"
  CHECK_RESULT $? 0 0 "lsb_release -h failed!"
```

- 涉及命令：lsb_release×2

#### oe_test_openEuler-lsb_02

- 描述：openEuler-lsb test to upgrade from 5.0-1 to lasted version
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "DNF_INSTALL $PKG_NAME failed!"
  CHECK_RESULT $? 0 0 "DNF_INSTALL $PKG_NAME_LATEST failed!"
```

- 涉及命令：rpm×2
