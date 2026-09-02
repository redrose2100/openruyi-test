all:
	bash ../common.sh -M "libseccomp"
	cd ./tmp_extract/libseccomp*  && \
	autoreconf && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && \
	make check-build
	bash ../common.sh -c "libseccomp*" "arch-syscall-check"
	bash ../common.sh -c "libseccomp*" "syscalls.csv"
	bash ../common.sh -c "libseccomp*" "seccomp-syscalls.h"
	bash ../common.sh -c "libseccomp*" "tests"
	bash ../common.sh -c "libseccomp*" "tools"
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"



