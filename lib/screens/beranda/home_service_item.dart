import 'package:flutter/material.dart';

import '../../services/layanan_service.dart';
import '../destinasi_wisata/destinasi_wisata_screen.dart';
import '../harga_barang/harga_bahan_pokok_screen.dart';
import '../islamic_center/islamic_center_home_screen.dart';
import '../klinik_hoax/klinik_hoax_home_screen.dart';
import '../nomor darurat/nomor_darurat.dart';
import '../open_data/open_data_screen.dart';
import '../point_jatim/point_jatim_home_screen.dart';
import '../rsud_provjatim/rsud_jatim.dart';
import '../rssa/rssa_screen.dart';
import '../transjatim/transjatim_screen.dart';

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
      image: 'assets/images/klinik_hoax.png',
      builder: (_) => const KlinikHoaksHomeScreen(),
    );
  }
  if (normalized.contains('destinasi')) {
    return HomeServiceItem(
      title: 'Destinasi',
      image: 'assets/images/destinasi_wisata.png',
      builder: (_) => const DestinasiWisataScreen(),
    );
  }
  if (normalized.contains('open data')) {
    return HomeServiceItem(
      title: 'Open Data',
      image: 'assets/images/open_data.png',
      builder: (_) => const OpenDataScreen(),
    );
  }
  if (normalized.contains('harga')) {
    return HomeServiceItem(
      title: 'Harga',
      image: 'assets/images/khas_jatim.png',
      builder: (_) => const HargaBahanPokokScreen(),
    );
  }
  if (normalized.contains('rsud haji')) {
    return HomeServiceItem(
      title: 'RSUD Haji',
      image: 'assets/images/rsud_haji.png',
      builder: (_) => const RsudHajiScreen(),
    );
  }
  if (normalized.contains('transjatim')) {
    return HomeServiceItem(
      title: 'Transjatim',
      image: 'assets/images/transjatim_ajaib.png',
      builder: (_) => const TransjatimScreen(),
    );
  }
  if (normalized.contains('saiful anwar')) {
    return HomeServiceItem(
      title: 'RSSA',
      image: 'assets/images/rsud_saifulanwar.png',
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
      image: 'assets/images/point_jatim.png',
      builder: (_) => const PointJatimHomeScreen(),
    );
  }
  if (normalized.contains('islamic')) {
    return HomeServiceItem(
      title: 'Islamic Center',
      image: 'assets/images/islamic_center.png',
      builder: (_) => const IslamicCenterHomeScreen(),
    );
  }

  return null;
}
