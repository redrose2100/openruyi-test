# Embedded OS Patch for Mugen Test Framework

## Overview

This patch is designed to make customized modifications for embedded OS testing. Before running tests on embedded OS, it is recommended to apply this patch to the Mugen test framework first.

## Patch Content

The patch `0001-make-customized-modifications-for-embedded-OS.patch` includes the following modifications:

### 1. SDK Environment Configuration
- Modified `libs/locallibs/combination.py` to export `SDK_PATH` environment variable
- Modified `mugen.sh` to source SDK environment setup script before building/running tests

### 2. Test Case Adaptations
- **kernel_hello_world_test**: Disabled kernel module compilation steps (pre-built modules expected)
- **initscripts_test_001**: Added systemctl detection to skip tests on systemd-based systems
- **net-tools_test_001**: Fixed route command output parsing with `-n` flag
- **system_service_sshd**: Added support for both init.d and systemctl service management
- **version_ltp_test_001** & **version_posix_suite_test_001**: Removed debug output

## How to Apply the Patch

### Prerequisites
- Ensure you have the `patch` command installed
- Navigate to the Mugen root directory

### Apply Patch

```bash
# Navigate to Mugen root directory
cd /path/to/mugen

# Apply the patch
patch -p1 < patchs/embedded-os/0001-make-customized-modifications-for-embedded-OS.patch
```

### Verify Patch Application

```bash
# Check if patch was applied successfully
git status
# Or check specific files
grep "SDK_PATH" mugen.sh
```

### Remove Patch (if needed)

```bash
# Remove the patch
patch -p1 -R < patchs/embedded-os/0001-make-customized-modifications-for-embedded-OS.patch
```

## Environment Variables

After applying the patch, ensure the following environment variable is set before running tests:

```bash
export SDK_PATH=/path/to/your/sdk
```

The SDK path should contain the `environment-setup-*` script for cross-compilation environment setup.

## Notes

1. Always apply this patch before running embedded OS tests
2. The patch modifies core framework files, so it should be applied carefully
3. If you need to run standard (non-embedded) tests, consider removing the patch first
