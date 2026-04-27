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
    logo: 'klinik_hoaks.png', 
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
