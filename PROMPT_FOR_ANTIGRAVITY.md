# Tantangan: bikin chess engine kuat di bawah 4096 byte Python

Paste seluruh isi file ini sebagai prompt ke agent AI di Antigravity, dengan folder
`~/Documents/Proyek_Kode_Lain/makefun-chess-challenge` dibuka sebagai workspace-nya.

## Tugas

Tulis `main.py` di folder ini (sejajar dengan folder `kit/`) yang menjadi chess engine
untuk kompetisi "tiny-chess-01" di make.fun. Baca aturan lengkapnya di `kit/RULES.txt`
sebelum menulis kode apa pun — ringkasan poin pentingnya:

1. **Ukuran**: `main.py` maksimal 4.096 byte sebagaimana ter-commit (termasuk komentar,
   whitespace, dan payload terkompresi jika dipakai). Hanya boleh pakai Python standard
   library (tidak ada pip install).
2. **Protokol**: program berjalan sebagai `python3 -P -s main.py`, berkomunikasi via HTTP
   POST ke `$MAKEFUN_ENV_URL`:
   - `POST /game {}` → posisi permainan saat ini (field `fen`, `legal_moves`, `game`,
     `status`). Saat semua game selesai, `status` jadi `"done"`.
   - `POST /move {"game": n, "move": "<uci>"}` → kirim langkah (format UCI: `e2e4`,
     promosi `e7e8q`, castling = langkah raja `e1g1`).
   - `POST /resign {"game": n}`.
3. **Lawan**: 8 engine house (depth-2 sampai depth-4 alpha-beta, lalu nodes-100k s/d
   nodes-2M) dengan Elo anchor 855–1712. Harus mengalahkan **house baseline** (sunfish
   4KB, Elo rata-rata ~1325–1365) untuk dapat hadiah.
4. **Determinisme — PENTING**: setiap trial dijalankan ulang (replay) dan harus identik
   byte-per-byte. **Jangan pernah pakai `time.time()`, `datetime.now()`, atau timer apa
   pun untuk memutuskan kedalaman pencarian atau langkah mana yang dipilih** — itu bikin
   replay tidak konsisten dan entri didiskualifikasi/unranked. Gunakan **budget jumlah
   node** (hitungan node yang dikunjungi) untuk membatasi pencarian, bukan waktu.
   Juga jangan pakai `random`/`Math.random()` tanpa seed dari `MAKEFUN_TRIAL_SEED`.
5. **Budget waktu nyata**: total 1.800 detik untuk seluruh trial (8 game), jadi rata-rata
   boleh ±3 detik/langkah, maksimal ~10 detik/langkah sebelum dianggap kalah waktu.
6. Boleh fork sunfish (lisensi GPL-3.0, harus dikreditkan & LICENSE diisi SPDX tag saja)
   TAPI itu cuma menyamai baseline, bukan mengalahkannya — target sebenarnya adalah
   **mengalahkan** sunfish, jadi idealnya buat engine sendiri yang lebih kuat atau
   modifikasi signifikan.

## Contoh yang SUDAH saya coba (dan GAGAL — untuk referensi, jangan ditiru)

Folder `claude-attempt-elo0/` (kalau ada) berisi percobaan saya sendiri (Claude) sebelumnya:
engine alpha-beta + quiescence search tapi cuma depth ~3 ply dengan evaluasi material
polos (tanpa piece-square table, tanpa king safety). Hasilnya: **kalah 0 dari 6 game**
di practice set, bahkan melawan lawan termudah (depth-2). Elo = 0.

Supaya menang, menurut analisis saya dibutuhkan minimal:
- Kedalaman pencarian lebih dalam (5-6+ ply), yang butuh board representation jauh
  lebih cepat dari pendekatan naif (list of 64 string).
- Evaluasi posisi lengkap: piece-square table, keamanan raja, mobilitas, bukan cuma
  material.
- Move ordering yang baik (MVV-LVA, killer move, atau transposition table) agar
  alpha-beta pruning efektif dalam budget node yang terbatas.
- Kode di atas semua itu TETAP harus dikompres ke bawah 4.096 byte (nama variabel
  pendek, hilangkan whitespace non-esensial, atau pakai teknik pack/unpack seperti
  yang dilakukan sunfish sendiri — lihat `kit/RULES.txt` bagian "The size rule").

## Cara tes

Dari folder ini, jalankan (butuh Docker, sudah terpasang di komputer ini):

```bash
cd kit
node cli/makefun.mjs grade-local --kit . --bot ../ --driver docker
```

Ini akan menjalankan `main.py` melawan 6 lawan practice (satu live trial), dan
mencetak skor (`wins`, `losses`, `draws`, `elo`). Ulangi iterasi sampai Elo melebihi
~1365 (baseline sunfish pada practice set) secara konsisten.

**Jangan submit apa pun ke make.fun** (belum ada akun terdaftar) — fokus dulu ke
iterasi lokal sampai benar-benar kuat. Laporkan hasil akhirnya (skor Elo, menang
berapa dari 6) setelah selesai.
