Berikut prompt yang dapat langsung digunakan untuk merevisi proposal **SIGAP-AI** secara menyeluruh. Prompt ini sudah diarahkan agar proposal menjadi lebih fokus sebagai karya tulis ilmiah, bukan sekadar rancangan produk.

---

## Prompt Revisi Proposal GEMASTIK KTI-TIK

Saya memiliki proposal seleksi internal GEMASTIK bidang Karya Tulis Ilmiah TIK berjudul sementara:

**“SIGAP-AI: Sistem Prediksi Dini dan Komunikasi Darurat Bencana Berbasis Hybrid Artificial Intelligence dan Mesh Network LoRa untuk Wilayah Blank Spot Indonesia.”**

Proposal saat ini menggabungkan prediksi bencana berbasis AI, komunikasi darurat LoRa, edge computing, aplikasi mobile, dashboard, sensor IoT, dan berbagai teknologi lainnya. Proposal menjelaskan dua kontribusi utama, yaitu prediksi dini berbasis data multimodal dan komunikasi darurat yang tetap berfungsi ketika jaringan seluler lumpuh. 

Tolong revisi proposal tersebut secara menyeluruh dengan ketentuan berikut.

# A. Tujuan Utama Revisi

Ubah proposal agar lebih:

* fokus;
* realistis untuk diimplementasikan;
* mudah dipahami oleh juri;
* kuat secara metodologi ilmiah;
* memiliki novelty yang spesifik;
* memiliki hasil eksperimen yang dapat diukur;
* tidak terkesan overclaim;
* tidak terlalu banyak memasukkan teknologi yang tidak benar-benar diuji;
* sesuai dengan karakter Karya Tulis Ilmiah TIK, bukan hanya proposal pengembangan aplikasi atau IoT.

Penyederhanaan harus dilakukan pada cakupan implementasi, tetapi **kedalaman penelitian, novelty, validasi metode, dan kualitas eksperimen harus diperkuat**.

# B. Fokus Jenis Bencana

Ubah ruang lingkup bencana menjadi khusus pada:

> **Bencana banjir**

Jangan lagi menjadikan banjir, longsor, dan cuaca ekstrem sebagai tiga objek utama sekaligus.

Jelaskan alasan pemilihan banjir secara logis dan ilmiah, antara lain:

* banjir dapat menyebabkan listrik padam;
* Base Transceiver Station dapat berhenti beroperasi karena gangguan listrik atau kerusakan perangkat;
* jaringan internet dan komunikasi seluler dapat terganggu;
* wilayah terdampak dapat berubah menjadi communication blank spot;
* warga membutuhkan saluran pelaporan darurat ketika jaringan konvensional tidak tersedia;
* laporan lokasi korban, kondisi medis, kebutuhan evakuasi, dan logistik harus dapat dikirim secara cepat.

Jangan membuat klaim bahwa semua banjir selalu menyebabkan BTS atau jaringan mati. Gunakan kalimat yang lebih hati-hati, misalnya:

> Pada banjir berskala besar, gangguan pasokan listrik, kerusakan infrastruktur, dan terputusnya jalur transmisi dapat menurunkan atau menghentikan layanan telekomunikasi di wilayah terdampak.

Proposal sebelumnya membahas gangguan BTS dan backbone fiber optik yang menyebabkan komunikasi blank spot serta menghambat pelaporan dan koordinasi selama masa kritis tanggap darurat. Pertahankan substansi masalah tersebut, tetapi fokuskan seluruh pembahasannya pada konteks banjir. 

# C. Penyederhanaan Konsep Utama

Sederhanakan SIGAP-AI menjadi sistem dengan dua fungsi inti:

1. **Flood Risk Prediction**
2. **Emergency Communication in Blank Spot Areas**

Jangan menjadikan semua fitur sebagai kontribusi utama.

Gunakan alur sistem utama berikut:

```text
Data cuaca dan data historis banjir
                ↓
        Model prediksi banjir
                ↓
          Flood Risk Score
                ↓
        Backend dan Dashboard
```

Alur komunikasi darurat:

```text
Warga
  ↓
Aplikasi Mobile Flutter
  ↓ Bluetooth Low Energy
Citizen Node berbasis ESP32 dan LoRa
  ↓ LoRa
Relay Node
  ↓ LoRa
Gateway Node
  ↓ Wi-Fi / internet gateway
Backend
  ↓
Dashboard Pusat Komando
```

