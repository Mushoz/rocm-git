# Maintainer: Torsten Keßler <tpkessler at archlinux dot org>

pkgname=rocsolver
pkgver=6.4.3
pkgrel=1
pkgdesc='Subset of LAPACK functionality on the ROCm platform'
arch=('x86_64')
url='https://rocm.docs.amd.com/projects/rocSOLVER/en/latest/index.html'
license=('BSD-2-Clause')
depends=('rocm-core' 'glibc' 'gcc-libs' 'hip-runtime-amd' 'rocblas' 'rocsparse')
makedepends=('rocm-cmake' 'python-pyaml' 'fmt')
_git='https://github.com/ROCmSoftwarePlatform/rocSOLVER'
source=("$pkgname-$pkgver.tar.gz::$_git/archive/rocm-$pkgver.tar.gz")
sha256sums=('6c2c6019eaf49abb30fc54f09b3d755ebcfbbd30d9b71052aa13bb0cbc26d2bb')
options=(!lto)
_dirname="$(basename "$_git")-$(basename "${source[0]}" .tar.gz)"

build() {
    # Compile source code for supported GPU archs in parallel
    export HIPCC_COMPILE_FLAGS_APPEND="-parallel-jobs=$(nproc)"
    export HIPCC_LINK_FLAGS_APPEND="-parallel-jobs=$(nproc)"
    # -fcf-protection is not supported by HIP, see
    # https://rocm.docs.amd.com/projects/llvm-project/en/latest/reference/rocmcc.html#support-status-of-other-clang-options
    local cmake_args=(
        -Wno-dev
        -S "$_dirname"
        -B build
        -D CMAKE_BUILD_TYPE=Release
        -D CMAKE_CXX_COMPILER=/opt/rocm/bin/hipcc
        -D CMAKE_CXX_FLAGS="${CXXFLAGS} -fcf-protection=none"
        -D CMAKE_INSTALL_PREFIX=/opt/rocm
        -D ROCSOLVER_EMBED_FMT=ON
    )
    cmake "${cmake_args[@]}"
    cmake --build build
}

package() {
    DESTDIR="$pkgdir" cmake --install build

    install -Dm644 "$_dirname/LICENSE.md" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
