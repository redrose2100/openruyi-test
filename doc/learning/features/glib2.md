# glib2

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/glib2` |
| 注册用例数 | 15 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_glib2 | package glib2 test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_glib2_gapplication | test gapplication command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_glib2_gdbus | test gdbus command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_glib2_gdbus-codegen | test gdbus-codegen command | pre_test/run_test/post_test | 35 | ✔ |  |  |
| oe_test_glib2_gio | test gio command | pre_test/run_test/post_test | 21 | ✔ |  |  |
| oe_test_glib2_glib-compile-resources | test glib-compile-resources command | pre_test/run_test/post_test | 25 | ✔ |  |  |
| oe_test_glib2_glib-compile-schemas | test glib-compile-schemas command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_glib2_glib-genmarshal | test glib-genmarshal command | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_glib2_glib-gettextize | test glib-gettextize command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_glib2_glib-mkenums | test glib-mkenums command | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_glib2_gobject-query | test gobject-query command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_glib2_gresource | test gresource command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_glib2_gsettings | test gsettings command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_glib2_gtester | test gtester command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_glib2_gtester-report | test gtester-report command | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_glib2

- 描述：package glib2 test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The system does not install glib2"
  CHECK_RESULT $? 0 0 "Test. c write error"
  CHECK_RESULT $? 0 0 "Compilation failed, no hello binary is generated"
  CHECK_RESULT $? 0 0 "not Print Hello, world!"
```

- 涉及命令：rpm×1

#### oe_test_glib2_gapplication

- 描述：test gapplication command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "gapplication help check failed"
  CHECK_RESULT $? 0 0 "gapplication version check failed"
  CHECK_RESULT $? 0 0 "gapplication list-apps check failed"
  CHECK_RESULT $? 0 0 "gapplication help launch check failed"
  CHECK_RESULT $? 0 0 "gapplication help action check failed"
  CHECK_RESULT $? 0 0 "gapplication help list-actions check failed"
```

#### oe_test_glib2_gdbus

- 描述：test gdbus command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "gdbus help check failed"
  CHECK_RESULT $? 0 0 "gdbus introspect --session check failed"
  CHECK_RESULT $? 0 0 "gdbus introspect --xml check failed"
  CHECK_RESULT $? 0 0 "gdbus introspect --recurse check failed"
  CHECK_RESULT $? 0 0 "gdbus introspect --only-properties check failed"
  CHECK_RESULT $? 0 0 "gdbus call check failed"
  CHECK_RESULT $? 0 0 "gdbus call --timeout check failed"
  CHECK_RESULT $? 0 0 "gdbus emit check failed"
  CHECK_RESULT $? 0 0 "gdbus monitor check failed"
  CHECK_RESULT $? 0 0 "gdbus wait check failed"
```

- 涉及命令：kill×1

#### oe_test_glib2_gdbus-codegen

- 描述：test gdbus-codegen command
- 函数：`pre_test, run_test, post_test`
- 断言（35 条）：

```
  CHECK_RESULT $? 0 0 "gdbus-codegen --help check failed"
  CHECK_RESULT $? 0 0 "gdbus-codegen --interface-prefix check failed"
  CHECK_RESULT $? 0 0 "gdbus-codegen --interface-prefix content check failed"
  CHECK_RESULT $? 0 0 "gdbus-codegen --c-namespace check failed"
  CHECK_RESULT $? 0 0 "gdbus-codegen --c-namespace content check failed"
  CHECK_RESULT $? 0 0 "gdbus-codegen --c-generate-object-manager check failed"
  CHECK_RESULT $? 0 0 "gdbus-codegen --c-generate-object-manager content check failed"
  CHECK_RESULT $? 0 0 "gdbus-codegen --c-generate-autocleanup check failed"
  CHECK_RESULT $? 0 0 "gdbus-codegen --c-generate-autocleanup content check failed"
  CHECK_RESULT $? 0 0 "gdbus-codegen --generate-docbook check failed"
  CHECK_RESULT $? 0 0 "gdbus-codegen --generate-docbook content check failed"
  CHECK_RESULT $? 0 0 "gdbus-codegen --generate-md check failed"
  ... 共 35 条（其余见源脚本）
```

- 涉及命令：grep×15, test×2, mkdir×1

#### oe_test_glib2_gio

- 描述：test gio command
- 函数：`pre_test, run_test, post_test`
- 断言（21 条）：

