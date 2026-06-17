import 'package:flutter/material.dart';

import 'package:majadigi/features/auth/data/auth_service.dart';
import 'package:majadigi/features/layanan/data/layanan_service.dart';
import 'package:majadigi/core/widgets/asset_icon_image.dart';
import 'package:majadigi/core/models/service_model.dart';
import 'package:majadigi/features/home/presentation/home_service_item.dart';

class SemuaLayananDaerahScreen extends StatefulWidget {
  const SemuaLayananDaerahScreen({super.key});

  @override
  State<SemuaLayananDaerahScreen> createState() =>
      _SemuaLayananDaerahScreenState();
}

class _SemuaLayananDaerahScreenState extends State<SemuaLayananDaerahScreen> {
  final LayananService _layananService = LayananService();

  String selectedDaerah = "Jawa Timur";
  bool _isLoading = true;
  String? _errorMessage;
  int? _installingLayananId;
  List<LayananModel> _layanan = [];

  final List<String> daerahList = [
    "Jawa Timur",
    "Kabupaten Banyuwangi",
    "Kabupaten Tuban",
    "Kota Surabaya",
    "Kabupaten Lamongan",
    "Kabupaten Tulungagung",
    "Kota Mojokerto",
    "Kota Probolinggo",
    "Kabupaten Jember",
    "Kabupaten Nganjuk",
    "Kabupaten Situbondo",
    "Kota Batu",
    "Kota Blitar",
    "Kabupaten Gresik",
  ];

  @override
  void initState() {
    super.initState();
    _loadLayanan();
  }

  @override
  void dispose() {
    _layananService.dispose();
    super.dispose();
  }

  Future<void> _loadLayanan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final layanan = await _layananService.getPublicLayanan();
      if (!mounted) {
        return;
      }

      setState(() {
        _layanan = layanan;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _layanan = [];
        _isLoading = false;
        _errorMessage = 'Layanan belum dapat dimuat.';
      });
    }
  }

  Future<void> _installService(LayananModel service) async {
    if (!service.isAvailable) {
      _showSnackBar('Layanan belum tersedia');
      return;
    }

    if (AuthService.currentSession == null) {
      _showSnackBar('Silakan login untuk install layanan.');
      return;
    }

    setState(() {
      _installingLayananId = service.id;
    });

    try {
      await _layananService.installLayanan(service.id);
      final refreshed = await _layananService.getPublicLayanan();
      if (!mounted) {
        return;
      }

      setState(() {
        _layanan = refreshed;
        _installingLayananId = null;
      });
      _showSnackBar('${layananDisplayTitle(service.name)} berhasil diinstall.');
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _installingLayananId = null;
      });
      _showSnackBar('Gagal install layanan.');
    }
  }

  void _openServiceDetail(LayananModel service) {
    final homeService = homeServiceFromLayanan(service);
    if (service.isInstalled && homeService != null) {
      Navigator.push(context, MaterialPageRoute(builder: homeService.builder));
      return;
    }

    _showLayananDetail(service);
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  String _serviceLogoPath(LayananModel service) {
    final backendIcon = service.iconUrl.trim();
    if (backendIcon.startsWith('http') || backendIcon.startsWith('assets/')) {
      return backendIcon;
    }
    if (backendIcon.isNotEmpty) {
      return layananLogoAssetPath(backendIcon);
    }

    final homeService = homeServiceFromLayanan(service);
    return homeService?.image ??
        layananLogoAssetPath(layananLogoAssetName(service.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 170,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/latar_belakang.png"),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Semua Layanan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: RefreshIndicator(
                      onRefresh: _loadLayanan,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          _buildDaerahDropdown(),
                          const SizedBox(height: 20),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset(
                              "assets/images/mapsjatim.png",
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildLayananContent(),
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

  Widget _buildDaerahDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF1D4F91), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedDaerah,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: daerahList.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedDaerah = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildLayananContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_errorMessage != null) {
      return Column(
        children: [
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: _loadLayanan, child: const Text('Muat ulang')),
        ],
      );
    }

    if (_layanan.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'Belum ada layanan tersedia.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: _layanan.map((item) {
        final isInstalling = _installingLayananId == item.id;

        return GestureDetector(
          onTap: isInstalling ? null : () => _openServiceDetail(item),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8E8E8)),
            ),
            child: Row(
              children: [
                AssetIconImage(
                  asset: _serviceLogoPath(item),
                  width: 42,
                  height: 42,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    layananDisplayTitle(item.name),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (isInstalling)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showLayananDetail(LayananModel service) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 28),
              AssetIconImage(
                asset: _serviceLogoPath(service),
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Text(
                layananDisplayTitle(service.name),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D1B4C),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                service.description.isEmpty
                    ? 'Detail layanan belum tersedia.'
                    : service.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: TextButton(
                        onPressed: () {
                          final homeService = homeServiceFromLayanan(service);
                          Navigator.pop(sheetContext);
                          if (service.isInstalled && homeService != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: homeService.builder),
                            );
                          } else {
                            _showSnackBar('Detail layanan belum tersedia.');
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFEAF1FF),
                          foregroundColor: const Color(0xFF1665F5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Detail Layanan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: service.isInstalled
                            ? null
                            : () {
                                Navigator.pop(sheetContext);
                                _installService(service);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1665F5),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFFE4E8F1),
                          disabledForegroundColor: Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          service.isInstalled ? "Terinstall" : "Install",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
