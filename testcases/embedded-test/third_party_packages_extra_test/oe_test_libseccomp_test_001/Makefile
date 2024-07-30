all:
	sh ../common.sh -d "libseccomp" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/libseccomp*  && \
	autoreconf && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && \
	make check-build
	sh ../common.sh -c "libseccomp*" "arch-syscall-check"
	sh ../common.sh -c "libseccomp*" "syscalls.csv"
	sh ../common.sh -c "libseccomp*" "seccomp-syscalls.h"
	sh ../common.sh -c "libseccomp*" "tests"
	sh ../common.sh -c "libseccomp*" "tools"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"



