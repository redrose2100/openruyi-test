# rrdtool

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rrdtool` |
| 注册用例数 | 36 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_rrdcached | Test rrdcached.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_rrdcached | Test rrdcached.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_rrdtool_create_01 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_create_02 | Test rrdtool | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_rrdtool_update | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graph_01 | Test rrdtool | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_rrdtool_graph_02 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graph_03 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graph_04 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graph_05 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graph_06 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graph_07 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graph_08 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graph_09 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graph_10 | Test rrdtool | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_rrdtool_graphv_01 | Test rrdtool | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_rrdtool_graphv_02 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graphv_03 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graphv_04 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graphv_05 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graphv_06 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graphv_07 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graphv_08 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graphv_09 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_graphv_10 | Test rrdtool | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_rrdtool_dump | Test rrdtool | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_rrdtool_restore | Test rrdtool | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_rrdtool_fetch | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_info | Test rrdtool | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_rrdtool_xport_01 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_xport_02 | Test rrdtool | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_rrdtool_flushcached | Test rrdtool | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_rrdtool_rrdcached_01 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_rrdcached_02 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_rrdcreate_01 | Test rrdtool | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rrdtool_rrdcreate_02 | Test rrdtool | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_rrdcached

- 描述：Test rrdcached.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_rrdcached

- 描述：Test rrdcached.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_rrdtool_create_01

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool create: faild to test option --start"
  CHECK_RESULT $? 0 0 "rrdtool create: faild to test option -b"
  CHECK_RESULT $? 0 0 "rrdtool create: faild to test option --step"
  CHECK_RESULT $? 0 0 "rrdtool create: faild to test option -s"
  CHECK_RESULT $? 0 0 "rrdtool create: faild to test option --no-overwrite"
  CHECK_RESULT $? 0 0 "rrdtool create: faild to test option -O"
  CHECK_RESULT $? 0 0 "rrdtool create: faild to test option --source"
  CHECK_RESULT $? 0 0 "rrdtool create: faild to test option -r"
  CHECK_RESULT $? 0 0 "rrdtool create: faild to test option --template"
  CHECK_RESULT $? 0 0 "rrdtool create: faild to test option -t"
```

#### oe_test_rrdtool_create_02

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool create: faild to test option --daemon"
  CHECK_RESULT $? 0 0 "rrdtool create: faild to test option -d"
  CHECK_RESULT $? 0 0 "rrdtool first: faild to test option --rraindex"
  CHECK_RESULT $? 0 0 "rrdtool first: faild to test option --daemon"
  CHECK_RESULT $? 0 0 "rrdtool first: faild to test option -d"
```

- 涉及命令：rrdcached×1, kill×1

#### oe_test_rrdtool_update

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool update: faild to test option --daemon"
  CHECK_RESULT $? 0 0 "rrdtool update: faild to test option -d"
  CHECK_RESULT $? 0 0 "rrdtool update: faild to test option --template"
  CHECK_RESULT $? 0 0 "rrdtool update: faild to test option -t"
  CHECK_RESULT $? 0 0 "rrdtool update: faild to test option --skip-past-updates"
  CHECK_RESULT $? 0 0 "rrdtool update: faild to test option -s"
  CHECK_RESULT $? 0 0 "rrdtool updatev: faild to test option --template"
  CHECK_RESULT $? 0 0 "rrdtool updatev: faild to test option -t"
  CHECK_RESULT $? 0 0 "rrdtool updatev: faild to test option --skip-past-updates"
  CHECK_RESULT $? 0 0 "rrdtool updatev: faild to test option -s"
```

- 涉及命令：rrdcached×1

#### oe_test_rrdtool_graph_01

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --start --end"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -s -e"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --step"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -S"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --title"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -t"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --vertical-label"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -v"
```

#### oe_test_rrdtool_graph_02

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --width"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -w"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --height"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -h"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --only-graph"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -j"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --full-size-mode"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -D"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --upper-limit"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -u"
```

#### oe_test_rrdtool_graph_03

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --lower-limit"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -l"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --rigid"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -r"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --alt-autoscale"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -A"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --alt-autoscale-min"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -J"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --alt-autoscale-max"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -M"
```

#### oe_test_rrdtool_graph_04

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --no-gridfit"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -N"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --x-grid"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -x"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --week-fmt"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -y"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --y-grid"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --left-axis-formatter"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -left-axis-format"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -Y"
```

