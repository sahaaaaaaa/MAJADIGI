// service_model.dart
import 'package:flutter/material.dart';
import 'package:majadigi/screens/destinasi_wisata/destinasi_wisata_screen.dart';
import 'package:majadigi/screens/harga_barang/harga_bahan_pokok_screen.dart';
import 'package:majadigi/screens/islamic_center/islamic_center_home_screen.dart';
import 'package:majadigi/screens/klinik_hoax/klinik_hoax_home_screen.dart';
import 'package:majadigi/screens/nomor%20darurat/nomor_darurat.dart';
import 'package:majadigi/screens/open_data/open_data_screen.dart';
import 'package:majadigi/screens/point_jatim/point_jatim_home_screen.dart';
import 'package:majadigi/screens/rssa/rssa_screen.dart';
import 'package:majadigi/screens/rsud_provjatim/rsud_jatim.dart';
import 'package:majadigi/screens/transjatim/transjatim_screen.dart';
import 'package:majadigi/services/layanan_service.dart';

class Recommendation {
  final int id;
  final String title;
  final String description;
  final String logo;
  final String kategori;
  final String? nawaBhakti;
  final Widget? screen;

  Recommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.logo,
    required this.kategori,
    this.nawaBhakti,
    this.screen,
  });
}

Recommendation recommendationFromLayanan(LayananModel layanan) {
  return Recommendation(
    id: layanan.id,
    title: layananDisplayTitle(layanan.name),
    description: layanan.description,
    logo: layananLogoAssetName(layanan.name),
    kategori: layananCategoryName(layanan.name, layanan.categoryName),
    nawaBhakti: layananNawaBhaktiSatyaName(
      layanan.name,
      layanan.nawaBhaktiSatya,
    ),
  );
}

String layananCategoryName(String name, String fallback) {
  final normalized = name.toLowerCase();

  if (normalized.contains('rsud')) {
    return 'Kesehatan';
  }
  if (normalized.contains('destinasi')) {
    return 'Pariwisata & Kebudayaan';
  }
  if (normalized.contains('islamic')) {
    return 'Sosial';
  }
  if (normalized.contains('open data')) {
    return 'Kependudukan';
  }
  if (normalized.contains('klinik hoaks')) {
    return 'Multisektor (Khusus)';
  }
  if (normalized.contains('harga') || normalized.contains('point jatim')) {
    return 'Ekonomi & Bisnis';
  }
  if (normalized.contains('nomor darurat')) {
    return 'Kebencanaan';
  }
  if (normalized.contains('transjatim')) {
    return 'Infrastruktur';
  }

  return fallback.isEmpty ? 'Layanan' : fallback;
}

String layananDisplayTitle(String name) {
  final normalized = name.toLowerCase();

  if (normalized.contains('saiful anwar')) {
    return 'RSUD Dr. Saiful Anwar';
  }
  if (normalized.contains('rsud haji')) {
    return 'RSUD Haji';
  }
  if (normalized.contains('transjatim')) {
    return 'Transjatim';
  }
  if (normalized.contains('point jatim')) {
    return 'Point Jatim';
  }
  if (normalized.contains('islamic')) {
    return 'Islamic Center';
  }

  return name;
}

String layananNawaBhaktiSatyaName(String name, String fallback) {
  final normalized = name.toLowerCase();

  if (normalized.contains('transjatim') ||
      normalized.contains('nomor darurat')) {
    return 'Jatim Akses';
  }
  if (normalized.contains('islamic')) {
    return 'Jatim Harmoni';
  }
  if (normalized.contains('saiful anwar') || normalized.contains('rsud haji')) {
    return 'Jatim Sehat';
  }

  return fallback;
}

String layananLogoAssetName(String name) {
  final normalized = name.toLowerCase();

  if (normalized.contains('open data')) {
    return 'open_data.png';
  }
  if (normalized.contains('klinik hoaks')) {
    return 'klinik_hoax.png';
  }
  if (normalized.contains('harga')) {
    return 'khas_jatim.png';
  }
  if (normalized.contains('nomor darurat')) {
    return 'icons/ambulans.svg';
  }
  if (normalized.contains('rsud haji')) {
    return 'rsud_haji.png';
  }
  if (normalized.contains('saiful anwar')) {
    return 'rsud_saifulanwar.png';
  }
  if (normalized.contains('transjatim')) {
    return 'transjatim_ajaib.png';
  }
  if (normalized.contains('point jatim')) {
    return 'point_jatim.png';
  }
  if (normalized.contains('islamic')) {
    return 'islamic_center.png';
  }
  if (normalized.contains('destinasi')) {
    return 'destinasi_wisata.png';
  }

  return 'klinik_hoax.png';
}

