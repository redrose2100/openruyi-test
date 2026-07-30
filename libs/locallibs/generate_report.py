#!/usr/bin/python3
import os
import sys
import json
import glob
import time
import argparse
from datetime import datetime
from typing import Iterator, Any
from urllib.parse import quote

OET_PATH: str | None = os.environ.get("OET_PATH")
if OET_PATH is None:
    raise RuntimeError(
        "OET_PATH environment variable is not set. "
        "Run via mugen.sh or 'export OET_PATH=...'"
    )

LOGS_DIR: str = os.path.join(OET_PATH, "logs")
LAST_FAILED_FILE: str = os.path.join(LOGS_DIR, "last_failed.json")
SUITE2CASES_DIR: str = os.path.join(OET_PATH, "suite2cases")

CAT_PASS = "pass"
CAT_FAIL = "fail"
CAT_SKIP = "skip"


def ec_category(code: int) -> str:
    if code == 0:
        return CAT_PASS
    elif code == 255:
        return CAT_SKIP
    else:
        return CAT_FAIL


def ec_is_pass(code: int) -> bool:
    return code == 0


def ec_is_fail(code: int) -> bool:
    return code not in (0, 255)


def ec_is_skip(code: int) -> bool:
    return code == 255


def walk_all_results() -> Iterator[tuple[str, str, int]]:
    for result_file in glob.glob(os.path.join(LOGS_DIR, "*", "*", "result")):
        rel = os.path.relpath(result_file, LOGS_DIR)
        parts = rel.split(os.sep)
        if len(parts) < 3:
            continue
        suite, case = parts[0], parts[1]
        try:
            with open(result_file) as f:
                code = int(f.read().strip())
        except (ValueError, OSError):
            continue
        yield suite, case, code


def read_results() -> dict[str, dict[str, list[str]]]:
    suites: dict[str, dict[str, list[str]]] = {}
    for suite, case, code in walk_all_results():
        cat = ec_category(code)
        suites.setdefault(suite, {CAT_PASS: [], CAT_FAIL: [], CAT_SKIP: []})[cat].append(case)
    return suites


def find_log_file(suite: str, case_name: str) -> str | None:
    case_dir = os.path.join(LOGS_DIR, suite, case_name)
    if not os.path.isdir(case_dir):
        return None
    log_files = sorted(
        glob.glob(os.path.join(case_dir, "*.log")),
        key=lambda p: _safe_mtime(p),
        reverse=True,
    )
    return log_files[0] if log_files else None


def _safe_mtime(path: str) -> float:
    try:
        return os.path.getmtime(path)
    except OSError:
        return 0.0


def extract_test_excerpt(log_path: str, max_lines: int = 20) -> str | None:
    try:
        with open(log_path, "rb") as f:
            raw = f.read()
        text = raw.decode("utf-8", errors="replace")
    except (OSError, UnicodeDecodeError):
        return None

    lines = text.split("\n")

    start_markers = [
        "Start to run test",
        "Start testing",
    ]
    end_markers = [
        "Start to restore the test environment",
        "start environment cleanup",
        "Finish environment cleanup",
    ]

    last_start = -1
    for i, line in enumerate(lines):
        for m in start_markers:
            if m in line:
                last_start = i

    if last_start < 0:
        return "\n".join(lines[-5:]).rstrip("\n")

    excerpt = []
    for i in range(last_start, len(lines)):
        line = lines[i]
        is_cleanup = any(m in line for m in end_markers)
        if is_cleanup and i > last_start:
            break
        excerpt.append(line)

    if len(excerpt) > max_lines:
        excerpt = excerpt[-max_lines:]

    return "\n".join(excerpt).rstrip("\n")


def read_case_history(suite: str, case: str) -> list[dict[str, Any]]:
    history_file = os.path.join(LOGS_DIR, suite, case, "history")
    if not os.path.isfile(history_file):
        return []
    history: list[dict[str, Any]] = []
    try:
        with open(history_file) as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                entry = json.loads(line)
                if not isinstance(entry, dict):
                    continue
                if "round" not in entry or "exitcode" not in entry:
                    continue
                history.append(entry)
    except (json.JSONDecodeError, OSError):
        pass
    return history


