<p align="center">
  <img src="assets/images/logo.png" alt="PT INTI Logo" width="140" />
</p>

<h1 align="center">Smart Bus Display</h1>
<p align="center">
  <b>Running Text Controller</b> - Aplikasi Flutter untuk mengendalikan panel LED (P5) pada bus, via Bluetooth Low Energy (BLE) dan sinkronisasi ke server.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/State%20Management-Provider-blueviolet" />
  <img src="https://img.shields.io/badge/Auth-Device%20Pairing-success" />
</p>

---

## Daftar Isi

- [Tentang Aplikasi](#tentang-aplikasi)
- [Fitur Utama](#fitur-utama)
- [Struktur Folder](#struktur-folder)
- [Autentikasi & Keamanan](#autentikasi--keamanan)
- [Persiapan Lingkungan](#persiapan-lingkungan)
- [Instalasi](#instalasi)
- [Konfigurasi Environment](#konfigurasi-environment)
- [Menjalankan Aplikasi](#menjalankan-aplikasi)
- [Panduan Penggunaan Aplikasi](#panduan-penggunaan-aplikasi)
  - [1. Pairing Device (Pertama Kali)](#1-pairing-device-pertama-kali)
  - [2. Menghubungkan ke Panel via Bluetooth](#2-menghubungkan-ke-panel-via-bluetooth)
  - [3. Mengatur Rute](#3-mengatur-rute)
  - [4. Mengatur Tampilan Animasi](#4-mengatur-tampilan-animasi)
  - [5. Preset](#5-preset)
  - [6. Mengirim ke Display](#6-mengirim-ke-display)
- [Referensi Provider (State Management)](#referensi-provider-state-management)
- [Referensi Service & Repository](#referensi-service--repository)
- [Model Data](#model-data)
- [Penanganan Error & Feedback](#penanganan-error--feedback)
- [Panduan Maintenance](#panduan-maintenance)
  - [Menambah Fitur Baru](#menambah-fitur-baru)
  - [Menambah Provider Baru](#menambah-provider-baru)
  - [Konvensi Kode](#konvensi-kode)
- [Troubleshooting](#troubleshooting)
- [Dependency Utama](#dependency-utama)
- [Lisensi Internal](#lisensi-internal)

---

## Tentang Aplikasi

**Smart Bus Display** adalah aplikasi kontrol untuk panel LED _running text_ (P5 Panel) yang dipasang di bus. Aplikasi ini memungkinkan operator untuk:

- Memilih rute bus dan arah perjalanan (Pergi/Pulang) yang akan ditampilkan di panel.
- Mengatur mode animasi teks (scroll, blink, static, dsb), kecepatan, kecerahan, dan ukuran font.
- Mengirim pengaturan tersebut langsung ke panel LED via **Bluetooth Low Energy (BLE)**.
- Menyimpan dan memuat kembali kombinasi pengaturan sebagai **preset** (misal: "Preset Pagi", "Preset Rute Jakarta").
- Menyinkronkan histori pengaturan ke **server backend** agar dapat dipantau/di-manage terpusat.

Aplikasi didesain untuk digunakan dalam **mode landscape** di perangkat yang dipasang di dashboard bus.

---

## Fitur Utama

| Fitur               | Deskripsi                                               |
| ------------------- | ------------------------------------------------------- |
| Device Pairing      | Autentikasi aman per-perangkat                          |
| Kontrol via BLE     | Kirim pengaturan langsung ke panel P5 tanpa internet    |
| Manajemen Rute      | Tambah, pilih, hapus rute; toggle arah Pergi/Pulang     |
| Mode Animasi        | 7 mode: Running, Static, Blink, Scroll (4 arah)         |
| Pengaturan Tampilan | Kecepatan scroll, kecerahan, ukuran font (live preview) |
| Preset              | Simpan, muat, dan timpa kombinasi pengaturan            |
| Live Preview        | Simulasi visual panel LED P5 secara real-time di layar  |
| Sinkronisasi Server | Rute & preset tersimpan terpusat di backend             |

---

### Struktur Folder

```
lib/
├── core/
│   ├── models/
│   │   ├── operation_result.dart      # Wrapper hasil operasi (success/failure)
│   │   └── route_model.dart           # Model data rute
│   ├── providers/
│   │   ├── connection_provider.dart   # BLE + status API server
│   │   ├── route_provider.dart        # Daftar rute, rute terpilih, arah
│   │   ├── display_settings_provider.dart  # Animasi, speed, brightness, fontSize
│   │   └── preset_provider.dart       # Simpan/muat/timpa preset
│   ├── repositories/
│   │   ├── route_repository.dart      # Abstraksi akses data rute
│   │   └── preset_repository.dart     # Abstraksi akses data preset
│   ├── services/
│   │   ├── api_service.dart           # HTTP client ke backend
│   │   ├── bluetooth_service.dart     # Komunikasi BLE ke panel P5
│   │   └── device_identity_service.dart  # Secure storage device ID & token
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── display_payload_builder.dart  # Pure function pembangun payload
│   │   └── feedback_extension.dart       # Extension SnackBar (context.showResult)
│   └── widgets/
│       ├── modern_slider.dart
│       └── primary_button.dart
├── features/
│   ├── splash/
│   │   └── splash_screen.dart         # Splash + cek status pairing
│   ├── pairing/
│   │   └── pairing_screen.dart        # Layar input kode pairing
│   ├── main_navigation/
│   │   └── main_navigation.dart       # Bottom nav: Home & Settings
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── app_header.dart
│   │       ├── preview_card.dart      # Simulasi panel LED live
│   │       ├── status_card.dart       # Status koneksi BLE
│   │       ├── route_card.dart        # CRUD rute
│   │       ├── animation_mode_card.dart
│   │       ├── display_setting_card.dart
│   │       └── quick_action_card.dart # Kirim, simpan/muat preset, reset
│   └── settings/
│       └── settings_screen.dart
├── app.dart                            # MaterialApp root
└── main.dart                           # Entry point + MultiProvider setup
```

---

## Autentikasi & Keamanan

Aplikasi ini **tidak lagi menggunakan API key statis** yang di-bundle ke dalam APK/IPA (rawan diekstrak lewat reverse-engineering). Sebagai gantinya, digunakan skema **device pairing**:

1. Admin menjalankan perintah CLI di server backend untuk membuat **kode pairing** sekali pakai (berlaku 15 menit).
2. Kode tersebut dimasukkan manual di layar **Pairing** pada aplikasi (hanya sekali, saat setup awal).
3. Aplikasi menukar kode tersebut dengan **device token** unik, disimpan di `flutter_secure_storage` (Keychain di iOS, Keystore di Android) — tidak pernah tersimpan dalam bentuk plain text di file konfigurasi.
4. Setiap request mutasi (tambah/hapus rute, simpan preset, dst) menyertakan header `x-device-id` dan `x-device-token`, diverifikasi server menggunakan hash + _constant-time comparison_.

**Implikasi untuk maintenance:**

- Kalau perangkat hilang/dicuri, cukup **revoke device tersebut di server** (set `revokedAt`), tidak perlu mengganti kredensial di semua perangkat lain.
- Tidak ada rahasia (secret) apa pun yang di-bundle ke dalam build aplikasi.

---

## Persiapan Lingkungan

| Tool                   | Versi Minimum                                         |
| ---------------------- | ----------------------------------------------------- |
| Flutter SDK            | 3.19+                                                 |
| Dart SDK               | 3.3+                                                  |
| Android Studio / Xcode | Untuk build native                                    |
| Perangkat fisik        | **Wajib** — BLE tidak berfungsi di emulator/simulator |

Pastikan Bluetooth & Location permission diaktifkan di perangkat pengujian (Android memerlukan izin lokasi untuk BLE scan).

---

## Instalasi

```bash
# 1. Clone repository
git clone https://github.com/asepjamaludinn/inti-busdisplay
cd inti-busdisplay

# 2. Install dependencies
flutter pub get

# 3. Salin file environment
cp .env.example .env
```

---

## Konfigurasi Environment

Buat file `.env` di root project (sejajar dengan `pubspec.yaml`):

```env
BACKEND_IP=192.168.1.10
BACKEND_PORT=3000
```

| Variable       | Keterangan                                                                                                          |
| -------------- | ------------------------------------------------------------------------------------------------------------------- |
| `BACKEND_IP`   | Alamat IP server backend (gunakan IP lokal jaringan, bukan `localhost`, jika device fisik dan server berbeda mesin) |
| `BACKEND_PORT` | Port server backend (default `3000`)                                                                                |

Tambahkan `assets/images/logo.png` ke `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/logo.png
  fonts:
    # ... (jika ada font kustom)
```

---

## Menjalankan Aplikasi

```bash
# Jalankan di perangkat fisik yang terhubung
flutter run

# Build APK release
flutter build apk --release

# Build App Bundle (untuk Play Store)
flutter build appbundle --release

# Build iOS (memerlukan macOS + Xcode)
flutter build ios --release
```

Aplikasi dikunci ke **mode landscape** (`DeviceOrientation.landscapeRight/landscapeLeft`) — ini disetel di `main.dart` dan tidak perlu diubah kecuali requirement berubah.

---

## Panduan Penggunaan Aplikasi

### 1. Pairing Device (Pertama Kali)

Saat aplikasi dibuka pertama kali (atau setelah data aplikasi dihapus), pengguna akan diarahkan ke layar **Pairing**:

1. Hubungi admin untuk menjalankan perintah pairing di server:
   ```bash
   npm run pair:generate
   ```
2. Admin akan mendapatkan kode 8 karakter (misal: `A7XK2P9Q`), berlaku 15 menit.
3. Masukkan kode tersebut di layar Pairing aplikasi, lalu tekan **Pasangkan**.
4. Jika berhasil, aplikasi otomatis masuk ke halaman utama (`MainNavigation`) dan device token tersimpan permanen di secure storage.

> Proses ini **hanya dilakukan sekali per perangkat**. Splash screen akan otomatis mengarahkan ke `MainNavigation` pada pembukaan aplikasi berikutnya selama token masih valid.

### 2. Menghubungkan ke Panel via Bluetooth

1. Di halaman **Home**, lihat **Status Card** - jika status "Terputus", tekan ikon Bluetooth.
2. Aplikasi akan memindai perangkat BLE di sekitar (4 detik).
3. Pilih panel P5 dari daftar (nama perangkat sesuai firmware panel), tekan **Hubungkan**.
4. Status akan berubah menjadi "Terhubung" dengan indikator hijau.

### 3. Mengatur Rute

- **Memilih rute:** gunakan dropdown di **Route Card**, pilih dari daftar rute yang tersinkron dari server.
- **Menambah rute baru:** tekan ikon `+`, isi 3 field terpisah (Kode, Kota Asal, Kota Tujuan), tekan **Simpan**. Sistem otomatis menolak kode atau kombinasi rute yang sudah ada (baik searah maupun arah sebaliknya).
- **Menghapus rute:** tekan ikon tempat sampah pada rute yang sedang aktif. Minimal harus tersisa 1 rute.
- **Toggle arah:** gunakan tab "Pergi Ke Tujuan" / "Kembali/Pulang" untuk membalik urutan asal-tujuan yang ditampilkan di panel.

### 4. Mengatur Tampilan Animasi

Pindah ke tab **Settings**:

- **Mode Animasi:** pilih dari 7 mode (Running, Static, Blink, Scroll Left/Right/Up/Down) — preview langsung terlihat di halaman Home.
- **Kecepatan Scroll:** slider 0–100, memengaruhi kecepatan animasi teks berjalan.
- **Kecerahan:** slider 0–100, memengaruhi opacity/brightness warna LED pada preview & panel fisik.
- **Ukuran Font:** slider yang menentukan ukuran teks pada panel.

### 5. Preset

- **Simpan Preset:** dari tab Settings, tekan **Simpan Preset**, beri nama (misal "Pagi - Rute Garut"), tekan Simpan. Kombinasi rute + arah + animasi + speed + brightness + fontSize saat ini akan tersimpan ke server.
- **Muat Preset:** tekan **Muat Preset**, pilih dari daftar preset tersimpan — semua pengaturan (rute, arah, animasi, dst) akan diterapkan otomatis.
- **Timpa Preset:** setelah memuat preset dan mengubah sebagian pengaturan, tombol **Timpa Preset "..."** akan muncul untuk menyimpan perubahan ke preset yang sama.
- **Reset ke Default:** mengembalikan semua pengaturan (rute pertama, animasi Scroll Left, speed 50, brightness 80, fontSize 16) dan melepaskan preset yang sedang dimuat.

### 6. Mengirim ke Display

Tekan tombol **Kirim ke Display** (tombol utama berwarna gradient) di tab Settings. Pengaturan saat ini akan:

1. Dikirim ke panel LED via Bluetooth (butuh koneksi BLE aktif).
2. Disinkronkan ke server backend secara paralel (tidak memblokir pengiriman BLE).

Jika BLE belum terhubung, aplikasi akan menampilkan peringatan dan tidak mengirim apa pun.

---

## Referensi Provider (State Management)

| Provider                  | Getter Utama                                                    | Method Aksi Utama                                                                                                  |
| ------------------------- | --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `ConnectionProvider`      | `isBleConnected`, `isApiConnected`, `scanResults`, `isScanning` | `startBleScan()`, `connectToDevice()`, `disconnectBle()`, `sendPayload()`                                          |
| `RouteProvider`           | `routes`, `selectedRoute`, `isPergi`                            | `setRoute()`, `setDirection()`, `addRoute()`, `deleteRoute()`, `applyRouteFromPayload()`, `resetSelection()`       |
| `DisplaySettingsProvider` | `animMode`, `speed`, `brightness`, `fontSize`                   | `setAnimMode()`, `setSpeed()`, `setBrightness()`, `setFontSize()`, `applyFromPayload()`, `resetToDefault()`        |
| `PresetProvider`          | `loadedPresetId`, `loadedPresetName`, `hasLoadedPreset`         | `saveCurrentPreset()`, `overwritePreset()`, `overwriteLoadedPreset()`, `markLoadedPreset()`, `clearLoadedPreset()` |

Semua provider didaftarkan di `main.dart` lewat `MultiProvider`, dapat diakses di widget manapun via:

```dart
final routeProvider = context.watch<RouteProvider>(); // rebuild saat state berubah
final routeProvider = context.read<RouteProvider>();   // baca sekali, untuk aksi (tap handler)
```

---

## Referensi Service & Repository

| Class                   | Tanggung Jawab                                                                                                                                                               |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ApiService`            | Seluruh komunikasi HTTP ke backend. Punya 2 helper internal: `_safeGet<T>()` (GET tanpa auth, fallback aman) dan `_authorizedRequest<T>()` (mutasi dengan device-token auth) |
| `BleService`            | Scan, connect, disconnect, dan tulis data ke karakteristik BLE panel P5                                                                                                      |
| `DeviceIdentityService` | Generate & simpan `deviceId`/`deviceToken` di secure storage                                                                                                                 |
| `RouteRepository`       | Abstraksi CRUD rute — dipanggil `RouteProvider`, meneruskan ke `ApiService`                                                                                                  |
| `PresetRepository`      | Abstraksi CRUD preset — dipanggil `PresetProvider`, meneruskan ke `ApiService`                                                                                               |

---

## Model Data

### `RouteModel`

```dart
RouteModel({
  String? id,          // null jika belum tersimpan di server
  required String code,        // Kode rute, mis. "B1"
  required String origin,      // Kota asal
  required String destination, // Kota tujuan
})
```

- `fullDisplayName` → `"B1 • Bandung - Garut"` (untuk dropdown & konfirmasi)
- `apiRouteName` → `"Bandung - Garut"` (untuk label ringkas)

### `OperationResult<T>`

Wrapper hasil operasi asinkron (pengganti pola try/catch berulang):

```dart
OperationResult.success(data, message);
OperationResult.failure(message);
```

Digunakan oleh seluruh provider agar UI layer bisa menampilkan feedback secara konsisten lewat `context.showResult(result)`.

---

## Penanganan Error & Feedback

Semua feedback ke pengguna (SnackBar) terpusat di `lib/core/utils/feedback_extension.dart`:

```dart
context.showFeedback(message: '...', color: AppColors.success);
context.showResult(result, fallbackSuccessMessage: '...');
```

**Aturan penting untuk maintenance:** provider **tidak pernah** memanggil `ScaffoldMessenger` secara langsung. Jika menambah method baru di provider yang butuh feedback ke user, method tersebut harus mengembalikan `OperationResult`, bukan menampilkan SnackBar sendiri.

---

## Panduan Maintenance

### Menambah Fitur Baru

1. Tentukan domain state-nya - apakah cocok masuk provider yang sudah ada, atau perlu provider baru?
2. Jika perlu data dari server, buat/gunakan repository yang sesuai - jangan panggil `ApiService` langsung dari provider.
3. Tambahkan UI di `features/`, hubungkan lewat `context.watch/read<ProviderX>()`.
4. Jangan panggil `BuildContext` dari dalam provider — kembalikan `OperationResult` dan biarkan widget yang menampilkan feedback.

### Menambah Provider Baru

```dart
// 1. Buat file baru di lib/core/providers/
class ExampleProvider extends ChangeNotifier {
  final ExampleRepository _repository;
  ExampleProvider({ExampleRepository? repository})
      : _repository = repository ?? ExampleRepository();
  // ... state & method
}

// 2. Daftarkan di main.dart
MultiProvider(
  providers: [
    // ...provider lain
    ChangeNotifierProvider(create: (_) => ExampleProvider()),
  ],
  child: const SmartBusDisplayApp(),
)
```

### Konvensi Kode

- **Bahasa UI & pesan error:** Bahasa Indonesia (konsisten dengan seluruh aplikasi).
- **Penamaan file:** `snake_case.dart`.
- **Warna:** selalu gunakan konstanta dari `AppColors`, jangan hardcode hex color di widget.
- **Dekorasi kartu:** gunakan `AppTheme.cardDecoration` / `coloredCardDecoration` / `gradientCardDecoration`, jangan buat `BoxDecoration` manual berulang.
- **Provider tidak boleh punya dependency ke `BuildContext`, `Navigator`, atau `ScaffoldMessenger`.**

---

## Troubleshooting

| Gejala                                         | Kemungkinan Penyebab                                                             | Solusi                                                                                                   |
| ---------------------------------------------- | -------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| Layar Pairing terus muncul walau sudah pairing | Token di secure storage terhapus/reset (uninstall app)                           | Lakukan pairing ulang dengan kode baru dari admin                                                        |
| BLE scan tidak menemukan perangkat             | Izin lokasi/Bluetooth belum diaktifkan (Android)                                 | Aktifkan izin di pengaturan aplikasi                                                                     |
| "Tidak dapat terhubung ke server"              | `BACKEND_IP`/`BACKEND_PORT` salah, atau device tidak satu jaringan dengan server | Cek `.env`, pastikan device & server satu WiFi/LAN                                                       |
| Kode rute/preset "sudah terdaftar"             | Duplikat terdeteksi baik di client maupun server (unique constraint DB)          | Gunakan kode/nama lain, atau gunakan toggle Pergi/Pulang untuk rute searah terbalik                      |
| Kirim ke Display tidak ada efek di panel       | BLE belum terhubung, atau `characteristicUuid` tidak cocok dengan firmware panel | Cek Status Card, pastikan "Terhubung"; verifikasi UUID di `bluetooth_service.dart` sesuai firmware panel |

---

## Dependency Utama

| Package                  | Kegunaan                                   |
| ------------------------ | ------------------------------------------ |
| `provider`               | State management                           |
| `http`                   | HTTP client ke backend                     |
| `flutter_blue_plus`      | Komunikasi Bluetooth Low Energy            |
| `flutter_secure_storage` | Penyimpanan aman device ID & token pairing |
| `uuid`                   | Generate device ID unik                    |
| `flutter_dotenv`         | Membaca konfigurasi `.env`                 |
| `google_fonts`           | Font DM Sans                               |

---

## Lisensi Internal

Aplikasi internal milik **PT INTI** — tidak untuk didistribusikan ke luar tanpa izin.
