all:
	sh ../common.sh -d "bash" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/bash*  && \
	autoconf && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) \
				--with-bash-malloc=no --with-afs && \
	make -O -j1 V=1 VERBOSE=1
	sh ../common.sh -c "bash*" "tests"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"