def build_history_data(
    suite: str, results: dict[str, list[str]]
) -> tuple[dict[str, list[dict[str, Any]]], list[int], list[str]]:
    all_cases = list(results[CAT_PASS])
    all_cases.extend(results[CAT_FAIL])
    all_cases.extend(results[CAT_SKIP])
    all_cases.sort()

    case_history: dict[str, list[dict[str, Any]]] = {}
    all_rounds: set[int] = set()
    for case in all_cases:
        hist = read_case_history(suite, case)
        case_history[case] = hist
        for h in hist:
            all_rounds.add(h["round"])
    all_rounds = sorted(all_rounds)
    return case_history, all_rounds, all_cases


def write_last_failed() -> None:
    results_dict: dict[str, dict[str, int]] = {}
    for suite, case, code in walk_all_results():
        results_dict.setdefault(suite, {})[case] = code

    summary = {"total": 0, CAT_PASS: 0, CAT_FAIL: 0, CAT_SKIP: 0}
    for suite, cases in results_dict.items():
        for code in cases.values():
            summary["total"] += 1
            cat = ec_category(code)
            summary[cat] += 1

    data = {
        "timestamp": datetime.now().strftime("%Y-%m-%d_%H-%M-%S"),
        "summary": summary,
        "results": results_dict,
    }
    with open(LAST_FAILED_FILE, "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)


def format_duration(seconds: int | float) -> str:
    h, r = divmod(int(seconds), 3600)
    m, s = divmod(r, 60)
    if h:
        return f"{h}h{m}m{s}s"
    elif m:
        return f"{m}m{s}s"
    else:
        return f"{s}s"


def escape_html(s: str) -> str:
    return (
        s.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace('"', "&quot;")
    )


def exitcode_label(code: int) -> str:
    cat = ec_category(code)
    if cat == CAT_PASS:
        return '<span class="badge pass">PASS</span>'
    elif cat == CAT_SKIP:
        return '<span class="badge skip">SKIP</span>'
    else:
        return '<span class="badge fail">FAIL</span>'


def exitcode_text(code: int) -> str:
    return {CAT_PASS: "PASS", CAT_FAIL: "FAIL", CAT_SKIP: "SKIP"}[ec_category(code)]


def _classify_case_row(
    case_name: str,
    case_history: dict[str, list[dict[str, Any]]],
    all_rounds: list[int],
    read_results_raw: dict[str, int],
) -> tuple[str, str]:
    hist = case_history.get(case_name, [])
    round_map = {h["round"]: h["exitcode"] for h in hist}
    current_code = read_results_raw.get(case_name)
    ever_failed = any(ec_is_fail(code) for code in round_map.values()) or (
        current_code is not None and ec_is_fail(current_code)
    )
    recovered = ever_failed and not ec_is_fail(current_code) if current_code is not None else False
    regressed = False
    if len(round_map) >= 2:
        seen_pass = False
        for r in all_rounds:
            if r in round_map and round_map[r] == 0:
                seen_pass = True
            if r in round_map and ec_is_fail(round_map[r]) and seen_pass:
                regressed = True
                break

    classes = "case-row"
    if ever_failed:
        classes += " ever-failed"
    if recovered:
        classes += " recovered"
    if regressed:
        classes += " regressed"
    if current_code is not None and ec_is_fail(current_code):
        classes += " current-failed"

    case_id = quote(case_name, safe="")
    row_html = f'<td><strong><a href="#detail-{case_id}" style="text-decoration:none;color:inherit;">{escape_html(case_name)}</a></strong></td>\n'
    for r in all_rounds:
        code = round_map.get(r)
        if code is not None:
            row_html += f"<td>{exitcode_label(code)}</td>\n"
        else:
            row_html += '<td><span class="badge none">-</span></td>\n'
    if current_code is not None:
        row_html += f"<td>{exitcode_label(current_code)}</td>\n"
    else:
        row_html += "<td>-</td>\n"
    return classes, row_html


def _render_html_report(
    suite: str,
    suite_dir: str,
    total: int,
    passed: int,
    failed: int,
    skipped: int,
    pass_rate: float,
    ts: str,
    duration: str,
    all_rounds: list[int],
    all_cases: list[str],
    case_history: dict[str, list[dict[str, Any]]],
    read_results_raw: dict[str, int],
    data: dict[str, list[str]],
) -> str:
    html = f"""<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<title>{escape_html(suite)} - mugen Test Report</title>
<style>
body {{ font-family: -apple-system, sans-serif; margin: 20px; color: #333; }}
h1 {{ border-bottom: 2px solid #eee; padding-bottom: 10px; }}
.filters {{ margin: 15px 0; }}
.filters select {{ padding: 5px 10px; font-size: 14px; }}
.summary {{ display: flex; gap: 20px; margin: 20px 0; }}
.summary-item {{ padding: 15px; border-radius: 8px; min-width: 100px; text-align: center; }}
.summary-item.total {{ background: #e8e8e8; }}
.summary-item.passed {{ background: #d4edda; color: #155724; }}
.summary-item.failed {{ background: #f8d7da; color: #721c24; }}
.summary-item.skipped {{ background: #fff3cd; color: #856404; }}
.summary-item .num {{ font-size: 28px; font-weight: bold; }}
table {{ border-collapse: collapse; width: 100%; margin-top: 10px; }}
th, td {{ border: 1px solid #ddd; padding: 6px 10px; text-align: left; font-size: 13px; }}
th {{ background: #f5f5f5; position: sticky; top: 0; }}
tr:hover {{ background: #f0f0f0; }}
.badge {{ display: inline-block; padding: 2px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }}
.badge.pass {{ background: #d4edda; color: #155724; }}
.badge.fail {{ background: #f8d7da; color: #721c24; }}
.badge.skip {{ background: #fff3cd; color: #856404; }}
.badge.none {{ background: #eee; color: #999; }}
.case-row {{ border-left: 4px solid transparent; }}
.case-row.ever-failed {{ border-left-color: #dc3545; }}
.case-row.recovered {{ border-left-color: #28a745; }}
.case-row.regressed {{ border-left-color: #ffc107; }}
.round-header {{ writing-mode: vertical-lr; text-orientation: mixed; white-space: nowrap; }}
.case-item {{ padding: 8px 15px; margin: 4px 0; border-left: 4px solid #ddd; }}
.case-item.failed {{ border-left-color: #dc3545; background: #fff8f8; }}
.case-item.passed {{ border-left-color: #28a745; }}
.case-item.skipped {{ border-left-color: #ffc107; }}
.case-title {{ font-weight: bold; }}
.log-link {{ color: #0366d6; text-decoration: none; font-size: 13px; }}
.log-link:hover {{ text-decoration: underline; }}
.excerpt {{ background: #f6f8fa; padding: 8px; border-radius: 4px; font-family: monospace; font-size: 13px; white-space: pre-wrap; margin-top: 5px; overflow-x: auto; }}
</style>
</head>
<body>
<h1>{escape_html(suite)}</h1>
<p>Generated: {escape_html(ts)} | Duration: {escape_html(duration)}</p>
<div class="summary">
<div class="summary-item total"><div class="num">{total}</div>Total</div>
<div class="summary-item passed"><div class="num">{passed}</div>Passed</div>
<div class="summary-item failed"><div class="num">{failed}</div>Failed</div>
<div class="summary-item skipped"><div class="num">{skipped}</div>Skipped</div>
</div>
<p>Pass rate: <strong>{pass_rate}%</strong></p>
"""

    if all_rounds:
        html += '<div class="filters">\n'
        html += '<label>Filter: <select id="filterSelect" onchange="filterTable(this.value)">\n'
        html += '<option value="all">All</option>\n'
        html += '<option value="ever-failed">Has failures</option>\n'
        html += '<option value="recovered">Recovered (fail -> pass)</option>\n'
        html += '<option value="regressed">Regressed (pass -> fail)</option>\n'
        html += '<option value="current-failed">Current failures</option>\n'
        html += "</select></label>\n"
        html += "</div>\n"

        html += '<div style="overflow-x: auto;">\n'
        html += "<table>\n<thead><tr>\n<th>Case</th>\n"
        for r in all_rounds:
            html += f'<th class="round-header">Round {r}</th>\n'
        html += "<th>Final</th>\n</tr></thead>\n<tbody>\n"

        for case_name in all_cases:
            classes, row_html = _classify_case_row(
                case_name, case_history, all_rounds, read_results_raw
            )
            html += f'<tr class="{escape_html(classes)}">\n'
            html += row_html
            html += "</tr>\n"

        html += "</tbody>\n</table>\n</div>\n"

        html += """<script>
function filterTable(val) {
    var rows = document.querySelectorAll('tbody tr');
    rows.forEach(function(row) {
        if (val === 'all') {
            row.style.display = '';
        } else {
            row.style.display = row.classList.contains(val) ? '' : 'none';
        }
    });
}
</script>
"""

    html += "<h2>Detail</h2>\n"

    all_cases_detailed = (
        [(CAT_FAIL, c) for c in data[CAT_FAIL]]
        + [(CAT_PASS, c) for c in data[CAT_PASS]]
        + [(CAT_SKIP, c) for c in data[CAT_SKIP]]
    )

    for status, case_name in all_cases_detailed:
        log_path = find_log_file(suite, case_name) if status == CAT_FAIL else None
        log_link = os.path.relpath(log_path, suite_dir) if log_path else ""
        tail = extract_test_excerpt(log_path) if log_path else ""
        case_id = quote(case_name, safe="")
        label = {CAT_PASS: "PASS", CAT_FAIL: "FAIL", CAT_SKIP: "SKIP"}[status]
        html += f'<div id="detail-{case_id}" class="case-item {status}">'
        html += f'  <span class="case-title">[{label}] {escape_html(case_name)}</span>'
        if log_link:
            html += f'  <a class="log-link" href="{quote(log_link)}" target="_blank"> [log]</a>'
        if tail:
            html += f'  <div class="excerpt">{escape_html(tail)}</div>'
        html += "</div>\n"
    html += "</body></html>"
    return html


def _render_md_report(
    suite: str,
    suite_dir: str,
    total: int,
    passed: int,
    failed: int,
    skipped: int,
    pass_rate: float,
    ts: str,
    duration: str,
    all_rounds: list[int],
    all_cases: list[str],
    case_history: dict[str, list[dict[str, Any]]],
    read_results_raw: dict[str, int],
    data: dict[str, list[str]],
) -> str:
    md = f"# {suite}\n\n"
    md += f"Generated: {ts} | Duration: {duration}\n\n"
    md += f"**Total: {total} | Passed: {passed} | Failed: {failed} | Skipped: {skipped}**\n\n"
    md += f"Pass rate: **{pass_rate}%**\n\n"

    if all_rounds:
        md += "## History\n\n"
        header = "| Case |"
        separator = "|------|"
        for r in all_rounds:
            header += f" Round {r} |"
            separator += "--------|"
        header += " Final |\n"
        separator += "-------|\n"
        md += header + separator

        for case_name in all_cases:
            hist = case_history.get(case_name, [])
            round_map = {h["round"]: h["exitcode"] for h in hist}
            current_code = read_results_raw.get(case_name)
            md += f"| {case_name} |"
            for r in all_rounds:
                code = round_map.get(r)
                md += f" {exitcode_text(code) if code is not None else '-'} |"
            md += f" {exitcode_text(current_code) if current_code is not None else '-'} |\n"
        md += "\n"

    md += "## Detail\n\n"
    for status, cases, label in [
        (CAT_FAIL, data[CAT_FAIL], "FAILED"),
        (CAT_PASS, data[CAT_PASS], "PASSED"),
        (CAT_SKIP, data[CAT_SKIP], "SKIPPED"),
    ]:
        if not cases:
            continue
        md += f"### {label}\n\n"
        for case_name in cases:
            log_path = find_log_file(suite, case_name) if status == CAT_FAIL else None
            log_link = os.path.relpath(log_path, suite_dir) if log_path else ""
            md += f"- **{case_name}**"
            if log_link:
                safe_link = log_link.replace("]", "\\]").replace(")", "\\)")
                md += f" - [log]({safe_link})"
            md += "\n"
            if log_path and status == CAT_FAIL:
                tail = extract_test_excerpt(log_path)
                if tail:
                    md += "  ```\n"
                    for line in tail.split("\n"):
                        md += f"  {line}\n"
                    md += "  ```\n"
        md += "\n"

    return md


def generate_suite_report(
    suite: str, data: dict[str, list[str]], start_time: int | None = None
) -> None:
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    failed = len(data[CAT_FAIL])
    passed = len(data[CAT_PASS])
    skipped = len(data[CAT_SKIP])
    total = failed + passed + skipped
    pass_rate = round(passed / total * 100, 1) if total else 0
    duration = format_duration(time.time() - start_time) if start_time else ""

    suite_dir = os.path.join(LOGS_DIR, suite)

    case_history, all_rounds, all_cases = build_history_data(suite, data)

    read_results_raw: dict[str, int] = {}
    for case_name in all_cases:
        r = os.path.join(suite_dir, case_name, "result")
        try:
            with open(r) as f:
                read_results_raw[case_name] = int(f.read().strip())
        except (ValueError, OSError):
            pass

    html = _render_html_report(
        suite, suite_dir, total, passed, failed, skipped,
        pass_rate, ts, duration, all_rounds, all_cases,
        case_history, read_results_raw, data,
    )
    with open(os.path.join(suite_dir, f"{suite}.html"), "w") as f:
        f.write(html)

    md = _render_md_report(
        suite, suite_dir, total, passed, failed, skipped,
        pass_rate, ts, duration, all_rounds, all_cases,
        case_history, read_results_raw, data,
    )
    with open(os.path.join(suite_dir, f"{suite}.md"), "w") as f:
        f.write(md)


def read_suite_cases(suite: str) -> list[str]:
    json_path = os.path.join(SUITE2CASES_DIR, f"{suite}.json")
    if not os.path.isfile(json_path):
        return []
    try:
        with open(json_path) as f:
            data = json.load(f)
    except (json.JSONDecodeError, OSError):
        return []
    cases = data.get("cases", [])
    return [c["name"] if isinstance(c, dict) else c for c in cases]


def list_cases(suite: str = "", modes: frozenset[str] = frozenset()) -> None:
    if not modes:
        return

    last_results: dict[str, dict[str, int]] = {}
    if os.path.isfile(LAST_FAILED_FILE):
        try:
            with open(LAST_FAILED_FILE) as f:
                data = json.load(f)
            last_results = data.get("results", {})
        except (json.JSONDecodeError, OSError):
            pass

    suites_to_process = [suite] if suite else list(last_results.keys())

    for s in suites_to_process:
        suite_results = last_results.get(s, {})
        suite_cases = read_suite_cases(s)

        failed_cases = {c for c, code in suite_results.items() if ec_is_fail(code)}
        skip_cases = {c for c, code in suite_results.items() if ec_is_skip(code)}
        not_run_cases: set[str] = set()

        if "not-run" in modes:
            for c in suite_cases:
                result_file = os.path.join(LOGS_DIR, s, c, "result")
                try:
                    with open(result_file) as f:
                        pass
                except OSError:
                    not_run_cases.add(c)

        selected: set[str] = set()
        if "failed" in modes:
            selected |= failed_cases
        if "skip" in modes:
            selected |= skip_cases
        if "not-run" in modes:
            selected |= not_run_cases

        for case_name in sorted(selected):
            sys.stdout.write(f"{s} {case_name}\n")


def report_cmd(start_time: int | None = None) -> None:
    suites = read_results()
    if not suites:
        return
    write_last_failed()
    for suite, data in suites.items():
        generate_suite_report(suite, data, start_time)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--start-time", type=int, default=None)
    parser.add_argument(
        "--list-cases",
        nargs="?",
        const="",
        default=None,
        help="Print cases to rerun",
    )
    parser.add_argument(
        "--mode",
        default="failed",
        help="Comma-separated modes: failed, skip, not-run, all",
    )
    args = parser.parse_args()

    if args.list_cases is not None:
        modes: set[str] = {"failed", "skip", "not-run"}
        if args.mode == "all":
            modes = {"failed", "skip", "not-run"}
        else:
            parts = [m.strip() for m in args.mode.split(",")]
            modes.clear()
            for p in parts:
                if p == "all":
                    modes = {"failed", "skip", "not-run"}
                    break
                elif p in ("failed", "skip", "not-run"):
                    modes.add(p)
                else:
                    sys.stderr.write(f"Unknown mode: {p}\n")
                    sys.exit(1)
        list_cases(suite=args.list_cases, modes=frozenset(modes))
    else:
        report_cmd(start_time=args.start_time)


if __name__ == "__main__":
    try:
        main()
    except RuntimeError as e:
        sys.stderr.write(f"{e}\n")
        sys.exit(1)
