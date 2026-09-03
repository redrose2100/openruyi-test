all:
	bash ../common.sh -M "tar"
	cd ./tmp_extract/tar* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine)  \
				--without-selinux --with-lzma="xz --format=lzma" \
				DEFAULT_RMT_DIR=/etc RSH=/usr/bin/ssh FORCE_UNSAFE_CONFIGURE=1 && \
	make && \
	cd tests && \
	make genfile checkseekhole ckmtime
	bash ../common.sh -c "tar*" "tests"
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"

	



