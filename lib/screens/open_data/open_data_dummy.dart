class OpenDataModel {
  final String title;
  final String content;
  final String date;
  final String category;
  final String image;

  final String totalDataset;
  final String totalPerangkatDaerah;
  final String totalArtikel;
  final String totalPengunjung;
  final String totalInfografik;
  final String totalPublikasi;

  final List<double> visitorChart;
  final List<double> downloadChart;

  OpenDataModel({
    required this.title,
    required this.content,
    required this.date,
    required this.category,
    required this.image,
    required this.totalDataset,
    required this.totalPerangkatDaerah,
    required this.totalArtikel,
    required this.totalPengunjung,
    required this.totalInfografik,
    required this.totalPublikasi,
    required this.visitorChart,
    required this.downloadChart,
  });
}

class HighlightDataModel {
  final String title;
  final String instansi;
  final String tahun;
  final String kategori;
  final String tanggal;
  final String status;

  HighlightDataModel({
    required this.title,
    required this.instansi,
    required this.tahun,
    required this.kategori,
    required this.tanggal,
    required this.status,
  });
}

final List<String> dummyOrganisasi = [

  "Badan Kepegawaian Daerah Provinsi Jawa Timur",

  "Badan Kesatuan Bangsa dan Politik Provinsi Jawa Timur",

  "Badan Koordinasi Wilayah Pembangunan dan Pemerintahan II Bojonegoro Provinsi Jawa Timur",

  "Badan Penanggulangan Bencana Daerah Provinsi Jawa Timur",

  "Badan Pendapatan Daerah Provinsi Jawa Timur",

  "Dinas Kesehatan Provinsi Jawa Timur",

  "Dinas Pendidikan Provinsi Jawa Timur",

  "Dinas Sosial Provinsi Jawa Timur",

  "Dinas Komunikasi dan Informatika Provinsi Jawa Timur",

  "Dinas Lingkungan Hidup Provinsi Jawa Timur",

  "Kabupaten Banyuwangi",

  "Kabupaten Jember",

  "Kabupaten Malang",

  "Kota Surabaya",

  "Rumah Sakit Umum Daerah Dr. Soetomo Surabaya Provinsi Jawa Timur",

  "Rumah Sakit Umum Daerah Husada Prima",

  "Sekretariat DPRD Provinsi Jawa Timur",
];

final List<String> dummyTopik = [

  "Ekonomi",

  "Infrastruktur",

  "Kemiskinan",

  "Kependudukan",

  "Kesehatan",

  "Lingkungan Hidup",

  "Pemerintah & Desa",

  "Pendidikan",

  "Sosial",

  "Tata Ruang",
];

final List<OpenDataModel> dummyOpenData = [
  OpenDataModel(
    title: "Realisasi Investasi Jawa Timur Tahun 2025 Tembus Rp. 147,7 Triliun",
    content: "Alhamdulillah, investasi Jawa Timur tahun 2025 tembus Rp 147,7 triliun dan trennya konsisten tumbuh sejak 2024.\n\nKomitmen ini didominasi PMDN dan PMA yang terus meningkat.\n\nMenurut Pemerintah Jawa Timur, sektor investasi terus bergerak positif dan berdampak pada ekonomi.",
    date: "08 April 2026",
    category: "Ekonomi",
    image: "assets/images/open_data_banner3.png",
    
    totalDataset: "40.204",
    totalPerangkatDaerah: "64",
    totalArtikel: "22",
    totalPengunjung: "100rb",
    totalInfografik: "510",
    totalPublikasi: "18",
    visitorChart: [3200, 2100, 1100, 500],
    downloadChart: [3000, 2000, 1000, 500],
  ),

  OpenDataModel(
    title: "Data Kependudukan Berdasarkan Wilayah",
    content: "Laporan lengkap mengenai persebaran penduduk di berbagai wilayah Jawa Timur pada kuartal pertama 2026.",
    date: "10 April 2026",
    category: "Sosial",
    image: "assets/images/open_data_banner2.png",

    totalDataset: "40.204",
    totalPerangkatDaerah: "64",
    totalArtikel: "22",
    totalPengunjung: "100rb",
    totalInfografik: "510",
    totalPublikasi: "18",

    visitorChart: [3200, 2100, 1100, 500],
    downloadChart: [3000, 2000, 1000, 500],
  ),
  OpenDataModel(
    title: "Publikasi Indeks Pembangunan Manusia",
    content: "Peningkatan IPM Jawa Timur menunjukkan keberhasilan program pendidikan dan kesehatan yang merata.",
    date: "12 April 2026",
    category: "Kesehatan",
    image: "assets/images/open_data_banner1.png",

    totalDataset: "40.204",
    totalPerangkatDaerah: "64",
    totalArtikel: "22",
    totalPengunjung: "100rb",
    totalInfografik: "510",
    totalPublikasi: "18",

    visitorChart: [3200, 2100, 1100, 500],
    downloadChart: [3000, 2000, 1000, 500],
  ),
];