Gabungkan kedua alur tersebut menjadi:

```text
                 FLOOD DATA
                     ↓
             CLOUD AI PREDICTION
                     ↓
              FLOOD RISK SCORE
                     ↓
                  BACKEND
                     ↓
                  DASHBOARD
                     ↑
                  GATEWAY
                     ↑ LoRa
                   RELAY
                     ↑ LoRa
                CITIZEN NODE
                     ↑ BLE
               MOBILE APPLICATION
                     ↑
                  CITIZEN
```

# D. Struktur Layer Teknologi

Buat section khusus bernama:

## Arsitektur dan Lapisan Teknologi SIGAP-AI

Jelaskan sistem menggunakan empat layer utama.

### 1. Flood Intelligence Layer

Fungsi:

* mengumpulkan data cuaca dan historis banjir;
* melakukan preprocessing;
* menjalankan model AI;
* menghasilkan flood risk score.

Teknologi yang dapat digunakan:

* Python;
* Pandas;
* Scikit-learn, TensorFlow, atau PyTorch;
* model baseline seperti Logistic Regression, Random Forest, atau XGBoost;
* model utama seperti LSTM apabila data berbentuk time series.

Hindari langsung menggunakan terlalu banyak model seperti LSTM, Temporal Fusion Transformer, CNN, dan multimodal fusion secara bersamaan apabila tidak semuanya benar-benar diuji.

### 2. Emergency Communication Layer

Fungsi:

* menerima pesan darurat dari warga;
* mengirim pesan tanpa jaringan seluler;
* meneruskan paket melalui LoRa multi-hop;
* menyimpan paket sementara jika gateway belum tersedia;
* meneruskan laporan ke gateway.

Perangkat utama:

* Citizen Node;
* Relay Node;
* Gateway Node;
* ESP32;
* modul LoRa;
* BLE;
* buzzer opsional.

Gunakan konfigurasi prototipe minimal tiga node:

```text
Citizen Node → Relay Node → Gateway Node
```

Jangan mengklaim jaringan mesh dinamis penuh jika implementasi hanya menggunakan jalur relay tetap.

Gunakan istilah yang lebih tepat:

> LoRa-based multi-hop emergency communication network

atau:

> priority-aware store-and-forward LoRa communication

bukan langsung mengklaim autonomous dynamic mesh apabila belum dilakukan route discovery, rerouting, dan recovery otomatis.

### 3. Application and Interface Layer

Komponen:

* aplikasi mobile Flutter;
* dashboard React;
* peta menggunakan Leaflet atau Mapbox;
* formulir laporan darurat;
* visualisasi risk score;
* status node;
* lokasi laporan warga;
* status pengiriman pesan.

Aplikasi mobile cukup memiliki:

* pilihan kategori laporan;
* lokasi GPS;
* deskripsi singkat;
* foto opsional;
* tingkat urgensi;
* tombol kirim;
* status pesan.

Kategori laporan dapat berupa:

* membutuhkan evakuasi;
* kondisi medis;
* terjebak banjir;
* kehilangan anggota keluarga;
* kebutuhan logistik.

Dashboard cukup memiliki:

* flood risk map;
* daftar laporan warga;
* lokasi laporan;
* tingkat urgensi;
* waktu laporan;
* status Citizen, Relay, dan Gateway Node;
* status paket;
* grafik performa sistem.

### 4. Backend and Data Layer

Teknologi:

* FastAPI atau Node.js;
* PostgreSQL;
* MQTT atau WebSocket;
* REST API;
* penyimpanan data laporan;
* penyimpanan hasil prediksi;
* komunikasi real-time ke dashboard.

PostGIS dapat digunakan jika memang dibutuhkan untuk analisis spasial. Jangan memasukkannya hanya untuk membuat teknologi terlihat kompleks.

# E. Proposed Method

Buat section khusus bernama:

## Metode yang Diusulkan

Jangan menjadikan Flutter, React, ESP32, LoRa, MQTT, dan AI sebagai novelty, karena teknologi tersebut sudah tersedia.

Novelty utama harus berupa metode yang spesifik, misalnya:

