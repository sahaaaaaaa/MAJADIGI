import 'package:flutter/material.dart';

class OpenDataInformasiScreen extends StatefulWidget {
  const OpenDataInformasiScreen({super.key});

  @override
  State<OpenDataInformasiScreen> createState() =>
      _OpenDataInformasiScreenState();
}

class _OpenDataInformasiScreenState
    extends State<OpenDataInformasiScreen> {

  bool manfaatExpanded = false;
  bool sistemExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7),

      body: Stack(
        children: [

          // BACKGROUND HEADER
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/latar_belakang.png',
                ),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          Column(
            children: [

              // APPBAR
              _buildAppBar(),

              const SizedBox(height: 10),

              // MAIN CONTAINER
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // HANDLE
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // BANNER
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 25),

                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade50,
                                Colors.blue.shade100,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.blue.shade100,
                            ),
                          ),

                          child: Center(
                            child: Image.asset(
                              'assets/images/open_data.png',
                              height: 80,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // TENTANG
                        const Text(
                          "Tentang Open Data",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "Layanan Open Data Jawa Timur merupakan platform "
                          "penyedia data publik yang dikelola oleh Pemerintah "
                          "Provinsi Jawa Timur untuk mendukung transparansi "
                          "informasi, pengambilan keputusan berbasis data, "
                          "dan kolaborasi publik.",
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.7,
                            color: Colors.grey[700],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // OPERASIONAL
                        const Text(
                          "Operasional",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _buildInfoCard(
                          title: "Link Layanan",
                          child: Text(
                            "https://opendata.jatimprov.go.id/",
                            style: TextStyle(
                              color: Colors.blue[700],
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        _buildInfoCard(
                          title: "Alamat",
                          child: Text(
                            "Jl. Ahmad Yani No.242-244, Gayungan, "
                            "Kec. Gayungan, Surabaya, Jawa Timur 60235",
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                        ),

                        _buildInfoCard(
                          title: "Jam Operasional",
                          child: Text(
                            "Senin - Minggu (24 Jam)",
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                        ),

                        _buildInfoCard(
                          title: "Media Sosial",
                          child: Row(
                            children: [

                              Icon(
                                Icons.play_circle_fill,
                                color: Colors.blue[700],
                              ),

                              const SizedBox(width: 6),

                              Text(
                                "Youtube",
                                style: TextStyle(
                                  color: Colors.blue[700],
                                ),
                              ),

                              const SizedBox(width: 24),

                              Icon(
                                Icons.camera_alt,
                                color: Colors.blue[700],
                              ),

                              const SizedBox(width: 6),

                              Text(
                                "Instagram",
                                style: TextStyle(
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // KETENTUAN
                        const Text(
                          "Ketentuan Umum",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // MANFAAT
                        _buildExpandTile(
                          title: "Manfaat",
                          isExpanded: manfaatExpanded,
                          onTap: () {
                            setState(() {
                              manfaatExpanded = !manfaatExpanded;
                            });
                          },

                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "1. Pemerintah hadir lebih transparan "
                                "dalam menyediakan informasi publik.",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  height: 1.7,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "2. Data dapat dimanfaatkan untuk "
                                "pengambilan keputusan yang lebih tepat.",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  height: 1.7,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "3. Masyarakat lebih mudah memperoleh "
                                "akses informasi resmi dan terpercaya.",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  height: 1.7,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "4. Mendukung inovasi dan kolaborasi "
                                "berbasis data antar berbagai pihak.",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // SISTEM
                        _buildExpandTile(
                          title: "Sistem, Mekanisme, dan Prosedur",
                          isExpanded: sistemExpanded,
                          onTap: () {
                            setState(() {
                              sistemExpanded = !sistemExpanded;
                            });
                          },

                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "1. Akses website Open Data Jawa Timur "
                                "melalui https://opendata.jatimprov.go.id/",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  height: 1.7,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "2. Cari dataset atau infografik "
                                "berdasarkan kategori yang tersedia.",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  height: 1.7,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "3. Pengguna dapat melihat detail data "
                                "dan melakukan unduhan dataset.",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  height: 1.7,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "4. Format data tersedia dalam berbagai "
                                "jenis seperti Excel, CSV, dan API.",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  height: 1.7,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "5. Seluruh data yang tersedia bersifat "
                                "terbuka dan dapat digunakan sesuai kebutuhan.",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  height: 1.7,
                                ),
                              ),
                            ],
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

  // APPBAR
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 55, 16, 0),
      child: Row(
        children: [

          InkWell(
            onTap: () => Navigator.pop(context),

            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                "Informasi",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),
        ],
      ),
    );
  }

  // INFO CARD
  Widget _buildInfoCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }

  // EXPAND TILE
  Widget _buildExpandTile({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isExpanded ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Column(
        children: [

          InkWell(
            onTap: onTap,

            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),

              child: Row(
                children: [

                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Icon(
                    isExpanded ? Icons.remove : Icons.add,
                  ),
                ],
              ),
            ),
          ),

          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: content,
            ),
        ],
      ),
    );
  }
}