#!/bin/bash
# Copyright (c) 2026 KylinSoft Co., Ltd.
# Licensed under the Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#     http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

####################################
# @Desc    : Validate suite2cases JSON files
#             - Check JSON syntax
#             - Check referenced test scripts exist
#             - Check case name consistency
#             - Check for duplicate registrations
# @Usage    : bash tools/validate_suite2cases.sh [suite2cases_dir] [testcases_dir]
####################################

# Default paths (relative to Mugen root)
SUITE2CASES_DIR="${1:-suite2cases}"
TESTCASES_DIR="${2:-testcases}"

# Counters
TOTAL_FILES=0
TOTAL_ERRORS=0
TOTAL_WARNINGS=0
TOTAL_CASES=0
TOTAL_DUPLICATES=0
TOTAL_MISSING=0

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    ((TOTAL_ERRORS++))
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    ((TOTAL_WARNINGS++))
}

log_ok() {
    echo -e "${GREEN}[OK]${NC} $1"
}

# Check if jq is available
if ! command -v jq >/dev/null 2>&1; then
    echo "Error: 'jq' is required but not installed."
    echo "Install it with: dnf install -y jq"
    exit 1
fi

# Check if python3 is available (for JSON syntax validation fallback)
HAS_PYTHON3=0

# Validate JSON syntax
validate_json_syntax() {
    local json_file="$1"

    # Method 1: Use jq to validate
    if ! jq empty "$json_file" 2>/dev/null; then
        log_error "$json_file: Invalid JSON syntax"
        # Try to show the specific error
        jq empty "$json_file" 2>&1 | head -3 | while read -r line; do
            echo "       $line"
        done
        return 1
    fi

    # Method 2: Check if it's a valid JSON object (not array at root)
    local root_type
    root_type=$(jq -r 'type' "$json_file" 2>/dev/null)
    if [ "$root_type" != "object" ]; then
        log_error "$json_file: Root element must be a JSON object, got '$root_type'"
        return 1
    fi

    return 0
}

# Validate JSON structure
validate_json_structure() {
    local json_file="$1"

    # Check for required 'cases' field
    local has_cases
    has_cases=$(jq 'has("cases")' "$json_file" 2>/dev/null)
    if [ "$has_cases" != "true" ]; then
        log_error "$json_file: Missing required 'cases' field"
        return 1
    fi

    # Check that 'cases' is an array
    local cases_type
    cases_type=$(jq -r '.cases | type' "$json_file" 2>/dev/null)
    if [ "$cases_type" != "array" ]; then
        log_error "$json_file: 'cases' must be an array, got '$cases_type'"
        return 1
    fi

    # Check for extra root-level fields (common mistake: appending arrays after the object)
    local root_keys
    root_keys=$(jq -r 'keys[]' "$json_file" 2>/dev/null)
    local valid_keys="path cases"
    for key in $root_keys; do
        local is_valid=0
        for vk in $valid_keys; do
            if [ "$key" = "$vk" ]; then
                is_valid=1
                break
            fi
        done
        if [ "$is_valid" -eq 0 ]; then
            log_warn "$json_file: Unexpected root-level field '$key'"
        fi
    done

    return 0
}

