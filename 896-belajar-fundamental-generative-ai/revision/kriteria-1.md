Kriteria 1: Melakukan Image Generation (Text-to-Image)

Jika merujuk pada gambar di instruksi, terdapat perbedaan gaya yang jelas antara kedua output. Hasil simple_image seharusnya bergaya kartun (tidak realistis), sedangkan advance_image seharusnya menghasilkan gambar fotorealistik yang menyerupai foto.
Berikut adalah saran perbaikan yang bisa kamu lakukan:
simple_image: Coba perbaiki dan sesuaikan kembali penulisan prompt-mu.Berikan penekanan yang jelas pada objek utama yang diwajibkan, yaitu sosok astronaut di atas bulan dengan planet Bumi sebagai latar belakangnya.Jangan lupa tambahkan kata kunci untuk gaya kartun. Kamu bisa merujuk kembali ke materi Anatomi Prompt yang Efektif pada modul Strategi untuk Mengontrol Hasil Image Generation. 
Sebagai panduan, susunlah prompt dengan urutan berikut:
Subject + Medium + Style + Artist & Website + Resolution & Lighting + Color
advance_image: Pastikan kamu menggunakan prompt dasar yang sama. Untuk melihat perbedaannya, lakukan tuning pada parameter inference_steps di rentang 50 sampai 200, dan atur guidance_scale di rentang 7 sampai 8.atau mencoba nilai lainnya.
Pada tugas ini, kamu memang ditantang untuk menghasilkan dua gambar yang berbeda menggunakan satu prompt yang sama. Jadi, wajar jika proses tuning parameter ini akan memakan sedikit waktu. Selamat bereksperimen!