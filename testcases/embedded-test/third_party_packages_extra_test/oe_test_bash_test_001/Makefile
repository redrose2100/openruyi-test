all:
	bash ../common.sh -M "bash"
	cd ./tmp_extract/bash*  && \
	autoconf && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --with-bash-malloc=no --with-afs && \
	make 'CPPFLAGS=-D_GNU_SOURCE -DRECYCLES_PIDS -DDEFAULT_PATH_VALUE='\''"/usr/local/bin:/usr/bin"'\'' ' version.h && \
	make 'CPPFLAGS=-D_GNU_SOURCE -DRECYCLES_PIDS -DDEFAULT_PATH_VALUE='\''"/usr/local/bin:/usr/bin"'\'' ' -C builtins && \
	make 'CPPFLAGS=-D_GNU_SOURCE -DRECYCLES_PIDS -DDEFAULT_PATH_VALUE='\''"/usr/local/bin:/usr/bin"'\'' ' && \
	sed -i 's/.*@( cd $$(srcdir)\/tests/#	@( cd $$(srcdir)\/tests/g' Makefile && \
	sed -i 's/$$(CC_FOR_BUILD)/$$(CC)/g' Makefile && \
	make check
	bash ../common.sh -c "bash*" "tests"
	bash ../common.sh -c "bash*" "y.tab.c"
	bash ../common.sh -c "bash*" "config.h"
	bash ../common.sh -c "bash*" "version.h"
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"



