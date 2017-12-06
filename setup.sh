#!/bin/bash -x
# https://github.com/google/syzkaller/blob/master/docs/linux/setup_ubuntu-host_qemu-vm_x86-64-kernel.md
# quick and dirty setup script
# Ubuntu 16.04 LTS
# vim, git, subversion installed
# Need to do Image (need to run script for image pack), QEMU, manager config file steps to finish setup

sudo apt-get -y install flex bison libc6-dev libc6-dev-i386 linux-libc-dev linux-libc-dev:i386 libgmp3-dev libmpfr-dev libmpc-dev build-essential bc libelf-dev libssl-dev debootstrap kvm qemu-kvm

# GCC compilation
mkdir gcc
GCC="$HOME/gcc"
mkdir kernel
KERNEL="$HOME/kernel"

svn checkout svn://gcc.gnu.org/svn/gcc/trunk $GCC
cd $GCC
svn ls -v ^/tags | grep gcc_7_1_0_release
svn up -r 247494

# REQ: dump in home dir
patch -p1 < ../fix.patch

mkdir build
mkdir install
cd build/
../configure --enable-languages=c,c++ --disable-bootstrap --enable-checking=no --with-gnu-as --with-gnu-ld --with-ld=/usr/bin/ld.bfd --disable-multilib --prefix=$GCC/install/
make -j64
make install

# Pull linux source
git clone https://github.com/torvalds/linux.git $KERNEL
cd $KERNEL
make defconfig
make kvmconfig

# Modify .config file with syzkaller requirements
declare -a arr=("CONFIG_KCOV" "CONFIG_DEBUG_INFO" "CONFIG_KASAN" "CONFIG_KASAN_INLINE" "CONFIG_KCOV_INSTRUMENT_ALL" "CONFIG_DEBUG_FS" "CONFIG_NAMESPACES" "CONFIG_USER_NS" "CONFIG_UTS_NS" "CONFIG_IPC_NS" "CONFIG_PID_NS" "CONFIG_NET_NS" "CONFIG_LOCKDEP" "CONFIG_PROVE_LOCKING" "CONFIG_DEBUG_ATOMIC_SLEEP" "CONFIG_PROVE_RCU" "CONFIG_DEBUG_VM" "CONFIG_REFCOUNT_FULL" "CONFIG_FORTIFY_SOURCE" "CONFIG_HARDENED_USERCOPY" "CONFIG_LOCKUP_DETECTOR" "CONFIG_SOFTLOCKUP_DETECTOR" "CONFIG_HARDLOCKUP_DETECTOR" "CONFIG_DETECT_HUNG_TASK" "CONFIG_WQ_WATCHDOG")
for i in "${arr[@]}"
do
   grep -q "^$i=y" .config || grep -q "^# $i is not set" .config && sed -i "s/^# $i is not set/$i=y/g" .config || echo "$i=y" >> .config
done
sed -i "s/^\(CONFIG_RCU_CPU_STALL_TIMEOUT=\).*/\160/" .config

yes "" | make oldconfig
make CC="$GCC/install/bin/gcc" -j64

# pull go
cd
wget https://storage.googleapis.com/golang/go1.8.1.linux-amd64.tar.gz
tar -xf go1.8.1.linux-amd64.tar.gz
mv go goroot
export GOROOT=`pwd`/goroot
export PATH=$GOROOT/bin:$PATH
mkdir gopath
export GOPATH=`pwd`/gopath
go get -u -d github.com/google/syzkaller/...
cd gopath/src/github.com/google/syzkaller/
mkdir workdir
make

# check gcc and kernel
ls $GCC/install/bin/
ls $KERNEL/vmlinux
ls $KERNEL/arch/x86/boot/bzImage 