import os
import re
import argparse
import subprocess
from llm import generate_script, check_package_command, generate_markdown

TEST_CASE_DIR = "generate_test_cases"
NOTE_DIR = "note.md"
current_file_path = os.path.abspath(__file__)
current_dir_path = os.path.dirname(current_file_path)


def parse_markdown_table(markdown_text):
    # 正则表达式匹配Markdown表格的每一行
    table_rows = re.findall(r'^\|(.*)\|$', markdown_text, re.MULTILINE)

    # 提取表头
    headers = re.split(r'\s*\|\s*', table_rows[0].strip())

    # 解析表格数据
    table_data = []
    for row in table_rows[2:]:  # 跳过头部和分割线
        if row:  # 确保不是空行
            cells = row.split(' | ')
            if len(cells) == len(headers):
                row_data = {headers[i]: cells[i] for i in range(len(headers))}
                table_data.append(row_data)

    return table_data


def get_test_case(md_file):
    with open(md_file, 'r') as f:
        test_case_file = f.read()
    dicts = parse_markdown_table(test_case_file)
    return dicts


def get_command_info(software_name, command):
    if command == software_name:
        command = ""
    command_info = ""
    # 获取命令--help信息
    result = subprocess.run([software_name, command, '--help'], capture_output=True, text=True)
    if result.returncode != 0:
        result = subprocess.run([software_name, command, 'help'], capture_output=True, text=True)
    if result.stdout:
        command_info = result.stdout
    else:
        command_info = result.stderr
    return command_info


def get_note(note_dir):
    note = ""
    if not note_dir or not os.path.exists(note_dir):
        return note
    with open(note_dir, 'r') as f:
        note = f.read()
    return note


def get_test_script(software_name):
    package_info = ""
    # 安装软件包
    result = subprocess.run(['dnf', 'install', '-y', software_name], capture_output=True, text=True)
    if result.returncode != 0:
        print(f"安装软件包失败：{result.stderr}")
        return
    # 获取软件包help信息
    try:
        print(f"获取软件包{software_name}的help信息：")
        result = subprocess.run([software_name, '--help'], capture_output=True, text=True)
        if result.returncode != 0:
            result = subprocess.run([software_name, 'help'], capture_output=True, text=True)
        if result.stdout:
            package_info = result.stdout
        else:
            package_info = result.stderr
        print(package_info)  # 打印软件包的帮助信息
    except subprocess.SubprocessError as e:
        print(f"执行 '{software_name} help' 时发生错误：{e}")

    if not package_info:
        return

    commands = check_package_command(package_info)
    if not commands:
        print(f"获取软件包{software_name}的子命令为空")
        commands = ['']

    software_dir = os.path.join(current_dir_path, TEST_CASE_DIR, software_name)
    # 如果不存在在test_cases目录下software_name文件夹的话，则创建
    os.makedirs(software_dir, exist_ok=True)
    # 根据note_dir，获取note_dir文件的内容
    note = get_note(os.path.join(current_dir_path, NOTE_DIR))
    # 遍历commands，生成测试脚本
    for index, command in enumerate(commands):
        # 获取命令信息
        command_info = get_command_info(software_name, command)
        # 生成测试脚本
        script = generate_script(package_info, command_info, note)
        # 在software_dir下保存{command}.sh
        if not command:
            command = f"{software_name}_{index+1}"
        with open(f"{software_dir}/{command}.sh", "w") as f:
            f.write(script)
        print(f"生成测试脚本{software_dir}/{command}.sh")


def get_test_script_md(software_name):
    # 读取software_dir下的.sh文件
    software_dir = os.path.join(current_dir_path, TEST_CASE_DIR, software_name)
    # 每个文件生成对应的md文件
    for file in os.listdir(software_dir):
        if file.endswith(".sh"):
            # 读取文件内容
            with open(os.path.join(software_dir, file), "r") as f:
                script = f.read()
            # 生成md文件
            md_file = generate_markdown(file, script)
            # 在software_dir下保存{file}.md
            with open(os.path.join(software_dir, f"{file}.md"), "w") as f:
                f.write(md_file)
            print(f"生成测试文档{software_dir}/{file}.md")


def main():
    # 创建 ArgumentParser 对象
    parser = argparse.ArgumentParser(description='根据软件包的help和测试文档生成测试脚本')

    # 添加参数
    # 模式
    parser.add_argument('-m', '--mode', help='模式，默认为shell，shell和md', default='shell')
    # 软件包名
    parser.add_argument('-n', '--package-name', help='软件包名称')

    # 解析命令行参数
    args = parser.parse_args()

    # 根据参数执行操作
    if args.mode == 'shell':
        get_test_script(args.package_name)
    elif args.mode == 'md':
        get_test_script_md(args.package_name)


if __name__ == "__main__":
    main()
