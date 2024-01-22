all:
	sh ../common.sh -d "tar" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/tar* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine)  \
				--without-selinux --with-lzma="xz --format=lzma" \
				DEFAULT_RMT_DIR=/etc RSH=/usr/bin/ssh FORCE_UNSAFE_CONFIGURE=1 && \
	make && \
	cd tests && \
	make genfile checkseekhole ckmtime
	sh ../common.sh -c "tar*" "tests"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"

	



