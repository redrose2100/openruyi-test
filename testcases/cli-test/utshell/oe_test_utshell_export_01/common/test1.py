# coding=utf-8
# Name:         test_unset_01
# Description:  
# Author:       Xietian
# Date:         2024/5/30
import subprocess

def local_cmd(cmd, cwd=None, ignore_print=False):
    """
    本机执行命令
    :param cmd:待执行命令
    :param cwd: 执行目录
    :param ignore_output: 是否输出命令输出，默认为否
    :return:
    """
    if not ignore_print:
        print('==========local cmd==========')
        print(cmd)

    process = subprocess.Popen(cmd,
                               stdin = subprocess.PIPE,
                               stdout = subprocess.PIPE,
                               stderr = subprocess.PIPE, shell=True, text=True, cwd=cwd)
    output, unused_err = process.communicate()
    output, unused_err = output.strip(), unused_err.strip()
    retcode = process.poll()
    if not ignore_print:
        print(f'=============output=======code={retcode}======')
        print(output+ unused_err)

    return output+ unused_err, retcode


ret, code = local_cmd('utshell -c "SHELLVAR=helloworld && export SHELLVAR && export -p"')
assert 'SHELLVAR="helloworld"' in ret

ret, code = local_cmd('utshell -c "SHELLVAR=helloworld && export SHELLVAR && export -p | grep hello"')
assert code == 0

ret, code = local_cmd('utshell -c "SHELLVAR=helloworld && export SHELLVAR && export -n SHELLVAR && export -p | grep hello"')
assert code == 1


