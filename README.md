
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
bk035
```

## 4. Fitur Pengembangan

1. **Rotasi arsip**: setelah backup, hanya 5 arsip terbaru yang disimpan. Arsip
   yang lebih lama dihapus otomatis. Cara mencoba: jalankan `./script/backup.sh`
   lebih dari 5 kali, lalu cek `ls ~/backup_09011282530035` (jumlah arsip tetap 5).
2. **Parameter**: ekstensi file dapat diberikan sebagai argumen. Cara mencoba:
   `./script/backup.sh pdf` (mengarsipkan file `.pdf`). Tanpa argumen, yang
   diarsipkan adalah file `.txt`.

## 5. Bukti Job Control

```
yora@yora-VirtualBox:~/Desktop/UTS_SO_09011282530035$ ./script/backup_loop.sh 10 > /dev/null &
jobs -l
fg
[1] 5850
[1]+  5850 Running                 ./script/backup_loop.sh 10 > /dev/null &
./script/backup_loop.sh 10 > /dev/null
^Z
[1]+  Stopped                 ./script/backup_loop.sh 10 > /dev/null
yora@yora-VirtualBox:~/Desktop/UTS_SO_09011282530035$ bg
ps x | grep -E "PID|backup_loop"
[1]+ ./script/backup_loop.sh 10 > /dev/null &
    PID TTY      STAT   TIME COMMAND
   5850 pts/0    S      0:00 /bin/bash ./script/backup_loop.sh 10
   5875 pts/0    S+     0:00 grep --color=auto -E PID|backup_loop
yora@yora-VirtualBox:~/Desktop/UTS_SO_09011282530035$ tail -n 5 ~/backup_09011282530035/backup.log
kill %1
jobs
2026-10-20 09:37:39 | backup_09011282530035_20261020_093739.tar.gz | 14 | 4,0K
2026-10-20 09:37:49 | backup_09011282530035_20261020_093749.tar.gz | 14 | 4,0K
2026-10-20 09:37:59 | backup_09011282530035_20261020_093759.tar.gz | 14 | 4,0K
2026-10-20 09:38:09 | backup_09011282530035_20261020_093809.tar.gz | 14 | 4,0K
2026-10-20 09:38:19 | backup_09011282530035_20261020_093819.tar.gz | 14 | 4,0K
[1]+  Running                 ./script/backup_loop.sh 10 > /dev/null &
[1]+  Terminated              ./script/backup_loop.sh 10 > /dev/null

```

## 6. Kendala

| Error yang muncul | Cara mengatasi |
|---|---|
| `remote: Invalid username or token. Password authentication is not supported` | Yang dimasukkan di kolom Password bukan token. Diatasi dengan membuat Personal Access Token (classic, scope `repo`) lalu menempelnya sebagai password. |
| `fatal: 'github.com/.../uts-os-...' does not appear to be a git repository` dan `error: remote origin already exists` | Alamat remote salah ketik (`uts-os`, seharusnya `uts-so`) dan tanpa `https://`. Diatasi dengan `git remote set-url origin https://github.com/Ayora213/uts-so-09011282530035.git`. |
| `fatal: The current branch main has no upstream branch` | Push pertama harus memakai `git push -u origin main`. |
| `CONFLICT (add/add): Merge conflict in README.md` | README ada di dua tempat dengan isi berbeda. Diatasi dengan memilih versi sendiri, lalu `git add` dan `git commit`. |
| `Error: direktori sumber '/home/yora/data_09011282530035' tidak ditemukan.` | Folder data uji belum dibuat. Diatasi dengan `mkdir -p` untuk membuat `~/data_NIM` beserta isinya, lalu menjalankan ulang script. |

