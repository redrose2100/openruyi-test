all:
	bash ../common.sh -M "libpng"
	cd ./tmp_extract/libpng* && \
	autoreconf -vif && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make -O -j1 V=1 VERBOSE=1 DFA_XTRA=pngusr.dfa && \
	sed -n '/TESTS =/,/\# man pages/p' Makefile | grep tests | awk '{print $$1}' > testfile && \
	sed -n '/TESTS =/,/\# man pages/p' Makefile | grep tests | awk '{print $$2}' | awk 'NF > 0' >> testfile && \
	sed -n '/TESTS =/,/\# man pages/p' Makefile | grep tests | awk '{print $$3}' | awk 'NF > 0' >> testfile && \
	sed -i 's/\\//g' testfile && \
	make check || true && \
	rm -rf .libs/libpng16.* && \
	mv pngimage pngstest pngunknown pngvalid pngtest pngtest.png .libs ../../tmp_test/
	bash ../common.sh -c "libpng*" "test-driver"
	bash ../common.sh -c "libpng*" "tests"
	bash ../common.sh -c "libpng*" "testfile" 
	bash ../common.sh -c "libpng*" "contrib"
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"