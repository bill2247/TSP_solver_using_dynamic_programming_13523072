# Pemecah Masalah Pedagang Keliling (Travelling Salesman Problem - TSP)

Program ini mengimplementasikan dua pendekatan untuk menyelesaikan Travelling Salesman Problem (TSP):
1.  **Brute Force:** Mencoba semua kemungkinan permutasi jalur untuk menemukan yang terpendek.
2.  **Dynamic Programming (Algoritma Held-Karp):** Pendekatan yang lebih efisien secara komputasi untuk menemukan solusi optimal.

Program ini ditulis dalam bahasa Ruby.

## Daftar Isi

- [Cara Kerja](#cara-kerja)
  - [Struktur Proyek](#struktur-proyek)
  - [Pembacaan Matriks](#pembacaan-matriks)
  - [Algoritma Brute Force](#algoritma-brute-force)
  - [Algoritma Dynamic Programming (Held-Karp)](#algoritma-dynamic-programming-held-karp)
- [Prasyarat](#prasyarat)
- [Cara Menjalankan Program](#cara-menjalankan-program)
- [Format File Input](#format-file-input)
- [Batasan](#batasan)

## Cara Kerja

### Struktur Proyek

Proyek ini diorganisir ke dalam beberapa file Ruby untuk modularitas:

-   `main.rb`: Skrip utama untuk menjalankan program. Mengelola input pengguna, memanggil solver, dan menampilkan hasil.
-   `matrix_reader.rb`: Berisi kelas `MatrixReader` yang bertanggung jawab untuk membaca dan memvalidasi matriks ketetanggaan dari file teks.
-   `brute_force_solver.rb`: Berisi kelas `BruteForceSolver` yang mengimplementasikan algoritma brute force untuk TSP.
-   `dynamic_programming_solver.rb`: Berisi kelas `DynamicProgrammingSolver` yang mengimplementasikan algoritma Held-Karp menggunakan dynamic programming.
-   `output_formatter.rb`: Modul `OutputFormatter` untuk memformat dan mencetak matriks serta hasil solusi ke konsol.

### Pembacaan Matriks

Program memulai dengan meminta pengguna untuk memasukkan path ke file teks yang berisi matriks ketetanggaan. `MatrixReader` kemudian membaca file ini, mengonversi datanya menjadi struktur matriks (array dari array integer), dan melakukan validasi dasar (misalnya, matriks tidak kosong, seragam, dan persegi).

### Algoritma Brute Force

Algoritma brute force bekerja dengan cara berikut:
1.  Mengidentifikasi semua node selain node awal (diasumsikan node 0).
2.  Menghasilkan setiap kemungkinan permutasi dari node-node tersebut.
3.  Untuk setiap permutasi, membentuk jalur lengkap yang dimulai dari node 0, mengunjungi node-node dalam permutasi, dan kembali ke node 0.
4.  Menghitung total bobot (biaya) dari setiap jalur.
5.  Menyimpan jalur dengan bobot minimum. Jika ada beberapa jalur dengan bobot minimum yang sama, semua jalur tersebut akan ditampilkan.
6.  Mengukur waktu yang dibutuhkan untuk proses pencarian.

**Kompleksitas:** $O(N!)$, di mana N adalah jumlah node. Karena kompleksitas faktorial, pendekatan ini hanya praktis untuk jumlah node yang sangat kecil (misalnya, N <= 10-12).

### Algoritma Dynamic Programming (Held-Karp)

Algoritma Held-Karp adalah solusi berbasis dynamic programming yang jauh lebih efisien daripada brute force untuk TSP.
1.  **State DP:** `dp[mask][i]` menyimpan biaya minimum dari jalur yang dimulai dari node awal (node 0), mengunjungi semua node yang direpresentasikan dalam `mask` (sebuah bitmask), dan berakhir di node `i`.
2.  **Base Case:** `dp[1 << start_node][start_node] = 0`. Biaya untuk berada di node awal, dengan hanya mengunjungi node awal itu sendiri, adalah 0.
3.  **Rekurensi:**
    `dp[mask][u] = min(dp[mask ^ (1 << u)][v] + cost[v][u])`
    untuk semua `v` dalam `mask ^ (1 << u)` (yaitu, `v` adalah node sebelum `u` dalam sub-jalur).
4.  **Solusi Akhir:** Setelah tabel `dp` terisi, biaya tur minimum adalah `min(dp[final_mask][i] + cost[i][start_node])` untuk semua node `i` (di mana `final_mask` adalah mask yang mencakup semua node).
5.  **Rekonstruksi Jalur:** Jalur optimal direkonstruksi dengan melacak kembali keputusan yang dibuat (node `v` mana yang dipilih) yang menghasilkan biaya minimum untuk setiap state `(mask, u)`, biasanya menggunakan tabel `parent`.
6.  Mengukur waktu yang dibutuhkan untuk proses pencarian.

**Kompleksitas:** $O(N^2 \cdot 2^N)$. Meskipun masih eksponensial, ini secara signifikan lebih baik daripada $O(N!)$ dan dapat menyelesaikan masalah untuk jumlah node yang lebih besar (misalnya, N hingga sekitar 20-25, tergantung pada implementasi dan sumber daya).

## Prasyarat

-   Ruby terinstal di sistem Anda (direkomendasikan versi 2.7 atau lebih baru). Anda dapat memeriksa instalasi Ruby dengan menjalankan `ruby -v` di terminal.

## Cara Menjalankan Program

1.  **Clone atau Unduh Proyek:**
    Jika proyek ini ada di repositori Git:
    ```bash
    git clone <url_repositori_anda>
    cd <nama_direktori_proyek>
    ```
    Atau, unduh semua file (`main.rb`, `matrix_reader.rb`, `brute_force_solver.rb`, `dynamic_programming_solver.rb`, `output_formatter.rb`) ke dalam satu direktori.

2.  **Siapkan File Input Matriks:**
    Buat file teks (misalnya, `matrix.txt`) yang berisi matriks ketetanggaan. Lihat [Format File Input](#format-file-input) di bawah. Simpan file testing pada folder `test`

3.  **Jalankan Skrip Utama:**
    Buka terminal atau command prompt, navigasi ke direktori tempat Anda menyimpan file-file program, dan jalankan perintah berikut:
    ```bash
    ruby src/main.rb
    ```

4.  **Masukkan Path File:**
    Program akan meminta Anda untuk memasukkan nama file txt yang sudah Anda sisipkan pada folder test lalu tekan Enter.
    Contoh:
    ```
    Masukkan path ke file matriks ketetanggaan (misalnya, matrix.txt):
    testcase1.txt
    ```

5.  **Lihat Hasil:**
    Program akan menampilkan matriks yang dibaca, diikuti oleh hasil dari solusi Brute Force (jika jumlah node kecil) dan solusi Dynamic Programming, termasuk:
    -   Waktu eksekusi
    -   Total bobot path minimum
    -   Satu atau lebih path optimal yang ditemukan

## Format File Input

File input harus berupa file teks (`.txt`) di mana setiap baris merepresentasikan satu baris dari matriks ketetanggaan. Angka-angka dalam satu baris harus dipisahkan oleh satu atau lebih spasi.

-   Matriks harus **persegi** (jumlah baris sama dengan jumlah kolom).
-   Node diindeks mulai dari 0.
-   `matrix[i][j]` merepresentasikan bobot (biaya) perjalanan dari node `i` ke node `j`.
-   Untuk node yang tidak terhubung secara langsung, Anda dapat menggunakan nilai yang sangat besar atau program akan menganggapnya sebagai `Float::INFINITY` jika tidak ada edge (implementasi mungkin memerlukan penyesuaian jika format sangat spesifik).
-   Biaya perjalanan dari sebuah node ke dirinya sendiri (`matrix[i][i]`) biasanya adalah 0.

## Batasan

-   **Brute Force:** Hanya praktis untuk N <= 10-12. Program secara otomatis akan melewati brute force untuk N yang lebih besar dari batas yang ditentukan dalam `main.rb` (saat ini > 10).
-   **Dynamic Programming (Held-Karp):** Menjadi lambat dan membutuhkan banyak memori untuk N > 20-25. Waktu eksekusi dapat menjadi signifikan.
-   **Representasi Path Ganda:**
    -   Brute force akan menampilkan semua path yang memiliki bobot minimum yang sama.
    -   Implementasi Dynamic Programming saat ini dirancang untuk menampilkan satu path optimal. Modifikasi lebih lanjut diperlukan untuk mengambil semua path optimal jika ada beberapa dengan bobot yang sama.
-   **Input Negatif:** Program saat ini mengasumsikan bobot non-negatif. Algoritma TSP standar tidak dirancang untuk menangani siklus negatif.

---
## Credit

- Nama: Sabilul Huda
- NIM: 13523072
- Email: sabilulhuda060106@gmail.com

---