```
  CHECK_RESULT $? 0 0 "gio help check failed"
  CHECK_RESULT $? 0 0 "gio version check failed"
  CHECK_RESULT $? 0 0 "gio info check failed"
  CHECK_RESULT $? 0 0 "gio cat check failed"
  CHECK_RESULT $? 0 0 "gio list check failed"
  CHECK_RESULT $? 0 0 "gio mkdir check failed"
  CHECK_RESULT $? 0 0 "gio mkdir directory creation check failed"
  CHECK_RESULT $? 0 0 "gio copy check failed"
  CHECK_RESULT $? 0 0 "gio copy file creation check failed"
  CHECK_RESULT $? 0 0 "gio move check failed"
  CHECK_RESULT $? 0 0 "gio move file check failed"
  CHECK_RESULT $? 0 0 "gio move source removal check failed"
  ... 共 21 条（其余见源脚本）
```

- 涉及命令：test×4, mkdir×1

#### oe_test_glib2_glib-compile-resources

- 描述：test glib-compile-resources command
- 函数：`pre_test, run_test, post_test`
- 断言（25 条）：

```
  CHECK_RESULT $? 0 0 "glib-compile-resources --help check failed"
  CHECK_RESULT $? 0 0 "glib-compile-resources --version check failed"
  CHECK_RESULT $? 0 0 "glib-compile-resources --target check failed"
  CHECK_RESULT $? 0 0 "glib-compile-resources --target output file check failed"
  CHECK_RESULT $? 0 0 "glib-compile-resources --sourcedir check failed"
  CHECK_RESULT $? 0 0 "glib-compile-resources --sourcedir output file check failed"
  CHECK_RESULT $? 0 0 "glib-compile-resources --generate check failed"
  CHECK_RESULT $? 0 0 "glib-compile-resources --generate output file check failed"
  CHECK_RESULT $? 0 0 "glib-compile-resources --generate-header check failed"
  CHECK_RESULT $? 0 0 "glib-compile-resources --generate-header content check failed"
  CHECK_RESULT $? 0 0 "glib-compile-resources --generate-source check failed"
  CHECK_RESULT $? 0 0 "glib-compile-resources --generate-source content check failed"
  ... 共 25 条（其余见源脚本）
```

- 涉及命令：grep×8, test×3, mkdir×1

#### oe_test_glib2_glib-compile-schemas

- 描述：test glib-compile-schemas command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "glib-compile-schemas --help check failed"
  CHECK_RESULT $? 0 0 "glib-compile-schemas --version check failed"
  CHECK_RESULT $? 0 0 "glib-compile-schemas --targetdir check failed"
  CHECK_RESULT $? 0 0 "glib-compile-schemas --targetdir content check failed"
  CHECK_RESULT $? 0 0 "glib-compile-schemas --dry-run check failed"
  CHECK_RESULT $? 0 0 "glib-compile-schemas --strict check failed"
  CHECK_RESULT $? 0 0 "glib-compile-schemas --strict content check failed"
  CHECK_RESULT $? 0 0 "glib-compile-schemas --allow-any-name check failed"
  CHECK_RESULT $? 0 0 "glib-compile-schemas --allow-any-name content check failed"
```

- 涉及命令：grep×3, mkdir×1

#### oe_test_glib2_glib-genmarshal

- 描述：test glib-genmarshal command
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "glib-genmarshal --help check failed"
  CHECK_RESULT $? 0 0 "glib-genmarshal --version check failed"
  CHECK_RESULT $? 0 0 "glib-genmarshal --prefix check failed"
  CHECK_RESULT $? 0 0 "glib-genmarshal --output check failed"
  CHECK_RESULT $? 0 0 "glib-genmarshal --output content check failed"
  CHECK_RESULT $? 0 0 "glib-genmarshal --skip-source check failed"
  CHECK_RESULT $? 0 0 "glib-genmarshal --internal check failed"
  CHECK_RESULT $? 0 0 "glib-genmarshal --valist-marshallers check failed"
  CHECK_RESULT $? 0 0 "glib-genmarshal --pragma-once check failed"
  CHECK_RESULT $? 0 0 "glib-genmarshal --include-header check failed"
  CHECK_RESULT $? 0 0 "glib-genmarshal --prototypes check failed"
  CHECK_RESULT $? 0 0 "glib-genmarshal --header check failed"
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：grep×1

#### oe_test_glib2_glib-gettextize

- 描述：test glib-gettextize command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "glib-gettextize --help check failed"
  CHECK_RESULT $? 0 0 "glib-gettextize --version check failed"
  CHECK_RESULT $? 0 0 "glib-gettextize basic check failed"
  CHECK_RESULT $? 0 0 "glib-gettextize po directory check failed"
  CHECK_RESULT $? 0 0 "glib-gettextize symlink check failed"
  CHECK_RESULT $? 0 0 "glib-gettextize --copy check failed"
  CHECK_RESULT $? 0 0 "glib-gettextize --copy file check failed"
  CHECK_RESULT $? 0 0 "glib-gettextize --copy not symlink check failed"
  CHECK_RESULT $? 0 0 "glib-gettextize --force check failed"
  CHECK_RESULT $? 0 0 "glib-gettextize --force po directory check failed"
  CHECK_RESULT $? 0 0 "glib-gettextize --copy --force check failed"
  CHECK_RESULT $? 0 0 "glib-gettextize --copy --force file check failed"
```

