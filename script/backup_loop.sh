#!/bin/bash
# Nama  : Ayora Gemala Gaparini
# NIM   : 09011282530035
# Kelas : SKU3B
#
# backup_loop.sh
# Menjalankan backup.sh berulang kali dengan jeda INTERVAL detik.
# Dijalankan di background: ./backup_loop.sh &
# Dihentikan dengan: kill %1   (atau kill PID)

# ===== VARIABEL =====
INTERVAL="${1:-60}"   # jeda antar backup (detik), bawaan 60
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # folder script ini

# ===== PERULANGAN =====
while true; do
  "$SCRIPT_DIR/backup.sh"     # jalankan backup
  sleep "$INTERVAL"           # tunggu sebelum backup berikutnya
done
