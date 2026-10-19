#!/bin/bash
# Nama  : Ayora Gemala Gaparini
# NIM   : 09011282530035
# Kelas : SKU3B
#
# backup.sh
# Mencari semua file .txt di direktori sumber (termasuk subdirektori),
# mengarsipkan + mengompresinya menjadi satu file .tar.gz bernama
# tanggal dan jam, lalu mencatat prosesnya ke file log.
#
# Pemakaian : ./backup.sh          -> backup file .txt (bawaan)
#             ./backup.sh pdf      -> backup file .pdf (fitur parameter)

# ===== VARIABEL (ubah di sini saja bila lokasi ingin diganti) =====
NIM="09011282530035"
SRC_DIR="$HOME/data_$NIM"            # direktori sumber
DEST_DIR="$HOME/backup_$NIM"         # direktori tujuan backup
LOG_NAME="backup.log"                # nama file log
LOG_FILE="$DEST_DIR/$LOG_NAME"       # lokasi lengkap file log
LIST_FILE="$DEST_DIR/daftar_file.txt" # daftar hasil find
MAX_ARCHIVE=5                        # rotasi: simpan 5 arsip terbaru
EXT="${1:-txt}"                      # ekstensi dari argumen, bawaan txt
EXT="${EXT#.}"                       # buang titik di depan bila ada

# ===== PENGECEKAN AWAL =====
# Berhenti jika NIM belum diganti dengan NIM asli
case "$NIM" in
  ISI_*) echo "Error: isi dulu variabel NIM di backup.sh" >&2; exit 1 ;;
esac

# Berhenti jika direktori sumber tidak ada
if [ ! -d "$SRC_DIR" ]; then
  echo "Error: direktori sumber '$SRC_DIR' tidak ditemukan." >&2
  exit 1
fi

# ===== DIREKTORI TUJUAN =====
# -p: buat jika belum ada, tidak error jika sudah ada
mkdir -p "$DEST_DIR"

# ===== PENCARIAN FILE =====
# find mencari semua file berekstensi $EXT (termasuk subdirektori).
# -printf '%P\n' menulis path relatif terhadap direktori sumber.
# Hasilnya disimpan ke file teks daftar.
find "$SRC_DIR" -type f -name "*.$EXT" -printf '%P\n' | sort > "$LIST_FILE"

COUNT=$(wc -l < "$LIST_FILE")        # jumlah file yang ditemukan
if [ "$COUNT" -eq 0 ]; then
  echo "Tidak ada file .$EXT di '$SRC_DIR'. Backup dibatalkan."
  exit 1
fi

# ===== NAMA ARSIP =====
TIMESTAMP=$(date +%Y%m%d_%H%M%S)     # contoh: 20261020_143005
LOG_TIME=$(date '+%Y-%m-%d %H:%M:%S') # contoh: 2026-10-20 14:30:05
ARCHIVE_NAME="backup_${NIM}_${TIMESTAMP}.tar.gz"
ARCHIVE="$DEST_DIR/$ARCHIVE_NAME"

# ===== PENGARSIPAN DAN KOMPRESI =====
# -c buat arsip, -z gzip, -v tampilkan proses, -f nama arsip
# -C pindah ke direktori sumber, -T baca daftar file dari LIST_FILE
if ! tar -czvf "$ARCHIVE" -C "$SRC_DIR" -T "$LIST_FILE"; then
  echo "Error: pembuatan arsip gagal." >&2
  exit 1
fi

# ===== VERIFIKASI ARSIP =====
# -t hanya menampilkan isi arsip tanpa mengekstrak
echo "--- Isi arsip $ARCHIVE_NAME ---"
tar -tzvf "$ARCHIVE"

# ===== LOG =====
# >> menambah baris di akhir file (tidak menimpa isi lama)
SIZE=$(du -h "$ARCHIVE" | cut -f1)   # ukuran arsip, contoh: 4.0K
echo "$LOG_TIME | $ARCHIVE_NAME | $COUNT | $SIZE" >> "$LOG_FILE"

# ===== FITUR: ROTASI ARSIP =====
# Nama arsip memuat tanggal, jadi urutan nama = urutan waktu.
# head -n -5 mengambil semua arsip KECUALI 5 yang terbaru, lalu dihapus.
ls -1 "$DEST_DIR"/backup_"$NIM"_*.tar.gz | head -n -"$MAX_ARCHIVE" |
while read -r OLD_ARCHIVE; do
  rm -f -- "$OLD_ARCHIVE"
done

echo "Backup selesai: $ARCHIVE_NAME ($COUNT file, $SIZE)"
