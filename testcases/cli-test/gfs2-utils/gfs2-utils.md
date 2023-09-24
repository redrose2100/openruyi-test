| **测试套** | **用例名** | **测试级别** | **测试类型** | **用例描述** | **节点数** | **预支条件** | **操作步骤** | **预期结果** | **是否自动化** | **备注** |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| gfs2-utils | oe_test_gfs2-utils_mkfs.gfs2 | 单元测试 | 功能测试 | gfs2-utils主要是用于文件系统，本用例主要是对mkfs.gfs2的命令进行测试。 | 1 | 安装源码包gfs2-utils：dnf install -y gfs2-utils | mkfs.gfs2命令的用法：     <br />1、-h：帮助信息。 <br />执行命令：<br />mkfs.gfs2 -h &#124; grep "Usage:"<br />2、-V：版本信息。<br />执行命令：<br />mkfs.gfs2 -V &#124; grep -E "mkfs.gfs2 master&#124;Copyright" | 1、输出帮助信息。<br />2、输出版本信息。 | 是 | <br /> |

