# SDL2

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/SDL2` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_sdl2_basic | Test SDL2 package installation | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_sdl2_sdl2-config | Test SDL2 sdl2-config command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_sdl2_api | Test SDL2 API interface correctness | config_params/pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_sdl2_basic

- 描述：Test SDL2 package installation
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "SDL2 package not installed"
  CHECK_RESULT $? 0 0 "SDL2-devel package not installed"
  CHECK_RESULT $? 0 0 "SDL2 version check failed"
  CHECK_RESULT $? 0 0 "SDL2 library file not found"
  CHECK_RESULT $? 0 0 "SDL.h header not found"
  CHECK_RESULT $? 0 0 "SDL_Init not found in SDL headers"
  CHECK_RESULT $? 0 0 "SDL_CreateWindow not found in SDL headers"
  CHECK_RESULT $? 0 0 "SDL_CreateRenderer not found in SDL headers"
  CHECK_RESULT $? 0 0 "SDL_OpenAudio not found in SDL headers"
  CHECK_RESULT $? 0 0 "pkg-config cflags does not contain SDL2"
  CHECK_RESULT $? 0 0 "pkg-config libs does not contain SDL2"
  CHECK_RESULT $? 0 0 "SDL2 pkg-config not found"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：grep×4, rpm×3

#### oe_test_sdl2_sdl2-config

- 描述：Test SDL2 sdl2-config command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "sdl2-config command not found"
  CHECK_RESULT $? 0 0 "sdl2-config --version output is not valid"
  CHECK_RESULT $? 0 0 "sdl2-config --prefix output is not valid"
  CHECK_RESULT $? 0 0 "sdl2-config --exec-prefix output is not valid"
  CHECK_RESULT $? 0 0 "sdl2-config --cflags output is not valid"
  CHECK_RESULT $? 0 0 "sdl2-config --libs output is not valid"
  CHECK_RESULT $? 0 0 "sdl2-config --static-libs output is not valid"
```

- 涉及命令：command×1

#### oe_test_sdl2_api

- 描述：Test SDL2 API interface correctness
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile SDL2 API test"
  CHECK_RESULT $? 0 0 "SDL2 API test failed"
  CHECK_RESULT $? 0 0 "SDL_Init symbol not found in SDL2"
  CHECK_RESULT $? 0 0 "SDL_Quit symbol not found in SDL2"
  CHECK_RESULT $? 0 0 "SDL_CreateWindow symbol not found in SDL2"
  CHECK_RESULT $? 0 0 "SDL_CreateRenderer symbol not found in SDL2"
  CHECK_RESULT $? 0 0 "SDL_OpenAudio symbol not found in SDL2"
```
