#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-07-29
# @License   :   Mulan PSL v2
# @Desc      :   Test glib-networking GIO modules and protocol support
# ############################################
# shellcheck disable=SC2119

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "glib-networking"
    tmp_dir=$(mktemp -d /tmp/test_XXXXXX)
    # Generate self-signed certificate for TLS testing
    openssl req -x509 -newkey rsa:2048 -keyout "$tmp_dir/server.key" \
        -out "$tmp_dir/server.crt" -days 1 -nodes -subj "/CN=localhost" > /dev/null 2>&1
    # Start D-Bus session for gsettings
    export DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --session --print-address --fork 2>/dev/null)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: Verify GIO TLS backend is default and supports TLS
    python3 -c "
from gi.repository import Gio
backend = Gio.TlsBackend.get_default()
assert backend is not None, 'No TLS backend found'
assert backend.supports_tls(), 'TLS backend does not support TLS'
print('TLS backend OK')
" 2>&1 | grep 'TLS backend OK' > /dev/null
    CHECK_RESULT $? 0 0 "GIO TLS backend not available or does not support TLS"

    # Test 2: Verify TLS connection to local server works
    openssl s_server -accept 18443 -cert "$tmp_dir/server.crt" \
        -key "$tmp_dir/server.key" -www > /dev/null 2>&1 &
    server_pid=$!
    python3 -c "
from gi.repository import Gio
client = Gio.SocketClient.new()
client.set_tls(True)
client.set_tls_validation_flags(0)
conn = client.connect_to_host('127.0.0.1', 18443, None)
assert conn is not None, 'TLS connection failed'
istream = conn.get_input_stream()
ostream = conn.get_output_stream()
ostream.write_all(b'GET / HTTP/1.0\r\n\r\n', None)
data = istream.read_bytes(1024, None)
assert data is not None, 'No data received'
print('TLS connection OK')
" 2>&1 | grep 'TLS connection OK' > /dev/null
    CHECK_RESULT $? 0 0 "TLS connection test failed"
    kill $server_pid 2>/dev/null || true

    # Test 3: Verify GSettings proxy schema availability and configuration
    gsettings list-schemas 2>/dev/null | grep '^org\.gnome\.system\.proxy$' > /dev/null
    CHECK_RESULT $? 0 0 "org.gnome.system.proxy schema not available"
    gsettings set org.gnome.system.proxy mode 'manual'
    gsettings set org.gnome.system.proxy.http host '127.0.0.1'
    gsettings set org.gnome.system.proxy.http port 8080
    [ "$(gsettings get org.gnome.system.proxy mode)" = "'manual'" ]
    CHECK_RESULT $? 0 0 "GSettings proxy mode not set correctly"
    [ "$(gsettings get org.gnome.system.proxy.http host)" = "'127.0.0.1'" ]
    CHECK_RESULT $? 0 0 "GSettings proxy host not set correctly"
    [ "$(gsettings get org.gnome.system.proxy.http port)" = "8080" ]
    CHECK_RESULT $? 0 0 "GSettings proxy port not set correctly"

    # Test 4: Reset proxy and verify GIO proxy resolver returns valid result
    gsettings set org.gnome.system.proxy mode 'none'
    python3 -c "
from gi.repository import Gio
resolver = Gio.ProxyResolver.get_default()
assert resolver is not None, 'No proxy resolver found'
proxies = resolver.lookup('http://example.com', None)
assert proxies is not None, 'Proxy lookup returned None'
assert len(proxies) > 0, 'Proxy lookup returned empty list'
print('Proxy resolver OK')
" 2>&1 | grep 'Proxy resolver OK' > /dev/null
    CHECK_RESULT $? 0 0 "GIO proxy resolver lookup failed"

    # Test 5: Verify GIO module cache indexes TLS and proxy modules
    [ -f "/usr/lib64/gio/modules/giomodule.cache" ]
    CHECK_RESULT $? 0 0 "GIO module cache missing"
    grep "libgiognutls.so" /usr/lib64/gio/modules/giomodule.cache > /dev/null
    CHECK_RESULT $? 0 0 "TLS module (libgiognutls.so) not indexed in GIO module cache"
    grep "libgiolibproxy.so" /usr/lib64/gio/modules/giomodule.cache > /dev/null
    CHECK_RESULT $? 0 0 "Proxy module (libgiolibproxy.so) not indexed in GIO module cache"

    # Test 6: Verify glib-pacrunner executable and D-Bus service file
    [ -x "/usr/libexec/glib-pacrunner" ]
    CHECK_RESULT $? 0 0 "glib-pacrunner not executable"
    grep 'org.gtk.GLib.PACRunner' /usr/share/dbus-1/services/org.gtk.GLib.PACRunner.service > /dev/null
    CHECK_RESULT $? 0 0 "glib-pacrunner D-Bus service file incorrect or missing"

    # Test 7: Verify gnutls library dependency is actually linked by libgiognutls.so
    ldd /usr/lib64/gio/modules/libgiognutls.so 2>/dev/null | grep "libgnutls" > /dev/null
    CHECK_RESULT $? 0 0 "libgiognutls.so does not link to gnutls library"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    gsettings set org.gnome.system.proxy mode 'none' 2>/dev/null || true
    pkill -f "openssl s_server" 2>/dev/null || true
    pkill -f "dbus-daemon.*--session" 2>/dev/null || true
    DNF_REMOVE
    rm -rf "$tmp_dir"
    LOG_INFO "End to restore the test environment."
}

main "$@"
