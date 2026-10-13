# rust

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rust` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_rustc_01 | Image compression tool rustc | pre_test/run_test/post_test | 35 | ✔ |  |  |
| oe_test_rustc_02 | Rust language tools rustc | pre_test/run_test/post_test | 27 | ✔ |  |  |
| oe_test_rustc_03 | Rust language tools rustc | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_rustdoc | Rust language tools rustdoc | pre_test/run_test/post_test | 21 | ✔ |  |  |
| oe_test_cargo_01 | Rust language tools cargo | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_cargo_02 | Rust language tools cargo | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_clippy | Rust language tools clippy | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_rustfmt | Rust language tools rustfmt | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_rustc_01

- 描述：Image compression tool rustc
- 函数：`pre_test, run_test, post_test`
- 断言（35 条）：

```
  CHECK_RESULT $? 0 0 "Help information printing failed"
  CHECK_RESULT $? 0 0 "Failed to print world！"
  CHECK_RESULT $? 0 0 "Failed to output the hello1 file"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to output the pub file"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to output the lib_lib.rlib file"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to output the lib_rlib.rlib file"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to output the lib_dy.so file"
  CHECK_RESULT $?
  ... 共 35 条（其余见源脚本）
```

- 涉及命令：test×17, rustc×2

#### oe_test_rustc_02

- 描述：Rust language tools rustc
- 函数：`pre_test, run_test, post_test`
- 断言（27 条）：

```
  CHECK_RESULT $? 0 0 "Failed to output the hello file"
  CHECK_RESULT $? 0 0 "Failed to output the hello file"
  CHECK_RESULT $? 0 0 "Failed to output the sysroot information"
  CHECK_RESULT $? 0 0 "Failed to output the target libdir"
  CHECK_RESULT $? 0 0 "Failed to output the cfg information"
  CHECK_RESULT $? 0 0 "Failed to output the target list"
  CHECK_RESULT $? 0 0 "Failed to output the target cpus"
  CHECK_RESULT $? 0 0 "Failed to output the target features"
  CHECK_RESULT $? 0 0 "Failed to output the relocation models"
  CHECK_RESULT $? 0 0 "Failed to output the code models"
  CHECK_RESULT $? 0 0 "Failed to output the stls models"
  CHECK_RESULT $?
  ... 共 27 条（其余见源脚本）
```

- 涉及命令：test×6, rustc×3

#### oe_test_rustc_03

- 描述：Rust language tools rustc
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set Linter option Deny"
  CHECK_RESULT $? 0 0 "Failed to set Linter option Forbit"
  CHECK_RESULT $? 0 0 "Failed to set Linter level warning"
  CHECK_RESULT $? 0 0 "Failed to output the hello_C file"
  CHECK_RESULT $? 0 0 "Failed to output the version information"
  CHECK_RESULT $? 0 0 "Failed to output the hello_v file"
  CHECK_RESULT $? 0 0 "-C help printing fails"
  CHECK_RESULT $? 0 0 "-W help printing fails"
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Link library failed"
```

- 涉及命令：rustc×6

#### oe_test_rustdoc

- 描述：Rust language tools rustdoc
- 函数：`pre_test, run_test, post_test`
- 断言（21 条）：

```
  CHECK_RESULT $? 0 0 "Help information printing failed"
  CHECK_RESULT $? 0 0 "Failed to output the version information"
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to specify the output path"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to pass configuration parameters"
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to run the test code"
  CHECK_RESULT $?
  ... 共 21 条（其余见源脚本）
```

- 涉及命令：test×4, rustdoc×3

#### oe_test_cargo_01

- 描述：Rust language tools cargo
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Help information printing failed"
  CHECK_RESULT $? 0 0 "Failed to output the version information"
  CHECK_RESULT $? 0 0 "Failed to list commands"
  CHECK_RESULT $? 0 0 "Failed to interpret code command"
  CHECK_RESULT $? 0 0 "Failed to list details"
  CHECK_RESULT $? 0 0 "Silent output failure"
  CHECK_RESULT $? 0 0 "Color setting failed"
  CHECK_RESULT $? 0 0 "Failed to run offline"
  CHECK_RESULT $? 0 0 "Help printing failed"
```

- 涉及命令：cargo×4

#### oe_test_cargo_02

- 描述：Rust language tools cargo
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to create a new package"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to compile package"
  CHECK_RESULT $? 0 0 "Failed to run package"
  CHECK_RESULT $? 0 0 "Failed to execute tests"
  CHECK_RESULT $? 0 0 "Failed to execute the benchmark"
  CHECK_RESULT $? 0 0 "Failure check kit"
  CHECK_RESULT $? 0 0 "Failed to build the package document"
  CHECK_RESULT $? 1 0 "Failed to delete a file"
  CHECK_RESULT $? 0 0 "Failed to create a new package"
  CHECK_RESULT $? 0 0 "Failed to update file"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：test×1

#### oe_test_clippy

- 描述：Rust language tools clippy
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "Help information printing failed"
  CHECK_RESULT $? 0 0 "Failed to output the version information"
  CHECK_RESULT $? 0 0 "Failure check"
  CHECK_RESULT $? 0 0 "Failed setup warning"
  CHECK_RESULT $? 0 0 "Failed setup Allow"
  CHECK_RESULT $? 0 0 "Failed setup Deny"
  CHECK_RESULT $? 0 0 "Failed setup Forbit"
  CHECK_RESULT $? 0 0 "Help information printing failed"
  CHECK_RESULT $? 0 0 "Failed to output the version information"
  CHECK_RESULT $? 0 0 "Failed to pass parameters"
  CHECK_RESULT $? 0 0 "Failed to set Linter option Allow"
  CHECK_RESULT $? 0 0 "Failed to set Linter option Allow"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：cargo-clippy×6, clippy-driver×2

#### oe_test_rustfmt

- 描述：Rust language tools rustfmt
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "cargo-fmt Help information printing failed"
  CHECK_RESULT $? 0 0 "Check the failure"
  CHECK_RESULT $? 0 0 "Check the failure"
  CHECK_RESULT $? 0 0 "Failed to set the 2018 version"
  CHECK_RESULT $? 0 0 "rustfmt Help information printing failed"
  CHECK_RESULT $? 0 0 "Default configuration failed"
  CHECK_RESULT $? 0 0 "Color setting failed"
  CHECK_RESULT $? 0 0 "Failed to output the version information of rustfmt"
```

- 涉及命令：rustfmt×2, cargo-fmt×1
