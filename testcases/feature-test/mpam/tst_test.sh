#!/bin/bash
#
# This is a test library for shell.
#

[ -n "$TST_LIB_LOADED" ] && return 0

export TST_PASS=0
export TST_FAIL=0
export TST_BROK=0
export TST_WARN=0
export TST_CONF=0
export TST_COUNT=0
export TST_COLOR_ENABLED=1
export TST_LIB_LOADED=1

trap "tst_brk TBROK 'test interrupted'" INT

tst_flag2color()
{
	local ansi_color_blue='\033[1;34m'
	local ansi_color_green='\033[1;32m'
	local ansi_color_magenta='\033[1;35m'
	local ansi_color_red='\033[1;31m'
	local ansi_color_yellow='\033[1;33m'

	case "$1" in
	TPASS) printf $ansi_color_green;;
	TFAIL) printf $ansi_color_red;;
	TBROK) printf $ansi_color_red;;
	TWARN) printf $ansi_color_magenta;;
	TINFO) printf $ansi_color_blue;;
	TCONF) printf $ansi_color_yellow;;
	esac
}

tst_color_enabled()
{
	[ $TST_COLOR_ENABLED -eq 1 ]  && return 1 || return 0
}

tst_print_colored()
{
	tst_color_enabled
	local color=$?

	[ "$color" = "1" ] && tst_flag2color "$1"
	printf "$2"
	[ "$color" = "1" ] && printf '\033[0m'
}

tst_exit()
{
	local ret=0

	if [ $TST_FAIL -gt 0 ]; then
		ret=$((ret|1))
	fi

	if [ $TST_BROK -gt 0 ]; then
		ret=$((ret|2))
	fi

	if [ $TST_WARN -gt 0 ]; then
		ret=$((ret|4))
	fi

	if [ $TST_CONF -gt 0 ]; then
		ret=$((ret|32))
	fi

    cat >&2 << EOF

Summary:
passed   $TST_PASS
failed   $TST_FAIL
broken   $TST_BROK
skipped  $TST_CONF
warnings $TST_WARN
EOF

	exit $ret
}

_tst_inc_res()
{
	case "$1" in
	TPASS) TST_PASS=$((TST_PASS+1));;
	TFAIL) TST_FAIL=$((TST_FAIL+1));;
	TBROK) TST_BROK=$((TST_BROK+1));;
	TWARN) TST_WARN=$((TST_WARN+1));;
	TCONF) TST_CONF=$((TST_CONF+1));;
	TINFO) ;;
	*) tst_brk TBROK "Invalid res type '$1'";;
	esac
}

tst_res()
{
	local res=$1
        if type caller >/dev/null 2>&1;then
		caller_info=$(caller 2) ||
			caller_info=$(caller 1) ||
			caller_info=$(caller 0)

		caller_info=$(echo "${caller_info}" | awk 'info=$NF":"$1 {print info}')
        fi

	shift

	tst_color_enabled
	local color=$?

	TST_COUNT=$(($TST_COUNT+1))

	_tst_inc_res "$res"
	printf "$(date) $TST_ID $TST_COUNT ${caller_info} "
	tst_print_colored $res "$res: "
	echo -e "$@"
}

tst_brk()
{
	local res=$1
	shift

	tst_res "$res" "$@"
	tst_exit
}

tst_begin_test()
{
	if [ -w /dev/kmsg ]; then
		export tst_date_time=`date +"%F %T%N"`
		echo "run test at $tst_date_time" > /dev/kmsg
	fi
}

_dmesg_since_test_start()
{
	if which tac > /dev/null 2>&1; then
		dmesg -T | tac | sed -ne "0,\#run test at $tst_date_time#p" | tac
	else
		dmesg -T >/dev/null 2>&1 && dmesg_cmd="dmesg -T" || dmesg_cmd="dmesg"
		tac_cmd="awk '{ lines[NR] = \$0 } END { for (i = NR; i > 0; i--) print lines[i] }'"
		eval "${dmesg_cmd} | ${tac_cmd} | sed -ne \"1,\#run test at ${tst_date_time}#p\" | ${tac_cmd}"
	fi
}

tst_check_dmesg_for()
{
	keywords=$@
	if [ -z "$keywords" ];then
		tst_res TWARN "tst_check_dmesg_for parameter is null"
	else
		_dmesg_since_test_start | grep -E -q "$keywords"
	fi
}

_tst_expect_pass()
{
	local fnc="$1"
	shift

	eval $@
	if [ $? -eq 0 ]; then
		tst_res TPASS "$@ passed as expected"
		return 0
	else
		$fnc TFAIL "$@ failed unexpectedly"
		return 1
	fi
}

_tst_expect_fail()
{
    local fnc="$1"
    shift

    eval $@
    if [ $? -ne 0 ]; then
        tst_res TPASS "$@ failed as expected"
        return 0
    else
        $fnc TFAIL "$@ pass unexpectedly"
        return 1
    fi
}

tst_expect_pass()
{
	_tst_expect_pass tst_res "$@"
}

tst_expect_fail()
{
    _tst_expect_fail tst_res "$@"
}

# check dmesg log for WARNING/Oops/etc.
tst_check_dmesg()
{
	ret=$(_dmesg_since_test_start | grep -E -q \
		-e "kernel BUG at" \
		-e "WARNING:" \
		-e "BUG:" \
		-e "WARNING:" \
		-e "Oops:" \
		-e "possible recursive locking detected" \
		-e "Internal error" \
		-e "suspicious RCU usage" \
		-e "possible circular locking dependency detected" \
		-e "general protection fault" \
		-e "BUG.*remaining" \
		-e "UBSAN" \
		-e "KASAN" \
		-e "unregister_netdevice: waiting for" \
		-e "Call trace")
	if [ $? -eq 0 ]; then
		tst_res TWARN "_check_dmesg: something found in dmesg\n$(_dmesg_since_test_start)"
	fi
}

if [ -z "$TST_ID" ]; then
	_tst_filename=$(basename $0) || \
		tst_brk TCONF "Failed to set TST_ID from \$0 ('$0')"
	TST_ID=${_tst_filename%%.*}
fi
export TST_ID="$TST_ID"
