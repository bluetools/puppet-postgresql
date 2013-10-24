require 'formula'

class Postgresql < Formula
  homepage 'http://www.postgresql.org/'
  url 'http://ftp.postgresql.org/pub/source/v9.3.1/postgresql-9.3.1.tar.bz2'
  sha256 '8ea4a7a92a6f5a79359b02e683ace335c5eb45dffe7f8a681a9ce82470a8a0b8'
  version '9.3.1-boxen1'

  #keg_only 'The different provided versions of PostgreSQL conflict with each other.'

  #env :std

  depends_on 'gettext'
  depends_on 'ossp-uuid'
  depends_on 'readline'

  def options
    [
      ['--with-tcl', 'Build with tcl support.'],
    ]
  end

  # Fix uuid-ossp build issues: http://archives.postgresql.org/pgsql-general/2012-07/msg00654.php
  def patches
    DATA
  end

  def install
    args = ["--prefix=#{prefix}",
            "--enable-dtrace",
            "--enable-nls",
            "--with-bonjour",
            "--with-gssapi",
            "--with-krb5",
            "--with-ldap",
            "--with-libxml",
            "--with-libxslt",
            "--with-openssl",
            "--with-ossp-uuid",
            "--with-pam",
            "--with-perl",
            "--with-python"]

    args << "--with-tcl" if ARGV.include? '--with-tcl'

    system "./configure", *args
    if build.head?
      # XXX Can't build docs using Homebrew-provided software, so skip
      # it when building from Git.
      system "make install"
      system "make -C contrib install"
    else
      system "make install-world"
    end
  end

end


__END__
--- a/contrib/uuid-ossp/uuid-ossp.c     2012-07-30 18:34:53.000000000 -0700
+++ b/contrib/uuid-ossp/uuid-ossp.c     2012-07-30 18:35:03.000000000 -0700
@@ -9,6 +9,8 @@
  *-------------------------------------------------------------------------
  */

+#define _XOPEN_SOURCE
+
 #include "postgres.h"
 #include "fmgr.h"
 #include "utils/builtins.h"
