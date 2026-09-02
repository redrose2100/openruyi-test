CURDIR=${shell pwd}
SYSROOT_DIR=${shell echo $$CC | awk -F[' ',=] '{for (x=1;x<=NF;x++) { if ($$x == "--sysroot"){print $$(x+1)} }}'}

all:
	bash ${COMMONDIR}/common.sh -s "https://atomgit.com/alichinese_admin/ltp.git" "20220121"
	cp -r ./tmp_download/ltp ./tmp_extract/
	cd ./tmp_extract/ltp && \
	make autotools && \
	./configure --prefix=${CURDIR}/tmp_test/ltp_run --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	sed -i '/^CFLAGS/s/$$/ -Wno-implicit-function-declaration -Wno-incompatible-function-pointer-types/' include/mk/config.mk && \
	make && \
	make install
	tar -cf tmp_test/allinfo.tar -C ${SYSROOT_DIR} --exclude=./etc --exclude=./home --exclude=./root ./
	bash ${COMMONDIR}/common.sh -r

clean:
	bash ${COMMONDIR}/common.sh -r "all"
