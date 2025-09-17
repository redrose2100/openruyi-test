#!/bin/bash


# custodia 仅支持到python3.9
checkcustodia() {
    if python3 -c "import sys; exit(0 if sys.version_info.minor > 9 else 1)" 2>/dev/null; then
    	exit 255
	fi
}

