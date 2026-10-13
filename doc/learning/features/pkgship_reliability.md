# pkgship_reliability

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `${OET_PATH}/testcases/feature-test/pkgship/pkgship_reliability` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pkgship_access_init | Access of start service | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_access_start | Access of start service | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_pkgship_full_inode_log | Check inject inode full for log | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_logrotate | Check logrotate | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_uwsgi_logrotate | Check logrotate | pre_test/run_test/post_test | 2 |  |  | 60m |

### 断言与命令明细

#### oe_test_pkgship_access_init

- 描述：Access of start service
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Root init pkgship failed."
  CHECK_RESULT $? 0 0 "Normal user init pkgship succeed unexpectly."
  CHECK_RESULT $? 0 0 "Admin pkgshipuser init pkgship failed."
```

#### oe_test_pkgship_access_start

- 描述：Access of start service
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Start systemctl pkgship by root failed."
  CHECK_RESULT $? 0 0 "Stop systemctl pkgship by root failed."
  CHECK_RESULT $? 0 0 "Start pkgshipd by root unexpectly."
  CHECK_RESULT $? 0 0 "Stop pkgshipd by root unexpectly."
  CHECK_RESULT $? 0 0 "Start pkgshipd by normal user unexpectly."
  CHECK_RESULT $? 0 0 "Stop pkgshipd by normal user unexpectly."
  CHECK_RESULT $? 0 0 "Start pkgshipd by admin failed."
  CHECK_RESULT $? 0 0 "Stop pkgshipd by admin failed."
```

#### oe_test_pkgship_full_inode_log

- 描述：Check inject inode full for log
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "There is no error msg on log when logrotate failed."
```

#### oe_test_pkgship_logrotate

- 描述：Check logrotate
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Change package.ini failed."
  CHECK_RESULT $? 0 0 "check $i pkgship installdep."
  CHECK_RESULT $? 0 0 "log_info rotate failed."
```

#### oe_test_pkgship_uwsgi_logrotate

- 描述：Check logrotate
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Change uwsgi_logrotate.sh failed."
  CHECK_RESULT $? 0 0 "uwsgi.log rotate failed."
```

- 涉及命令：sed×5