> **Risk- and Urgency-Aware Message Prioritization for LoRa Multi-Hop Emergency Communication**

Metode tersebut mengatur urutan pengiriman laporan berdasarkan:

* tingkat urgensi laporan;
* flood risk score wilayah;
* lama waktu paket menunggu;
* kategori kondisi korban;
* jumlah hop;
* kondisi gateway.

Contoh data paket:

```text
Message ID
Emergency Category
Urgency Level
Flood Risk Score
Latitude
Longitude
Timestamp
Waiting Time
Hop Count
Time-to-Live
Payload
Checksum
```

Contoh formula prioritas:

[
Priority = w_1U + w_2R + w_3W + w_4V
]

Dengan:

* (U): tingkat urgensi;
* (R): flood risk score;
* (W): waktu tunggu paket;
* (V): tingkat kerentanan atau severity laporan;
* (w_1, w_2, w_3, w_4): bobot setiap variabel.

Jelaskan bagaimana bobot ditentukan, misalnya melalui:

* studi literatur;
* konsultasi ahli;
* eksperimen awal;
* sensitivity analysis;
* kombinasi pendekatan berbobot.

Metode harus memiliki mekanisme anti-starvation agar pesan berprioritas rendah tidak tertunda tanpa batas. Salah satu caranya adalah menggunakan waiting-time aging, yaitu prioritas paket meningkat ketika terlalu lama menunggu.

Bandingkan metode usulan dengan baseline:

* FIFO;
* fixed priority;
* metode tanpa flood risk score;
* komunikasi direct tanpa relay;
* metode store-and-forward standar.

# F. Research Question

Susun pertanyaan penelitian yang spesifik, misalnya:

1. Bagaimana merancang sistem pelaporan darurat banjir yang tetap dapat mengirimkan laporan warga ketika jaringan seluler tidak tersedia?
2. Apakah jaringan LoRa multi-hop tiga node dapat meningkatkan jangkauan dan keberhasilan penyampaian laporan dibanding komunikasi langsung?
3. Apakah metode risk- and urgency-aware prioritization dapat mempercepat pengiriman laporan berprioritas tinggi dibandingkan FIFO?
4. Bagaimana pengaruh jarak, penghalang, jumlah hop, dan ukuran payload terhadap latency serta packet delivery ratio?
5. Seberapa besar waktu end-to-end yang dibutuhkan sejak laporan dikirim melalui aplikasi hingga muncul pada dashboard?

# G. Tujuan Penelitian

Batasi tujuan penelitian menjadi maksimal empat atau lima tujuan yang terukur.

Contoh:

1. Merancang arsitektur sistem prediksi risiko banjir dan komunikasi darurat berbasis LoRa multi-hop.
2. Mengembangkan prototipe tiga node yang terdiri atas Citizen Node, Relay Node, dan Gateway Node.
3. Mengembangkan metode risk- and urgency-aware message prioritization.
4. Mengintegrasikan aplikasi mobile, jaringan LoRa, backend, dan dashboard pusat komando.
5. Mengevaluasi performa sistem berdasarkan latency, packet delivery ratio, packet loss, RSSI, SNR, dan end-to-end delivery time.

# H. Dataset

Buat section khusus bernama:

## Dataset dan Sumber Data

Cari dan identifikasi dataset nyata yang dapat digunakan untuk prediksi banjir di Indonesia.

Untuk setiap dataset, jelaskan:

* nama dataset;
* instansi penyedia;
* bentuk data;
* format file;
* rentang waktu;
* resolusi temporal;
* resolusi spasial;
* variabel yang tersedia;
* mekanisme akses;
* kebutuhan preprocessing;
* perannya dalam model;
* keterbatasannya.

Jenis data yang perlu dicari:

### 1. Data cuaca

Contoh variabel:

* curah hujan;
* suhu;
* kelembapan;
* kecepatan angin;
* tekanan udara;
* prakiraan cuaca.

Kemungkinan sumber:

* BMKG;
* data.go.id;
* portal Satu Data;
* dataset cuaca terbuka yang kredibel.

### 2. Data historis kejadian banjir

Contoh:

* tanggal kejadian;
* wilayah;
* jumlah korban;
* jumlah rumah terdampak;
* tinggi air;
* durasi banjir;
* koordinat atau administrasi wilayah.

