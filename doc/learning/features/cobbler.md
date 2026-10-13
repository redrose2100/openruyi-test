# cobbler

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/cobbler` |
| 注册用例数 | 10 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_cobbler_distro | Test "cobbler distro" command | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_cobbler_profile | Test "cobbler profile" command | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_cobbler_system | Test "cobbler system" command | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_cobbler_repo | Test "cobbler repo" command | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_cobbler_image | Test "cobbler image" command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_cobbler_mgmtclass | Test "cobbler mgmtclass" command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_cobbler_package | Test "cobbler package" command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_cobbler_file | Test "cobbler file" command | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_cobbler_other | Test "other cobbler" command | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_service_cobblerd | Test cobblerd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_cobbler_distro

- 描述：Test "cobbler distro" command
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: distro add"
  CHECK_RESULT $? 0 0 "Failed option: distro add"
  CHECK_RESULT $? 0 0 "Failed option: distro add"
  CHECK_RESULT $? 0 0 "Failed option: distro copy"
  CHECK_RESULT $? 0 0 "Failed option: distro copy"
  CHECK_RESULT $? 0 0 "Failed option: distro edit"
  CHECK_RESULT $? 0 0 "Failed option: distro edit"
  CHECK_RESULT $? 0 0 "Failed option: distro list"
  CHECK_RESULT $? 0 0 "Failed option: distro find"
  CHECK_RESULT $? 0 0 "Failed option: distro remove"
  CHECK_RESULT $? 0 1 "Failed option: distro remove"
  CHECK_RESULT $? 0 0 "Failed option: distro rename"
  ... 共 14 条（其余见源脚本）
```

#### oe_test_cobbler_profile

- 描述：Test "cobbler profile" command
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: profile add"
  CHECK_RESULT $? 0 0 "Failed option: profile copy"
  CHECK_RESULT $? 0 0 "Failed option: profile copy"
  CHECK_RESULT $? 0 0 "Failed option: profile dumpvars"
  CHECK_RESULT $? 0 0 "Failed option: profile edit"
  CHECK_RESULT $? 0 0 "Failed option: profile edit"
  CHECK_RESULT $? 0 0 "Failed option: profile list"
  CHECK_RESULT $? 0 0 "Failed option: profile find"
  CHECK_RESULT $? 0 0 "Failed option: profile remove"
  CHECK_RESULT $? 0 1 "Failed option: profile remove"
  CHECK_RESULT $? 0 0 "Failed option: profile rename"
  CHECK_RESULT $? 0 0 "Failed option: profile rename"
  ... 共 14 条（其余见源脚本）
```

#### oe_test_cobbler_system

- 描述：Test "cobbler system" command
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: system add"
  CHECK_RESULT $? 0 0 "Failed option: system copy"
  CHECK_RESULT $? 0 0 "Failed option: sysetm copy"
  CHECK_RESULT $? 0 0 "Failed option: system dumpvars"
  CHECK_RESULT $? 0 0 "Failed option: system edit"
  CHECK_RESULT $? 0 0 "Failed option: system edit"
  CHECK_RESULT $? 0 0 "Failed option: system list"
  CHECK_RESULT $? 0 0 "Failed option: system find"
  CHECK_RESULT $? 0 0 "Failed option: system remove"
  CHECK_RESULT $? 0 1 "Failed option: system remove"
  CHECK_RESULT $? 0 0 "Failed option: system rename"
  CHECK_RESULT $? 0 0 "Failed option: system rename"
  ... 共 18 条（其余见源脚本）
```

#### oe_test_cobbler_repo

- 描述：Test "cobbler repo" command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: repo add"
  CHECK_RESULT $? 0 0 "Failed option: repo add"
  CHECK_RESULT $? 0 0 "Failed option: repo copy"
  CHECK_RESULT $? 0 0 "Failed option: repo copy"
  CHECK_RESULT $? 0 0 "Failed option: repo edit"
  CHECK_RESULT $? 0 0 "Failed option: repo edit"
  CHECK_RESULT $? 0 0 "Failed option: repo list"
  CHECK_RESULT $? 0 0 "Failed option: repo find"
  CHECK_RESULT $? 0 0 "Failed option: repo remove"
  CHECK_RESULT $? 0 1 "Failed option: repo remove"
  CHECK_RESULT $? 0 0 "Failed option: repo rename"
  CHECK_RESULT $? 0 0 "Failed option: repo rename"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：mkdir×2

#### oe_test_cobbler_image