final List<HighlightDataModel> dummyHighlightData = [

  HighlightDataModel(
    title:
        "Jumlah Hari Perawatan (Rawat Inap) Berdasarkan Kelas",

    instansi:
        "Rumah Sakit Umum Daerah Husada Prima",

    tahun: "2020 - 2025",

    kategori: "Kesehatan",

    tanggal: "21 April 2025",

    status: "Tetap",
  ),

  HighlightDataModel(
    title:
        "Jumlah Layanan Radiologi Berdasarkan Jenis Kegiatan",

    instansi:
        "Rumah Sakit Umum Daerah Husada Prima",

    tahun: "2020 - 2025",

    kategori: "Kesehatan",

    tanggal: "21 April 2025",

    status: "Tetap",
  ),

  HighlightDataModel(
    title:
        "Jumlah Anak yang Menikah di bawah 19 Tahun berdasarkan Jenis Kelamin",

    instansi:
        "Dinas Pemberdayaan Perempuan, Perlindungan Anak dan Kependudukan",

    tahun: "2020 - 2025",

    kategori: "Kependudukan",

    tanggal: "21 April 2025",

    status: "Tetap",
  ),

  HighlightDataModel(
  title:
      "Jumlah Penyaluran Dana Desa Menurut Kabupaten/Kota di Jawa Timur",

  instansi:
      "Dinas Pemberdayaan Masyarakat dan Desa Provinsi Jawa Timur",

  tahun: "2020 - 2025",

  kategori: "Ekonomi",

  tanggal: "21 April 2025",

  status: "Tetap",
),

HighlightDataModel(
  title:
      "Jumlah koperasi berdasarkan status keaktifan",

  instansi:
      "Dinas Pemberdayaan Masyarakat dan Desa Provinsi Jawa Timur",

  tahun: "2020 - 2025",

  kategori: "Ekonomi",

  tanggal: "21 April 2025",

  status: "Tetap",
),

HighlightDataModel(
  title:
      "Jumlah tenaga kerja koperasi",

  instansi:
      "Dinas Pemberdayaan Masyarakat dan Desa Provinsi Jawa Timur",

  tahun: "2020 - 2025",

  kategori: "Ekonomi",

  tanggal: "21 April 2025",

  status: "Tetap",
),

HighlightDataModel(
  title:
      "Jumlah Koperasi Aktif berdasarkan kelompok",

  instansi:
      "Dinas Pemberdayaan Masyarakat dan Desa Provinsi Jawa Timur",

  tahun: "2020 - 2025",

  kategori: "Ekonomi",

  tanggal: "21 April 2025",

  status: "Tetap",
),
];

class DataTableModel {

  final int id;
  final String periode;

  DataTableModel({
    required this.id,
    required this.periode,
  });
}

final List<DataTableModel> dummyTableData = [

  DataTableModel(
    id: 1,
    periode: "Maret 2026",
  ),

  DataTableModel(
    id: 2,
    periode: "Januari 2026",
  ),

  DataTableModel(
    id: 3,
    periode: "Februari 2026",
  ),

  DataTableModel(
    id: 4,
    periode: "Maret 2026",
  ),

  DataTableModel(
    id: 5,
    periode: "Desember 2026",
  ),

  DataTableModel(
    id: 6,
    periode: "April 2026",
  ),

  DataTableModel(
    id: 7,
    periode: "Mei 2026",
  ),

  DataTableModel(
    id: 8,
    periode: "Juni 2026",
  ),
];