String layananLogoAssetPath(String logo) {
  if (logo.startsWith('assets/')) {
    return logo;
  }

  return 'assets/images/$logo';
}

final List<Recommendation> backendLayananFallbackRecommendations = [
  Recommendation(
    id: 1,
    title: 'Open Data',
    description: 'Transparansi data publik untuk masyarakat',
    logo: 'open_data.png',
    kategori: 'Kependudukan',
    screen: const OpenDataScreen(),
  ),
  Recommendation(
    id: 2,
    title: 'Klinik Hoaks',
    description: 'Verifikasi informasi dan cek fakta digital',
    logo: 'klinik_hoax.png',
    kategori: 'Kependudukan',
    screen: const KlinikHoaksHomeScreen(),
  ),
  Recommendation(
    id: 3,
    title: 'Harga Bahan Pokok',
    description: 'Pantau harga pangan pasar secara real-time',
    logo: 'khas_jatim.png',
    kategori: 'Ekonomi & Bisnis',
  ),
  Recommendation(
    id: 4,
    title: 'Nomor Darurat',
    description: 'Layanan cepat tanggap darurat 24 jam',
    logo: 'icons/ambulans.svg',
    kategori: 'Kependudukan',
    nawaBhakti: 'Jatim Akses',
  ),
  Recommendation(
    id: 5,
    title: 'RSUD Haji',
    description: 'Pelayanan kesehatan berkualitas dan islami',
    logo: 'rsud_haji.png',
    kategori: 'Kesehatan',
    nawaBhakti: 'Jatim Sehat',
  ),
  Recommendation(
    id: 6,
    title: 'RSUD Dr. Saiful Anwar',
    description: 'Layanan kesehatan rujukan utama Jawa Timur',
    logo: 'rsud_saifulanwar.png',
    kategori: 'Kesehatan',
    nawaBhakti: 'Jatim Sehat',
  ),
  Recommendation(
    id: 7,
    title: 'Transjatim',
    description: 'Informasi rute transportasi publik Jatim',
    logo: 'transjatim_ajaib.png',
    kategori: 'Kependudukan',
    nawaBhakti: 'Jatim Akses',
  ),
  Recommendation(
    id: 8,
    title: 'Point Jatim',
    description: 'Sistem poin terintegrasi layanan warga',
    logo: 'point_jatim.png',
    kategori: 'Ekonomi & Bisnis',
    screen: PointJatimHomeScreen(),
  ),
  Recommendation(
    id: 9,
    title: 'Islamic Center',
    description: 'Pusat informasi dan kegiatan keagamaan',
    logo: 'islamic_center.png',
    kategori: 'Ekonomi & Bisnis',
    nawaBhakti: 'Jatim Harmoni',
    screen: const IslamicCenterHomeScreen(),
  ),
  Recommendation(
    id: 10,
    title: 'Destinasi Wisata',
    description: 'Eksplorasi keindahan alam dan budaya Jatim',
    logo: 'destinasi_wisata.png',
    kategori: 'Pariwisata & Kebudayaan',
    screen: const DestinasiWisataScreen(),
  ),
];

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
    content:
        "Beredar unggahan di media sosial yang menampilkan pertemuan antara Duta Besar Amerika Serikat dan Ketua Umum PBNU...",
  ),
  // Tambahkan berita lainnya sesuai desain
];

