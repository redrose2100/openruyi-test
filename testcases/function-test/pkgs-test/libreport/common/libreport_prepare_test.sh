#!/usr/bin/bash
# Prepare test environment for libreport/satyr testing
# Usage: libreport_prepare_test.sh <test_dir>

test_dir="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Compile test program and generate real coredump via gcore
gcc -g -o "${test_dir}/test_program" "${SCRIPT_DIR}/libreport_test_program.c" || exit 1
"${test_dir}/test_program" &
test_pid=$!
sleep 0.5
gcore -o "${test_dir}/coredump" "$test_pid" || { echo "gcore failed" >&2; kill "$test_pid" 2>/dev/null; exit 1; }
kill "$test_pid" 2>/dev/null || true
if [ -f "${test_dir}/coredump.${test_pid}" ]; then
    mv "${test_dir}/coredump.${test_pid}" "${test_dir}/coredump"
elif [ -f "${test_dir}/core.${test_pid}" ]; then
    mv "${test_dir}/core.${test_pid}" "${test_dir}/coredump"
fi
if [ ! -f "${test_dir}/coredump" ]; then
    echo "coredump file not created" >&2
    exit 1
fi

# Create GDB backtrace file for debug normalize
cat > "${test_dir}/gdb_backtrace" << 'EOF'
main /usr/lib64/libc.so.6
/root/test.c:10
foo /usr/lib64/libc.so.6
/root/test.c:5
EOF

# Create ABRT problem directory files
echo "1" > "${test_dir}/version"
echo "crash" > "${test_dir}/type"
echo "test" > "${test_dir}/analyzer"
echo "Test problem" > "${test_dir}/title"
echo "Testing satyr functionality" > "${test_dir}/description"
echo "${test_dir}/test_program" > "${test_dir}/executable"
echo "0" > "${test_dir}/uid"
echo "0" > "${test_dir}/gid"
echo "1000" > "${test_dir}/pid"
echo "1000" > "${test_dir}/ppid"
touch "${test_dir}/maps"
touch "${test_dir}/backtrace"
echo "bash test" > "${test_dir}/cmdline"
echo "Segmentation fault" > "${test_dir}/reason"
uname -m > "${test_dir}/architecture"
uname -r > "${test_dir}/kernel"
hostname > "${test_dir}/hostname"
date +%s > "${test_dir}/time"
echo "root" > "${test_dir}/username"
date +%s > "${test_dir}/last_occurrence"
rpm -qf /bin/ls --qf '%{NAME}' > "${test_dir}/package" 2>/dev/null || echo "coreutils" > "${test_dir}/package"
rpm -qf /bin/ls --qf '%{NAME}' > "${test_dir}/pkg_name" 2>/dev/null || echo "coreutils" > "${test_dir}/pkg_name"
rpm -qf /bin/ls --qf '%{VERSION}' > "${test_dir}/pkg_version" 2>/dev/null || echo "9.9.9" > "${test_dir}/pkg_version"
rpm -qf /bin/ls --qf '%{RELEASE}' > "${test_dir}/pkg_release" 2>/dev/null || echo "0" > "${test_dir}/pkg_release"
echo "0" > "${test_dir}/pkg_epoch"
rpm -qf /bin/ls --qf '%{ARCH}' > "${test_dir}/pkg_arch" 2>/dev/null || uname -m > "${test_dir}/pkg_arch"
rpm -qf /bin/ls --qf '%{GROUP}' > "${test_dir}/component" 2>/dev/null || echo "system" > "${test_dir}/component"
touch "${test_dir}/dso_list"
touch "${test_dir}/interpreter"
touch "${test_dir}/environ"
printf "1" > "${test_dir}/count"
uuidgen 2>/dev/null > "${test_dir}/uuid" || echo "00000000-0000-0000-0000-000000000000" > "${test_dir}/uuid"
uuidgen 2>/dev/null > "${test_dir}/duphash" || echo "00000000-0000-0000-0000-000000000000" > "${test_dir}/duphash"
echo "0" > "${test_dir}/rating"
touch "${test_dir}/core_backtrace"
if [ -f /etc/openEuler-release ]; then
    cat /etc/openEuler-release > "${test_dir}/os_release"
elif [ -f /etc/system-release ]; then
    cat /etc/system-release > "${test_dir}/os_release"
else
    os_name=$(grep '^NAME=' /etc/os-release | cut -d'"' -f2)
    os_version_id=$(grep '^VERSION_ID=' /etc/os-release | cut -d'"' -f2)
    echo "${os_name} release ${os_version_id}" > "${test_dir}/os_release"
fi

