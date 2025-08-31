# Maintainer: Torsten Keßler <tpkessler at archlinux dot org>
pkgname=python-tensile
pkgver=6.4.3
pkgrel=1
pkgdesc="benchmark-driven backend libraries for general matrix-matrix multiplications"
arch=('any')
url='https://rocm.docs.amd.com/projects/Tensile/en/latest/'
license=('MIT')
depends=('python' 'python-msgpack' 'python-pyaml' 'python-joblib')
makedepends=('cmake' 'python-build' 'python-installer' 'python-wheel' 'python-setuptools')
_git='https://github.com/ROCm/Tensile'
source=("$pkgname-$pkgver.tar.gz::$_git/archive/refs/tags/rocm-$pkgver.tar.gz")
sha256sums=('0190bfc7050c6ea73fb20ce4d35a056644e129f792f3b016b079ee6cc237a598')

prepare() {
	cd "Tensile-rocm-$pkgver"
	# https://src.fedoraproject.org/rpms/python-tensile/blob/rawhide/f/python-tensile.spec#_85
	sed -i -e 's@${Tensile_PREFIX}/bin/TensileGetPath@TensileGetPath@g' Tensile/cmake/TensileConfig.cmake
	sed -i -e 's@opt/rocm@usr@g' Tensile/Common.py
	sed -i -e 's@opt/rocm@usr@g' Tensile/Tests/yaml_only/test_config.py
	sed -i -e 's@globalParameters["IgnoreAsmCapCache"] = False@globalParameters["IgnoreAsmCapCache"] = True@' Tensile/Common.py
	sed -i -e 's@arguments["IgnoreAsmCapCache"] = args.IgnoreAsmCapCache@arguments["IgnoreAsmCapCache"] = True@' Tensile/TensileCreateLibrary.py
	sed -i -e 's@if not ignoreCacheCheck and derivedAsmCaps@if False and derivedAsmCaps@' Tensile/Common.py
}

build() {
	cd "Tensile-rocm-$pkgver"
	python -m build --wheel --no-isolation
}

package() {
	cd "Tensile-rocm-$pkgver"
	python -m installer --destdir="$pkgdir" dist/*.whl
	# cmake files are installed to the wrong location, /usr/cmake.
	# Move them to the right directory.
	mkdir -p "$pkgdir"/usr/lib/cmake/Tensile
	mv "$pkgdir"/usr/cmake/* "$pkgdir"/usr/lib/cmake/Tensile
	rm -rf "$pkgdir"/usr/cmake
	install -vDm644 LICENSE.md "$pkgdir"/usr/share/licenses/"$pkgname"/LICENSE
}
