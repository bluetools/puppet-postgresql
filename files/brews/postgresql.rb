require 'formula'

class Postgresql < Formula
  homepage 'http://www.postgresql.org/'
  url 'http://ftp.postgresql.org/pub/source/v9.3.0/postgresql-9.3.0.tar.bz2'
  sha256 '784e5db7d8fd69b08ddb125c4452211e04b089516359a5cf72d292cade7c728e'
  version '9.3.0-boxen1'

  #keg_only 'The different provided versions of PostgreSQL conflict with each other.'

  #env :std

  depends_on 'gettext'
  depends_on 'ossp-uuid'
  depends_on 'readline'

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
            "--with-python",
            "--with-tcl"]

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
