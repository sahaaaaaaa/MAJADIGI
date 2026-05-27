// service_model.dart
import 'package:flutter/material.dart';
import 'package:majadigi/screens/destinasi_wisata/destinasi_wisata_screen.dart';
import 'package:majadigi/screens/islamic_center/islamic_center_home_screen.dart';
import 'package:majadigi/screens/klinik_hoax/klinik_hoax_home_screen.dart';
import 'package:majadigi/screens/open_data/open_data_screen.dart';
import 'package:majadigi/screens/point_jatim/point_jatim_home_screen.dart';
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
    return 'PPID';
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
  ),
  Recommendation(
    id: 5,
    title: 'RSUD Haji',
    description: 'Pelayanan kesehatan berkualitas dan islami',
    logo: 'rsud_haji.png',
    kategori: 'Kesehatan',
  ),
  Recommendation(
    id: 6,
    title: 'RSUD Dr. Saiful Anwar',
    description: 'Layanan kesehatan rujukan utama Jawa Timur',
    logo: 'rsud_saifulanwar.png',
    kategori: 'Kesehatan',
  ),
  Recommendation(
    id: 7,
    title: 'Transjatim',
    description: 'Informasi rute transportasi publik Jatim',
    logo: 'transjatim_ajaib.png',
    kategori: 'Kependudukan',
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
  ),
  Recommendation(
    id: 2,
    title: 'RSUD Haji',
    description: 'Pelayanan kesehatan berkualitas dan islami',
    logo: 'rsud_haji.png',
    kategori: 'Kesehatan',
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
    screen: const IslamicCenterHomeScreen(),
  ),
  Recommendation(
    id: 5,
    title: 'Open Data',
    description: 'Transparansi data publik untuk masyarakat',
    logo: 'open_data.png',
    kategori: 'PPID',
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
    logo: 'klinik_hoax.png',
    kategori: 'Ekonomi & Bisnis',
  ),
  Recommendation(
    id: 8,
    title: 'Nomor Darurat',
    description: 'Layanan cepat tanggap darurat 24 jam',
    logo: 'icons/ambulans.svg',
    kategori: 'Kebencanaan',
  ),
  Recommendation(
    id: 9,
    title: 'Transjatim',
    description: 'Informasi rute transportasi publik Jatim',
    logo: 'transjatim_ajaib.png',
    kategori: 'Infrastruktur',
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
    kategori: 'Ekonomi & Bisnis',
    nawaBhakti: 'Jatim Agro',
  ),
  Recommendation(
    id: 12,
    title: 'Kidungan',
    description: 'Koleksi khas semua tentang Jawa Timur',
    logo: 'kidungan.jpg',
    kategori: 'Pariwisata & Kebudayaan',
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
    description: 'Koleksi khas semua tentang Jawa Timur',

    logo: 'klinik_hoax.png',

    kategori: 'Pariwisata & Kebudayaan',
  ),

  Recommendation(
    id: 16,
    title: 'Paket Kunjungan Agrowisata',
    description: 'Koleksi khas semua tentang Jawa Timur',

    logo: 'klinik_hoax.png',

    kategori: 'Pariwisata & Kebudayaan',
  ),

  Recommendation(
    id: 17,
    title: 'Khas Jatim',
    description: 'Koleksi khas semua tentang Jawa Timur',

    logo: 'khas_jatim.png',

    kategori: 'Pariwisata & Kebudayaan',
  ),

  Recommendation(
    id: 18,
    title: 'Cak Durasim',
    description: 'Koleksi khas semua tentang Jawa Timur',

    logo: 'cak_durasim.png',

    kategori: 'Pariwisata & Kebudayaan',
  ),

  Recommendation(
    id: 19,
    title: 'Virtual Tour 360',
    description: 'Koleksi khas semua tentang Jawa Timur',

    logo: 'klinik_hoax.png',

    kategori: 'Pariwisata & Kebudayaan',
  ),

  Recommendation(
    id: 20,
    title: 'RSUD Haji Prov. Jatim',
    description: 'Pelayanan kesehatan berkualitas dan islami',

    logo: 'rsud_haji.png',

    kategori: 'Kesehatan',
  ),

  Recommendation(
    id: 21,
    title: 'Transjatim AJAIB 2.0',
    description: 'Informasi rute transportasi publik Jatim',

    logo: 'transjatim_ajaib.png',

    kategori: 'Infrastruktur',
  ),

  Recommendation(
    id: 22,
    title: 'Islamic Center',
    description: 'Pusat informasi dan kegiatan keagamaan',

    logo: 'islamic_center.png',

    kategori: 'Sosial',

    screen: const IslamicCenterHomeScreen(),
  ),
];
