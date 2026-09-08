#! /bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (c) 2012 FUJITSU LIMITED
# Copyright (c) 2014-2018 Linux Test Project
# Copyright (c) 2021 Joerg Vehlow <joerg.vehlow@aox-tech.de>
#
# Author: Peng Haitao <penght@cn.fujitsu.com>
# shellcheck disable=SC2034,SC2209,SC3043,SC2155,SC2103,SC1091
MEMCG_TESTFUNC=test
TST_CNT=4



# Run test cases which test memory.move_charge_at_immigrate
test_move_charge()
{
	local memtypes="$1"
	local size=$2
	local total_size=$3
	local move_charge_mask=$4
	local b_rss=$5
	local b_cache=$6
	local a_rss=$7
	local a_cache=$8

	mkdir subgroup_a

	start_memcg_process $memtypes -s $size

	warmup
	if [ $? -ne 0 ]; then
		rmdir subgroup_a
		return
	fi

	ROD echo $MEMCG_PROCESS_PID \> subgroup_a/tasks
	signal_memcg_process $total_size "subgroup_a/"

	ROD mkdir subgroup_b
	echo $move_charge_mask > subgroup_b/memory.move_charge_at_immigrate
	echo $MEMCG_PROCESS_PID > subgroup_b/tasks

	local stat_wait=0
	local max_stat_wait=50
	while [ $stat_wait -lt $max_stat_wait ]; do
		local rss_b=$(grep -w rss subgroup_b/memory.stat | cut -d " " -f 2)
		[ -z "$rss_b" ] && rss_b=0
		local cache_b=$(grep -w cache subgroup_b/memory.stat | cut -d " " -f 2)
		[ -z "$cache_b" ] && cache_b=0
		local rss_a=$(grep -w rss subgroup_a/memory.stat | cut -d " " -f 2)
		[ -z "$rss_a" ] && rss_a=0
		local cache_a=$(grep -w cache subgroup_a/memory.stat | cut -d " " -f 2)
		[ -z "$cache_a" ] && cache_a=0

		local match=1
		if [ "$b_rss" -gt 0 ] && [ "$rss_b" -eq 0 ]; then
			match=0
		fi
		if [ "$b_cache" -gt 0 ] && [ "$cache_b" -eq 0 ]; then
			match=0
		fi
		if [ "$a_rss" -gt 0 ] && [ "$rss_a" -eq 0 ]; then
			match=0
		fi
		if [ "$a_cache" -gt 0 ] && [ "$cache_a" -eq 0 ]; then
			match=0
		fi
		if [ "$b_rss" -eq 0 ] && [ "$rss_b" -gt 0 ] && [ "$a_rss" -gt 0 ]; then
			match=0
		fi
		if [ "$b_cache" -eq 0 ] && [ "$cache_b" -gt 0 ] && [ "$a_cache" -gt 0 ]; then
			match=0
		fi
		if [ "$a_rss" -eq 0 ] && [ "$rss_a" -gt 0 ] && [ "$b_rss" -gt 0 ]; then
			match=0
		fi
		if [ "$a_cache" -eq 0 ] && [ "$cache_a" -gt 0 ] && [ "$b_cache" -gt 0 ]; then
			match=0
		fi

		if [ $match -eq 1 ]; then
			break
		fi

		tst_sleep 100ms
		stat_wait=$((stat_wait + 1))
	done

	cd subgroup_b
	check_mem_stat "rss" $b_rss
	check_mem_stat "cache" $b_cache
	cd ../subgroup_a
	check_mem_stat "rss" $a_rss
	check_mem_stat "cache" $a_cache
	cd ..
	stop_memcg_process
	rmdir subgroup_a subgroup_b
}


test1()
{
	tst_res TINFO "Test disable moving charges"
	test_move_charge "--mmap-anon" $PAGESIZES $PAGESIZES 0 0 0 $PAGESIZES 0
}

test2()
{
	tst_res TINFO "Test move anon"
	test_move_charge "--mmap-anon --shm --mmap-file" $PAGESIZES \
		$((PAGESIZES * 3)) 1 $PAGESIZES 0 0 $((PAGESIZES * 2))
}

test3()
{
	tst_res TINFO "Test move file"
	test_move_charge "--mmap-anon --shm --mmap-file" $PAGESIZES \
		$((PAGESIZES * 3)) 2 0 $((PAGESIZES * 2)) $PAGESIZES 0
}

test4()
{
	tst_res TINFO "Test move anon and file"
	test_move_charge "--mmap-anon --shm" $PAGESIZES \
		$((PAGESIZES * 2)) 3 $PAGESIZES $PAGESIZES 0 0
}

. memcg_lib.sh
tst_run
