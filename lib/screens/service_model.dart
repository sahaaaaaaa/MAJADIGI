// service_model.dart
class Recommendation {
  final int id;
  final String title;
  final String description;
  final String logo;
  final String kategori;

  Recommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.logo,
    required this.kategori,
  });
}

class NewsArticle {
  final int id;
  final String title;
  final String content;
  final String date;
  final String imageUrl;
  final String category; // Contoh: Hoaks, Fakta, Disinformasi

  NewsArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.imageUrl,
    required this.category,
  });
}

List<NewsArticle> dummyNews = [
  NewsArticle(
    id: 1,
    title: "Dubes AS & Gus Yahya Ajak Umat Islam Kecam Tindakan Iran",
    date: "08 April 2026",
    category: "Hoaks",
    imageUrl: "assets/news1.png",
    content: "Beredar unggahan di media sosial yang menampilkan pertemuan antara Duta Besar Amerika Serikat dan Ketua Umum PBNU...",
  ),
  // Tambahkan berita lainnya sesuai desain
];

final List<Recommendation> recommendations = [
  Recommendation(
    id: 1, 
    title: 'RSUD Dr. Saiful Anwar', 
    description: 'Layanan kesehatan rujukan utama Jawa Timur', 
    logo: 'rsud_saiful.png', 
    kategori: 'Kesehatan'
  ),
  Recommendation(
    id: 2, 
    title: 'RSUD Haji', 
    description: 'Pelayanan kesehatan berkualitas dan islami', 
    logo: 'rsud_haji.png', 
    kategori: 'Kesehatan'
  ),
  Recommendation(
    id: 3, 
    title: 'Destinasi Wisata', 
    description: 'Eksplorasi keindahan alam dan budaya Jatim', 
    logo: 'wisata.png', 
    kategori: 'Pariwisata & Kebudayaan' 
  ),
  Recommendation(
    id: 4, 
    title: 'Islamic Center', 
    description: 'Pusat informasi dan kegiatan keagamaan', 
    logo: 'islamic_center.png', 
    kategori: 'Sosial' 
  ),
  Recommendation(
    id: 5, 
    title: 'Open Data', 
    description: 'Transparansi data publik untuk masyarakat', 
    logo: 'open_data.png', 
    kategori: 'PPID'
  ),
  Recommendation(
    id: 6, 
    title: 'Klinik Hoaks', 
    description: 'Verifikasi informasi dan cek fakta digital', 
    logo: 'klinik_hoak.png', 
    kategori: 'Multisektor (Khusus)'
  ),
  Recommendation(
    id: 7, 
    title: 'Harga Bahan Pokok', 
    description: 'Pantau harga pangan pasar secara real-time', 
    logo: 'harga_pangan.png', 
    kategori: 'Ekonomi & Bisnis' 
  ),
  Recommendation(
    id: 8, 
    title: 'Kontak Darurat', 
    description: 'Layanan cepat tanggap darurat 24 jam', 
    logo: 'emergency.png', 
    kategori: 'Kebencanaan' 
  ),
  Recommendation(
    id: 9, 
    title: 'Transjatim', 
    description: 'Informasi rute transportasi publik Jatim', 
    logo: 'transjatim.png', 
    kategori: 'Infrastruktur'
  ),
  Recommendation(
    id: 10, 
    title: 'Point Jatim', 
    description: 'Sistem poin terintegrasi layanan warga', 
    logo: 'point_jatim.png', 
    kategori: 'Kependudukan'
  ),
];
