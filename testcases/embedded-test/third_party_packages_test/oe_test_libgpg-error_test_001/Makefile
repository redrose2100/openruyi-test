all:
	sh ../common.sh -d "libgpg-error" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/libgpg-error* && \
	autoreconf -f && \
	sed -i -e 's|^libdir=@libdir@$$|libdir=@exec_prefix@/lib|g;s|@GPG_ERROR_CONFIG_HOST@|none|g' src/gpg-error-config.in  && \
	sed -i -e '/--variable=host/d' src/gpg-error-config-test.sh.in  && \
	sed -i -e 's|sys_lib_dlsearch_path_spec="/lib /usr/lib|sys_lib_dlsearch_path_spec="/lib /usr/lib /usr/lib64|g' configure  && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --disable-dependency-tracking --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc --datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib64 --libexecdir=/usr/libexec --localstatedir=/var --sharedstatedir=/var/lib --mandir=/usr/share/man --infodir=/usr/share/info --disable-static --disable-rpath --disable-languages --enable-install-gpg-error-config && \
	sed -i 's/check-TESTS:/#check-TESTS:/g' src/Makefile && \
	sed -i 's/check-TESTS:/#check-TESTS:/g' tests/Makefile && \
	make V=1 check
	sh ../common.sh -c "libgpg-error*" "gpg-error-config-test.sh"
	sh ../common.sh -c "libgpg-error*" "tests"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"