include /usr/share/dpkg/pkg-info.mk

PACKAGE := rknpu
BUILDDIR ?= $(PACKAGE)-$(DEB_VERSION_UPSTREAM)
DEB_HOST_ARCH ?= $(shell dpkg-architecture -qDEB_HOST_ARCH)
DEB := rknpu-dkms_$(DEB_VERSION_UPSTREAM_REVISION)_$(DEB_HOST_ARCH).deb
UPSTREAM_COMMIT := $(shell git -C rk3588-rknn-core rev-parse HEAD 2>/dev/null)

all: deb

$(BUILDDIR): rk3588-rknn-core debian
	test -n "$(UPSTREAM_COMMIT)"
	rm -rf $@ $@.tmp
	mkdir $@.tmp
	git -C rk3588-rknn-core archive $(UPSTREAM_COMMIT) | tar -x -C $@.tmp
	cp -a debian $@.tmp/
	printf '%s\n' \
		'Source: https://github.com/lurenJBD/rk3588-rknn-core.git' \
		'Commit: $(UPSTREAM_COMMIT)' \
		> $@.tmp/debian/SOURCE
	mv $@.tmp $@

.PHONY: deb
deb: $(DEB)
	DEB_VENDOR=debian lintian --display-info --display-experimental $(DEB)
$(DEB): $(BUILDDIR)
	cd $(BUILDDIR); DEB_VENDOR=debian dpkg-buildpackage -b -us -uc

.PHONY: lint
lint: $(DEB)
	DEB_VENDOR=debian lintian --display-info --display-experimental $(DEB)

.PHONY: clean
clean:
	rm -rf $(BUILDDIR) $(BUILDDIR).tmp
	rm -f rknpu-dkms_*.deb rknpu_*.buildinfo rknpu_*.changes
