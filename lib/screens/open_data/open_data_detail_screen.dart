import 'package:flutter/material.dart';

class OpenDataDetailScreen extends StatelessWidget {
  const OpenDataDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7),

      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/latar_belakang.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Column(
            children: [

              // APPBAR
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 55, 16, 0),

                child: Row(
                  children: [

                    InkWell(
                      onTap: () => Navigator.pop(context),

                      child: const Row(
                        children: [

                          Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18,
                          ),

                          SizedBox(width: 8),

                          Text(
                            "Kembali",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: Container(
                  width: double.infinity,

                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),

                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Center(
                          child: Container(
                            width: 40,
                            height: 5,

                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(24),

                          child: Image.asset(
                            'assets/images/info1.png',
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [

                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey[600],
                            ),

                            const SizedBox(width: 8),

                            Text(
                              "08 April 2026",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),

                            const Spacer(),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),

                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(20),

                                border: Border.all(
                                  color: Colors.blue,
                                ),
                              ),

                              child: const Text(
                                "Ekonomi",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Realisasi Investasi Jawa Timur Tahun 2025 Tembus Rp. 147,7 Triliun",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Alhamdulillah, investasi Jawa Timur "
                          "tahun 2025 tembus Rp 147,7 triliun "
                          "dan trennya konsisten tumbuh sejak 2024.\n\n"
                          "Komitmen ini didominasi PMDN dan PMA "
                          "yang terus meningkat.\n\n"
                          "Menurut Pemerintah Jawa Timur, "
                          "sektor investasi terus bergerak "
                          "positif dan berdampak pada ekonomi.",
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 16,
                            height: 1.8,
                          ),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 52,

                          child: ElevatedButton(
                            onPressed: () {},

                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF0D57E7),

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(16),
                              ),
                            ),

                            child: const Text(
                              "Unduh",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}