Kemungkinan sumber:

* BNPB;
* DIBI;
* InaRISK;
* BPBD;
* data.go.id.

### 3. Data topografi

Contoh:

* elevasi;
* kemiringan lereng;
* daerah aliran sungai;
* jarak dari sungai;
* penggunaan lahan.

Kemungkinan sumber:

* DEMNAS;
* Badan Informasi Geospasial;
* OpenStreetMap;
* Copernicus.

### 4. Data satelit, hanya jika realistis

Contoh:

* Sentinel-1 SAR;
* Sentinel-2;
* indeks kelembapan;
* tutupan lahan;
* genangan.

Namun, data satelit tidak wajib digunakan apabila membuat implementasi terlalu berat. Jika tidak digunakan pada model utama, letakkan sebagai future work atau eksperimen tambahan.

# I. Bentuk Dataset dan Implementasi Model

Jelaskan bentuk dataset akhir yang akan digunakan untuk training.

Contoh tabular time-series:

| timestamp | wilayah | rainfall_1h | rainfall_24h | humidity | elevation | river_distance | previous_flood | flood_label |
| --------- | ------- | ----------: | -----------: | -------: | --------: | -------------: | -------------: | ----------: |

Alternatif bentuk agregasi:

```text
Wilayah × Waktu × Variabel Cuaca × Kondisi Topografi × Label Banjir
```

Jelaskan tahapan preprocessing:

1. pengumpulan data;
2. penyamaan wilayah;
3. penyamaan timestamp;
4. penanganan missing values;
5. pembersihan data;
6. normalisasi atau standardisasi;
7. feature engineering;
8. pembuatan label;
9. pembagian train, validation, dan test;
10. pencegahan data leakage.

Feature engineering dapat meliputi:

* cumulative rainfall 3 jam;
* cumulative rainfall 6 jam;
* cumulative rainfall 24 jam;
* rainfall intensity;
* antecedent rainfall;
* seasonal features;
* elevation;
* slope;
* river proximity;
* historical flood frequency.

Gunakan pembagian data berbasis waktu apabila dataset merupakan time series. Jangan melakukan random split apabila dapat menyebabkan informasi masa depan masuk ke data training.

# J. Model Prediksi Banjir

Gunakan model yang realistis.

Baseline:

* Logistic Regression;
* Decision Tree;
* Random Forest;
* XGBoost.

Model utama:

* LSTM, jika dataset time series memadai;
* atau model terbaik hasil eksperimen baseline.

Jangan memilih model hanya karena terlihat canggih.

Evaluasi menggunakan:

* accuracy;
* precision;
* recall;
* F1-score;
* ROC-AUC atau PR-AUC;
* confusion matrix;
* false negative rate.

False negative harus dibahas secara khusus karena kegagalan memprediksi kondisi berbahaya lebih kritis daripada false positive dalam konteks peringatan bencana.

Output AI harus berupa:

* probabilitas atau flood risk score;
* kategori Low, Medium, High;
* timestamp prediksi;
* wilayah;
* confidence score;
* variabel pendukung.

# K. Output Penelitian

Buat section khusus bernama:

## Luaran dan Output Penelitian

Pisahkan output menjadi beberapa kategori.

### 1. Output ilmiah

* proposed method;
* formula prioritas;
* algoritma routing atau forwarding;
* arsitektur sistem;
* analisis eksperimen;
* karya tulis ilmiah;
* dataset hasil preprocessing;
* dokumentasi metode;
* kemungkinan HKI.

### 2. Output hardware dan IoT

* satu Citizen Node;
* satu Relay Node;
* satu Gateway Node;
* prototipe komunikasi LoRa multi-hop;
* mekanisme store-and-forward;
* sensor opsional;
* buzzer atau indikator status.

### 3. Output aplikasi

* aplikasi Flutter untuk pelaporan;
* dashboard React;
* peta lokasi laporan;
* status node;
* risk score;
* riwayat laporan.

### 4. Output AI

* dataset terkurasi;
* model baseline;
* model utama;
* flood risk score;
* evaluasi model;
* confusion matrix;
* feature importance jika relevan.

### 5. Output eksperimen

