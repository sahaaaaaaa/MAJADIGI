import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../services/transjatim_service.dart';

class DaftarTiketScreen
    extends StatefulWidget {
  const DaftarTiketScreen({
    super.key,
  });

  @override
  State<DaftarTiketScreen> createState() => _DaftarTiketScreenState();
}

class _DaftarTiketScreenState extends State<DaftarTiketScreen> {
  final TransjatimService _transjatimService = TransjatimService();

  TransjatimTariffResponse? _tariffs;

  static const TransjatimTariffResponse _fallbackTariffs =
      TransjatimTariffResponse(
    regular: [
      TransjatimTariff(type: 'Umum', nominal: '5000'),
      TransjatimTariff(type: 'Pelajar', nominal: '2500'),
    ],
    luxury: [
      TransjatimTariff(type: 'SBY - GSK', nominal: '20000'),
      TransjatimTariff(type: 'SBY - SDA', nominal: '15000'),
      TransjatimTariff(type: 'SDA - GSK', nominal: '30000'),
    ],
  );

  TransjatimTariffResponse get _availableTariffs {
    final tariffs = _tariffs;
    if (tariffs == null ||
        (tariffs.regular.isEmpty && tariffs.luxury.isEmpty)) {
      return _fallbackTariffs;
    }
    return tariffs;
  }

  @override
  void initState() {
    super.initState();
    _loadTariffs();
  }

  @override
  void dispose() {
    _transjatimService.dispose();
    super.dispose();
  }

  Future<void> _loadTariffs() async {
    try {
      final tariffs = await _transjatimService.getTariffs();
      if (!mounted) {
        return;
      }
      setState(() {
        _tariffs = tariffs;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final tariffs = _availableTariffs;

    return Scaffold(
      backgroundColor:
          Colors.transparent,

      body: Stack(
        children: [
          // 🔵 HEADER BG
          Container(
            width: double.infinity,
            height: 240,
            decoration:
                const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/latar_belakang.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 🔹 HEADER
                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),

                      const Expanded(
                        child: Text(
                          "Daftar Tiket",
                          textAlign:
                              TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    width:
                        double.infinity,
                    decoration:
                        const BoxDecoration(
                      color: Color(
                        0xFFF5F5F5,
                      ),
                      borderRadius:
                          BorderRadius.vertical(
                        top:
                            Radius.circular(
                          34,
                        ),
                      ),
                    ),

                    child: Padding(
                      padding:
                          const EdgeInsets
                              .all(16),
                      child: ListView(
                        children: [
                          const SizedBox(
                              height: 8),

                          const Text(
                            "Umum",
                            style:
                                TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color: Color(
                                0xFF121938,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 16),

                          ..._ticketCards(
                            tariffs.regular,
                            'assets/images/icons/users-03.svg',
                          ),

                          const SizedBox(
                              height: 28),

                          const Text(
                            "Luxury",
                            style:
                                TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color: Color(
                                0xFF121938,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 16),

                          ..._ticketCards(
                            tariffs.luxury,
                            'assets/images/icons/bus.svg',
                          ),
                        ],
                      ),
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

  List<Widget> _ticketCards(
    List<TransjatimTariff> tariffs,
    String icon,
  ) {
    final children = <Widget>[];

    for (var index = 0; index < tariffs.length; index++) {
      if (index > 0) {
        children.add(const SizedBox(height: 12));
      }

      children.add(
        _ticketCard(
          icon: icon,
          title: tariffs[index].type,
          price: _formatRupiah(tariffs[index].nominal),
        ),
      );
    }

    return children;
  }

  String _formatRupiah(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return 'Rp0';
    }

    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      final remaining = digits.length - index;
      buffer.write(digits[index]);
      if (remaining > 1 && remaining % 3 == 1) {
        buffer.write('.');
      }
    }

    return 'Rp$buffer';
  }

  Widget _ticketCard({
    required String icon,
    required String title,
    required String price,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 24,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w600,
                color: Color(
                  0xFF121938,
                ),
              ),
            ),
          ),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: price,
                  style: const TextStyle(
                    color: Color(
                      0xFF121938,
                    ),
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const TextSpan(
                  text: " / Tiket",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
