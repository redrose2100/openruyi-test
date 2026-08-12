all:
	dnf install -y rpcgen || yum install -y rpcgen || apt-get install -y rpcsvc-proto || true
	bash ../common.sh -M "nfs-utils" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/nfs-utils* && \
	./configure --host=$${CROSS_COMPILE%-} \
				--build=$$(gcc -dumpmachine) \
				--with-statduser=rpcuser \
                --enable-mountconfig \
                --enable-libmount-mount \
                --enable-uuid \
                --disable-gss \
                --disable-nfsdcltrack \
                --with-statdpath=/var/lib/nfs/statd  && \
	sed -i 's/nfsidmap//' utils/Makefile && \
	make || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/nfs-utils* && \
	cd tests && \
	make && \
	make statdb_dump && \
	cd nsm_client && \
	make nsm_client || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/nfs-utils* && \
	cd tests && \
	sed -i 's/$$srcdir\/..\/utils\/statd\/statd/\/usr\/sbin\/rpc.statd/g' test-lib.sh && \
	sed -i 's/DUMPER=`realpath ..\/tools\/nfsconf\/nfsconftool`/DUMPER=\/usr\/sbin\/nfsconf/g' t0002-nfsconf.sh || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "nfs-utils*" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