* hasil packet delivery ratio;
* latency;
* packet loss;
* RSSI;
* SNR;
* end-to-end delivery time;
* konsumsi daya;
* perbandingan metode usulan dengan baseline;
* hasil ablation study.

# L. Hasil dan Pembahasan yang Direncanakan

Buat section khusus bernama:

## Rencana Hasil dan Pembahasan

Jelaskan bahwa bagian hasil tidak hanya menampilkan screenshot aplikasi, tetapi harus berisi eksperimen ilmiah.

Rancang minimal eksperimen berikut.

### Eksperimen 1 — Evaluasi model prediksi banjir

Bandingkan beberapa model berdasarkan:

* precision;
* recall;
* F1-score;
* false negative;
* waktu inferensi.

### Eksperimen 2 — Komunikasi direct dan multi-hop

Bandingkan:

```text
Citizen Node → Gateway
```

dengan:

```text
Citizen Node → Relay Node → Gateway
```

Ukur:

* packet delivery ratio;
* latency;
* packet loss;
* RSSI;
* SNR.

### Eksperimen 3 — Prioritas pesan

Bandingkan:

* FIFO;
* fixed priority;
* proposed risk- and urgency-aware method.

Ukur:

* latency pesan high priority;
* success rate pesan high priority;
* waktu tunggu pesan medium dan low;
* fairness;
* kemungkinan starvation.

### Eksperimen 4 — Store-and-forward

Skenario:

1. gateway dibuat offline;
2. relay menerima dan menyimpan paket;
3. gateway diaktifkan kembali;
4. paket diteruskan;
5. ukur recovery delay dan keberhasilan pengiriman.

### Eksperimen 5 — End-to-end testing

Ukur waktu:

```text
Mobile App
→ BLE
→ Citizen Node
→ Relay
→ Gateway
→ Backend
→ Dashboard
```

Pisahkan:

* application latency;
* BLE latency;
* LoRa latency;
* backend latency;
* dashboard update latency.

### Eksperimen 6 — Jarak dan penghalang

Gunakan beberapa kondisi:

* indoor;
* outdoor;
* line-of-sight;
* non-line-of-sight;
* jarak pendek;
* jarak menengah;
* terhalang bangunan.

### Eksperimen 7 — Konsumsi daya

Ukur:

* idle power;
* receive power;
* transmit power;
* estimasi runtime.

Panel surya cukup dijadikan feasibility analysis atau demonstrasi pada satu node apabila belum sempat diterapkan pada seluruh node.

# M. Judul Proposal

Cari beberapa alternatif judul yang:

* singkat;
* mudah dimengerti;
* mencerminkan banjir;
* mencerminkan komunikasi darurat;
* mencerminkan LoRa;
* mencerminkan AI jika AI tetap menjadi kontribusi utama;
* tidak terlalu banyak menggunakan istilah teknis;
* tidak overclaim;
* idealnya maksimal 13 kata apabila aturan tersebut benar;
* tetap sesuai gaya judul karya tulis ilmiah GEMASTIK.

Sebelum menetapkan batas 13 kata, verifikasi terlebih dahulu panduan resmi GEMASTIK tahun berjalan. Jangan menganggap batas tersebut benar tanpa sumber resmi.

Buat minimal 10 alternatif judul dalam bahasa Indonesia dan, jika diperlukan, versi bahasa Inggris.

Contoh arah judul:

1. **SIGAP-AI: Prediksi Banjir dan Komunikasi Darurat LoRa untuk Wilayah Blank Spot**
2. **SIGAP-Banjir: Sistem Prediksi dan Pelaporan Darurat Berbasis AI dan LoRa**
3. **Sistem Pelaporan Darurat Banjir Berbasis AI dan LoRa Multi-Hop**
4. **Komunikasi Darurat Banjir Berbasis LoRa dengan Prioritas Risiko AI**
5. **SIGAP-Flood: Komunikasi Darurat LoRa Berbasis Prediksi Risiko Banjir**

Setiap judul harus dievaluasi berdasarkan:

* jumlah kata;
* kejelasan;
* fokus;
* unsur kebaruan;
* kemudahan dipahami;
* kesesuaian dengan isi penelitian;
* risiko overclaim.

# N. Asta Cita

Tambahkan keterkaitan proposal dengan **Asta Cita ke-8**, yaitu:

