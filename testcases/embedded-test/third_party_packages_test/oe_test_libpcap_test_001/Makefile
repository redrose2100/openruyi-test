all:
	bash ../common.sh -M "libpcap" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/libpcap* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --enable-shared && \
	make && \
	VER=`cat VERSION` && \
	sed -i "s/..\/libpcap.a/..\/libpcap.so.$$VER/g" testprogs/Makefile && \
	make -C testprogs || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "libpcap*" "testprogs" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
