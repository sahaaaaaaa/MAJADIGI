import 'package:flutter/material.dart';

import 'package:majadigi/features/layanan/data/layanan_service.dart';
import 'package:majadigi/features/destinasi_wisata/presentation/destinasi_wisata_screen.dart';
import 'package:majadigi/features/harga_barang/presentation/harga_bahan_pokok_screen.dart';
import 'package:majadigi/features/islamic_center/presentation/islamic_center_home_screen.dart';
import 'package:majadigi/features/klinik_hoax/presentation/klinik_hoax_home_screen.dart';
import 'package:majadigi/features/nomor_darurat/presentation/nomor_darurat.dart';
import 'package:majadigi/features/open_data/presentation/open_data_screen.dart';
import 'package:majadigi/features/point_jatim/presentation/point_jatim_home_screen.dart';
import 'package:majadigi/features/rsud_provjatim/presentation/rsud_jatim.dart';
import 'package:majadigi/features/rssa/presentation/rssa_screen.dart';
import 'package:majadigi/features/transjatim/presentation/transjatim_screen.dart';

class HomeServiceItem {
  const HomeServiceItem({
    required this.title,
    required this.image,
    required this.builder,
  });

  final String title;
  final String image;
  final WidgetBuilder builder;
}

HomeServiceItem? homeServiceFromLayanan(LayananModel layanan) {
  final normalized = layanan.name.toLowerCase();

  if (normalized.contains('klinik hoaks')) {
    return HomeServiceItem(
      title: 'Klinik Hoaks',
      image: 'assets/images/klinik_hoax.svg',
      builder: (_) => const KlinikHoaksHomeScreen(),
    );
  }
  if (normalized.contains('destinasi')) {
    return HomeServiceItem(
      title: 'Destinasi',
      image: 'assets/images/destinasi_wisata.svg',
      builder: (_) => const DestinasiWisataScreen(),
    );
  }
  if (normalized.contains('open data')) {
    return HomeServiceItem(
      title: 'Open Data',
      image: 'assets/images/open_data.svg',
      builder: (_) => const OpenDataScreen(),
    );
  }
  if (normalized.contains('harga')) {
    return HomeServiceItem(
      title: 'Harga',
      image: 'assets/images/khas_jatim.svg',
      builder: (_) => const HargaBahanPokokScreen(),
    );
  }
  if (normalized.contains('rsud haji')) {
    return HomeServiceItem(
      title: 'RSUD Haji',
      image: 'assets/images/rsud_haji.svg',
      builder: (_) => const RsudHajiScreen(),
    );
  }
  if (normalized.contains('transjatim')) {
    return HomeServiceItem(
      title: 'Transjatim',
      image: 'assets/images/transjatim_ajaib.svg',
      builder: (_) => const TransjatimScreen(),
    );
  }
  if (normalized.contains('saiful anwar')) {
    return HomeServiceItem(
      title: 'RSSA',
      image: 'assets/images/rsud_saifulanwar.svg',
      builder: (_) => const RssaScreen(),
    );
  }
  if (normalized.contains('nomor darurat')) {
    return HomeServiceItem(
      title: 'Nomor Darurat',
      image: 'assets/images/icons/ambulans.svg',
      builder: (_) => const NomorDaruratScreen(),
    );
  }
  if (normalized.contains('point jatim')) {
    return HomeServiceItem(
      title: 'Point Jatim',
      image: 'assets/images/point_jatim.svg',
      builder: (_) => const PointJatimHomeScreen(),
    );
  }
  if (normalized.contains('islamic')) {
    return HomeServiceItem(
      title: 'Islamic Center',
      image: 'assets/images/islamic_center.svg',
      builder: (_) => const IslamicCenterHomeScreen(),
    );
  }

  return null;
}
