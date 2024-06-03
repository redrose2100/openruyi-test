all:
	sh ../common.sh -d "bash" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/bash*  && \
	autoconf && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --with-bash-malloc=no --with-afs && \
	make 'CPPFLAGS=-D_GNU_SOURCE -DRECYCLES_PIDS -DDEFAULT_PATH_VALUE='\''"/usr/local/bin:/usr/bin"'\'' ' version.h && \
	make 'CPPFLAGS=-D_GNU_SOURCE -DRECYCLES_PIDS -DDEFAULT_PATH_VALUE='\''"/usr/local/bin:/usr/bin"'\'' ' -C builtins && \
	make 'CPPFLAGS=-D_GNU_SOURCE -DRECYCLES_PIDS -DDEFAULT_PATH_VALUE='\''"/usr/local/bin:/usr/bin"'\'' ' && \
	sed -i 's/.*@( cd $$(srcdir)\/tests/#	@( cd $$(srcdir)\/tests/g' Makefile && \
	sed -i 's/$$(CC_FOR_BUILD)/$$(CC)/g' Makefile && \
	make check
	sh ../common.sh -c "bash*" "tests"
	sh ../common.sh -c "bash*" "y.tab.c"
	sh ../common.sh -c "bash*" "config.h"
	sh ../common.sh -c "bash*" "version.h"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"



