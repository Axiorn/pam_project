# 📱 BMI Calculator & Subscription App (PAM Project)

## 🌟 Deskripsi Proyek

Aplikasi **BMI Calculator & Subscription App** adalah proyek yang dikembangkan sebagai tugas akhir mata kuliah Pemrograman Aplikasi Mobile (PAM). Aplikasi ini dirancang untuk memungkinkan pengguna menghitung Body Mass Index (BMI), melacak riwayat hasil kalkulasi, dan mengelola kuota penggunaan melalui sistem langganan (subscription).

### Fitur Utama:

* **Autentikasi Aman:** Login dan Registrasi pengguna dengan hashing password SHA-256.
* **Kalkulator BMI:** Menghitung BMI secara real-time dengan memanggil API eksternal.
* **Manajemen Kuota:** Pengguna memiliki kuota terbatas yang berkurang setiap kali kalkulasi BMI dilakukan.
* **Sistem Langganan:** Fitur untuk menambah kuota dan mengaktifkan langganan (30 hari) dengan berbagai paket.
* **Pencatatan Riwayat:** Menyimpan semua hasil BMI ke database lokal, lengkap dengan waktu dan lokasi pengguna, serta fitur filter berdasarkan kategori BMI dan zona waktu.
* **Notifikasi:** Menggunakan notifikasi lokal untuk konfirmasi penyimpanan BMI dan aktivasi langganan.
* **Pengaturan Tema:** Mendukung mode Terang (Light Mode) dan Gelap (Dark Mode).

---

## 🛠️ Teknologi dan Framework yang Digunakan

| Kategori | Teknologi/Framework | Tujuan Penggunaan |
| :--- | :--- | :--- |
| **Framework Utama** | **Flutter** | Pengembangan antarmuka pengguna (UI) dan logika aplikasi *cross-platform*. |
| **Bahasa Pemrograman** | **Dart** | Bahasa pemrograman utama Flutter. |
| **State Management** | **Provider** | Mengelola *state* global, khususnya untuk perubahan tema (Theming). |
| **Database Lokal** | **Hive** | Database NoSQL ringan untuk menyimpan data pengguna (`UserModel`), sesi (`sessionBox`), dan riwayat BMI (`BmiResultModel`) secara lokal. |
| **API/HTTP** | **`http` package** | Melakukan permintaan ke API eksternal untuk kalkulasi BMI. |
| **Keamanan** | **`crypto` (SHA-256)** | Melakukan *hashing* kata sandi pengguna untuk keamanan saat registrasi dan login. |
| **Fitur Tambahan** | **`geolocator`** | Mendapatkan data lokasi (koordinat) saat menghitung dan menyimpan BMI. |
| **Notifikasi** | **`awesome_notifications`** | Menampilkan notifikasi lokal untuk konfirmasi. |

---

## 🚀 Cara Menjalankan Aplikasi

Ikuti langkah-langkah di bawah ini untuk menginstal dan menjalankan proyek ini di perangkat atau emulator Anda.

### 1. Prasyarat

Pastikan Anda telah menginstal yang berikut ini di sistem Anda:

* **Flutter SDK** (Versi yang disarankan sesuai `pubspec.yaml` atau lebih baru).
* **Dart SDK**.
* **IDE (Visual Studio Code atau Android Studio)** dengan plugin Flutter/Dart.

### 2. Cloning Repositori

Buka Terminal atau Command Prompt Anda dan jalankan perintah *cloning* berikut:

```bash
# Clone repository
git clone [https://github.com/ldclabs/anda](https://github.com/ldclabs/anda)

# Masuk ke direktori proyek
cd pam_project
