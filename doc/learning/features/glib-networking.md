# glib-networking

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/glib-networking` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_glib_networking_install | Test glib-networking package installation integrity | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_glib_networking_modules | Test glib-networking GIO modules and protocol support | pre_test/run_test/post_test | 13 | ✔ |  |  |

### 断言与命令明细

#### oe_test_glib_networking_install

- 描述：Test glib-networking package installation integrity
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "glib-networking package not installed"
  CHECK_RESULT $? 0 0 "Package integrity check failed (rpm -V)"
  CHECK_RESULT $? 0 0 "Package contains no files"
  CHECK_RESULT $? 0 0 "Documentation directory missing"
  CHECK_RESULT $? 0 0 "Critical file missing: $f"
  CHECK_RESULT $? 0 0 "Dependency $dep not installed"
  CHECK_RESULT $? 0 0 "GIO module cache missing"
  CHECK_RESULT $? 0 0 "GIO module $mod file not found for dependency check"
  CHECK_RESULT $? 1 0 "GIO module $mod has unresolved library dependencies"
```

- 涉及命令：rpm×3

#### oe_test_glib_networking_modules

- 描述：Test glib-networking GIO modules and protocol support
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "GIO TLS backend not available or does not support TLS"
  CHECK_RESULT $? 0 0 "TLS connection test failed"
  CHECK_RESULT $? 0 0 "org.gnome.system.proxy schema not available"
  CHECK_RESULT $? 0 0 "GSettings proxy mode not set correctly"
  CHECK_RESULT $? 0 0 "GSettings proxy host not set correctly"
  CHECK_RESULT $? 0 0 "GSettings proxy port not set correctly"
  CHECK_RESULT $? 0 0 "GIO proxy resolver lookup failed"
  CHECK_RESULT $? 0 0 "GIO module cache missing"
  CHECK_RESULT $? 0 0 "TLS module (libgiognutls.so) not indexed in GIO module cache"
  CHECK_RESULT $? 0 0 "Proxy module (libgiolibproxy.so) not indexed in GIO module cache"
  CHECK_RESULT $? 0 0 "glib-pacrunner not executable"
  CHECK_RESULT $? 0 0 "glib-pacrunner D-Bus service file incorrect or missing"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：python3×3, pkill×2
