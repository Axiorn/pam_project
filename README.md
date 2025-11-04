## 🏋️ BMI Calculator & Subscription App (PAM Project)

Aplikasi **BMI Calculator & Subscription App** adalah proyek yang dikembangkan untuk tugas akhir mata kuliah Pemrograman Aplikasi Mobile (PAM). Tujuannya adalah menyediakan platform terpadu bagi pengguna untuk **menghitung Body Mass Index (BMI)** mereka, **melacak riwayat** kalkulasi dengan filter dan konversi zona waktu, serta mengelola penggunaan melalui sistem **kuota dan langganan** (*subscription*). Aplikasi ini dibangun dengan arsitektur modular menggunakan Flutter, menjamin penyimpanan data lokal yang aman menggunakan Hive, dan integrasi API untuk hasil BMI.

-----

## 🛠️ Teknologi dan Dependensi

Proyek ini sepenuhnya dikembangkan menggunakan **Flutter** dan **Dart**, dengan fokus pada penyimpanan data lokal dan integrasi layanan.

| Kategori | Teknologi/Paket Utama | Fungsionalitas |
| :--- | :--- | :--- |
| **Framework Utama** | **Flutter** | Cross-platform UI Development. |
| **Database Lokal** | **Hive** & **`hive_flutter`** | Penyimpanan dataUserModel, BmiResultModel, dan sesi secara cepat dan lokal. |
| **Integrasi Eksternal** | **`http`** | Memanggil API kalkulator BMI. |
| **Location** | **`geolocator`** | Mengambil data koordinat lokasi untuk setiap catatan BMI. |
| **Notifikasi** | **`awesome_notifications`** | Menampilkan notifikasi sukses untuk penyimpanan data dan aktivasi langganan. |
| **Autentikasi Aman** | **`crypto`** | *Hashing* password menggunakan SHA-256. |
| **State Management** | **Provider** | Mengelola *state* aplikasi, terutama untuk tema gelap/terang. |

-----

## 📦 Instalasi & Deployment Lokal

Sebelum memulai, pastikan Anda telah menginstal **Flutter SDK** dan **Dart SDK** di sistem Anda, serta memiliki **IDE** (seperti VS Code atau Android Studio) yang mendukung pengembangan Flutter.

### 1\. Clone Repository

Jalankan perintah berikut di terminal untuk meng-clone proyek ke komputer lokal Anda:

```bash
# Clone repository
git clone https://github.com/Axiorn/pam_project

# Masuk ke direktori proyek
cd pam_project
```

### 2\. Instalasi Dependensi

Di dalam direktori proyek (`pam_project`), jalankan perintah berikut untuk mengunduh semua *package* yang dibutuhkan (tercantum dalam `pubspec.yaml`):

```bash
flutter pub get
```

### 3\. Generate Hive Adapters

Karena proyek ini menggunakan Hive untuk serialisasi data, Anda harus menjalankan *code generator* untuk membuat file model adapter (`*.g.dart`):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Perintah ini akan membuat `user_model.g.dart` dan `bmi_result_model.g.dart`, yang sangat penting untuk fungsionalitas Hive.

### 4\. Menjalankan Aplikasi

Pastikan Anda telah menyambungkan perangkat fisik atau menjalankan emulator/simulator.

```bash
flutter run
```

Aplikasi akan di-*build* dan diluncurkan. Halaman awal aplikasi adalah **LoginScreen** atau **HomeScreen**, tergantung pada status sesi terakhir di *Hive Session Box*.

-----

## 👍🏻 Standarisasi dan Best Practice

Proyek ini menerapkan beberapa *best practices* Flutter/Dart, khususnya dalam penamaan dan struktur untuk meningkatkan *readability* dan *maintainability* kode:

### 1\. Penamaan File dan Kelas (PascalCase)

  * Semua file Dart yang mendefinisikan *widget* atau *class* utama menggunakan format **`snake_case`** untuk nama file (`bmi_calculator_screen.dart`).
  * Nama kelas di dalamnya menggunakan **`PascalCase`** (`BmiCalculatorScreen`, `AuthService`, `UserModel`).

### 2\. Penamaan Variabel dan Metode (camelCase)

  * Variabel lokal, properti kelas, dan nama metode menggunakan format **`camelCase`** (`calculateBmi`, `remainingQuota`, `usernameController`).

### 3\. Struktur Direktori Modular

  * Logika bisnis dan penyimpanan data dipisahkan dalam folder `core/services` dan `core/models` (`auth_service.dart`, `hive_service.dart`, `user_model.dart`).
  * Tampilan (*Screens*) dan *Widget* disajikan secara jelas di folder `presentation`.

### 4\. Penggunaan Final/Const

  * Konstanta seperti rute aplikasi (`AppRoutes`) dan nama *Hive Box* (`HiveBoxes`) didefinisikan menggunakan `static const` untuk efisiensi.

### 5\. Prinsip Konsistensi

  * Kode selalu dipastikan **konsisten** dalam penggunaan tanda kutip (`'`) dan gaya pemformatan (`dart format`) di seluruh proyek.
