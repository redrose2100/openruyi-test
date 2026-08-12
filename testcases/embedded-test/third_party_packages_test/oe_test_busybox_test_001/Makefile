all:
	git config --global --add safe.directory '*' || { bash ../common.sh -r; exit 1; }
	bash ../common.sh -M "busybox" || { bash ../common.sh -r; exit 1; }
	bash ../common.sh -M "yocto-embedded-tools" || { bash ../common.sh -r; exit 1; }
	bash ../common.sh -s "https://atomgit.com/openeuler/yocto-meta-openeuler.git" "$${YOCTO_META_BRANCH:-openEuler-24.03-LTS}" || { bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "busybox*" "testsuite" || { bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "/" "defconfig-busybox" "./tmp_download/yocto-embedded-tools/config/arm64/" || { bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "/" "defconfig" "./tmp_download/yocto-meta-openeuler/meta-openeuler/recipes-core/busybox/files" || { bash ../common.sh -r; exit 1; }

	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
