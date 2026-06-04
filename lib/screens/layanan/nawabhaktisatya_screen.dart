import 'package:flutter/material.dart';
import 'package:majadigi/screens/layanan/nawa_detail_screen.dart';

class NawaBhaktiScreen extends StatelessWidget {
  const NawaBhaktiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> nawaList = [
      {
        "title": "Jatim Agro",

        "description":
            "Pengembangan komoditas unggulan dan dukungan infrastruktur untuk mencapai ketahanan pangan nasional",

        "image": "assets/images/nawa/jatim_agro.svg",
      },

      {
        "title": "Jatim Sehat",

        "description":
            "Peningkatan layanan kesehatan yang mudah diakses dan berkualitas bagi masyarakat Jawa Timur",

        "image": "assets/images/nawa/jatim_sehat.svg",
      },

      {
        "title": "Jatim Cerdas",

        "description":
            "Pelayanan dan akses pendidikan yang lebih merata untuk seluruh masyarakat",

        "image": "assets/images/nawa/jatim_cerdas.svg",
      },

      {
        "title": "Jatim Sejahtera",

        "description":
            "Percepatan pengentasan kemiskinan dan peningkatan kesejahteraan masyarakat",

        "image": "assets/images/nawa/jatim_sejahtera.svg",
      },

      {
        "title": "Jatim Akses",

        "description":
            "Perkuat konektivitas dan aglomerasi antar wilayah di Jawa Timur",

        "image": "assets/images/nawa/jatim_akses.svg",
      },

      {
        "title": "Jatim Berkah & Amanah",

        "description":
            "Optimalisasi pemerintahan efektif, efisien, dan anti korupsi",

        "image": "assets/images/nawa/jatim_berkah.svg",
      },

      {
        "title": "Jatim Harmoni",

        "description":
            "Harmoni dalam toleransi, kesetaraan, dan kehidupan sosial masyarakat",

        "image": "assets/images/nawa/jatim_harmoni.svg",
      },

      {
        "title": "Jatim Lestari",

        "description":
            "Pengembangan ekonomi hijau dan keberlanjutan lingkungan hidup",

        "image": "assets/images/nawa/jatim_lestari.svg",
      },

      {
        "title": "Jatim Kerja",

        "description":
            "Ekonomi inklusif dan lapangan pekerjaan yang lebih luas",

        "image": "assets/images/nawa/jatim_kerja.svg",
      },
    ];

    return GridView.builder(
      physics: const BouncingScrollPhysics(),

      itemCount: nawaList.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,

        crossAxisSpacing: 14,
        mainAxisSpacing: 14,

        childAspectRatio: 0.78,
      ),

      itemBuilder: (context, index) {
        final item = nawaList[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) => NawaDetailScreen(
                  title: item["title"]!,
                  description: item["description"]!,
                  image: item["image"]!,
                ),
              ),
            );
          },

          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(22),

              border: Border.all(color: const Color(0xffEAEAEA)),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// ICON
                Container(
                  width: 58,
                  height: 58,

                  padding: const EdgeInsets.all(10),

                  decoration: const BoxDecoration(
                    color: Color(0xffF5F7FF),
                    shape: BoxShape.circle,
                  ),

                  child: Image.asset(item["image"]!),
                ),

                const SizedBox(height: 16),

                /// TITLE
                Text(
                  item["title"]!,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 10),

                /// DESCRIPTION
                Flexible(
                  child: Text(
                    item["description"]!,

                    maxLines: 4,

                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,

                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
