# Midyanet BOINC kaynağı

Bu repo, [Midyanet](https://midyanet.com) gönüllü hesaplama
uygulamalarıyla dağıtılan BOINC istemci ikililerinin derlendiği
**BOINC kaynak kodudur**. GNU Lesser General Public License kapsamındaki
yükümlülüklerimiz gereği, dağıttığımız ikililere karşılık gelen kaynağı
herkese açık olarak burada sunuyoruz.

- Upstream: [https://github.com/BOINC/boinc](https://github.com/BOINC/boinc) — `client_release/8.2/8.2.15`
- Upstream'e göre değişiklikler: [MIDYANET-DEGISIKLIKLER.md](MIDYANET-DEGISIKLIKLER.md)
- Lisans: **LGPL-3.0-or-later** — [COPYING.LESSER](COPYING.LESSER) ve
  [COPYING](COPYING). Telif: The Regents of the University of California
  ve BOINC katkıcıları; üçüncü taraf bileşenler için [COPYRIGHT](COPYRIGHT).

Bu repo yalnızca kaynak sunumu içindir; geliştirme Midyanet'in kendi
repolarında yürütülür. BOINC'e yönelik hata bildirimleri ve katkılar için
lütfen upstream projeye başvurun.

## Sürüm eşlemesi

| Midyanet sürümü | BOINC sürümü | Upstream etiketi | Midyanet kaynak commit'i |
|---|---|---|---|
| pilot (macOS) | 8.2.15 | `client_release/8.2/8.2.15` | `335e85ddd2c30ecd470cd063cd0141e1333d9b8c` |

Her Midyanet sürümü bu repoda `midyanet/<sürüm>` biçiminde bir git
etiketiyle işaretlenir; belirli bir sürümün kaynağı o etikettedir.
Uygulamadaki BOINC istemci sürümü `boinc --version` ile görülebilir.

## Derleme

Genel BOINC derleme talimatı upstream belgelerindedir
([wiki](https://github.com/BOINC/boinc/wiki), `INSTALL`, `README.BOINC.md`).

Midyanet ikilileri aşağıdaki betiklerle derlenir; her betiğin başında
gereksinimler, kullanım ve çıktı yolu açıklanmıştır:

- [`midyanet/macos/build-client-universal.sh`](midyanet/macos/build-client-universal.sh)

macOS (Xcode komut satırı araçları gerekir):

```bash
./midyanet/macos/build-client-universal.sh
```

Betikler BOINC'in kendi bağımlılık betikleriyle (`mac_build/`,
`3rdParty/`) OpenSSL, c-ares ve libcurl'ü kaynaktan derler ve istemciyi
bunlara statik bağlar. Uygulamadaki istemciyi kendi derlediğinizle
değiştirmek için uygulama paketindeki `Contents/Helpers/midyanet-client`
dosyasını değiştirin; macOS kod imzası nedeniyle uygulama paketini yerel
olarak yeniden imzalamanız gerekebilir.
