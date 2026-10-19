# Tugas Besar UTS Sistem Operasi

## 1. Identitas

- Nama  : Ayora Gemala Gaparini
- NIM   : 09011282530035
- Kelas : SKU3B

## 2. Deskripsi

Proyek ini berisi tiga *shell script* untuk membackup catatan praktikum.

- `script/backup.sh`: memakai `find` untuk mencari semua file `.txt` (termasuk
  subdirektori) di `~/data_NIM`, menyimpan daftarnya ke file teks, lalu
  mengarsipkannya dengan `tar -czvf` menjadi
  `~/backup_NIM/backup_NIM_TANGGAL_JAM.tar.gz`. Isi arsip ditampilkan dengan
  `tar -tzvf`, lalu satu baris dicatat ke `~/backup_NIM/backup.log` memakai `>>`
  dengan format `tanggal jam | nama arsip | jumlah file | ukuran arsip`.
- `script/backup_loop.sh`: menjalankan `backup.sh` berulang dengan `while true`
  dan `sleep $INTERVAL` (bawaan 60 detik). Dijalankan di background dengan `&`.
- `script/alias.sh`: berisi alias `bkXXX` untuk menjalankan `backup.sh`.

## 3. Cara Menjalankan

```bash
# Dari folder repositori
cd ~/uts-so-09011282530035
chmod +x script/*.sh

# Backup sekali
./script/backup.sh

# Backup berulang di background (jeda bawaan 60 detik)
./script/backup_loop.sh &

# Backup berulang dengan jeda 10 detik
./script/backup_loop.sh 10 &

# Hentikan loop
kill %1

# Alias (setelah ditambahkan ke ~/.bashrc dan terminal dibuka ulang)
bkXXX
```

## 4. Fitur Pengembangan

1. **Rotasi arsip**: setelah backup, hanya 5 arsip terbaru yang disimpan. Arsip
   yang lebih lama dihapus otomatis. Cara mencoba: jalankan `./script/backup.sh`
   lebih dari 5 kali, lalu cek `ls ~/backup_ISI_NIM_ANDA` (jumlah arsip tetap 5).
2. **Parameter**: ekstensi file dapat diberikan sebagai argumen. Cara mencoba:
   `./script/backup.sh pdf` (mengarsipkan file `.pdf`). Tanpa argumen, yang
   diarsipkan adalah file `.txt`.

## 5. Bukti Job Control

Keluaran terminal saat menjalankan `./backup_loop.sh &`, `jobs -l`, `fg`,
Ctrl+Z, `bg`, `ps x`, dan `kill`:

```text
TEMPEL KELUARAN TERMINAL ANDA DI SINI
```

## 6. Kendala

| Error yang muncul | Cara mengatasi |
|---|---|
| TULIS ERROR ASLI YANG ANDA ALAMI | TULIS CARA ANDA MENGATASINYA |
