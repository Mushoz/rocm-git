# Maintainer: Torsten Keßler <tpkessler at archlinux dot org>

pkgname=rocwmma
pkgver=6.4.3
pkgrel=2
pkgdesc='Library for accelerating mixed precision matrix multiplication'
arch=('x86_64')
url='https://rocm.docs.amd.com/projects/rocWMMA/en/latest/'
license=('MIT')
depends=('rocm-core' 'hip-runtime-amd' 'rocblas' 'openmp')
makedepends=('rocm-cmake' 'doxygen' 'rocm-toolchain')
_git='https://github.com/ROCmSoftwarePlatform/rocWMMA'
source=("$pkgname-$pkgver.tar.gz::$_git/archive/rocm-$pkgver.tar.gz")
sha256sums=('34797c458603688748a046b611e14693221843de96740ed3ba5c606d41ab0cdf')
_dirname="$(basename "$_git")-$(basename "${source[0]}" .tar.gz)"
options=(!lto)

build() {
    local cmake_args=(
        -Wno-dev
        -B build
        -S "$_dirname"
        -D CMAKE_POLICY_VERSION_MINIMUM=3.5
        -D CMAKE_BUILD_TYPE=Release
        -D CMAKE_CXX_COMPILER=amdclang++
        -D CMAKE_INSTALL_PREFIX=/opt/rocm
        -D ROCWMMA_BUILD_TESTS=OFF
        -D ROCWMMA_BUILD_SAMPLES=OFF
        -D ROCM_SYMLINK_LIBS=OFF
        -D HIP_PLATFORM=amd
        -D GPU_TARGETS=$(rocm-supported-gfx)
    )
    cmake "${cmake_args[@]}"
    cmake --build build
}

package() {
    DESTDIR="$pkgdir" cmake --install build

    install -Dm644 "$_dirname/LICENSE.md" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
