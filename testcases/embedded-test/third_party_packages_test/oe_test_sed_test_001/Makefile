all:
	sh ../common.sh -d "sed" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/sed* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine)  \
				--without-included-regex && \
	make -j1 
	sh ../common.sh -c "sed*" "testsuite"
	sh ../common.sh -c "sed*" "init.cfg"
	sh ../common.sh -c "sed*" "test-driver"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"

	



