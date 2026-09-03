SHELL=/bin/bash
all:
	dnf install gettext-devel -y || yum install gettext-devel -y || apt-get install -y gettext libc6-dev || true
	bash ../common.sh -M "util-linux" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/util-linux* && \
	bash autogen.sh && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --without-systemd && \
	make check-programs && \
	allSample=$$(find ./ -name "sample-*")" test_uuid_parser test_uuidd"; \
	for oneSampel in $${allSample[@]}; do \
	sed -i "s/relink_command=/# relink_command=/g" $${oneSampel}; \
	done &&\
	sed -i 's/-P $$paraller_jobs//g' tests/run.sh && \
	mkdir -p run_test_dir && \
	cp -r test_* ./run_test_dir/ && \
	cp -r sample-* ./run_test_dir/ && \
	cp -r .libs ./run_test_dir/ && \
	cp Makefile ./run_test_dir/ && \
	cp config.h ./run_test_dir/ && \
	cp -r tests ./run_test_dir/ || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "util-linux*" "run_test_dir" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
