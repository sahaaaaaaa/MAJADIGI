import 'package:flutter/material.dart';

class KlinikHoaksDetailScreen extends StatelessWidget {
  const KlinikHoaksDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      body: SafeArea(
        child: Column(
          children: [

            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back_ios,
                            size: 18,
                            color: Color(0xFF0D57E7)),
                        SizedBox(width: 4),
                        Text(
                          "Kembali",
                          style: TextStyle(
                            color: Color(0xFF0D57E7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // CONTENT
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),

                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/images/detail_hoaks.png',
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // DATE + BADGE
                      Row(
                        children: [

                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey[600],
                          ),

                          const SizedBox(width: 6),

                          Text(
                            "08 April 2026",
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),

                          const Spacer(),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 5,
                            ),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.red,
                              ),
                            ),

                            child: const Text(
                              "Hoaks",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // TITLE
                      const Text(
                        "Dubes AS & Gus Yahya Ajak Umat Islam Kecam Tindakan Iran",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // CONTENT
                      Text(
                        "Beredar unggahan di media sosial yang menampilkan "
                        "pertemuan antara Duta Besar Amerika Serikat dan "
                        "Ketua Umum PBNU...\n\n"
                        "Faktanya, pertemuan antara Duta Besar Amerika "
                        "Serikat dan Gus Yahya memang terjadi, namun isi "
                        "pembahasannya berbeda jauh dari narasi yang beredar.",
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.8,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}