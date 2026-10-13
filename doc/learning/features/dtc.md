# dtc

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/dtc` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_dtc | dtc basic function | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_dtc_control | dtc basic function | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_dtc_blob | dtc basic function | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_dtc_format | dtc basic function | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_dtc_symbol | dtc basic function | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_dtc_info | dtc basic function | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_dtc

- 描述：dtc basic function
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "Compilation failed"
  CHECK_RESULT $? 0 0 "File generation failed"
  CHECK_RESULT $? 0 0 "Decompile failed"
  CHECK_RESULT $? 0 0 "File generation failed"
```

- 涉及命令：dtc×2, test×2

#### oe_test_dtc_control

- 描述：dtc basic function
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Compile with quiet mode (-q) failed"
  CHECK_RESULT $? 0 0 "control_quiet.dtb not generated"
  CHECK_RESULT $? 0 0 "Compile with more quiet mode (-qq) failed"
  CHECK_RESULT $? 0 0 "control_qq.dtb not generated"
  CHECK_RESULT $? 0 0 "Compile with most quiet mode (-qqq) failed"
  CHECK_RESULT $? 0 0 "control_qqq.dtb not generated"
  CHECK_RESULT $? 0 0 "Compile with force mode (-f) failed"
  CHECK_RESULT $? 0 0 "control_force.dtb not generated"
  CHECK_RESULT $? 0 0 "Compile with quiet+force mode (-q -f) failed"
  CHECK_RESULT $? 0 0 "control_q_force.dtb not generated"
```

- 涉及命令：dtc×5, test×5, mkdir×1

#### oe_test_dtc_blob

- 描述：dtc basic function
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Compile with blob version 17 failed"
  CHECK_RESULT $? 0 0 "blob_v17.dtb not generated"
  CHECK_RESULT $? 0 0 "Compile with reserve map failed"
  CHECK_RESULT $? 0 0 "blob_reserve.dtb not generated"
  CHECK_RESULT $? 0 0 "Compile with minimum space failed"
  CHECK_RESULT $? 0 0 "blob_space.dtb not generated"
  CHECK_RESULT $? 0 0 "Compile with padding failed"
  CHECK_RESULT $? 0 0 "blob_pad.dtb not generated"
  CHECK_RESULT $? 0 0 "Compile with align and boot CPU failed"
  CHECK_RESULT $? 0 0 "blob_align_boot.dtb not generated"
```

- 涉及命令：dtc×5, test×5, mkdir×1

#### oe_test_dtc_format

- 描述：dtc basic function
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Convert dts to dtb failed"
  CHECK_RESULT $? 0 0 "basic.dtb not generated"
  CHECK_RESULT $? 0 0 "Convert dtb to dts failed"
  CHECK_RESULT $? 0 0 "basic_recover.dts not generated"
  CHECK_RESULT $? 0 0 "Convert dts to asm failed"
  CHECK_RESULT $? 0 0 "basic.asm not generated"
```

- 涉及命令：dtc×3, test×3, mkdir×1

#### oe_test_dtc_symbol

- 描述：dtc basic function
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Compile with symbol generation only (-@) failed"
  CHECK_RESULT $? 0 0 "symbol_only_sym.dtb not generated"
  CHECK_RESULT $? 0 0 "Compile with auto alias only (-A) failed"
  CHECK_RESULT $? 0 0 "symbol_only_alias.dtb not generated"
  CHECK_RESULT $? 0 0 "Compile with phandle (epapr) only (-H epapr) failed"
  CHECK_RESULT $? 0 0 "symbol_only_phandle_epapr.dtb not generated"
  CHECK_RESULT $? 0 0 "Compile with phandle (both) only (-H both) failed"
  CHECK_RESULT $? 0 0 "symbol_only_phandle_both.dtb not generated"
  CHECK_RESULT $? 0 0 "Compile with symbols+auto alias (-@ -A) failed"
  CHECK_RESULT $? 0 0 "symbol_sym_alias.dtb not generated"
```

- 涉及命令：test×5, dtc×3, mkdir×1

#### oe_test_dtc_info

- 描述：dtc basic function
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Generate dependency file failed"
  CHECK_RESULT $? 0 0 "info.dep not generated"
  CHECK_RESULT $? 0 0 "Compile with sort failed"
  CHECK_RESULT $? 0 0 "info_sorted.dtb not generated"
  CHECK_RESULT $? 0 0 "Decompile with annotation failed"
  CHECK_RESULT $? 0 0 "info_annot.dts not generated"
  CHECK_RESULT $? 0 0 "Compile with include path failed"
  CHECK_RESULT $? 0 0 "info_include.dtb not generated"
```

- 涉及命令：dtc×4, test×4, mkdir×1
