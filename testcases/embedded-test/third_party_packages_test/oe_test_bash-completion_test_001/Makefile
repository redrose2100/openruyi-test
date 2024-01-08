all:
	sh ../common.sh -d "bash-completion" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/bash-completion*  && \
	autoreconf -fiv && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make 
	sh ../common.sh -c "bash-completion*" "completions"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"



