#!/bin/bash -x
# https://www.evilsocket.net/2015/04/30/fuzzing-with-afl-fuzz-a-practical-example-afl-vs-binutils/
# quick and dirty afl setup script
# Ubuntu 16.04 LTS

sudo apt-get install texinfo bison flex
wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
tar -xvzf afl-latest.tgz
cd afl*
make
sudo make install

cd
git clone git://sourceware.org/git/binutils-gdb.git
cd binutils*
CC=afl-gcc ./configure
make

# this will fail, run as root
# sudo -i
echo core > /proc/sys/kernel/core_pattern

mkdir afl_in afl_out
cp /bin/ps afl_in/
#afl-fuzz -i afl_in -o afl_out ./binutils/readelf -a @@