> Memperkuat penyelarasan kehidupan yang harmonis dengan lingkungan, alam, dan budaya, serta peningkatan toleransi antarumat beragama untuk mencapai masyarakat yang adil dan makmur.

Jangan hanya menempelkan kalimat Asta Cita secara normatif.

Jelaskan keterkaitannya secara substantif:

* meningkatkan ketahanan masyarakat terhadap risiko banjir;
* memperkuat hubungan manusia dengan kondisi lingkungan;
* mendorong pemanfaatan teknologi untuk adaptasi bencana;
* mendukung masyarakat yang lebih aman dan tangguh;
* mengurangi kesenjangan akses komunikasi pada wilayah terdampak;
* membantu distribusi pertolongan secara lebih adil;
* mendukung pengambilan keputusan berbasis risiko lingkungan.

Contoh narasi:

> SIGAP-AI mendukung Asta Cita ke-8 melalui pemanfaatan teknologi untuk memperkuat ketahanan masyarakat terhadap risiko banjir dan menjaga keberlanjutan hubungan antara manusia dan lingkungan. Sistem ini membantu masyarakat di wilayah terdampak tetap memperoleh akses pelaporan dan pertolongan ketika infrastruktur komunikasi konvensional terganggu.

Pastikan referensi terhadap Asta Cita menggunakan sumber pemerintah resmi.

# O. Sustainable Development Goals

Tambahkan section keterkaitan dengan SDGs.

SDGs utama:

### SDG 11 — Sustainable Cities and Communities

Terutama:

* pengurangan risiko bencana;
* kota dan komunitas tangguh;
* pengurangan korban serta kerugian akibat bencana.

### SDG 13 — Climate Action

Terutama:

* adaptasi terhadap risiko iklim;
* peningkatan ketahanan terhadap bencana terkait iklim;
* sistem peringatan dini.

SDGs tambahan apabila relevan:

### SDG 9 — Industry, Innovation and Infrastructure

* infrastruktur tangguh;
* inovasi komunikasi;
* teknologi untuk wilayah dengan keterbatasan jaringan.

Jangan memasukkan terlalu banyak SDGs. Utamakan SDG 11 dan SDG 13, sedangkan SDG 9 menjadi pendukung.

Jelaskan hubungan setiap SDG dengan fitur, metode, dan dampak sistem.

# P. Literature Review dan State of the Art

Susun literature review ke dalam beberapa klaster:

1. flood prediction menggunakan machine learning;
2. flood early warning system;
3. LoRa untuk komunikasi darurat;
4. LoRa multi-hop atau mesh networking;
5. store-and-forward communication;
6. emergency message prioritization;
7. offline-first disaster reporting;
8. integrasi AI dengan emergency communication.

Buat tabel state of the art dengan kolom:

| Penelitian | Tahun | Prediksi Banjir | LoRa | Multi-Hop | Prioritas Pesan | Aplikasi Warga | Dashboard | Keterbatasan |
| ---------- | ----: | --------------: | ---: | --------: | --------------: | -------------: | --------: | ------------ |

Dari tabel tersebut, rumuskan research gap secara eksplisit.

Research gap tidak boleh hanya:

> Belum ada sistem seperti SIGAP-AI.

Gunakan gap yang lebih tajam:

> Penelitian prediksi banjir umumnya bergantung pada internet untuk distribusi peringatan, sedangkan penelitian komunikasi LoRa untuk bencana umumnya belum memanfaatkan flood risk score sebagai dasar prioritas pengiriman laporan warga.

# Q. Aturan Referensi

Lakukan pencarian terhadap panduan resmi GEMASTIK tahun berjalan untuk mengetahui:

* jumlah minimum atau maksimum referensi;
* batas tahun publikasi;
* format sitasi;
* gaya referensi;
* apakah menggunakan IEEE;
* ketentuan sumber internet;
* ketentuan sumber berita;
* ketentuan similarity;
* aturan jumlah halaman;
* aturan judul;
* template karya tulis;
* aturan penggunaan AI generatif jika ada.

Prioritaskan sumber:

1. jurnal terindeks;
2. conference proceeding;
3. dokumentasi resmi pemerintah;
4. laporan resmi lembaga;
5. dataset resmi;
6. standar teknis;
7. berita kredibel hanya untuk konteks kejadian aktual.

