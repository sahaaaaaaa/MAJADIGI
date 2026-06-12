import 'package:flutter/material.dart';
import 'package:majadigi/services/layanan_service.dart';

class Recommendation {
  final int id;
  final String title;
  final String description;
  final String logo;
  final String kategori;
  final String? nawaBhakti;
  final Widget? screen;
  final bool isFeatured;

  Recommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.logo,
    required this.kategori,
    this.nawaBhakti,
    this.screen,
    this.isFeatured = false,
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
    isFeatured: layanan.isFeatured,
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
    return 'open_data.svg';
  }
  if (normalized.contains('klinik hoaks')) {
    return 'klinik_hoax.svg';
  }
  if (normalized.contains('harga')) {
    return 'khas_jatim.svg';
  }
  if (normalized.contains('nomor darurat')) {
    return 'icons/ambulans.svg';
  }
  if (normalized.contains('rsud haji')) {
    return 'rsud_haji.svg';
  }
  if (normalized.contains('saiful anwar')) {
    return 'rsud_saifulanwar.svg';
  }
  if (normalized.contains('transjatim')) {
    return 'transjatim_ajaib.svg';
  }
  if (normalized.contains('point jatim')) {
    return 'point_jatim.svg';
  }
  if (normalized.contains('islamic')) {
    return 'islamic_center.svg';
  }
  if (normalized.contains('destinasi')) {
    return 'destinasi_wisata.svg';
  }

  return 'klinik_hoax.svg';
}

String layananLogoAssetPath(String logo) {
  if (logo.startsWith('assets/')) {
    return logo;
  }

  return 'assets/images/$logo';
}

class NewsArticle {
  final int id;
  final String title;
  final String content;
  final String date;
  final String imageUrl;
  final String category;

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
];
