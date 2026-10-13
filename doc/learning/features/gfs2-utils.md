# gfs2-utils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/gfs2-utils` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gfs2-utils_fsck.gfs2 | test fsck.gfs2 command | config_params/pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_gfs2-utils_gfs2_edit_01 | test gfs2_edit and gfs2_convert command | config_params/pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_gfs2-utils_gfs2_edit_02 | test gfs2_edit -p commands | config_params/pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_gfs2-utils_gfs2_grow | test gfs2_grow command | config_params/pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_gfs2-utils_gfs2_jadd | test gfs2_jadd command | config_params/pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_gfs2-utils_glocktop | test glocktop command | config_params/pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_gfs2-utils_mkfs.gfs2 | test mkfs.gfs2 command | config_params/pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_gfs2-utils_tunegfs2 | test tunegfs2 command | config_params/pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gfs2-utils_fsck.gfs2

- 描述：test fsck.gfs2 command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "fsck.gfs2 -h check failed"
  CHECK_RESULT $? 0 0 "fsck.gfs2 -V check failed"
  CHECK_RESULT $? 0 0 "fsck.gfs2 -v check failed"
  CHECK_RESULT $? 0 0 "fsck.gfs2 -n check failed"
  CHECK_RESULT $? 0 0 "fsck.gfs2 -y check failed"
  CHECK_RESULT $? 0 0 "fsck.gfs2 -a check failed"
  CHECK_RESULT $? 0 0 "fsck.gfs2 -p check failed"
```

- 涉及命令：fsck.gfs2×7, mkfs.gfs2×1, losetup×1

#### oe_test_gfs2-utils_gfs2_edit_01

- 描述：test gfs2_edit and gfs2_convert command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "gfs2_convert -h check failed"
  CHECK_RESULT $? 0 0 "gfs2_convert -V check failed"
  CHECK_RESULT $? 0 0 "gfs2_convert -v check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -h check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -V check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit rgcount check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit rgflags check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -z 0 savergs check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -c 1 check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -s root check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -x check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -d -p journals check failed"
```

- 涉及命令：gfs2_edit×7, gfs2_convert×3, mkfs.gfs2×1, test×1, losetup×1

#### oe_test_gfs2-utils_gfs2_edit_02

- 描述：test gfs2_edit -p commands
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "gfs2_edit -p sb check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -p size check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -p master check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -p root check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -p jindex check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -p per_node check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -p inum check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -p statfs check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -p rindex check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -p rgs check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -p quota check failed"
  CHECK_RESULT $? 0 0 "gfs2_edit -p blocktype check failed"
```

- 涉及命令：gfs2_edit×12, mkfs.gfs2×1, losetup×1

#### oe_test_gfs2-utils_gfs2_grow

- 描述：test gfs2_grow command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "gfs2_grow -h check failed"
  CHECK_RESULT $? 0 0 "gfs2_grow -V check failed"
  CHECK_RESULT $? 0 0 "gfs2_grow -T check failed"
  CHECK_RESULT $? 0 0 "gfs2_grow -v check failed"
  CHECK_RESULT $? 0 1 "gfs2_grow -q check failed"
```

- 涉及命令：gfs2_grow×5, losetup×3, truncate×2, mkfs.gfs2×1, mkdir×1, test×1

#### oe_test_gfs2-utils_gfs2_jadd

- 描述：test gfs2_jadd command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "gfs2_jadd -h check failed"
  CHECK_RESULT $? 0 0 "gfs2_jadd -V check failed"
  CHECK_RESULT $? 0 0 "gfs2_jadd -J check failed"
  CHECK_RESULT $? 0 0 "gfs2_jadd -j check failed"
  CHECK_RESULT $? 0 0 "gfs2_jadd -D check failed"
  CHECK_RESULT $? 0 0 "gfs2_jadd -c check failed"
  CHECK_RESULT $? 0 1 "gfs2_jadd -q check failed"
```

- 涉及命令：gfs2_jadd×7, mkfs.gfs2×1, mkdir×1, test×1, losetup×1

#### oe_test_gfs2-utils_glocktop

- 描述：test glocktop command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "glocktop -h check failed"
  CHECK_RESULT $? 0 0 "glocktop -t check failed"
  CHECK_RESULT $? 0 0 "glocktop -d check failed"
  CHECK_RESULT $? 0 0 "glocktop -n check failed"
  CHECK_RESULT $? 0 0 "glocktop -H check failed"
  CHECK_RESULT $? 0 0 "glocktop -r check failed"
  CHECK_RESULT $? 0 0 "glocktop -s check failed"
```

- 涉及命令：mkfs.gfs2×1, mkdir×1, glocktop×1, losetup×1

#### oe_test_gfs2-utils_mkfs.gfs2

- 描述：test mkfs.gfs2 command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "mkfs.gfs2 -h check failed"
  CHECK_RESULT $? 0 0 "mkfs.gfs2 -V check failed"
  CHECK_RESULT $? 0 0 "mkfs.gfs2 -O check failed"
  CHECK_RESULT $? 0 1 "mkfs.gfs2 -K check failed"
  CHECK_RESULT $? 0 0 "mkfs.gfs2 -D check failed"
  CHECK_RESULT $? 0 0 "mkfs.gfs2 -b check failed"
  CHECK_RESULT $? 0 0 "mkfs.gfs2 -c check failed"
  CHECK_RESULT $? 0 0 "mkfs.gfs2 -J check failed"
  CHECK_RESULT $? 0 0 "mkfs.gfs2 -j check failed"
  CHECK_RESULT $? 0 0 "mkfs.gfs2 -q check failed"
  CHECK_RESULT $? 0 0 "mkfs.gfs2 -r check failed"
  CHECK_RESULT $? 0 0 "mkfs.gfs2 -t check failed"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：mkfs.gfs2×13, losetup×1

#### oe_test_gfs2-utils_tunegfs2

- 描述：test tunegfs2 command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "tunegfs2 -h check failed"
  CHECK_RESULT $? 0 0 "tunegfs2 -V check failed"
  CHECK_RESULT $? 0 0 "tunegfs2 -L check failed"
  CHECK_RESULT $? 0 0 "tunegfs2 -L label not set"
  CHECK_RESULT $? 0 0 "tunegfs2 -r check failed"
  CHECK_RESULT $? 0 0 "tunegfs2 -r version not set"
  CHECK_RESULT $? 0 0 "tunegfs2 -U check failed"
  CHECK_RESULT $? 0 0 "tunegfs2 -U UUID not set"
  CHECK_RESULT $? 0 0 "tunegfs2 -o locktable check failed"
  CHECK_RESULT $? 0 0 "tunegfs2 -o locktable not effective"
```

- 涉及命令：tunegfs2×10, mkfs.gfs2×1, losetup×1
