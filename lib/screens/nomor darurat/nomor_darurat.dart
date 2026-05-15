import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'informasi_nomor.dart';

class NomorDaruratScreen extends StatefulWidget {
  const NomorDaruratScreen({super.key});

  @override
  State<NomorDaruratScreen> createState() => _NomorDaruratScreenState();
}

class _NomorDaruratScreenState extends State<NomorDaruratScreen> {
  String selectedLocation = "Jawa Timur";

  final List<String> locations = [
    "Jawa Timur",
    "Surabaya",
    "Malang",
    "Sidoarjo",
    "Kediri",
    "Jember",
    "Blitar",
    "Madiun",
    "Banyuwangi",
    "Probolinggo",
  ];

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0047B3),

      body: Stack(
        children: [
          // HEADER
          // Latar Belakang Biru
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/latar_belakang.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // =========================
                // APPBAR
                // =========================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),

                      const Expanded(
                        child: Center(
                          child: Text(
                            "Nomor Darurat",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.bookmark_border,
                              color: Colors.white,
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const InfoNomorDaruratScreen(),
                                ),
                              );
                            },

                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // =========================
                // CONTENT
                // =========================
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),

                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),

                    child: Column(
                      children: [
                        // ======================
                        // DROPDOWN
                        // ======================
                        Container(
                          height: 54,
                          padding: const EdgeInsets.symmetric(horizontal: 16),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),

                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedLocation,

                              isExpanded: true,

                              icon: SvgPicture.asset(
                                "assets/images/selector.svg",
                                width: 18,
                                height: 18,
                              ),

                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),

                              items: locations.map((String location) {
                                return DropdownMenuItem<String>(
                                  value: location,
                                  child: Text(location),
                                );
                              }).toList(),

                              onChanged: (String? value) {
                                setState(() {
                                  selectedLocation = value!;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // ======================
                        // CARD 1
                        // ======================
                        _emergencyCard(
                          image: "assets/images/ambulans.svg",
                          title: "AMBULANS / KEADAAN DARURAT",
                          subtitle: "Ambulans seluruh Jawa Timur.",
                          buttonText: "CALL CENTER 112",
                          phoneNumber: "112",
                        ),

                        const SizedBox(height: 14),

                        // ======================
                        // CARD 2
                        // ======================
                        _emergencyCard(
                          image: "assets/images/polda.svg",
                          title: "POLDA JATIM",
                          subtitle: "Polisi daerah Jawa Timur",
                          buttonText: "CALL CENTER (031)8280748",
                          phoneNumber: "0318280748",
                        ),

                        const SizedBox(height: 14),

                        // ======================
                        // CARD 3
                        // ======================
                        _emergencyCard(
                          image: "assets/images/call.svg",
                          title: "CALL CENTER",
                          subtitle: "Call center Provinsi Jawa Timur",
                          buttonText: "CALL CENTER 1500979",
                          phoneNumber: "1500979",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emergencyCard({
    required String image,
    required String title,
    required String subtitle,
    required String buttonText,
    required String phoneNumber,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF8AB6FF)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(image, width: 24, height: 24),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF121938),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          GestureDetector(
            onTap: () {
              makePhoneCall(phoneNumber);
            },

            child: Container(
              width: double.infinity,
              height: 48,

              decoration: BoxDecoration(
                color: const Color(0xFF0E63FF),
                borderRadius: BorderRadius.circular(30),
              ),

              child: Center(
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
