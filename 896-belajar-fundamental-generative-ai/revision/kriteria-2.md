Kriteria 2: Menyempurnakan Gambar Melalui Image-to-Image

Hasil generate fungsi inpainting belum menampilkan object broken satelit yang diharapkan sesuai contoh gambar pada instruksi. [object satelite inpainting masih jauh dari eksptasi]
Tips & Trik

Cobalah untuk memperbaiki prompt dengan menambahkan detail seperti besar atau kecilnya object dan sebagainya, kemudian lakukan tuning config scale dan step dari kecil hingga besar,
Pada model inpainting berbasis diffusion (misalnya Stable Diffusion), dua parameter utama yang sangat berpengaruh adalah:
CFG Scale (Guidance Scale)
Sampling Steps
Kalau keduanya terlalu kecil, hasil inpainting sering:
Tidak muncul sama sekali
Perubahannya sangat halus
Mask terabaikan
Output terlihat seperti gambar asli tanpa modifikasi