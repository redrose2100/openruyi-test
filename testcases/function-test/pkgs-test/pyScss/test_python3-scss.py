from scss import Compiler

# 创建编译器对象
compiler = Compiler()

# 定义要编译的 SCSS 样式
scss_code = """
$primary-color: #ff0000;
$secondary-color: #00ff00;

body {
  background-color: $primary-color;
}

h1 {
  color: $secondary-color;
}
"""

# 使用编译器将 SCSS 编译为 CSS
css_code = compiler.compile_string(scss_code)

# 打印编译后的 CSS 代码
print(css_code)
