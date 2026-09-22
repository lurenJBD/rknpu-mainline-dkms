# RKNPU DKMS Debian Package

This repository builds the mainline Rockchip RK3588 RKNPU driver as a Debian DKMS package (`rknpu-dkms`).

The kernel driver source is tracked as a Git submodule pointing to [`rk3588-rknn-core`](https://github.com/lurenJBD/rk3588-rknn-core.git).

---

## Prerequisites (Debian / Ubuntu)

Ensure the packaging tools and DKMS infrastructure are installed:

```bash
sudo apt update
sudo apt install -y \
    build-essential \
    debhelper \
    dh-dkms \
    dpkg-dev \
    lintian \
    dkms \
    linux-headers-$(uname -r)
```

---

## Building the DEB Package

Clone the repository with submodules:

```bash
git clone --recurse-submodules https://github.com/lurenJBD/rknpu-mainline-dkms.git
cd rknpu-mainline-dkms
make deb
```

Upon successful build, the Debian package `rknpu-dkms_0.9.8-1_arm64.deb` will be generated in the repository root.

---

## Installation

Install the generated `.deb` package using `dpkg`:

```bash
sudo dpkg -i rknpu-dkms_0.9.8-1_arm64.deb
```

DKMS will automatically trigger a build of the `rknpu` kernel module for your currently installed kernel and install it into `/lib/modules/$(uname -r)/updates/dkms/rknpu.ko`.

---

## Verification

Check the DKMS registration status:

```bash
dkms status
```

Expected output:
```text
rknpu/0.9.8, <kernel-version>, aarch64: installed
```

Load the module:

```bash
sudo modprobe rknpu
dmesg | grep -i rknpu
```

---

## License

This package and the underlying driver are licensed under the **GPL-2.0 License** - see the [LICENSE](LICENSE) file for details.
