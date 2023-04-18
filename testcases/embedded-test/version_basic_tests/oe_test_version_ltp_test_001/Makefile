CURDIR=${shell pwd}
SYSROOT_DIR=${shell echo $$CC | awk -F[' ',=] '{for (x=1;x<=NF;x++) { if ($$x == "--sysroot"){print $$(x+1)} }}'}

all:
	sh ${COMMONDIR}/common.sh -s "https://github.com/linux-test-project/ltp.git" "20220121"
	cp -r ./tmp_download/ltp ./tmp_extract/
	cd ./tmp_extract/ltp && \
	make autotools && \
	./configure --prefix=${CURDIR}/tmp_test/ltp_run --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && \
	make install
	tar -cf tmp_test/allinfo.tar -C ${SYSROOT_DIR} ./
	sh ${COMMONDIR}/common.sh -r

clean:
	sh ${COMMONDIR}/common.sh -r "all"