Berita tidak boleh menjadi sumber utama untuk:

* metode;
* novelty;
* arsitektur;
* parameter eksperimen;
* klaim ilmiah;
* performa model.

Berita hanya dapat digunakan untuk:

* contoh kejadian banjir;
* dampak kerusakan komunikasi;
* kronologi bencana;
* kondisi lapangan.

Data statistik utama sebaiknya menggunakan:

* BNPB;
* BMKG;
* BIG;
* BPS;
* Komdigi;
* pemerintah daerah;
* World Bank;
* UNDRR;
* ITU;
* sumber resmi lain.

Jika aturan resmi tidak menentukan jumlah referensi, berikan rekomendasi jumlah yang wajar untuk karya ilmiah kompetisi, tetapi tandai sebagai rekomendasi, bukan aturan resmi.

# R. Contoh Karya KTI GEMASTIK Sebelumnya

Cari contoh:

* karya pemenang;
* finalis;
* juara 1, 2, dan 3;
* proceeding;
* repository universitas;
* artikel berita kampus;
* video presentasi;
* poster;
* abstrak atau full paper KTI GEMASTIK tahun sebelumnya.

Prioritaskan sumber resmi:

* laman GEMASTIK;
* Balai Pengembangan Talenta Indonesia;
* Puspresnas;
* universitas peserta;
* repository perguruan tinggi;
* Google Scholar;
* IEEE atau proceeding resmi.

Untuk setiap contoh yang ditemukan, analisis:

* judul;
* masalah;
* metode;
* novelty;
* jumlah teknologi;
* bentuk eksperimen;
* jumlah baseline;
* kekuatan hasil;
* gaya penulisan;
* struktur abstrak;
* pola presentasi;
* alasan karya tersebut tampak kompetitif.

Jangan mengklaim sebuah paper sebagai pemenang jika statusnya tidak dapat diverifikasi.

Jika full paper tidak tersedia, jelaskan bahwa analisis hanya didasarkan pada abstrak, berita, poster, atau video yang tersedia.

# S. Kelayakan dan Batas Implementasi

Revisi bagian feasibility agar lebih realistis.

Target prototipe:

* tiga node LoRa;
* satu aplikasi mobile;
* satu dashboard;
* satu backend;
* satu model prediksi;
* satu metode prioritas;
* satu alur end-to-end.

Fitur yang dapat diletakkan sebagai pengembangan lanjutan:

* mesh routing dinamis;
* banyak relay;
* HF radio;
* VSAT fisik;
* SMS gateway;
* solar panel pada semua node;
* TinyML kompleks;
* citra satelit multimodal penuh;
* integrasi langsung dengan BPBD;
* optimasi rute tim SAR;
* skala kabupaten.

Jangan menghapus visi jangka panjang, tetapi pisahkan secara jelas:

* implemented features;
* tested features;
* simulated features;
* conceptual future features.

# T. Gaya Penulisan

Gunakan bahasa Indonesia ilmiah yang:

* formal;
* jelas;
* tidak terlalu bertele-tele;
* tidak menggunakan buzzword secara berlebihan;
* konsisten dalam istilah;
* menghindari klaim absolut;
* membedakan fakta, asumsi, target, dan hasil eksperimen;
* tidak menyebut hasil yang belum diperoleh sebagai fakta.

Hindari kalimat seperti:

> Sistem ini pasti menurunkan waktu respons tim SAR.

Gunakan:

> Sistem ini dirancang untuk membantu mempercepat penyampaian laporan darurat. Dampaknya terhadap waktu respons perlu divalidasi melalui eksperimen dan uji lapangan.

Hindari klaim angka seperti:

* jangkauan 10 km;
* pengurangan response time;
* akurasi tertentu;
* penghematan biaya;
* ketahanan baterai;

kecuali memiliki sumber atau hasil pengujian.

# U. Struktur Proposal Hasil Revisi

Susun proposal hasil revisi menggunakan struktur berikut:

