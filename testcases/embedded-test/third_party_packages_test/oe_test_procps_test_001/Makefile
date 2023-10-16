all:
	sh ../common.sh -d "procps-ng" "${DOWNLOAD_BRANCH}"
	if [ -e ./tmp_download/procps-ng/backport-vmstat-Print-guest-time.patch ]; then \
	patch -p1 -d ./tmp_extract/procps*/ < ./tmp_download/procps-ng/backport-vmstat-Print-guest-time.patch; \
	fi
	cd ./tmp_extract/procps* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && \
	make -C testsuite site.exp && \
	make check || echo "done"
	sh ../common.sh -c "procps*" "testsuite"
	sh ../common.sh -c "procps*" "ps"
	sh ../common.sh -c "procps*" "tests"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"