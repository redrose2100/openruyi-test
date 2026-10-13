# ImageMagick

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ImageMagick` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ImageMagick_01 | verification ImageMagick‘s command | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_ImageMagick_02 | verification ImageMagick‘s command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_ImageMagick_03 | verification ImageMagick‘s command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_ImageMagick_04 | verification ImageMagick‘s command | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_ImageMagick_05 | verification ImageMagick‘s command | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_ImageMagick_06 | verification ImageMagick‘s command | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_ImageMagick_07 | verification ImageMagick‘s command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_ImageMagick_08 | verification ImageMagick‘s command | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ImageMagick_01

- 描述：verification ImageMagick‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

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
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：test×7, convert×2

#### oe_test_ImageMagick_02

- 描述：verification ImageMagick‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT "$(identify -verbose thumbnail.jpg | grep Quality | grep -cE '70')" 1
  CHECK_RESULT "$(identify -verbose thumbnail1.jpg | grep Quality | grep -cE '100')" 1
  CHECK_RESULT "$(identify -verbose thumbnail2.jpg | grep Quality | grep -cE '100')" 1
  CHECK_RESULT "$(identify -verbose thumbnail3.jpg | grep Quality | grep -cE '100')" 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：convert×7, test×3

#### oe_test_ImageMagick_03

- 描述：verification ImageMagick‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

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
```

- 涉及命令：test×6, convert×5

#### oe_test_ImageMagick_04

- 描述：verification ImageMagick‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

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
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：test×7, convert×6

#### oe_test_ImageMagick_05

- 描述：verification ImageMagick‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

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
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：test×9, convert×5, composite×1

#### oe_test_ImageMagick_06

- 描述：verification ImageMagick‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

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
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：test×8, composite×4, compare×2

#### oe_test_ImageMagick_07

- 描述：verification ImageMagick‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

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
```

- 涉及命令：test×5, montage×2, compare×1

#### oe_test_ImageMagick_08

- 描述：verification ImageMagick‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(identify -precision 5 -define identify:locate=maximum -define identify:limit=3 test1.jpg | grep -cE 'Red|Green|Blue')" 3
```

- 涉及命令：mogrify×3, identify×3, test×1