- 涉及命令：test×5, mkdir×1

#### oe_test_glib2_glib-mkenums

- 描述：test glib-mkenums command
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "glib-mkenums --help check failed"
  CHECK_RESULT $? 0 0 "glib-mkenums --version check failed"
  CHECK_RESULT $? 0 0 "glib-mkenums basic output check failed"
  CHECK_RESULT $? 0 0 "glib-mkenums --identifier-prefix output check failed"
  CHECK_RESULT $? 0 0 "glib-mkenums --symbol-prefix output check failed"
  CHECK_RESULT $? 0 0 "glib-mkenums --fhead check failed"
  CHECK_RESULT $? 0 0 "glib-mkenums --ftail check failed"
  CHECK_RESULT $? 0 0 "glib-mkenums --fprod check failed"
  CHECK_RESULT $? 0 0 "glib-mkenums --eprod check failed"
  CHECK_RESULT $? 0 0 "glib-mkenums --vhead check failed"
  CHECK_RESULT $? 0 0 "glib-mkenums --vprod check failed"
  CHECK_RESULT $? 0 0 "glib-mkenums --vtail check failed"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：grep×1

#### oe_test_glib2_gobject-query

- 描述：test gobject-query command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "gobject-query --help check failed"
  CHECK_RESULT $? 0 0 "gobject-query tree check failed"
  CHECK_RESULT $? 0 0 "gobject-query -r check failed"
  CHECK_RESULT $? 0 0 "gobject-query froots check failed"
  CHECK_RESULT $? 0 1 "gobject-query -n check failed"
  CHECK_RESULT $? 0 0 "gobject-query -n check failed"
  CHECK_RESULT $? 0 0 "gobject-query -b check failed"
  CHECK_RESULT $? 0 0 "gobject-query -i check failed"
  CHECK_RESULT $? 0 0 "gobject-query -s check failed"
```

#### oe_test_glib2_gresource

- 描述：test gresource command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "gresource help check failed"
  CHECK_RESULT $? 0 0 "gresource sections check failed"
  CHECK_RESULT $? 0 0 "gresource list check failed"
  CHECK_RESULT $? 0 0 "gresource details check failed"
  CHECK_RESULT $? 0 0 "gresource extract check failed"
  CHECK_RESULT $? 0 0 "gresource --section check failed"
```

- 涉及命令：mkdir×1

#### oe_test_glib2_gsettings

- 描述：test gsettings command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "gsettings help check failed"
  CHECK_RESULT $? 0 0 "gsettings --version check failed"
  CHECK_RESULT $? 0 0 "gsettings list-schemas check failed"
  CHECK_RESULT $? 0 0 "gsettings list-relocatable-schemas check failed"
  CHECK_RESULT $? 0 0 "gsettings list-keys check failed"
  CHECK_RESULT $? 0 0 "gsettings list-recursively check failed"
  CHECK_RESULT $? 0 0 "gsettings get check failed"
  CHECK_RESULT $? 0 0 "gsettings range check failed"
  CHECK_RESULT $? 0 0 "gsettings describe check failed"
  CHECK_RESULT $? 0 0 "gsettings writable check failed"
```

#### oe_test_glib2_gtester

- 描述：test gtester command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "gtester --help check failed"
  CHECK_RESULT $? 0 0 "gtester --version check failed"
  CHECK_RESULT $? 0 0 "gtester --verbose check failed"
  CHECK_RESULT $? 0 0 "gtester -l check failed"
  CHECK_RESULT $? 0 0 "gtester -m quick check failed"
  CHECK_RESULT $? 0 0 "gtester -p check failed"
  CHECK_RESULT $? 0 1 "gtester -p check failed"
  CHECK_RESULT $? 0 0 "gtester -s check failed"
  CHECK_RESULT $? 0 0 "gtester -o file check failed"
  CHECK_RESULT $? 0 0 "gtester -k check failed"
  CHECK_RESULT $? 0 1 "gtester --quiet check failed"
```

- 涉及命令：gtester×6, grep×1

#### oe_test_glib2_gtester-report

- 描述：test gtester-report command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "gtester-report --help check failed"
  CHECK_RESULT $? 0 0 "gtester-report --version check failed"
  CHECK_RESULT $? 0 0 "gtester-report basic check failed"
  CHECK_RESULT $? 0 0 "gtester-report report title check failed"
```
