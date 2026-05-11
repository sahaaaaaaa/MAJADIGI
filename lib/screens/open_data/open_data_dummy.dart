class OpenDataModel {
  final String title;
  final String content;
  final String date;
  final String category;
  final String image;

  OpenDataModel({
    required this.title,
    required this.content,
    required this.date,
    required this.category,
    required this.image,
  });
}

final List<OpenDataModel> dummyOpenData = [
  OpenDataModel(
    title: "Realisasi Investasi Jawa Timur Tahun 2025 Tembus Rp. 147,7 Triliun",
    content: "Alhamdulillah, investasi Jawa Timur tahun 2025 tembus Rp 147,7 triliun dan trennya konsisten tumbuh sejak 2024.\n\nKomitmen ini didominasi PMDN dan PMA yang terus meningkat.\n\nMenurut Pemerintah Jawa Timur, sektor investasi terus bergerak positif dan berdampak pada ekonomi.",
    date: "08 April 2026",
    category: "Ekonomi",
    image: "assets/images/open_data_banner3.png",
  ),
  OpenDataModel(
    title: "Data Kependudukan Berdasarkan Wilayah",
    content: "Laporan lengkap mengenai persebaran penduduk di berbagai wilayah Jawa Timur pada kuartal pertama 2026.",
    date: "10 April 2026",
    category: "Sosial",
    image: "assets/images/open_data_banner2.png",
  ),
  OpenDataModel(
    title: "Publikasi Indeks Pembangunan Manusia",
    content: "Peningkatan IPM Jawa Timur menunjukkan keberhasilan program pendidikan dan kesehatan yang merata.",
    date: "12 April 2026",
    category: "Kesehatan",
    image: "assets/images/open_data_banner1.png",
  ),
];