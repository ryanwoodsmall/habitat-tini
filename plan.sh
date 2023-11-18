pkg_name="tini"
pkg_origin="ryanwoodsmall"
pkg_version="0.19.0"
pkg_license=("MIT")
pkg_maintainer="ryanwoodsmall <rwoodsmall@gmail.com>"
pkg_description="A tiny but valid 'init' for containers"
pkg_upstream_url="https://github.com/krallin/tini"
pkg_dirname="${pkg_name}-${pkg_version}"
pkg_filename="v${pkg_version}.tar.gz"
pkg_source="https://github.com/krallin/tini/archive/${pkg_filename}"
pkg_shasum="0fd35a7030052acd9f58948d1d900fe1e432ee37103c5561554408bdac6bbf0d"
pkg_build_deps=("core/gcc" "core/musl" "core/file")
pkg_bin_dirs=("sbin")

DO_CHECK=1

do_build() {
  cd "${SRC_PATH}/src" || exit 1
  echo '#define TINI_VERSION "'${pkg_version}'"' > tiniConfig.h
  echo '#define TINI_GIT ""' >> tiniConfig.h
  $(pkg_path_for core/musl)/bin/musl-gcc -g0 -Os -Wl,-s -Wl,-static tini.c -o tini -static -s
}

do_install() {
  cd "${SRC_PATH}/src" || exit 1
  mkdir -p "${pkg_prefix}/sbin"
  install -m 0755 tini "${pkg_prefix}/sbin/tini"
}

do_check() {
  cd "${SRC_PATH}/src" || exit 1
  build_line "checking that tini is static"
  file ./tini | grep 'ELF.*static'
  build_line "checking tini version"
  ./tini --version | grep "${pkg_version}"
}
