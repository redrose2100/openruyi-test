all:
	bash ../common.sh -M "ncurses" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/ncurses* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) \
		--with-abi-version=6 \
		--without-debug \
		--without-ada \
		--without-gpm \
		--enable-hard-tabs \
		--enable-xmc-glitch \
		--enable-colorfgbg \
		--with-shared \
		--disable-big-core \
		--program-prefix= \
		--with-ticlib \
		--enable-sigwinch \
		--enable-pc-files \
		--disable-rpath-hack \
		--with-manpage-format=normal \
		--without-manpage-renames \
		--disable-stripping && \
	make || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "ncurses*" "test" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cp ./tmp_extract/ncurses*/lib/libncurses.so.6* ./tmp_test/ 2>/dev/null || true
	cp ./tmp_extract/ncurses*/lib/libncursesw.so.6* ./tmp_test/ 2>/dev/null || true
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