1. Judul
2. Abstrak
3. Kata Kunci
4. Pendahuluan
5. Latar Belakang Banjir dan Communication Blank Spot
6. Identifikasi Masalah
7. Research Gap
8. Rumusan Masalah
9. Tujuan Penelitian
10. Kontribusi Penelitian
11. Tinjauan Pustaka
12. State of the Art
13. Arsitektur dan Lapisan Teknologi
14. Dataset dan Preprocessing
15. Metode Prediksi Banjir
16. Metode Prioritas Pesan
17. Implementasi IoT dan LoRa Multi-Hop
18. Implementasi Aplikasi, Backend, dan Dashboard
19. Skenario Pengujian
20. Metrik Evaluasi
21. Luaran Penelitian
22. Rencana Hasil dan Pembahasan
23. Kelayakan Implementasi
24. Timeline
25. Keterkaitan dengan Asta Cita
26. Keterkaitan dengan SDGs
27. Limitasi
28. Rencana Pengembangan
29. Kesimpulan
30. Daftar Pustaka

Sesuaikan struktur akhir dengan template resmi GEMASTIK apabila template yang berlaku memiliki susunan berbeda.

# V. Format Output yang Diminta

Berikan hasil revisi dalam urutan berikut:

1. Ringkasan masalah proposal lama.
2. Daftar bagian yang harus dihapus, dipertahankan, disederhanakan, dan ditambahkan.
3. Usulan fokus penelitian final.
4. Sepuluh alternatif judul beserta jumlah katanya.
5. Arsitektur sistem final.
6. Diagram alur sistem dalam bentuk teks dan Mermaid.
7. Penjelasan setiap technology layer.
8. Rumusan research gap.
9. Rumusan masalah.
10. Tujuan penelitian.
11. Tiga kontribusi ilmiah utama.
12. Proposed method lengkap.
13. Struktur data paket LoRa.
14. Rekomendasi dataset.
15. Bentuk tabel dataset.
16. Tahapan preprocessing.
17. Model baseline dan model utama.
18. Output atau luaran penelitian.
19. Rancangan eksperimen.
20. Metrik evaluasi.
21. Rencana hasil dan pembahasan.
22. Revisi timeline.
23. Narasi Asta Cita.
24. Narasi SDGs.
25. Aturan referensi berdasarkan panduan resmi.
26. Daftar dan analisis contoh karya KTI GEMASTIK sebelumnya.
27. Draft proposal hasil revisi secara utuh.

# W. Aturan Validitas Informasi

* Gunakan sumber terbaru dan kredibel.
* Verifikasi seluruh aturan GEMASTIK melalui panduan resmi tahun berjalan.
* Jangan mengarang batas jumlah kata judul, jumlah referensi, jumlah halaman, atau format sitasi.
* Bedakan aturan resmi dengan rekomendasi.
* Setiap statistik harus memiliki referensi.
* Setiap dataset harus disertai sumber akses.
* Setiap karya pemenang GEMASTIK harus disertai bukti status kemenangan.
* Jangan mengklaim teknologi telah diimplementasikan jika baru direncanakan.
* Jangan menulis hasil eksperimen fiktif.
* Untuk tabel hasil, gunakan placeholder seperti “akan diisi berdasarkan hasil pengujian”.
* Cantumkan limitasi dan risiko implementasi secara jujur.
* Prioritaskan kualitas penelitian daripada jumlah fitur.

# X. Arah Akhir Proposal

Arah akhir penelitian yang direkomendasikan adalah:

> **SIGAP-AI sebagai sistem prediksi risiko banjir dan komunikasi darurat berbasis LoRa multi-hop yang menggunakan tingkat risiko dan urgensi untuk menentukan prioritas pengiriman laporan warga pada wilayah communication blank spot.**

Kontribusi utama harus diringkas menjadi:

1. metode risk- and urgency-aware message prioritization;
2. arsitektur offline-first BLE–LoRa multi-hop–gateway–dashboard;
3. validasi eksperimental berdasarkan reliability, latency, packet delivery ratio, dan keberhasilan penyampaian pesan darurat.

Aplikasi, dashboard, dan hardware harus diposisikan sebagai **testbed untuk membuktikan metode**, bukan sebagai novelty utama.

---

Bagian yang paling penting dari prompt ini adalah memastikan hasil revisi tidak sekadar “mengurangi fitur”, tetapi mengubah proposal dari rancangan sistem yang luas menjadi **penelitian yang fokus, dapat diuji, memiliki baseline, dan menghasilkan kontribusi ilmiah yang spesifik**.