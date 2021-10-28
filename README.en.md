# mugen

## Introduction
mugen is an open test framework in the openEuler community that provides public configurations and methods for community developers to compile and execute test code.

## What's New
- Optimized the entry point function of the mugen framework.
- Added the test suite path and test case environment to the current version.
- Added public Python functions.

## Instructions

#### Install Dependent Software
`bash dep_install.sh`

#### Configure Environment Variables for the Test Suite
- Command: `bash mugen.sh -c --ip $ip --password $passwd --user $user --port $port`
- Parameter description:
  - **ip**: IP address of the test machine.
  - **user**: login user of the test machine. The default user is root.
  - **password**: password for logging in to the test machine.
  - **port**: SSH login port of the test machine. The default port is 22.
- Environment variable file: **./conf/env.json**
```
{
    "NODE": [
        {
            "ID": 1,
            "LOCALTION": "local",
            "MACHINE": "physical",
            "FRAME": "aarch64",
            "NIC": "eth0",
            "MAC": "55:54:00:c8:a9:21",
            "IPV4": "192.168.0.10",
            "USER": "root",
            "PASSWORD": "openEuler12#$",
            "SSH_PORT": 22,
            "BMC_IP": "",
            "BMC_USER": "",
            "BMC_PASSWORD": ""
        },
        {
            "ID": 2,
            "LOCALTION": "remote",
            "MACHINE": "kvm",
            "FRAME": "aarch64",
            "NIC": "eth0",
            "MAC": "55:54:00:c8:a9:22",
            "IPV4": "192.168.0.11",
            "USER": "root",
            "PASSWORD": "openEuler12#$",
            "SSH_PORT": 22,
            "HOST_IP": "",
            "HOST_USER": "",
            "HOST_PASSWORD": ""
            "HOST_SSH_PORT": ""
        }
    ]
}
```
- Usage in the test case:  NODE${id}_${LOCALTION}

#### Execute the Cases
- Execute all test cases.
`bash mugen.sh -a`
- Execute a specified test suite.
  `bash mugen.sh -f testsuite`
- Execute a single test case.
  `bash mugen.sh -f testsuite -r testcase`
- Print the execution process of the shell script in logs.
```
bash mugen.sh -a -x 
bash mugen.sh -f testsuite -x
bash mugen.sh -f testsuite -r testcase -x
```

#### Add Cases
- (Recommended) Compile test case scripts based on the template.
```
source ${OET_PATH}/libs/locallibs/common_lib.sh

# Data and parameter configurations to be preloaded.
function config_params() {
    LOG_INFO "Start to config params of the case."

    LOG_INFO "No params need to config."

    LOG_INFO "End to config params of the case."
}

# Installation of test objects and tools required for the test.
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    LOG_INFO "No pkgs need to install."

    LOG_INFO "End to prepare the test environment."
}

# Test point execution
function run_test() {
    LOG_INFO "Start to run test."

    # Test command: ls
    ls -CZl -all
    CHECK_RESULT 0

    # Check whether the proc|usr|roor|var|sys|etc|boot|dev directory exists in the / directory.
    CHECK_RESULT "$(ls / | grep -cE 'proc|usr|roor|var|sys|etc|boot|dev')" 7

    LOG_INFO "End to run test."
}

# Perform postprocessing to restore the test environment.
function post_test() {
    LOG_INFO "Start to restore the test environment."

    LOG_INFO "Nothing to do."

    LOG_INFO "End to restore the test environment."
}

main "$@"
```

- For a pure shell script or python script, you can determine whether a case is successful based on the return code of script execution.
  - References: cases oe_test_casename_02 and oe_test_casename_03 in the test suite.


