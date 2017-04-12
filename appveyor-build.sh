set -e

curl -L -O https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz
tar -xf gmp-6.1.2.tar.xz
mkdir gmp-dist

cd gmp-6.1.2
./configure --prefix=$PWD/../gmp-dist
make
make install

cd ..
curl -L -o yices.tar.gz http://yices.csl.sri.com/cgi-bin/yices2-newnewdownload.cgi?file=yices-2.5.2-src.tar.gz&accept=I+Agree
tar -xzf yices.tar.gz
rm yices.tar.gz
mv yices-* yices
mkdir yices-dist

cd yices
./configure --prefix=$PWD/../yices-dist --build=i686-pc-mingw32 CC=i686-w64-mingw32-gcc LD=i686-w64-mingw32-ld STRIP=i686-w64-mingw32-strip RANLIB=i686-w64-mingw32-ranlib --with-static-gmp=$PWD/../gmp-dist/lib/libgmp.a --with-static-gmp-include-dir=$PWD/../gmp-dist/include/ CPPFLAGS=-I/usr/i686-w64-mingw32/sys-root/mingw/include LDFLAGS=-L/usr/i686-w64-mingw32/sys-root/mingw/lib/
make static-lib OPTION=mingw32
make install OPTION=mingw32
cd ..

zip yices.zip yices-dist