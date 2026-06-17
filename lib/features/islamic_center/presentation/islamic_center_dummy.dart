import 'package:flutter/material.dart';

class IslamicCenterFacilityModel {
  final String image;
  final String title;
  final String description;
  final List<String> tags;

  /// DETAIL
  final List<IslamicCenterRoomModel> rooms;

  const IslamicCenterFacilityModel({
    required this.image,
    required this.title,
    required this.description,
    required this.tags,
    required this.rooms,
  });
}

class IslamicCenterRoomModel {
  final String image;
  final String title;
  final String kapasitas;
  final String harga;

  const IslamicCenterRoomModel({
    required this.image,
    required this.title,
    required this.kapasitas,
    required this.harga,
  });
}

class IslamicCenterDummy {

  static const String pageTitle =
      'Islamic Center';

  static const List<IslamicCenterFacilityModel>
      fasilitas = [

    /// AULA
    IslamicCenterFacilityModel(
      image:
          'assets/images/islamicCenter/aula.png',

      title: 'Aula',

      description:
          'Islamic Centre menyediakan beragam ruangan sesuai dengan kebutuhan pertemuan formal maupun perayaan acara besar.',

      tags: [
        'Hall Utama',
        'Ruang VIP',
        '2+',
      ],

      rooms: [

        IslamicCenterRoomModel(
          image:
              'assets/images/islamicCenter/aula.png',

          title: 'Ruang Rapat',

          kapasitas: '2000 Orang',

          harga: 'Rp10.000.000',
        ),

        IslamicCenterRoomModel(
          image:
              'assets/images/islamicCenter/aula.png',

          title: 'Ruang Rapat',

          kapasitas: '150 Orang',

          harga: 'Rp2.000.000',
        ),

        IslamicCenterRoomModel(
          image:
              'assets/images/islamicCenter/aula.png',

          title: 'Ruang VIP',

          kapasitas: '25 Orang',

          harga: 'Rp1.500.000',
        ),

        IslamicCenterRoomModel(
          image:
              'assets/images/islamicCenter/aula.png',

          title: 'Ruang Kelas',

          kapasitas: '50 Orang',

          harga: 'Rp1.000.000',
        ),
      ],
    ),

    /// ASRAMA
    IslamicCenterFacilityModel(
      image:
          'assets/images/islamicCenter/asrama.png',

      title: 'Asrama',

      description:
          'Islamic Centre menyediakan beragam ruangan sesuai dengan kebutuhan pertemuan formal maupun perayaan acara besar.',

      tags: [
        'Kamar 2 Bed',
        'Kamar 4 Bed',
        'Kamar 6 Bed',
      ],

      rooms: [
        IslamicCenterRoomModel(
          image:
              'assets/images/islamicCenter/asrama.png',

          title: 'Kamar 2 Bed',

          kapasitas: '2 Orang',

          harga: 'Rp300.000',
        ),

        IslamicCenterRoomModel(
          image:
              'assets/images/islamicCenter/asrama.png',

          title: 'Kamar 4 Bed',

          kapasitas: '4 Orang',

          harga: 'Rp450.000',
        ),
      ],
    ),

    /// MASJID
    IslamicCenterFacilityModel(
      image:
          'assets/images/islamicCenter/masjid.png',

      title: 'Ruang Masjid',

      description:
          'Islamic Centre menyediakan beragam ruangan sesuai dengan kebutuhan pertemuan formal maupun perayaan acara besar.',

      tags: [
        'Ruang VIP',
        'Akad Nikah + Petugas',
        '1+',
      ],

      rooms: [
        IslamicCenterRoomModel(
          image:
              'assets/images/islamicCenter/masjid.png',

          title: 'Ruang VIP',

          kapasitas: '30 Orang',

          harga: 'Rp2.500.000',
        ),
      ],
    ),
  ];
}