#### JSON File Format in Suite2casessuite2cases
- The file name is the test suite name, and the file name extension is .json.
-  File content:
![https://gitee.com/openeuler/G11N/raw/master/learning-materials/open-source-basics/images/%E6%8D%95%E8%8E%B71.PNG](https://gitee.com/openeuler/G11N/raw/master/learning-materials/open-source-basics/images/捕获1.PNG)

#### Public Functions of the Framework
- Load the functions to the cases for invoking.
```
# bash
source ${OET_PATH}/libs/locallibs/common_lib.sh

# python
import os, sys, subprocess

LIBS_PATH = os.environ.get("OET_PATH") + "/libs/locallibs"
sys.path.append(LIBS_PATH)
import xxx
```

- Public functions
  - Print logs.
  ```
  # bash 
  LOG_INFO "$message"
  LOG_WARN "$message"
  LOG_DEBUG "$message"
  LOG_ERROR "$message"
  # python
  import mugen_log
  mugen_log.logging(level, message) # level:INFO,WARN,DEBUG,ERROR;message:日志输出
  ```
  - Check the result.
  ```
  # bash
  CHECK_RESULT $1 $2 $3 $4
  # $1: returned result of the test point
  # $2: Expected result
  # $3: comparison mode. 0: The returned result matches the expected result. 1: The returned result is different from the expected result.
  # $4: Detect problems and generate logs.
  ```
  - Install and uninstall an RPM package.
  ```
  # bash
  ## func 1
  DNF_INSTALL "vim bc" "$node_id"
  DNF_REMOVE "$node_id" "jq" "$mode"
  
  # mode: The default value is 0, indicating that the packages installed in the test case are deleted. If the value is not 0, only the current software package is uninstalled.
  # python
  import rpm_manage
  tpmfile = rpm_manage.rpm_install(pkgs, node, tmpfile)
  rpm_manage.rpm_remove(node, pkgs, tmpfile)
  ```
  - Run remote commands.
  ```
  # bash
  ## func 1
  SSH_CMD "$cmd" $remote_ip $remote_password $remote_user $time_out $remote_port`
  ## func 2
  P_SSH_CMD --cmd $cmd --node $node(remote node ID)
  P_SSH_CMD --cmd $cmd --ip $remote_ip --password $remote_password --port $remote_port --user $remote_user --timeout $timeout
  # python
  conn = ssh_cmd.pssh_conn(remote_ip, remote_password,remote_port,remote_user,remote_timeout)
  exitcode, output = ssh_cmd.pssh_cmd(conn, cmd)
  
  # port: The default value is 22.
  # user: The default value is root.
  # timeout: no restriction by default
  ```
  - Transfer directory files.
  ```
  # bash
  ## func 1
  ### Transfer a local file to a remote host.
  `SSH_SCP $local_path/$file $REMOTE_USER@$REMOTE_IP:$remote_path "$REMOTE_PASSWD"`
  ### Transfer a remote file to the local host.
  `SSH_SCP $REMOTE_USER@$REMOTE_IP:$remote_path/$file $local_path "$REMOTE_PASSWD"`
  ## func 2
  ### Directory transfer
  SFTP get/put --localdir $localdir --remotedir $remotedir
  ### File transfer
  SFTP get/put --localdir $localdir --remotedir $remotedir --localfile/remotefile $localfile/$remotefile
  #python
  ### Directory transfer
  import ssh_cmd, sftp
  conn = ssh_cmd.pssh_conn(remote_ip, remote_password,remote_port,remote_user,remote_timeout)
  psftp_get(conn,remote_dir, local_dir)
  psftp_put(local_dir=local_dir, remote_dir=remote_dir)
  ### File transfer
  import ssh_cmd, sftp
  psftp_get(remote_dir, remote_file, local_dir)
  psftp_put(local_dir=local_dir, local_file=local_file, remote_dir=remote_dir)
  
  
  #get: obtain from the remote host.
  #put: transfer to the remote host.
  #localdir: defaults to the current directory.
  #remotedir: defaults to the remote root directory.
  ```
  - Obtain an idle port.
  ```
  # bash
  GET_FREE_PORT $ip
  # python
  import free_port
  free_port.find_free_port(ip)
  ```
  - Check whether a port is occupied.
  ```
  # bash 
  IS_FREE_PORT $port $ip
  # python
  import free_port
  free_port.is_free_port(port, ip)
  ```
  - Obtain the test NIC.
  ```
  # bash
  TEST_NIC $node_id
  # python
  import get_test_device
  get_test_nic(node_id)
  
  # node_id：The default node ID is 1.
  ```
  - Obtain the test disk.
  ```
  # bash
  TEST_DISK $node_id
  # python
  import get_test_device
  get_test_disk(node_id)
  
  # node_id：The default node ID is 1.
  ```
  - Set the wait time.
  ```
  # bash
  SLEEP_WAIT $wait_time $cmd
  # python
  import sleep_wait
  sleep_wait.sleep_wait(wait_time,cmd)
  ```
  - Wait for remote restart.
  ```
  # bash
  REMOTE_REBOOT_WAIT $node_id $wait_time
  ```

#### Test Case Debug
- After setting OET_PATH (environment variable of the mugen framework path), you can directly run the case script in the directory where the case is located.

#### Case Timeout Description
- The default timeout interval is 30 minutes.
- If the execution duration of a test case exceeds 30 minutes, the value of TIMEOUT is re-assigned in the test case.