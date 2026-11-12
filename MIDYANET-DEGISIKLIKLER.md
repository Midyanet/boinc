# Midyanet değişiklikleri

Bu dosya, bu kaynak ağacının upstream BOINC'e göre değiştirilmiş hâlini
bildirir (GNU LGPL v3, bölüm 4 ve GNU GPL v3, bölüm 5(a)).

| | |
|---|---|
| Upstream | [BOINC](https://github.com/BOINC/boinc) `client_release/8.2/8.2.15` (`3422898505b74c637a4b530a94b63be90bdf025b`) |
| BOINC sürümü | 8.2.15 |
| Midyanet kaynak commit'i | `335e85ddd2c30ecd470cd063cd0141e1333d9b8c` (2026-11-07) |
| Değiştiren | Midyanet |
| Lisans | LGPL-3.0-or-later (`COPYING.LESSER`, `COPYING`) |

## Upstream dosyalarında içerik değişikliği

Yok. BOINC C/C++ kaynağı ve upstream derleme dosyaları upstream ile
birebir aynıdır.

## Midyanet'in eklediği dosyalar

Dağıtılan ikilinin nasıl derlendiğini tanımlayan betik ve ayarlar.
Ayrıntı her dosyanın başındaki açıklamadadır.

- `midyanet/macos/build-client-universal.sh`
- `midyanet/macos/client-universal.xcconfig`

## İlgili Midyanet commit'leri

- `335e85ddd2` 2026-11-07 — build(macos): gömülü headless client için universal derleme betiği

## Pakete alınmayanlar

Midyanet kaynak reposundaki şu içerik BOINC türevi olmadığı ya da
ikiliye girmediği için bu pakette yer almaz: Midyanet Go ajanı (ayrı
bir program; BOINC kodu içermez), CI tanımları, iç belgeler ve geliştirme
araçlarının yapılandırması. Upstream'in CI tanımları (`.github/`)
derlenen ikiliyi etkilemez; upstream reposunda bulunabilir.

Upstream'in özgün README'si `README.BOINC.md` olarak korunmuştur.
