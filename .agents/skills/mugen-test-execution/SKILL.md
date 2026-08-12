---
name: mugen-test-execution
description: >
  Handles all mugen test execution scenarios: single test case, full test suite,
  all suites, combination tests, remote execution, and build-before-test.
  Use when user asks to 'run test', '执行测试', '跑测试', 'run test case', 'run test suite',
  '执行用例', '执行测试套', '组合测试', 'combination test', 'build test', '编译测试',
  'run mugen', 'bash mugen.sh', '-f', '-r', '-s', '-b', '-a'.
  Also triggers for 'check test results', '查看测试结果', 'test report', '测试报告',
  'why test failed', '测试失败原因', 're-run test', '重跑测试'.
  Covers QEMU aarch64 embedded device testing with SSH remote execution.
---

# mugen Test Execution Guide

This skill handles all test execution scenarios for the **mugen** test framework,
targeting openEuler Embedded QEMU aarch64 devices.

## Available Test Suites

The following embedded test suites are available under `testcases/embedded-test/`:

| Suite | Description | Requires Build (`-b`) | Default Timeout |
|-------|-------------|----------------------|-----------------|
| `embedded_os_basic_test` | OS basic command tests | No | ~30 min |
| `embedded_os_basic_extra_test` | OS extra feature tests | No | ~10 min |
| `embedded_application_develop_tests` | Application development tests | Yes | ~5 min |
| `embedded_third_party_packages_test` | Third-party package tests | Yes | ~60 min |
| `embedded_version_basic_tests` | LTP + POSIX suite tests | Yes | ~8 hours (LTP) |
| `embedded_security_config_test` | Security configuration tests | No | ~5 min |
| `embedded_unix_bench_tests` | Unix benchmark tests | No | ~30 min |

## mugen Command Reference

```
bash mugen.sh [options]

Options:
  -a                Execute all test suites
  -f <suite>        Execute specified test suite
  -r <case>         Execute specified test case (requires -f)
  -s                Run on remote NODE1 (SSH remote execution)
  -b                Build test suite before execution (compile test cases)
  -x                Debug mode (bash -x)
```

## Execution Modes

### 1. Single Test Case

Run one specific test case within a test suite:

```bash
bash mugen.sh -f <test_suite> -r <test_case> -s
```

Example:
```bash
bash mugen.sh -f embedded_os_basic_test -r oe_test_basic_cmd_cat -s
```

**When to use**: Debugging a specific test failure, verifying a fix, or running
a single test case in isolation.

### 2. Full Test Suite

Run all test cases in a test suite:

```bash
bash mugen.sh -f <test_suite> -s
```

Example:
```bash
bash mugen.sh -f embedded_os_basic_test -s
```

**When to use**: Running a complete test suite on a device, regression testing
after changes to a specific area.

### 3. All Test Suites

Run all available test suites:

```bash
bash mugen.sh -a -s
```

**When to use**: Full regression testing, generating complete test reports.

### 4. Build Before Test

For suites that require compilation (third_party_packages_test, version_basic_tests,
application_develop_tests), build first:

```bash
# Step 1: Set SDK environment
export SDK_PATH=/opt/sdk/<sdk-name>
source /opt/sdk/<sdk-name>/environment-setup-aarch64-openeuler-linux

# Step 2: Build
bash mugen.sh -b <test_suite>

# Step 3: Run
bash mugen.sh -f <test_suite> -s
```

**SDK selection by device:**
- Device A (QEMU aarch64, no python3): `/opt/sdk/qemu-aarch64`
- Device B (QEMU aarch64, with python3): `/opt/sdk/qemu-aarch64-oebridge-xfce`

**When to use**: When test suite contains compiled test cases (C/C++ programs,
kernel modules, LTP, POSIX suite). Build artifacts are stored as `tmp_test.tar`
in each test case directory.

### 5. Combination Tests

Run multiple test suites in sequence with environment switching:

```bash
bash run_combinations.sh
```

Combination tests are defined in `combination/*.json` files. Each combination:
1. Configures device environment (SDK, QEMU image, network)
2. Generates temporary suite2cases from combination definition
3. Builds and executes all test suites in the combination
4. Collects results into `combination_results/`
5. Cleans up and restores original suite2cases

**When to use**: Integration testing across multiple test suites with different
device configurations.

## Device Configuration

### env.json

Device connection info is in `conf/env.json`. mugen uses **NODE1** for remote
execution (`-s` flag). To switch target devices, swap NODE1 and NODE2:

```json
{
    "NODE": [
        {
            "ID": 1,
            "IPV4": "192.168.7.2",
            "USER": "root",
            "PASSWORD": "<password>",
            "SSH_PORT": 22,
            "COPY_ALL": "true"
        },
        {
            "ID": 2,
            "IPV4": "192.168.122.11",
            ...
        }
    ]
}
```

### SSH Authentication

QEMU embedded devices use **keyboard-interactive** SSH authentication (not
password auth). The mugen framework handles this via `ssh_cmd.py`.

### Password Expiry Handling

QEMU devices may have password expiry enabled. Before running tests, disable it:

