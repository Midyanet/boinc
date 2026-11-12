#!/bin/bash
# Midyanet — macOS için gömülü, headless BOINC client derlemesi (universal).
#
# Manager uygulaması bu binary'yi Midyanet.app/Contents/Helpers/midyanet-client
# olarak paketler. Bkz. midyanet-manager docs/adr/0001-gomulu-headless-client.md
#
# Yalnız client için gereken bağımlılıkları (openssl, c-ares, curl) derler;
# wxWidgets/freetype/ftgl (BOINC Manager ve ekran koruyucu) derlenmez.
#
# Kullanım (repo kökünden):
#   ./midyanet/macos/build-client-universal.sh [--clean]
# Çıktı:
#   build/midyanet-macos/midyanet-client   (arm64 + x86_64)
# Bağımlılık cache: $MIDYANET_DEPS_DIR (varsayılan ~/Library/Caches/midyanet/boinc-deps)

set -euo pipefail

ROOTDIR="$(cd "$(dirname "$0")/../.." && pwd)"
# openssl Configure boşluk içeren yolları desteklemez; bağımlılıklar boşluksuz
# bir cache dizininde derlenir.
DEPS_DIR="${MIDYANET_DEPS_DIR:-${HOME}/Library/Caches/midyanet/boinc-deps}"
case "${DEPS_DIR}" in *" "*) echo "HATA: MIDYANET_DEPS_DIR boşluk içeremez"; exit 1;; esac
PREFIX="${DEPS_DIR}/prefix"
OUTDIR="${ROOTDIR}/build/midyanet-macos"
ARCHS="arm64 x86_64"

doclean=""
if [ "${1:-}" = "--clean" ]; then doclean="-clean"; fi

cd "${ROOTDIR}"
mkdir -p "${DEPS_DIR}/src" "${PREFIX}" "${OUTDIR}"

# BOINC'in bağımlılık betikleri `source` ile çalışır ve set -e ile uyumlu değildir.
set +eu
source "${ROOTDIR}/mac_build/dependencyNames.sh"

# BOINC betikleri IFS'yi değiştirebildiği için mimariler tek tek doğrulanır.
is_universal() {
    local a
    for a in arm64 x86_64; do
        lipo "$1" -verify_arch "$a" 2>/dev/null || return 1
    done
}

build_dep() {
    local dirname="$1" filename="$2" url="$3" script="$4" product="$5"
    local flag="${PREFIX}/${dirname}_done"
    if [ -z "${doclean}" ] && [ -e "${flag}" ] \
        && is_universal "${PREFIX}/lib/${product}"; then
        echo "== ${dirname} hazır"
        return 0
    fi
    echo "== ${dirname} derleniyor"
    cd "${DEPS_DIR}/src" || return 1
    [ -d "${dirname}" ] || { [ -e "${filename}" ] || wget -q "${url}"; tar -xf "${filename}"; }
    cd "${dirname}" || return 1
    source "${script}" --prefix "${PREFIX}" -clean -q || return 1
    cd "${ROOTDIR}" || return 1
    touch "${flag}"
}

build_dep "${opensslDirName}" "${opensslFileName}" "${opensslURL}" "${ROOTDIR}/mac_build/buildopenssl.sh" "libssl.a" || exit 1
build_dep "${caresDirName}"   "${caresFileName}"   "${caresURL}"   "${ROOTDIR}/mac_build/buildc-ares.sh"  "libcares.a" || exit 1
build_dep "${curlDirName}"    "${curlFileName}"    "${curlURL}"    "${ROOTDIR}/mac_build/buildcurl.sh"    "libcurl.a" || exit 1

for lib in libssl.a libcrypto.a libcares.a libcurl.a; do
    is_universal "${PREFIX}/lib/${lib}" || { echo "HATA: ${lib} universal değil"; exit 1; }
done

echo "== BOINC_Client derleniyor (${ARCHS})"
cd "${ROOTDIR}/mac_build" || exit 1
# BuildMacBOINC.sh, Update_Info_Plists.sh içinden -setting'leri geçirmeden ek
# xcodebuild çağrıları yapıyor; ortak ayarlar bu yüzden xcconfig ile verilir.
# -setting değerleri BuildMacBOINC.sh tarafından tırnaklanır; burada ek tırnak
# KONMAZ (yoksa eval içinde ../lib/** glob olarak açılır).
export XCODE_XCCONFIG_FILE="${ROOTDIR}/midyanet/macos/client-universal.xcconfig"
source BuildMacBOINC.sh ${doclean:+} -client \
    -setting HEADER_SEARCH_PATHS "../clientgui ../lib/** ../api/ ${PREFIX}/include \\\${HEADER_SEARCH_PATHS}" \
    -setting USER_HEADER_SEARCH_PATHS "" \
    -setting LIBRARY_SEARCH_PATHS "${PREFIX}/lib ../lib \\\${LIBRARY_SEARCH_PATHS}" \
    || { echo "HATA: BOINC_Client derlenemedi"; exit 1; }

cp "${ROOTDIR}/mac_build/build/Deployment/boinc" "${OUTDIR}/midyanet-client"
cd "${ROOTDIR}"
git rev-parse HEAD > "${OUTDIR}/midyanet-client.commit"

echo "== Doğrulama"
lipo -info "${OUTDIR}/midyanet-client"
is_universal "${OUTDIR}/midyanet-client" || { echo "HATA: client universal değil"; exit 1; }
otool -L "${OUTDIR}/midyanet-client"
echo "Tamam: ${OUTDIR}/midyanet-client ($(cat "${OUTDIR}/midyanet-client.commit"))"
