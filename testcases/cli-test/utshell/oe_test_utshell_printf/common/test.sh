#!/bin/utshell
returnSimple() {
local  __resultvar=$1
printf -v "$__resultvar" '%s' "ERROR"
echo "Hello World"
}
returnSimple theResult
echo ${theResult}
echo Done.