#### oe_test_rrdtool_graph_05

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --alt-y-grid"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -o"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --logarithmic"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -X"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --units-exponent"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -L"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --units-length"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --units"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --right-axis"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --right-axis-label"
```

#### oe_test_rrdtool_graph_06

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --right-axis-formatter"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --right-axis-format"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -g"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --no-legend"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -F"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --force-rules-legend"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --legend-position"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --legend-direction"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -z"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -lazy"
```

#### oe_test_rrdtool_graph_07

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -d"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --daemon"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -f"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -imginfo"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -c"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --color"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --grid-dash"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --border"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --dynamic-labels"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -m"
```

- 涉及命令：rrdcached×1, kill×1

#### oe_test_rrdtool_graph_08

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --zoom"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -n"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --font"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -R"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --font-render-mode"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -B"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --font-smoothing-threshold"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -P"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --pango-markup"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -G"
```

#### oe_test_rrdtool_graph_09

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --graph-render-mode"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -E"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --slope-mode"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -a"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --imgforma"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -i"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --interlaced"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -T"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --tabwidth"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -b"
```

#### oe_test_rrdtool_graph_10

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --base"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -W"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --watermark"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option -Z"
  CHECK_RESULT $? 0 0 "rrdtool graph: faild to test option --use-nan-for-all-missing-data"
```

#### oe_test_rrdtool_graphv_01

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --start --end"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -s -e"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --step"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -S"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --title"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -t"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --vertical-label"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -v"
```

#### oe_test_rrdtool_graphv_02

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --width"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -w"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --height"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -h"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --only-graph"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -j"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --full-size-mode"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -D"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --upper-limit"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -u"
```

#### oe_test_rrdtool_graphv_03

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --lower-limit"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -l"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --rigid"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -r"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --alt-autoscale"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -A"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --alt-autoscale-min"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -J"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --alt-autoscale-max"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -M"
```

#### oe_test_rrdtool_graphv_04

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --no-gridfit"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -N"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --x-grid"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -x"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --week-fmt"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -y"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --y-grid"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --left-axis-formatter"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -left-axis-format"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -Y"
```

#### oe_test_rrdtool_graphv_05

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --alt-y-grid"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -o"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --logarithmic"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -X"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --units-exponent"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -L"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --units-length"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --units"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --right-axis"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --right-axis-label"
```

#### oe_test_rrdtool_graphv_06

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --right-axis-formatter"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --right-axis-format"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -g"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --no-legend"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -F"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --force-rules-legend"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --legend-position"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --legend-direction"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -z"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -lazy"
```

#### oe_test_rrdtool_graphv_07

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -d"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --daemon"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -f"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -imginfo"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -c"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --color"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --grid-dash"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --border"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --dynamic-labels"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -m"
```

- 涉及命令：rrdcached×1, kill×1

#### oe_test_rrdtool_graphv_08

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --zoom"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -n"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --font"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -R"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --font-render-mode"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -B"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --font-smoothing-threshold"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -P"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --pango-markup"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -G"
```

#### oe_test_rrdtool_graphv_09

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --graph-render-mode"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -E"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --slope-mode"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -a"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --imgforma"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -i"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --interlaced"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -T"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --tabwidth"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -b"
```

#### oe_test_rrdtool_graphv_10

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --base"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -W"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --watermark"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -Z"
  CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --use-nan-for-all-missing-data"
```

#### oe_test_rrdtool_dump

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool update: faild to test option --header"
  CHECK_RESULT $? 0 0 "rrdtool update: faild to test option -h"
  CHECK_RESULT $? 0 0 "rrdtool update: faild to test option --no-header"
  CHECK_RESULT $? 0 0 "rrdtool update: faild to test option -n"
  CHECK_RESULT $? 0 0 "rrdtool update: faild to test option --daemon"
  CHECK_RESULT $? 0 0 "rrdtool update: faild to test option -d"
```

- 涉及命令：rrdcached×1, kill×1

#### oe_test_rrdtool_restore

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool restore: faild to test option --range-check"
  CHECK_RESULT $? 0 0 "rrdtool restore: faild to test option -r"
  CHECK_RESULT $? 0 0 "rrdtool restore: faild to test option --force-overwrite"
  CHECK_RESULT $? 0 0 "rrdtool restore: faild to test option -f"
```

