AS=ca65
CC=cl65
LD=ld65
CFLAGS=-ttelestrat
LDFILES=
ROM=monitor

all : build
.PHONY : all

ifdef TRAVIS_BRANCH
ifeq ($(TRAVIS_BRANCH), master)
RELEASE:=$(shell cat VERSION)
else
RELEASE:=alpha
endif
endif

HOMEDIR=/home/travis/bin/
HOMEDIR_ORIX=/home/travis/build/orix-software/$(ROM)/
ORIX_VERSION=1.0

SOURCE=src/$(ROM).asm

TELESTRAT_TARGET_RELEASE=release/telestrat
MYDATE = $(shell date +"%Y-%m-%d %H:%m")
 
build: $(SOURCE)
	@date +'.define __DATE__ "%F %R"' > src/build.inc
	$(AS) $(CFLAGS) $(SOURCE) -o $(ROM).ld65
	$(LD) -tnone $(ROM).ld65 -o $(ROM).rom

test:
	#cp src/include/orix.h build/usr/include/orix/
	mkdir -p build/usr/share/man/
	mkdir -p build/usr/share/$(ROM)/
	cp $(ROM).rom build/usr/share/$(ROM)/
	#sh tools/builddocs.sh
	export ORIX_PATH=`pwd`
	cd build && tar -c * > ../$(ROM).tar &&	cd ..
	filepack  $(ROM).tar $(ROM).pkg
	gzip $(ROM).tar
	mv $(ROM).tar.gz $(ROM).tgz
	php buildTestAndRelease/publish/publish2repo.php $(ROM).tgz ${hash} 6502 tgz $(RELEASE)

  
  


  

