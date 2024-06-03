all:
	if [[  ${DOWNLOAD_BRANCH}  =~ "22.03" ]]; then download_branch=v590; else download_branch=v633; fi; \
	sh ../common.sh -s "https://github.com/gwsw/less.git" "$${download_branch}"
	cp -rR ./tmp_download/* ./tmp_extract/
	cd ./tmp_extract/less/lesstest && \
	sed -i "s/CC =/# CC =/g" Makefile && \
	make
	cp -Rr ./tmp_extract/less/lesstest ./tmp_test/
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"