#### oe_test_rrdtool_fetch

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool fetch: faild to test option --resolution"
  CHECK_RESULT $? 0 0 "rrdtool fetch: faild to test option -r"
  CHECK_RESULT $? 0 0 "rrdtool fetch: faild to test option --start"
  CHECK_RESULT $? 0 0 "rrdtool fetch: faild to test option -s"
  CHECK_RESULT $? 0 0 "rrdtool fetch: faild to test option --end"
  CHECK_RESULT $? 0 0 "rrdtool fetch: faild to test option -e"
  CHECK_RESULT $? 0 0 "rrdtool fetch: faild to test option --align-start"
  CHECK_RESULT $? 0 0 "rrdtool fetch: faild to test option -a"
  CHECK_RESULT $? 0 0 "rrdtool fetch: faild to test option --daemon"
  CHECK_RESULT $? 0 0 "rrdtool fetch: faild to test option -d"
```

- 涉及命令：rrdcached×1, kill×1

#### oe_test_rrdtool_info

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool info: faild to test option --daemon"
  CHECK_RESULT $? 0 0 "rrdtool info: faild to test option -d"
  CHECK_RESULT $? 0 0 "rrdtool info: faild to test option --noflush"
  CHECK_RESULT $? 0 0 "rrdtool info: faild to test option -F"
  CHECK_RESULT $? 0 0 "rrdtool last: faild to test option --daemon"
  CHECK_RESULT $? 0 0 "rrdtool last: faild to test option -d"
  CHECK_RESULT $? 0 0 "rrdtool lastupdate: faild to test option --daemon"
  CHECK_RESULT $? 0 0 "rrdtool lastupdate: faild to test option -d"
  CHECK_RESULT $? 0 0 "rrdtool resize: faild to test option"
```

- 涉及命令：rrdcached×1, kill×1

#### oe_test_rrdtool_xport_01

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option -s"
  CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --start"
  CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option -e"
  CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --end"
  CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option -m"
  CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --maxrows"
  CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --daemon"
  CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option -d"
  CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option -t"
  CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --showtime"
```

- 涉及命令：rrdcached×1, pkill×1

#### oe_test_rrdtool_xport_02

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --step"
  CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --json"
  CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --enumds"
```

#### oe_test_rrdtool_flushcached

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "rrdtool flushcached: faild to test option --daemon"
  CHECK_RESULT $? 0 0 "rrdtool flushcached: faild to test option -d"
  CHECK_RESULT $? 0 0 "rrdcgi: faild to test option -f"
  CHECK_RESULT $? 0 0 "rrdcgi: faild to test option --filter"
```

- 涉及命令：rrdcached×1, rrdcgi×1, kill×1

#### oe_test_rrdtool_rrdcached_01

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -L"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -l"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -s"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -m"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -P"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -V"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -w"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -z"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -f"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -p"
```

- 涉及命令：rrdcached×10, kill×1

#### oe_test_rrdtool_rrdcached_02

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -t"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -j"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -F"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -b"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -B"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -R"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -a"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -O"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -G"
  CHECK_RESULT $? 0 0 "rrdcached: faild to test option -U"
```

- 涉及命令：rrdcached×10, kill×1

#### oe_test_rrdtool_rrdcreate_01

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "rrdcreate: faild to test option --start"
  CHECK_RESULT $? 0 0 "rrdcreate: faild to test option -b"
  CHECK_RESULT $? 0 0 "rrdcreate: faild to test option --step"
  CHECK_RESULT $? 0 0 "rrdcreate: faild to test option -s"
  CHECK_RESULT $? 0 0 "rrdcreate: faild to test option --no-overwrite"
  CHECK_RESULT $? 0 0 "rrdcreate: faild to test option -O"
  CHECK_RESULT $? 0 0 "rrdcreate: faild to test option --source"
  CHECK_RESULT $? 0 0 "rrdcreate: faild to test option -r"
  CHECK_RESULT $? 0 0 "rrdcreate: faild to test option --template"
  CHECK_RESULT $? 0 0 "rrdcreate: faild to test option -t"
```

- 涉及命令：rrdcreate×2

#### oe_test_rrdtool_rrdcreate_02

- 描述：Test rrdtool
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "rrdcreate: faild to test option --daemon"
  CHECK_RESULT $? 0 0 "rrdcreate: faild to test option -d"
  CHECK_RESULT $? 0 0 "rrdtool info: faild to test option --daemon"
  CHECK_RESULT $? 0 0 "rrdtool info: faild to test option -d"
  CHECK_RESULT $? 0 0 "rrdtool info: faild to test option --noflush"
  CHECK_RESULT $? 0 0 "rrdtool info: faild to test option -F"
```

- 涉及命令：rrdcached×1, rrdcreate×1, kill×1