final List<Recommendation> recommendations = [
  Recommendation(
    id: 1, 
    title: 'RSUD Dr. Saiful Anwar', 
    description: 'Layanan kesehatan rujukan utama Jawa Timur', 
    logo: 'rsud_saifulanwar.png', 
    kategori: 'Kesehatan',
    nawaBhakti: 'Jatim Sehat',
    screen: const RssaScreen(),
  ),
  Recommendation(
    id: 2, 
    title: 'RSUD Haji Prov. Jatim ', 
    description: 'Pelayanan kesehatan berkualitas dan islami', 
    logo: 'rsud_haji.png', 
    kategori: 'Kesehatan',
    screen: const RsudHajiScreen(),
    nawaBhakti: 'Jatim Sehat',
  ),
  Recommendation(
    id: 3,
    title: 'Destinasi Wisata',
    description: 'Eksplorasi keindahan alam dan budaya Jatim',
    logo: 'destinasi_wisata.png',
    kategori: 'Pariwisata & Kebudayaan',
    screen: const DestinasiWisataScreen(),
  ),
  Recommendation(
    id: 4,
    title: 'Islamic Center',
    description: 'Pusat informasi dan kegiatan keagamaan',
    logo: 'islamic_center.png',
    kategori: 'Sosial',
    nawaBhakti: 'Jatim Harmoni',
    screen: const IslamicCenterHomeScreen(),
    nawaBhakti: 'Jatim Harmoni',
  ),
  Recommendation(
    id: 5, 
    title: 'Open Data', 
    description: 'Transparansi data publik untuk masyarakat', 
    logo: 'open_data.png', 
    kategori: 'Multisektor (Khusus)',
    screen: const OpenDataScreen(),
  ),
  Recommendation(
    id: 6,
    title: 'Klinik Hoaks',
    description: 'Verifikasi informasi dan cek fakta digital',
    logo: 'klinik_hoax.png',
    kategori: 'Multisektor (Khusus)',
    screen: KlinikHoaksHomeScreen(),
  ),
  Recommendation(
    id: 7, 
    title: 'Harga Bahan Pokok', 
    description: 'Pantau harga pangan pasar secara real-time', 
    logo: 'LogoJawaTimur.png', 
    kategori: 'Ekonomi & Bisnis',
    nawaBhakti: 'Jatim Sejahtera',
    screen: const HargaBahanPokokScreen(),
  ),
  Recommendation(
    id: 8, 
    title: 'Nomor Darurat', 
    description: 'Layanan cepat tanggap darurat 24 jam', 
    logo: 'LogoJawaTimur.png', 
    kategori: 'Kebencanaan',
    nawaBhakti: 'Jatim Akses',
    screen: const NomorDaruratScreen(),
  ),
  Recommendation(
    id: 9, 
    title: 'Transjatim AJAIB 2.0', 
    description: 'Informasi rute transportasi publik Jatim', 
    logo: 'transjatim_ajaib.png', 
    kategori: 'Infrastruktur',
    nawaBhakti: 'Jatim Akses',
    screen: const TransjatimScreen(),
  ),
  Recommendation(
    id: 10,
    title: 'Point Jatim',
    description: 'Sistem poin terintegrasi layanan warga',
    logo: 'point_jatim.png',
    kategori: 'Kependudukan',
    screen: PointJatimHomeScreen(),
  ),
  Recommendation(
    id: 11, 
    title: 'SKOPI', 
    description: 'Koleksi khas semua tentang Jawa Timur', 
    logo: 'SKOPI.png', 
    kategori: 'Infrastruktur',
    nawaBhakti: 'Jatim Agro',
  ),
  Recommendation(
  id: 12,
  title: 'Kidungan',
  description: 'Koleksi khas semua tentang Jawa Timur',
  logo: 'kidungan.jpg',
  kategori: 'Lingkungan Hidup',
  nawaBhakti: 'Jatim Agro',
  ),

  Recommendation(
    id: 13,
    title: 'Peta potensi tembakau',
    description: 'Koleksi khas semua tentang Jawa Timur',
    logo: 'klinik_hoax.png',
    kategori: 'Ekonomi & Bisnis',
    nawaBhakti: 'Jatim Agro',
  ),

  Recommendation(
    id: 14,
    title: 'Pemesanan Bibit Hortikultura',
    description: 'Koleksi khas semua tentang Jawa Timur',
    logo: 'klinik_hoax.png',
    kategori: 'Ekonomi & Bisnis',
    nawaBhakti: 'Jatim Agro',
  ),

  Recommendation(
    id: 15,
    title: 'Pusaka Jawatimuran',
    description:'Koleksi khas semua tentang Jawa Timur',
    logo: 'klinik_hoax.png',
    kategori:'Pariwisata & Kebudayaan',
  ),

  Recommendation(
    id: 16,
    title: 'Paket Kunjungan Agrowisata',
    description: 'Agrowisata Puspa Lebo',
    logo: 'LogoJawaTimur.png',
    kategori: 'Pariwisata & Kebudayaan',
    nawaBhakti: 'Jatim Cerdas',
  ),

  Recommendation(
    id: 17,
    title: 'Khas Jatim',
    description: 'Koleksi khas semua tentang Jawa Timur',
    logo: 'khas_jatim.png',
    kategori:'Pariwisata & Kebudayaan',
    nawaBhakti: 'Jatim Harmoni',
  ),

  Recommendation(
    id: 18,
    title: 'Cak Durasim',
    description:'Koleksi khas semua tentang Jawa Timur',
    logo: 'cak_durasim.png',
    kategori:'Pariwisata & Kebudayaan',
    nawaBhakti: 'Jatim Harmoni',
  ),

  Recommendation(
    id: 19,
    title: 'Virtual Tour 360',
    description: 'Koleksi khas semua tentang Jawa Timur',
    logo: 'klinik_hoax.png',
    kategori:'Pariwisata & Kebudayaan',
    nawaBhakti: 'Jatim Lestari',
  ),

  Recommendation(
    id: 20,
    title: 'Klinik Online Disnak Jatim',
    description: 'Pusat Informasi dan Konsultasi Hewan Online Jatim',
    logo: 'LogoJawaTimur.png',
    kategori: 'Kesehatan',
    nawaBhakti: 'Jatim Sehat',
  ),

  Recommendation(
    id: 21,
    title: 'Smart Kampung Bayuwangi',
    description:'layanan publik berbasis digital Pemerintah Kab. Bayuwangi',
    logo: 'LogoJawaTimur.png',
    kategori:'Kependudukan',
    nawaBhakti: 'Jatim Lestari',
  ),

  Recommendation(
    id: 22,
    title: 'LAPOR PAK (Layanan Perempuan dan Anak Korban Kekerasan)',
    description: 'layanan Perempuan dan Anak Korban Kekerasan',
    logo: 'lapor_pak.png',
    kategori: 'Sosial',
    nawaBhakti: 'Jatim Sejahtera',
  ),

  Recommendation(
    id: 23,
    title: 'Ngajuk Smart City',
    description: 'Aplikasi Nganjuk Smart City portal layanan digital Kabupaten Nganjuk',
    logo: 'nganjuk_smartcity.png',
    kategori: 'Pariwisata & Kebudayaan',
    nawaBhakti: 'Jatim Akses',
  ),

  Recommendation(
    id: 24,
    title: 'SIMPEL K3 (Sistem Pelayanan K3L)',
    description: 'Sistem Pelayanan Keselamatan dan Kesehatan Kerja (SIMPLE K3) berbasis web',
    logo: 'LogoJawaTimur.png',
    kategori: 'Ketenagakerjaan',
    nawaBhakti: 'Jatim Kerja',
  ),

  Recommendation(
    id: 25,
    title: 'Informasi Pelatihan Kerja',
    description: 'Akses informasi pelatihan kerja sesuai minat dan bidangmu untuk persiapan karir',
    logo: 'LogoJawaTimur.png',
    kategori: 'Ketenagakerjaan',
    nawaBhakti: 'Jatim Kerja',
  ),

  Recommendation(
    id: 26,
    title: 'Informasi Lowongan Kerja',
    description: 'Akses mudah ke berbagai lowongan kerja terpercaya dari Disnaker di Jawa Timur',
    logo: 'LogoJawaTimur.png',
    kategori: 'Ketenagakerjaan',
    nawaBhakti: 'Jatim Kerja',
  ),

  Recommendation(
    id: 27,
    title: 'Siparimanta',
    description: 'Layanan online permohonan magang/penelitian/PKL, dan permintaan data di Pelabuhan Perikanan Pantai Bulu.',
    logo: 'siparimanta.jpg',
    kategori: 'Pendidikan',
    nawaBhakti: 'Jatim Cerdas',
  ),
  Recommendation(
    id: 28,
    title: 'Ruang Juru',
    description: 'Aplikasi Bahan Ajar Operasi dan Pemeliharaan operasional irigasi Dinas PU Sumber Daya Air',
    logo: 'ruang_juru.jpg',
    kategori: 'Pendidikan',
    nawaBhakti: 'Jatim Cerdas',
  ),
  Recommendation(
    id: 29,
    title: 'E-KWU Cabdin Pasuruan',
    description: 'Produk Kreatif dan Kewirausahaan SMA, SMK & SLB Pasuruan Raya',
    logo: 'e_kwu_cabdin_pasuruan.jpg',
    kategori: 'Pendidikan',
    nawaBhakti: 'Jatim Cerdas',
  ),
  Recommendation(
    id: 30,
    title: 'SIM RUSUN',
    description: 'Sistem Informasi Rumah Susun dan Rumdis',
    logo: 'LogoJawaTimur.png',
    kategori: 'Infrastruktur',
    nawaBhakti: 'Jatim Sejahtera',
  ),
  Recommendation(
    id: 31,
    title: 'SIJAWARA+',
    description: 'layanan Pembelajaran untuk meningkatkan wawasan tentang perkoperasian dan pengembangan bisnis UMKM',
    logo: 'sijawara.png',
    kategori: 'Ekonomi & Bisnis',
    nawaBhakti: 'Jatim Sejahtera',
  ),
  Recommendation(
    id: 32,
    title: 'SIKIPO JATIM',
    description: 'Sistem Keterbukaan Informasi Publik Online',
    logo: 'LogoJawaTimur.png',
    kategori: 'Pemerintahan & Desa',
    nawaBhakti: 'Jatim Berkah & Amanah',
  ),
  Recommendation(
    id: 33,
    title: 'Rumah ASN',
    description: 'Ruang menjawab aspirasi ASN dan masyarakat umum seputar kepegawaian',
    logo: 'rumahAsn.png',
    kategori: 'Pemerintahan & Desa',
    nawaBhakti: 'Jatim Berkah & Amanah',
  ),
  Recommendation(
    id: 34,
    title: 'Sukma-e Jatim',
    description: 'Survei kepuasan masyarakat secara elektronik Jawa Timur',
    logo: 'sukma_e_jatim.jpg',
    kategori: 'Multisektor (Khusus)',
    nawaBhakti: 'Jatim Berkah & Amanah',
  ),
  Recommendation(
    id: 35,
    title: 'PANDUCAKTI',
    description: 'Layanan Administrasi Kependudukan Cepat, Akurat, dan Terintegrasi',
    logo: 'panducakti.png',
    kategori: 'Kependudukan',
    nawaBhakti: 'Jatim Harmoni',
  ),
  Recommendation(
    id: 36,
    title: 'Hallo BNNP Jatim',
    description: 'Form Pengaduan Badan Narkotika Nasional Provinsi (BNNP) Jawa Timur.',
    logo: 'BNNP.png',
    kategori: 'Multisektor (Khusus)',
    nawaBhakti: 'Jatim Harmoni',
  ),
    Recommendation(
    id: 37,
    title: 'Data Penerima & Info Program Bansos (SAPA BANSOS)',
    description: 'Sistem Aplikasi Pelayanan Administrasi Bantuan Sosial',
    logo: 'LogoJawaTimur.png',
    kategori: 'Sosial',
    nawaBhakti: 'Jatim Sejahtera',
  ),
  Recommendation(
    id: 38,
    title: 'Sipetarungsilat',
    description: 'Pelayanan tata ruang laut Jawa Timur',
    logo: 'sipetarungsilat.png',
    kategori: 'Lingkungan Hidup',
    nawaBhakti: 'Jatim Lestari',
  ),
  Recommendation(
    id: 39,
    title: 'Pendaftaran Bimbingan dan Pelatihan Perbenihan',
    description: 'Layanan pendaftaran online untuk pelatihan perbenihan pertanian',
    logo: 'LogoJawaTimur.png',
    kategori: 'Lingkungan Hidup',
    nawaBhakti: 'Jatim Lestari',
  ),
  Recommendation(
    id: 40,
    title: 'Klinik BUMDesa',
    description: 'Klinik Badan Usaha Milik Desa',
    logo: 'LogoJawaTimur.png',
    kategori: 'Pemerintahan & Desa',
  ),
  Recommendation(
    id: 41,
    title: 'SIAP Grak!',
    description: 'Layanan prakiraan cuaca dan ketinggian gelombang',
    logo: 'siap_grak.jpg',
    kategori: 'Kebencanaan',
  ),
  Recommendation(
    id: 42,
    title: 'lapor Potensi Longsor',
    description: 'Form Asesmen Awal Risiko Tanah Longsor',
    logo: 'Lapor_Potensi_Longsor.jpg',
    kategori: 'Kebencanaan',
  ),
  Recommendation(
    id: 43,
    title: 'Surabaya Single Window Alfa (SSWALFA)',
    description: 'Layanan digital terpadu untuk pengajuan izin secara mandiri di Kota Surabaya.',
    logo: 'LogoJawaTimur.png',
    kategori: 'Lingkungan Hidup',
    nawaBhakti: 'Jatim Cerdas',
  ),
];

