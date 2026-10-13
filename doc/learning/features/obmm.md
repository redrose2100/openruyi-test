# obmm

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `$OET_PATH/testcases/feature-test/obmm` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_obmm_ko_para_003 | [pmd_mapping<100%] mempool_allocator模块参数测试 | pre_test/run_test/post_test | 34 |  |  |  |
| oe_test_obmm_export_granu | 导出粒度测试 | pre_test/run_test/post_test | 24 |  |  |  |
| oe_test_obmm_ko_para_004 | [pmd_mapping=100%] mempool_allocator模块参数测试 | pre_test/run_test/post_test | 33 |  |  |  |
| oe_test_obmm_ko_para_001 | ko内核模块参数测试: mempool_size | get_export_nid/pre_test/run_test/post_test | 33 |  |  |  |
| oe_test_obmm_cmdline_pmd_mapping_001 | cmdline配置：pmd_mapping配置参数测试--pmd_mapping=0% | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_obmm_cmdline_pmd_mapping_002 | cmdline配置：pmd_mapping配置参数测试--pmd_mapping=12%（16G 2numa环境） | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_obmm_cmdline_pmd_mapping_003 | cmdline配置：pmd_mapping配置参数测试--pmd_mapping=13%（16G 2numa环境） | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_obmm_cmdline_pmd_mapping_004 | cmdline配置：pmd_mapping配置参数测试--pmd_mapping=100% | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_obmm_cmdline_pmd_mapping_005 | cmdline配置：pmd_mapping配置参数测试--不配置pmd_mapping | pre_test/run_test/post_test | 3 |  |  |  |

### 断言与命令明细

#### oe_test_obmm_ko_para_003

- 描述：[pmd_mapping<100%] mempool_allocator模块参数测试
- 函数：`pre_test, run_test, post_test`
- 断言（34 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  ... 共 34 条（其余见源脚本）
```

- 涉及命令：dmesg×10

#### oe_test_obmm_export_granu

- 描述：导出粒度测试
- 函数：`pre_test, run_test, post_test`
- 断言（24 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  ... 共 24 条（其余见源脚本）
```

- 涉及命令：dmesg×5

#### oe_test_obmm_ko_para_004

- 描述：[pmd_mapping=100%] mempool_allocator模块参数测试
- 函数：`pre_test, run_test, post_test`
- 断言（33 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0
  ... 共 33 条（其余见源脚本）
```

- 涉及命令：dmesg×7

#### oe_test_obmm_ko_para_001

- 描述：ko内核模块参数测试: mempool_size
- 函数：`get_export_nid, pre_test, run_test, post_test`
- 断言（33 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 0 "pool_size=$pool_size"
  ... 共 33 条（其余见源脚本）
```

- 涉及命令：dmesg×24

#### oe_test_obmm_cmdline_pmd_mapping_001

- 描述：cmdline配置：pmd_mapping配置参数测试--pmd_mapping=0%
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
```

- 涉及命令：grep×1

#### oe_test_obmm_cmdline_pmd_mapping_002

- 描述：cmdline配置：pmd_mapping配置参数测试--pmd_mapping=12%（16G 2numa环境）
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
```

- 涉及命令：grep×1

#### oe_test_obmm_cmdline_pmd_mapping_003

- 描述：cmdline配置：pmd_mapping配置参数测试--pmd_mapping=13%（16G 2numa环境）
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $((end_addr - start_addr)) $GB2B
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
```

- 涉及命令：grep×2

#### oe_test_obmm_cmdline_pmd_mapping_004

- 描述：cmdline配置：pmd_mapping配置参数测试--pmd_mapping=100%
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
```

- 涉及命令：grep×1

#### oe_test_obmm_cmdline_pmd_mapping_005

- 描述：cmdline配置：pmd_mapping配置参数测试--不配置pmd_mapping
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
```

- 涉及命令：grep×1
