# libappstream-glib

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libappstream-glib` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libappstream-glib_appstream-builder_01 | verify the uasge of libappstream-glib command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libappstream-glib_appstream-builder_02 | verify the uasge of libappstream-glib command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_libappstream-glib_appstream-compose | verify the uasge of libappstream-glib command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_libappstream-glib_appstream-util_01 | verify the uasge of libappstream-glib command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libappstream-glib_appstream-util_02 | verify the uasge of libappstream-glib command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libappstream-glib_appstream-util_03 | verify the uasge of libappstream-glib command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libappstream-glib_appstream-util_04 | verify the uasge of libappstream-glib command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libappstream-glib_appstream-util_05 | verify the uasge of libappstream-glib command | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libappstream-glib_appstream-builder_01

- 描述：verify the uasge of libappstream-glib command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check appstream-builder -h failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder --help failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --packages-dir --origin failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder --verbose --packages-dir --origin failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --add-cache-id id --origin failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --include-failed --packages-dir --origin failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --enable-hidpi --packages-dir --origin failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --enable-embed --packages-dir --origin failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --uncompressed-icons --packages-dir --origin failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --log-dir --packages-dir --origin metadata failed"
```

- 涉及命令：appstream-builder×8, mkdir×1

#### oe_test_libappstream-glib_appstream-builder_02

- 描述：verify the uasge of libappstream-glib command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --log-dir --packages-dir --origin failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --log-dir --packages-dir --origin failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --icons-dir --packages-dir --origin metadata  failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --cache-dir --packages-dir --origin failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --basename --packages-dir --origin --max-threads failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --basename --packages-dir --origin --min-icon-size failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --basename --packages-dir --origin --old-metadata failed"
  CHECK_RESULT $? 0 0 "Check appstream-builder -v --basename --packages-dir --origin --veto-ignore failed"
```

- 涉及命令：appstream-builder×8, mkdir×1

#### oe_test_libappstream-glib_appstream-compose

- 描述：verify the uasge of libappstream-glib command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check appstream-compose -h failed"
  CHECK_RESULT $? 0 0 "Check appstream-compose --help failed"
  CHECK_RESULT $? 0 0 "Check appstream-compose --v failed"
  CHECK_RESULT $? 0 0 "Check appstream-compose --verbose failed"
  CHECK_RESULT $? 0 0 "Check appstream-compose -prefix failed"
  CHECK_RESULT $? 0 0 "Check appstream-compose --min-icon-size failed"
  CHECK_RESULT $? 0 0 "Check appstream-compose --basename failed"
```

- 涉及命令：appstream-compose×5, appstream-util×1

#### oe_test_libappstream-glib_appstream-util_01

- 描述：verify the uasge of libappstream-glib command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check appstream-util -h failed"
  CHECK_RESULT $? 0 0 "Check appstream-util --help failed"
  CHECK_RESULT $? 0 0 "Check appstream-util --nonet failed"
  CHECK_RESULT $? 0 0 "Check appstream-util --verbose --nonet failed"
  CHECK_RESULT $? 0 0 "Check appstream-util --version failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet add-language failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet add-provide failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v agreement-export failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet appdata-from-desktop failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet appdata-to-news failed"
```

- 涉及命令：appstream-util×6

#### oe_test_libappstream-glib_appstream-util_02

- 描述：verify the uasge of libappstream-glib command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet check-component failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet check-root failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet compare failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet convert failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet dump failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet generate-guid failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet incorporate failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet install failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet install-origin failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet markup-import simple failed"
```

- 涉及命令：appstream-util×10

#### oe_test_libappstream-glib_appstream-util_03

- 描述：verify the uasge of libappstream-glib command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet matrix-html failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet merge-appstream failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet mirror-screenshots failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet modify failed"
  CHECK_RESULT $? 0 0 "Check nohup appstream-util -v --profile --nonet news-to-appdata failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet non-package-yaml failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet query-installed failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet regex failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet replace-screenshots failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet search failed"
```

- 涉及命令：appstream-util×9

#### oe_test_libappstream-glib_appstream-util_04

- 描述：verify the uasge of libappstream-glib command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet search-category failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet search-pkgname failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet show-search-tokens failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet split-appstream failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet status-csv failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v status-html failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet uninstall failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet upgrade failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet validate failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet validate-relax failed"
```

- 涉及命令：appstream-util×10

#### oe_test_libappstream-glib_appstream-util_05

- 描述：verify the uasge of libappstream-glib command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet validate-strict failed"
  CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet vercmp failed"
  CHECK_RESULT $? 0 0 "Check nohup appstream-util -v --profile --nonet watch failed"
```

- 涉及命令：appstream-util×2, pgrep×1
