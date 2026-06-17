import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:majadigi/features/nomor_darurat/data/nomor_darurat_service.dart';
import 'package:majadigi/core/widgets/layanan_favorite_button.dart';
import 'package:majadigi/features/nomor_darurat/presentation/informasi_nomor.dart';

class NomorDaruratScreen extends StatefulWidget {
  const NomorDaruratScreen({super.key});

  @override
  State<NomorDaruratScreen> createState() => _NomorDaruratScreenState();
}

class _NomorDaruratScreenState extends State<NomorDaruratScreen> {
  final NomorDaruratService _nomorDaruratService = NomorDaruratService();

  String selectedLocationId = "";
  int _numberRequestSerial = 0;
  bool _hasLoadedNumbers = false;
  List<KabKotaDarurat> locations = [];
  List<NomorDaruratItem> emergencyNumbers = [];

  final List<NomorDaruratItem> fallbackEmergencyNumbers = [
    NomorDaruratItem(
      id: "ambulans",
      name: "Ambulans / Keadaan darurat",
      number: "112",
      description: "Ambulans seluruh Jawa Timur.",
      isNational: false,
      isProvince: true,
      kabKotaId: "",
    ),
    NomorDaruratItem(
      id: "polda",
      name: "Polda jatim",
      number: "(031) 8280748",
      description: "Polisi daerah Jawa Timur",
      isNational: false,
      isProvince: true,
      kabKotaId: "",
    ),
    NomorDaruratItem(
      id: "call-center",
      name: "Call Center",
      number: "1500979",
      description: "Call center Provinsi Jawa Timur",
      isNational: false,
      isProvince: true,
      kabKotaId: "",
    ),
  ];

  List<NomorDaruratItem> get visibleEmergencyNumbers {
    if (_hasLoadedNumbers) {
      return emergencyNumbers;
    }

    return fallbackEmergencyNumbers;
  }

  @override
  void initState() {
    super.initState();
    _fetchKabKota();
    _fetchNomorDarurat();
  }

  @override
  void dispose() {
    _nomorDaruratService.dispose();
    super.dispose();
  }

  Future<void> _fetchKabKota() async {
    try {
      final data = await _nomorDaruratService.getKabKota();
      if (!mounted) {
        return;
      }

      setState(() {
        locations = data;
      });
    } catch (_) {}
  }

  Future<void> _fetchNomorDarurat() async {
    final requestSerial = ++_numberRequestSerial;
    final kabKotaId = selectedLocationId;

    try {
      final data = await _nomorDaruratService.getNomorDarurat(
        kabKotaId: kabKotaId.isEmpty ? null : kabKotaId,
      );
      if (!mounted || requestSerial != _numberRequestSerial) {
        return;
      }

      setState(() {
        emergencyNumbers = data;
        _hasLoadedNumbers = true;
      });
    } catch (_) {
      if (!mounted || requestSerial != _numberRequestSerial) {
        return;
      }

      setState(() {
        emergencyNumbers = kabKotaId.isEmpty ? fallbackEmergencyNumbers : [];
        _hasLoadedNumbers = true;
      });
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri phoneUri = Uri(scheme: 'tel', path: cleanedPhoneNumber);

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
                          const LayananFavoriteButton(
                            serviceName: 'Nomor Darurat',
                            lookupQuery: 'Nomor Darurat',
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
                              value: selectedLocationId,

                              isExpanded: true,

                              icon: SvgPicture.asset(
                                "assets/images/icons/selector.svg",
                                width: 18,
                                height: 18,
                              ),

                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),

                              items: [
                                const DropdownMenuItem<String>(
                                  value: "",
                                  child: Text("Jawa Timur"),
                                ),
                                ...locations.map((location) {
                                  return DropdownMenuItem<String>(
                                    value: location.id,
                                    child: Text(location.name),
                                  );
                                }),
                              ],

                              onChanged: (String? value) {
                                if (value == null) {
                                  return;
                                }

                                setState(() {
                                  selectedLocationId = value;
                                  emergencyNumbers = [];
                                  _hasLoadedNumbers = false;
                                });
                                _fetchNomorDarurat();
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: visibleEmergencyNumbers.isEmpty
                                ? 1
                                : visibleEmergencyNumbers.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              if (visibleEmergencyNumbers.isEmpty) {
                                return _emptyEmergencyCard();
                              }

                              final item = visibleEmergencyNumbers[index];
                              return _emergencyCard(
                                image: _iconForEmergencyNumber(item),
                                title: item.name.toUpperCase(),
                                subtitle: _subtitleForEmergencyNumber(item),
                                buttonText: "CALL CENTER ${item.number}",
                                phoneNumber: item.number,
                              );
                            },
                          ),
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

  Widget _emptyEmergencyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF8AB6FF)),
      ),
      child: const Text(
        "Nomor darurat belum tersedia untuk wilayah ini.",
        style: TextStyle(fontSize: 15, color: Colors.grey),
      ),
    );
  }

  String _subtitleForEmergencyNumber(NomorDaruratItem item) {
    if (item.description.isNotEmpty) {
      return item.description;
    }

    if (item.isProvince) {
      return "Layanan darurat Provinsi Jawa Timur";
    }

    final selectedLocation = locations.where((location) {
      return location.id == selectedLocationId;
    }).toList();

    if (selectedLocation.isNotEmpty) {
      return "Layanan darurat ${selectedLocation.first.name}";
    }

    return "Layanan nomor darurat";
  }

  String _iconForEmergencyNumber(NomorDaruratItem item) {
    final name = item.name.toLowerCase();
    if (name.contains('ambulans') || name.contains('ambulance')) {
      return "assets/images/icons/ambulans.svg";
    }
    if (name.contains('polda') ||
        name.contains('polisi') ||
        name.contains('polres')) {
      return "assets/images/icons/polda.svg";
    }
    return "assets/images/icons/call.svg";
  }
}