# Validate case entries
validate_cases() {
    local json_file="$1"
    local suite_name
    suite_name=$(basename "$json_file" .json)

    # Get the base path from JSON
    local base_path
    base_path=$(jq -r '.path // empty' "$json_file" 2>/dev/null)

    # Resolve $OET_PATH to actual path
    if [ -n "$base_path" ]; then
        base_path="${base_path//\$OET_PATH/\$TESTCASES_DIR}"
    fi

    # Get number of cases
    local case_count
    case_count=$(jq '.cases | length' "$json_file" 2>/dev/null)

    if [ "$case_count" -eq 0 ]; then
        log_warn "$json_file: No test cases registered"
        return 0
    fi

    # Track duplicates within this file
    local -A seen_names

    # Iterate over each case entry
    for i in $(seq 0 $((case_count - 1))); do
        ((TOTAL_CASES++))

        # Get case name (support both "name" and "case_name" formats)
        local case_name
        case_name=$(jq -r ".cases[$i].name // .cases[$i].case_name // empty" "$json_file" 2>/dev/null)

        if [ -z "$case_name" ]; then
            log_error "$json_file: cases[$i] missing 'name' or 'case_name' field"
            continue
        fi

        # Check for duplicate case names within this file
        if [ -n "${seen_names[$case_name]+x}" ]; then
            log_error "$json_file: Duplicate case name '$case_name'"
            ((TOTAL_DUPLICATES++))
            continue
        fi
        seen_names[$case_name]=1

        # Get case_path if specified (support both "case_path" and path from base)
        local case_path
        case_path=$(jq -r ".cases[$i].case_path // empty" "$json_file" 2>/dev/null)

        # Determine the script file to check
        local script_file=""
        if [ -n "$case_path" ]; then
            # If case_path is specified, resolve it
            case_path="${case_path//\$OET_PATH/\$TESTCASES_DIR}"
            script_file="$case_path"
        elif [ -n "$base_path" ]; then
            # Use base path + case_name.sh
            script_file="${base_path}/${case_name}.sh"
        else
            # No path info, try to find the script in testcases directory
            script_file=""
        fi

        # Check if the script file exists
        if [ -n "$script_file" ]; then
            if [ ! -f "$script_file" ]; then
                log_error "$json_file: Test script not found: $script_file (case: $case_name)"
                ((TOTAL_MISSING++))
            fi
        else
            # Try to find the script by name in testcases directory
            local found
            found=$(find "$TESTCASES_DIR" -name "${case_name}.sh" -type f 2>/dev/null | head -1)
            if [ -z "$found" ]; then
                log_warn "$json_file: Cannot locate script for case '$case_name' (no path info in JSON)"
            fi
        fi

        # Check name consistency: case_name should match the script filename
        if [ -n "$script_file" ] && [ -f "$script_file" ]; then
            local script_basename
            script_basename=$(basename "$script_file" .sh)
            if [ "$script_basename" != "$case_name" ]; then
                log_warn "$json_file: Case name '$case_name' does not match script filename '$script_basename.sh'"
            fi
        fi
    done
}

# Check for cross-file duplicate registrations
check_cross_file_duplicates() {
    echo ""
    echo "=== Cross-file Duplicate Check ==="

    local -A global_cases

    for json_file in "$SUITE2CASES_DIR"/*.json; do
        [ -f "$json_file" ] || continue

        local suite_name
        suite_name=$(basename "$json_file" .json)

        local case_count
        case_count=$(jq '.cases | length' "$json_file" 2>/dev/null)

        for i in $(seq 0 $((case_count - 1))); do
            local case_name
            case_name=$(jq -r ".cases[$i].name // .cases[$i].case_name // empty" "$json_file" 2>/dev/null)

            if [ -n "$case_name" ]; then
                if [ -n "${global_cases[$case_name]+x}" ]; then
                    log_error "Cross-file duplicate: '$case_name' registered in both '${global_cases[$case_name]}' and '$suite_name'"
                    ((TOTAL_DUPLICATES++))
                else
                    global_cases[$case_name]="$suite_name"
                fi
            fi
        done
    done
}

# Main
echo "========================================"
echo " Mugen suite2cases Validator"
echo "========================================"
echo ""
echo "Suite2cases dir: $SUITE2CASES_DIR"
echo "Testcases dir:   $TESTCASES_DIR"
echo ""

# Check directories exist
if [ ! -d "$SUITE2CASES_DIR" ]; then
    echo "Error: suite2cases directory '$SUITE2CASES_DIR' not found."
    exit 1
fi

if [ ! -d "$TESTCASES_DIR" ]; then
    echo "Error: testcases directory '$TESTCASES_DIR' not found."
    exit 1
fi

# Process each JSON file
echo "=== Per-file Validation ==="
echo ""

for json_file in "$SUITE2CASES_DIR"/*.json; do
    [ -f "$json_file" ] || continue
    ((TOTAL_FILES++))

    local_name=$(basename "$json_file")
    echo "--- $local_name ---"

    # Step 1: Validate JSON syntax
    if ! validate_json_syntax "$json_file"; then
        echo ""
        continue
    fi

    # Step 2: Validate JSON structure
    if ! validate_json_structure "$json_file"; then
        echo ""
        continue
    fi

    # Step 3: Validate case entries
    validate_cases "$json_file"

    log_ok "$local_name: structure valid"
    echo ""
done

# Step 4: Cross-file duplicate check
check_cross_file_duplicates

# Summary
echo ""
echo "========================================"
echo " Summary"
echo "========================================"
echo " JSON files checked:  $TOTAL_FILES"
echo " Total cases found:   $TOTAL_CASES"
echo " Missing scripts:     $TOTAL_MISSING"
echo " Duplicate cases:     $TOTAL_DUPLICATES"
echo " Errors:              $TOTAL_ERRORS"
echo " Warnings:            $TOTAL_WARNINGS"
echo "========================================"

if [ "$TOTAL_ERRORS" -gt 0 ]; then
    echo -e "${RED}Validation FAILED with $TOTAL_ERRORS error(s).${NC}"
    exit 1
else
    echo -e "${GREEN}Validation PASSED.${NC}"
    exit 0
fi