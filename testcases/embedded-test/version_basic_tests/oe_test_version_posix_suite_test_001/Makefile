CC:= ${shell echo $$CC | sed "s/-fstack-protector-strong//g"}
all:
	sh ${COMMONDIR}/common.sh -s "https://github.com/emscripten-core/posixtestsuite.git" "main"
	cp -r ./tmp_download/posixtestsuite ./tmp_extract/
	cd ./tmp_extract/posixtestsuite && \
	sed -i '$a #include<signal.h>' include/posixtest.h && \
	sed -i "s/char semname\[20\]/char semname\[40\]/g" `grep -rl "char semname\[20\]" conformance/interfaces/` && \
	sed -i "1i #pragma GCC optimize \(\"-O0\"\)" conformance/interfaces/pthread_create/10-1.c && \
	sed -i "1i #pragma GCC push_options" conformance/interfaces/pthread_create/10-1.c && \
	sed -i "\$$i #pragma GCC pop_options" conformance/interfaces/pthread_create/10-1.c && \
	sed -i "s/CFLAGS = -g -O2 -Wall -Werror /CFLAGS = -g -O2 -Wno-implicit-function-declaration /g" Makefile && \
	POSIX_TARGET=./ make > ../build.log 2>&1 && \
	sed -i "s/\$$(top_builddir)\/t0 \$$(top_builddir)\/t0.val/#/g" Makefile
	cp -r ./tmp_extract/* ./tmp_test/
	sh ${COMMONDIR}/common.sh -r

clean:
	sh ${COMMONDIR}/common.sh -r "all"
