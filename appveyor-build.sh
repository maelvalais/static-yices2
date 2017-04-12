set -e

curl -L -O https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2
curl -L -O https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2.sig
#gpg --keyserver wwwkeys.pgp.net --recv-keys 28C67298
#gpg --verify gmp-6.1.2.tar.bz2.sig gmp-6.1.2.tar.bz2

tar -jxvf gmp-6.1.2.tar.bz2
mkdir gmp-static-dist gmp-shared-dist

cd gmp-6.1.2
./configure --prefix=$PWD/../gmp-static-dist --disable-shared --enable-static CC=i686-w64-mingw32-gcc --host=i686-w64-mingw32 --build=i686-pc-cygwin ABI=32
make
make install
./configure --prefix=$PWD/../gmp-shared-dist --enable-shared --disable-static CC=i686-w64-mingw32-gcc --host=i686-w64-mingw32 --build=i686-pc-cygwin ABI=32
make
make install
cd ..


curl -L -o yices.tar.gz http://yices.csl.sri.com/cgi-bin/yices2-newnewdownload.cgi?file=yices-2.5.2-src.tar.gz&accept=I+Agree
tar -xzf yices.tar.gz
rm yices.tar.gz
mv yices-* yices
mkdir yices-dist

cd yices
./configure --prefix=$PWD/../yices-dist --build=i686-pc-mingw32 CC=i686-w64-mingw32-gcc \
LD=i686-w64-mingw32-ld STRIP=i686-w64-mingw32-strip RANLIB=i686-w64-mingw32-ranlib \
--with-static-gmp=$PWD/../gmp-static-dist/lib/libgmp.a \
--with-static-gmp-include-dir=$PWD/../gmp-static-dist/include/ \
CPPFLAGS=-I$PWD/../gmp-shared-dist/include LDFLAGS=-L$PWD/../gmp-shared-dist/lib
make static-lib OPTION=mingw32
make install OPTION=mingw32
cd ..

zip yices.zip yices-dist