bin_PROGRAMS = autoreconf

autoreconf_SOURCES = autoreconf-test.c
autoreconf_CPPFLAGS = -DCONFIG_DIR=\"$(sysconfdir)\" -DLIBRARY_DIR=\"$(pkglibdir)\"
autoreconf_LDFLAGS = -export-dynamic -lmemcached
noinst_HEADERS =
AM_CPPFLAGS = -I/usr/local/libmemcached/include/

autoreconf_LDADD = $(top_builddir)/sx/libsession.la \
            $(top_builddir)/util/libutil.la