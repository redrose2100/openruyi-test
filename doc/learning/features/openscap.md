# openscap

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/openscap` |
| 注册用例数 | 7 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_openscap_01 | verification opencc‘s command | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_scanning_system | Vulnerability scanning system | pre_test/run_test/post_test | 2 | ✔ |  | 60m |
| oe_test_scanning_remote_system | Scanning remote system vulnerabilities | pre_test/run_test/post_test | 1 | ✔ |  | 60m |
| oe_test_ensure_security_compliance | View configuration files to ensure security compliance | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_assess_safety_compliance | Assess safety compliance for specific benchmarks | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_fix_anisible | Fix anisible to make the system consistent with ospp | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_service_oscap-remediate | Test oscap-remediate.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_openscap_01

- 描述：verification opencc‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：test×4, oscap×1

#### oe_test_scanning_system

- 描述：Vulnerability scanning system
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_scanning_remote_system

- 描述：Scanning remote system vulnerabilities
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：expect×1

#### oe_test_ensure_security_compliance

- 描述：View configuration files to ensure security compliance
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_assess_safety_compliance

- 描述：Assess safety compliance for specific benchmarks
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：expect×1

#### oe_test_fix_anisible

- 描述：Fix anisible to make the system consistent with ospp
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_service_oscap-remediate

- 描述：Test oscap-remediate.service restart
- 函数：`pre_test, run_test, post_test`