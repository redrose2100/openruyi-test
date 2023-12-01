| 测试套 | 用例名        | 测试级别 | 测试类型 | 用例描述                          | 节点数 | 预支条件                          | 操作步骤 | 预期结果 | 是否自动化 | 备注 |
| ----- |--------------| --- | --- |-------------------------------| --- |-------------------------------|------|------|-------| --- |
| objectweb-asm3 |oe_test_objectweb-asm3-processor   |单元测试|功能测试| 测试 objectweb-asm3 软件的用法 |1|1、 安装raptor2二进制包：dnf install -y objectweb-asm3;2、切换文件目录到/usr/share/java/objectweb-asm3 目录下| java -classpath asm.jar:asm-util.jar org.objectweb.asm.util.TraceClassVisitor java.lang.Void 2>&1 \| grep 'java/lang/Void' | 1、输出java.lang.Void方法的字节码  |  是 |   |

