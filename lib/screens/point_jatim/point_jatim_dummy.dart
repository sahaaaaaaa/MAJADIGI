class PointJatimHighlightModel {
  final String image;
  final String title;
  final String subtitle;

  const PointJatimHighlightModel({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class PointJatimProjectModel {
  final String image;
  final String category;
  final String title;
  final String lokasi;
  final String harga;
  final String tahun;
  final List<String> infomemoImages;

  const PointJatimProjectModel({
    required this.image,
    required this.category,
    required this.title,
    required this.lokasi,
    required this.harga,
    required this.tahun,
    required this.infomemoImages,
  });
}

class PointJatimDummy {
  static const String pageTitle = 'POINT JATIM';

  static const List<String> kategoriList = [
    'Semua',
    'Peternakan',
    'Industri',
    'UMKM',
    'Pertanian',
  ];

  static const List<PointJatimHighlightModel> highlights = [
  PointJatimHighlightModel(
    image: 'assets/images/pointJatim/pasar_agrobis.png',
    title: 'Pasar Agrobis',
    subtitle: 'Pengembangan Pasar Agrobis Kota Batu',
  ),

  PointJatimHighlightModel(
    image: 'assets/images/pointJatim/biofarmaka.png',
    title: 'BIOFARMAKA',
    subtitle: 'Proyek Pengembangan Biofarmaka',
  ),

  PointJatimHighlightModel(
    image: 'assets/images/pointJatim/pengembangan_susu_sapi.png',
    title: 'Digital Smart',
    subtitle: 'Pengembangan Smart Industry',
  ),
];

  static const List<PointJatimProjectModel> projects = [
  PointJatimProjectModel(
    image:
        'assets/images/pointJatim/peternakan_sapi_perah_terintegrasi.png',
    category: 'Peternakan',
    title: 'Peternakan Sapi Perah Terintegrasi Modern',
    lokasi: 'Pujon, Kabupaten Malang',
    harga: 'Rp 16,00 Miliar',
    tahun: '2025',
    infomemoImages: [
      'assets/images/pointJatim/infomemo_peternakan_sapi1.png',
      'assets/images/pointJatim/infomemo_peternakan_sapi2.png',
    ],
  ),

  PointJatimProjectModel(
    image: 'assets/images/pointJatim/rsud_kajuruhan.png',
    category: 'Kesehatan',
    title: 'RSUD Kanjuruhan',
    lokasi: 'Malang',
    harga: 'Rp 216,43 Miliar',
    tahun: '2024',
    infomemoImages: [
      'assets/images/pointJatim/infomemo_rsud_kajuruhan1.png',
    ],
  ),

  PointJatimProjectModel(
    image:
        'assets/images/pointJatim/pengembangan_susu_sapi.png',
    category: 'Peternakan',
    title: 'Pengembangan Susu Sapi',
    lokasi: 'Pujon, Kabupaten Malang',
    harga: 'Rp 110,00 Miliar',
    tahun: '2023',
    infomemoImages: [
      'assets/images/pointJatim/infomemo_pengembangan_susu_sapi2.png',
    ],
  ),
];
}

class PointJatimDetailDummy {
  static const String deskripsi =
      'Proyek Integrated Farming Sapi Perah merupakan proyek strategis yang diinisiasi oleh Dinas Peternakan Pemerintah Provinsi Jawa Timur dalam program Investment Project Ready to Offer dalam rangka mendukung pengembangan investasi yang berbasis ESG (Environmental, Social and Governance) serta peningkatan industri pertanian dan peternakan dalam rangka program ketahanan pangan di Indonesia. Hal ini sesuai dengan trend investasi global pada program ekonomi hijau secara berkelanjutan. Lokasi proyek dikembangkan pada wilayah Desa Ngroto Kecamatan Pujon, Kabupaten Malang Provinsi Jawa Timur dengan dasar pertimbangan kesesuaian lahan yang telah memenuhi aspek geografis, topografi, demografi dan aspek-aspek pendukung strategis lainnya seperti dekat dengan potensi market, sumber pakan alamiah dan lokasi merupakan klaster terbesar produksi susu sapi segar di Jawa Timur.';
}