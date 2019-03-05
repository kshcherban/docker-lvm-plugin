# Installation Directories
SYSCONFDIR ?=$(DESTDIR)/etc/docker
SYSTEMDIR ?=$(DESTDIR)/usr/lib/systemd/system
GOLANG ?= /usr/bin/go
BINARY ?= docker-lvm-plugin
MANINSTALLDIR?= ${DESTDIR}/usr/share/man
BINDIR ?=$(DESTDIR)/usr/libexec/docker

export GO15VENDOREXPERIMENT=1

all: man lvm-plugin-build

.PHONY: man
man:
	if (go-md2man --version >/dev/null 2>&1); then go-md2man -in man/docker-lvm-plugin.8.md -out docker-lvm-plugin.8; fi

.PHONY: lvm-plugin-build
lvm-plugin-build: main.go driver.go
	$(GOLANG) get -v
	$(GOLANG) build -o $(BINARY) .

.PHONY: install
install:
	if [ ! -f "$(SYSCONFDIR)/docker-lvm-plugin" ]; then					\
	   install -D -m 644 etc/docker/docker-lvm-plugin $(SYSCONFDIR)/docker-lvm-plugin;	\
	fi
	install -D -m 644 systemd/docker-lvm-plugin.service $(SYSTEMDIR)/docker-lvm-plugin.service
	install -D -m 644 systemd/docker-lvm-plugin.socket $(SYSTEMDIR)/docker-lvm-plugin.socket
	install -D -m 755 $(BINARY) $(BINDIR)/$(BINARY)
	install -D -m 644 docker-lvm-plugin.8 ${MANINSTALLDIR}/man8/docker-lvm-plugin.8

.PHONY: clean
clean:
	rm -f $(BINARY)
	rm -f docker-lvm-plugin.8