- 描述：Test "cobbler image" command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: image add"
  CHECK_RESULT $? 0 0 "Failed option: image copy"
  CHECK_RESULT $? 0 0 "Failed option: image copy"
  CHECK_RESULT $? 0 0 "Failed option: image edit"
  CHECK_RESULT $? 0 0 "Failed option: image edit"
  CHECK_RESULT $? 0 0 "Failed option: image list"
  CHECK_RESULT $? 0 0 "Failed option: image find"
  CHECK_RESULT $? 0 0 "Failed option: image remove"
  CHECK_RESULT $? 0 1 "Failed option: image remove"
  CHECK_RESULT $? 0 0 "Failed option: image rename"
  CHECK_RESULT $? 0 0 "Failed option: image rename"
  CHECK_RESULT $? 0 0 "Failed option: image report"
```

- 涉及命令：mkdir×2

#### oe_test_cobbler_mgmtclass

- 描述：Test "cobbler mgmtclass" command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: mgmtclass add"
  CHECK_RESULT $? 0 0 "Failed option: mgmtclass copy"
  CHECK_RESULT $? 0 0 "Failed option: mgmtclass copy"
  CHECK_RESULT $? 0 0 "Failed option: mgmtclass edit"
  CHECK_RESULT $? 0 0 "Failed option: mgmtclass edit"
  CHECK_RESULT $? 0 0 "Failed option: mgmtclass list"
  CHECK_RESULT $? 0 0 "Failed option: mgmtclass find"
  CHECK_RESULT $? 0 0 "Failed option: mgmtclass remove"
  CHECK_RESULT $? 0 1 "Failed option: mgmtclass remove"
  CHECK_RESULT $? 0 0 "Failed option: mgmtclass rename"
  CHECK_RESULT $? 0 0 "Failed option: mgmtclass rename"
  CHECK_RESULT $? 0 0 "Failed option: mgmtclass report"
```

- 涉及命令：mkdir×2

#### oe_test_cobbler_package

- 描述：Test "cobbler package" command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: package add"
  CHECK_RESULT $? 0 0 "Failed option: package copy"
  CHECK_RESULT $? 0 0 "Failed option: package copy"
  CHECK_RESULT $? 0 0 "Failed option: package edit"
  CHECK_RESULT $? 0 0 "Failed option: package edit"
  CHECK_RESULT $? 0 0 "Failed option: package list"
  CHECK_RESULT $? 0 0 "Failed option: package find"
  CHECK_RESULT $? 0 0 "Failed option: package remove"
  CHECK_RESULT $? 0 1 "Failed option: package remove"
  CHECK_RESULT $? 0 0 "Failed option: package rename"
  CHECK_RESULT $? 0 0 "Failed option: package rename"
  CHECK_RESULT $? 0 0 "Failed option: package report"
```

- 涉及命令：mkdir×2

#### oe_test_cobbler_file

- 描述：Test "cobbler file" command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: file add"
  CHECK_RESULT $? 0 0 "Failed option: file add"
  CHECK_RESULT $? 0 0 "Failed option: file copy"
  CHECK_RESULT $? 0 0 "Failed option: file copy"
  CHECK_RESULT $? 0 0 "Failed option: file edit"
  CHECK_RESULT $? 0 0 "Failed option: file edit"
  CHECK_RESULT $? 0 0 "Failed option: file list"
  CHECK_RESULT $? 0 0 "Failed option: file find"
  CHECK_RESULT $? 0 0 "Failed option: file remove"
  CHECK_RESULT $? 0 1 "Failed option: file remove"
  CHECK_RESULT $? 0 0 "Failed option: file rename"
  CHECK_RESULT $? 0 0 "Failed option: file rename"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：mkdir×2

#### oe_test_cobbler_other

- 描述：Test "other cobbler" command
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: aclsetup"
  CHECK_RESULT $? 0 0 "Failed option: buildiso"
  CHECK_RESULT $? 0 0 "Failed option: buildiso"
  CHECK_RESULT $? 0 0 "Failed option: import"
  CHECK_RESULT $? 0 0 "Failed option: list"
  CHECK_RESULT $? 0 0 "Failed option: report"
  CHECK_RESULT $? 0 0 "Failed option: reposync"
  CHECK_RESULT $? 0 0 "Failed option: sync"
  CHECK_RESULT $? 0 0 "Failed option: validate-autoinstalls"
  CHECK_RESULT $? 0 0 "Failed option: version"
  CHECK_RESULT $? 0 0 "Failed option: signature update"
  CHECK_RESULT $? 0 0 "Failed option: signature reload"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：test×1

#### oe_test_service_cobblerd

- 描述：Test cobblerd.service restart
- 函数：`pre_test, run_test, post_test`