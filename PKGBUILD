# Maintainer: Torsten Keßler <tpkessler at archlinux dot org>
# Contributor: Markus Näther <naether.markus@gmail.com>
pkgname=hipblas
pkgver=6.4.3
pkgrel=1
pkgdesc='ROCm BLAS marshalling library'
arch=('x86_64')
url='https://rocm.docs.amd.com/projects/hipBLAS/en/latest/index.html'
license=('MIT')
depends=('rocm-core' 'glibc' 'gcc-libs' 'hip-runtime-amd' 'hipblas-common' 'rocblas' 'rocsolver')
makedepends=('rocm-cmake' 'git' 'cmake' 'gcc-fortran')
_git='https://github.com/ROCm/hipBLAS'
source=("$pkgname-$pkgver.tar.gz::$_git/archive/rocm-$pkgver.tar.gz")
sha256sums=('75121df09f9b0b3116c19258c9526e0cff3d8845361031305ba0369f140fd8b8')
_dirname="$(basename "$_git")-$(basename "${source[0]}" ".tar.gz")"

build() {
  # -fcf-protection is not supported by HIP, see
  # https://rocm.docs.amd.com/projects/llvm-project/en/latest/reference/rocmcc.html#support-status-of-other-clang-options
  local cmake_args=(
    -Wno-dev
    -S "$_dirname"
    -B build
    -D CMAKE_BUILD_TYPE=None
    -D CMAKE_CXX_COMPILER=/opt/rocm/bin/hipcc
    -D CMAKE_CXX_FLAGS="${CXXFLAGS} -fcf-protection=none"
  )
  cmake "${cmake_args[@]}"
  cmake --build build
}

package() {
  DESTDIR="$pkgdir" cmake --install build

  install -Dm644 "$_dirname/LICENSE.md" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