```python
import paramiko
transport = paramiko.Transport((ip, 22))
transport.connect(username="root")
def handler(title, instructions, prompts):
    responses = []
    for p in prompts:
        if "new password" in p[0].lower():
            responses.append(new_password)
        else:
            responses.append(old_password)
    return responses
transport.auth_interactive("root", handler)
session = transport.open_session()
session.exec_command("chage -M 99999 root")
```

## Test Results

### Result Locations

- **Per-test results**: `results/<test_suite>/succeed/` and `results/<test_suite>/failed/`
- **Test logs**: `logs/<test_suite>/<test_case>/<timestamp>.log`
- **Combination results**: `combination_results/`
- **Summary output**: stdout (last line shows total counts)

### Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Test passed |
| 1 | Test failed (assertion failure) |
| 7 | Environment error (library ABI mismatch, missing dependency) |
| 255 | Test skipped (exit 255, e.g., QEMU detection, unsupported feature) |
| 143 | Test timed out (SIGKILL) |

### Checking Results After Execution

```bash
# Check success/failure counts
ls results/<test_suite>/succeed/ | wc -l
ls results/<test_suite>/failed/ 2>/dev/null | wc -l

# Check specific test log
cat logs/<test_suite>/<test_case>/*.log

# Search for assertion failures
grep "CHECK_RESULT 1 0" logs/<test_suite>/<test_case>/*.log
```

## Known Issues and Workarounds

### LTP Test System Library Corruption

The LTP test (`oe_test_version_ltp_test_001`) extracts `allinfo.tar` to `/`,
which overwrites system libraries including PAM. This causes SSH daemon crash.

**Workaround** (already applied):
- `trap "" SIGHUP` in remote command prevents test script from being killed
- `ssh_cmd.py` reconnect mechanism reads result from `/tmp/mugen_re.log` after
  SSH recovers
- Test order: POSIX suite runs before LTP (configured in suite2cases JSON)

### QEMU Device Limitations

- **No DMI/SMBIOS**: `/sys/class/dmi/id/` does not exist. Use
  `/proc/device-tree/compatible` (contains "linux,dummy-virt") for QEMU detection.
- **No block device**: initrd rootfs is in memory. Tests requiring block devices
  (chattr, O_DIRECT) should detect and skip (exit 255).
- **No external network (NAT mode)**: Tests requiring internet should check
  connectivity and skip if unavailable.
- **No python3 (some devices)**: mugen uses `common_lib_shell.sh` instead of
  `common_lib_python.sh`. Shell version has limited functionality.

## Execution Steps

### Phase 1: Pre-flight Check

1. Verify target device is accessible:
   ```python
   # Test SSH connection
   transport = paramiko.Transport((ip, 22))
   transport.connect(username="root")
   ```
2. Disable password expiry: `chage -M 99999 root`
3. Clean previous test data: `rm -rf /mugen_re/` on remote device
4. Verify `conf/env.json` NODE1 matches target device
5. If build required: verify SDK path and source environment

### Phase 2: Build (if needed)

1. Set SDK environment:
   ```bash
   export SDK_PATH=/opt/sdk/<sdk-name>
   source /opt/sdk/<sdk-name>/environment-setup-aarch64-openeuler-linux
   ```
2. Clean previous build artifacts:
   ```bash
   rm -rf testcases/embedded-test/<suite>/tmp_extract \
          testcases/embedded-test/<suite>/tmp_download \
          testcases/embedded-test/<suite>/tmp_test
   ```
3. Build:
   ```bash
   bash mugen.sh -b <test_suite>
   ```
4. Verify `tmp_test.tar` was created in each test case directory.

### Phase 3: Execute

1. Run test:
   ```bash
   bash mugen.sh -f <test_suite> -s
   ```
2. For long-running tests (LTP, ~8 hours), use background execution:
   ```bash
   nohup bash mugen.sh -f embedded_version_basic_tests -s > /tmp/mugen_run.log 2>&1 &
   ```
3. Monitor progress:
   ```bash
   # Check if mugen is still running
   ps aux | grep mugen | grep -v grep
   # Check results so far
   ls results/<test_suite>/succeed/ | wc -l
   ```

### Phase 4: Verify Results

1. Check summary line in output:
   ```
   A total of N use cases were executed, with X successes Y failures and Z skips.
   ```
2. Verify no unexpected failures:
   ```bash
   ls results/<test_suite>/failed/ 2>/dev/null
   ```
3. If failures exist, examine logs:
   ```bash
   cat logs/<test_suite>/<failed_case>/*.log | tail -30
   ```
4. Generate test report (if requested).

## Common Commands Reference

```bash
# Single test case
bash mugen.sh -f embedded_os_basic_test -r oe_test_basic_cmd_cat -s

# Full test suite
bash mugen.sh -f embedded_os_basic_test -s

# Build + run
export SDK_PATH=/opt/sdk/qemu-aarch64
source /opt/sdk/qemu-aarch64/environment-setup-aarch64-openeuler-linux
bash mugen.sh -b embedded_third_party_packages_test
bash mugen.sh -f embedded_third_party_packages_test -s

# All suites
bash mugen.sh -a -s

# Debug mode
bash mugen.sh -f embedded_os_basic_test -r oe_test_basic_cmd_cat -s -x

# Combination tests
bash run_combinations.sh

# Check results
ls results/embedded_os_basic_test/succeed/ | wc -l
ls results/embedded_os_basic_test/failed/ 2>/dev/null | wc -l
```
