#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Copyright (c) 2026 KylinSoft Co., Ltd.
# Licensed under the Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#     http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

"""
Mugen Test Report Generator

Parses Mugen test results from results/ and logs/ directories,
generates a Markdown report with pass rates and failure details.

Usage:
    python3 tools/generate_report.py [results_dir] [logs_dir]

Defaults:
    results_dir = ./results
    logs_dir    = ./logs
"""

import os
import sys
import glob
import argparse
from datetime import datetime
from collections import OrderedDict


def parse_results(results_dir):
    """
    Parse the results/ directory structure.
    Returns a dict: { suite_name: { "succeed": [...], "failed": [...], "skipped": [...] } }
    """
    suites = OrderedDict()

    if not os.path.isdir(results_dir):
        print(f"Error: results directory '{results_dir}' not found.")
        sys.exit(1)

    for suite_name in sorted(os.listdir(results_dir)):
        suite_path = os.path.join(results_dir, suite_name)
        if not os.path.isdir(suite_path):
            continue

        suite_data = {"succeed": [], "failed": [], "skipped": []}

        for status in ("succeed", "failed", "skipped"):
            status_dir = os.path.join(suite_path, status)
            if os.path.isdir(status_dir):
                for case_file in sorted(os.listdir(status_dir)):
                    case_path = os.path.join(status_dir, case_file)
                    if os.path.isfile(case_path):
                        suite_data[status].append(case_file)

        total = len(suite_data["succeed"]) + len(suite_data["failed"]) + len(suite_data["skipped"])
        if total > 0:
            suites[suite_name] = suite_data

    return suites


def extract_error_logs(logs_dir, suite_name, case_name):
    """
    Extract LOG_ERROR lines from the log file of a failed test case.
    Log path pattern: logs/<suite>/<case>/<timestamp>.log
    """
    errors = []
    case_log_dir = os.path.join(logs_dir, suite_name, case_name)

    if not os.path.isdir(case_log_dir):
        return errors

    # Find the latest log file (sorted by name/timestamp)
    log_files = sorted(glob.glob(os.path.join(case_log_dir, "*.log")))
    if not log_files:
        return errors

    latest_log = log_files[-1]
    try:
        with open(latest_log, "r", encoding="utf-8", errors="ignore") as f:
            for line in f:
                line = line.strip()
                if "LOG_ERROR" in line or "ERROR" in line:
                    errors.append(line)
    except (IOError, OSError):
        pass

    return errors


def generate_summary(suites):
    """Generate overall summary statistics."""
    total_succeed = 0
    total_failed = 0
    total_skipped = 0

    for suite_data in suites.values():
        total_succeed += len(suite_data["succeed"])
        total_failed += len(suite_data["failed"])
        total_skipped += len(suite_data["skipped"])

    total = total_succeed + total_failed + total_skipped
    pass_rate = (total_succeed / total * 100) if total > 0 else 0

    return {
        "total": total,
        "succeed": total_succeed,
        "failed": total_failed,
        "skipped": total_skipped,
        "pass_rate": pass_rate,
    }


def generate_markdown(suites, logs_dir):
    """Generate the full Markdown report."""
    summary = generate_summary(suites)
    lines = []

    # Title
    lines.append("# Mugen Test Report")
    lines.append("")
    lines.append(f"> Generated at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    lines.append("")

    # Overall Summary
    lines.append("## Overall Summary")
    lines.append("")
    lines.append(f"| Metric | Count |")
    lines.append(f"|--------|-------|")
    lines.append(f"| Total Cases | {summary['total']} |")
    lines.append(f"| Passed | {summary['succeed']} |")
    lines.append(f"| Failed | {summary['failed']} |")
    lines.append(f"| Skipped | {summary['skipped']} |")
    lines.append(f"| **Pass Rate** | **{summary['pass_rate']:.1f}%** |")
    lines.append("")

    # Per-Suite Summary
    lines.append("## Suite Results")
    lines.append("")
    lines.append("| Suite | Passed | Failed | Skipped | Total | Pass Rate |")
    lines.append("|-------|--------|--------|---------|-------|-----------|")

    for suite_name, suite_data in suites.items():
        s = len(suite_data["succeed"])
        f = len(suite_data["failed"])
        k = len(suite_data["skipped"])
        t = s + f + k
        rate = (s / t * 100) if t > 0 else 0
        lines.append(f"| {suite_name} | {s} | {f} | {k} | {t} | {rate:.1f}% |")

    lines.append("")

    # Failure Details
    if summary["failed"] > 0:
        lines.append("## Failure Details")
        lines.append("")

        for suite_name, suite_data in suites.items():
            if not suite_data["failed"]:
                continue

            lines.append(f"### {suite_name}")
            lines.append("")

            for case_name in suite_data["failed"]:
                lines.append(f"#### {case_name}")
                lines.append("")

                errors = extract_error_logs(logs_dir, suite_name, case_name)
                if errors:
                    lines.append("```")
                    for err in errors[:10]:  # Limit to 10 lines per case
                        lines.append(err)
                    if len(errors) > 10:
                        lines.append(f"... ({len(errors) - 10} more error lines)")
                    lines.append("```")
                else:
                    lines.append("*No error log found.*")
                lines.append("")

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(
        description="Generate Markdown test report from Mugen results."
    )
    parser.add_argument(
        "results_dir",
        nargs="?",
        default="results",
        help="Path to the results directory (default: ./results)",
    )
    parser.add_argument(
        "logs_dir",
        nargs="?",
        default="logs",
        help="Path to the logs directory (default: ./logs)",
    )
    parser.add_argument(
        "-o", "--output",
        default="test_report.md",
        help="Output report file path (default: test_report.md)",
    )
    args = parser.parse_args()

    suites = parse_results(args.results_dir)
    if not suites:
        print("No test results found.")
        sys.exit(0)

    report = generate_markdown(suites, args.logs_dir)

    with open(args.output, "w", encoding="utf-8") as f:
        f.write(report)

    print(f"Report generated: {args.output}")

    summary = generate_summary(suites)
    print(f"Total: {summary['total']} | "
          f"Passed: {summary['succeed']} | "
          f"Failed: {summary['failed']} | "
          f"Skipped: {summary['skipped']} | "
          f"Pass Rate: {summary['pass_rate']:.1f}%")


if __name__ == "__main__":
    main()