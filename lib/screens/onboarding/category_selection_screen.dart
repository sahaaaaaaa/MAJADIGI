import 'package:flutter/material.dart';
import 'bottom_sheet_screen.dart';
import '../service_model.dart';
import 'loading_screen.dart';
import '../../services/auth_service.dart';

class PilihKategori extends StatefulWidget {
  final RegisterRequest? registrationData;
  final Set<int> initialSelectedIds;

  const PilihKategori({
    super.key,
    this.registrationData,
    this.initialSelectedIds = const <int>{},
  });

  @override
  State<PilihKategori> createState() => _PilihKategori();
}

class _PilihKategori extends State<PilihKategori> {
  final AuthService authService = AuthService();
  final Set<int> _selectedIds = {};
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedIds.addAll(widget.initialSelectedIds);
  }

  @override
  void dispose() {
    authService.dispose();
    super.dispose();
  }

  Future<void> _finishSelection({required bool allowEmpty}) async {
    if (isSubmitting || (!allowEmpty && _selectedIds.isEmpty)) {
      return;
    }

    if (widget.registrationData == null) {
      _goToLoading();
      return;
    }

    final selectedIds = _selectedIds.toList()..sort();

    setState(() {
      isSubmitting = true;
    });

    try {
      await authService.register(
        request: widget.registrationData!,
        layananIds: selectedIds,
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoadingLayanan()),
        (route) => false,
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      _showMessage(error.message);
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  void _goToLoading() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoadingLayanan()),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -140,
              left: -120,
              child: Container(
                width: 520,
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 12),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(20),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Kembali',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Onest',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(34),
                        topRight: Radius.circular(34),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildTopHeader(),
                        const SizedBox(height: 28),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildTitleSection(),
                                const SizedBox(height: 26),
                                _buildCategorySection(),
                              ]
                            ),
                          ),
                        ),
                        _buildBottomButtons(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 42,
                height: 42,
                child: Image.asset(
                  'assets/images/logo_majadigi.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.bubble_chart_rounded,
                      color: Color(0xFF0E63FF),
                      size: 36,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MAJADIGI',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1453D1),
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    'Majapahit Digital',
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF888888),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE2E2E2), width: 1),
          ),
          child: const Row(
            children: [
              Icon(Icons.language, size: 18, color: Color(0xFF4F4F4F)),
              SizedBox(width: 6),
              Text(
                'Bahasa Indonesia',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4F4F4F),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
          'Pilih Layananmu',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontFamily: 'Onest',
            fontWeight: FontWeight.w700,
            color: Color(0xFF0D1B4C),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Pilih layanan publik yang sesui dengan kebutuhan layanan Anda.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Recommendation item) {
  // Cek apakah ID item ini ada dalam list yang dipilih
    bool isSelected = _selectedIds.contains(item.id);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedIds.remove(item.id);
          } else {
            _selectedIds.add(item.id);
          }
        });
      },
      child: Container(
        width: double.infinity, 
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF0E63FF) 
                : const Color(0xFFE2E2E2),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Image.asset(item.logo, height: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              isSelected ? Icons.check : Icons.add,
              color: isSelected 
                  ? const Color(0xFF0E63FF) 
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    final categories = [
      'Pariwisata & Kebudayaan', 'Pendidikan', 'Ketenagakerjaan', 
      'Ekonomi & Bisnis', 'Kesehatan', 'Kependudukan', 'Multisektor (Khusus)', 
      'Infrastruktur', 'Sosial', 'Lingkungan Hidup', 'PPID', 
      'Pemerintah & Desa', 'Kebencanaan'
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 12,
      children: categories.map((cat) {
        int count = recommendations.where((r) => r.kategori == cat && _selectedIds.contains(r.id)).length;
        bool isSelected = count > 0;
        
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => LayananSheetContent(
              kategori: cat,
              allData: recommendations,// Ambil data dari variabel global kamu
              initialSelectedIds: _selectedIds,
              onToggle: (id) {
                setState(() {
                  if (_selectedIds.contains(id)) {
                    _selectedIds.remove(id);
                  } else {
                    _selectedIds.add(id);
                  }
                });
              },
            ),
          );
        },
          child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE8F1FF) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected 
                  ? const Color(0xFF0E63FF) 
                  : const Color(0xFFE2E2E2),
              width: 1.3,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                cat,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected 
                      ? const Color(0xFF0E63FF) 
                      : const Color(0xFF2F2F2F),
                ),
              ),

              /// COUNT (KURUNG)
              if (isSelected && count > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '($count)',
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Onest',
                    color: Color(0xFF0E63FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],

              const SizedBox(width: 6),

              /// ICON DI KANAN
              Icon(
                isSelected ? Icons.check : Icons.add,
                size: 18,
                color: isSelected 
                    ? const Color(0xFF0E63FF) 
                    : const Color(0xFF9E9E9E),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            text: isSubmitting ? 'Memproses...' : 'Lewati',
            isPrimary: false,
            onPressed: isSubmitting
                ? null
                : () => _finishSelection(allowEmpty: true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildButton(
            text: isSubmitting
                ? 'Memproses...'
                : 'Selanjutnya${_selectedIds.isNotEmpty ? " (${_selectedIds.length})" : ""}',
            isPrimary: true,
            onPressed: isSubmitting || _selectedIds.isEmpty
                ? null
                : () => _finishSelection(allowEmpty: false),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required bool isPrimary,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
              isPrimary ? const Color(0xFF0E63FF) : const Color(0xFFDCE7F8),
          foregroundColor: isPrimary ? Colors.white : const Color(0xFF0E63FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
