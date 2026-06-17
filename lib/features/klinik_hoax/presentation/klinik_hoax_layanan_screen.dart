import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:majadigi/features/klinik_hoax/data/klinik_hoaks_service.dart';

class KlinikHoaksLayananScreen extends StatefulWidget {
  final int initialTab; // 0 untuk Laporan, 1 untuk Lacak
  const KlinikHoaksLayananScreen({super.key, this.initialTab = 0});

  @override
  State<KlinikHoaksLayananScreen> createState() =>
      _KlinikHoaksLayananScreenState();
}

class _KlinikHoaksLayananScreenState extends State<KlinikHoaksLayananScreen> {
  late int activeTab;
  late final KlinikHoaksService _klinikHoaksService;

  final TextEditingController namaUser = TextEditingController();
  final TextEditingController emailUser = TextEditingController();
  final TextEditingController phoneUser = TextEditingController();
  final TextEditingController laporanKlinikHoaks =
      TextEditingController(); // Ini yang kamu minta
  final TextEditingController linkBukti = TextEditingController();
  final TextEditingController captchaInput = TextEditingController();
  final TextEditingController tiketLacak = TextEditingController();

  bool _isSubmitting = false;
  bool _isTracking = false;
  KlinikHoaksTrackedReport? _trackedReport;

  @override
  void initState() {
    super.initState();
    activeTab = widget.initialTab;
    _klinikHoaksService = KlinikHoaksService();
  }

  @override
  void dispose() {
    _klinikHoaksService.dispose();
    namaUser.dispose();
    emailUser.dispose();
    phoneUser.dispose();
    laporanKlinikHoaks.dispose();
    linkBukti.dispose();
    captchaInput.dispose();
    tiketLacak.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7), // Latar biru khas Majadigi
      body: Stack(
        children: [
          // Background Header
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

          Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 10),

              // Container Putih Utama
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
                      children: [
                        // Handle bar kecil di atas (opsional, biar mirip modal)
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Judul Dinamis
                        Text(
                          activeTab == 0
                              ? "Laporan Hoaks"
                              : "Lacak tiket Laporan",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Deskripsi Dinamis
                        Text(
                          activeTab == 0
                              ? "Kirimkan detail informasi yang kamu dapat, akan kami bantu cari klarifikasinya dalam 1x24 jam."
                              : "Masukkan kode tiket yang telah dikirim ke Email anda.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Form Konten
                        activeTab == 0
                            ? _buildFormLaporan()
                            : _buildFormLacak(),
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 50, 20, 10),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const Row(
              children: [
                Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Kembali',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 16),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFE2E2E2), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF0E63FF), width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _buildFormLaporan() {
    return Column(
      children: [
        _buildTextField(controller: namaUser, hintText: "Nama Anda"),
        _buildTextField(
          controller: emailUser,
          hintText: "Email",
          keyboardType: TextInputType.emailAddress,
        ),
        _buildTextField(
          controller: phoneUser,
          hintText: "No handphone",
          keyboardType: TextInputType.phone,
        ),
        _buildTextField(
          controller: laporanKlinikHoaks,
          hintText: "Isi Laporan...",
          maxLines: 4,
        ),
        _buildTextField(
          controller: linkBukti,
          hintText: "Link Bukti / Website",
        ),
        // Simulasikan Captcha (seperti di image_6c2eb1.png)
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/images/captcha_dummy.png',
                height: 40,
                errorBuilder: (c, e, s) => const Icon(Icons.image),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildTextField(
                controller: captchaInput,
                hintText: "Kode Captcha",
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        _buildSubmitButton(
          "Kirim!",
          isLoading: _isSubmitting,
          onPressed: _submitReport,
        ),
      ],
    );
  }

  // --- UI FORM LACAK ---
  Widget _buildFormLacak() {
    return Column(
      children: [
        // Desain ala kartu tiket
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFDCE7F8), width: 1.5),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.confirmation_number_outlined,
                size: 40,
                color: Color(0xFF0D57E7),
              ),
              const SizedBox(height: 12),
              const Text(
                "Nomor Tiket Laporan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1B4C),
                ),
              ),
              const SizedBox(height: 20),
              // Inputan tiket
              _buildTextField(
                controller: tiketLacak,
                hintText: "Contoh: KH-20260527-VM4HQN",
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildSubmitButton(
          "Lacak",
          isLoading: _isTracking,
          onPressed: _trackReport,
        ),
        if (_trackedReport != null) ...[
          const SizedBox(height: 24),
          _buildTrackingResult(_trackedReport!),
        ],
      ],
    );
  }

  Widget _buildSubmitButton(
    String text, {
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D57E7),
          disabledBackgroundColor: const Color(0xFF8BB4FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildTrackingResult(KlinikHoaksTrackedReport report) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDCE7F8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  report.ticketCode,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D1B4C),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildStatusChip(report.statusLabel),
            ],
          ),
          const SizedBox(height: 18),
          _buildInfoRow(Icons.person_outline, report.name),
          _buildInfoRow(Icons.mail_outline, report.email),
          if (report.phone.isNotEmpty)
            _buildInfoRow(Icons.phone_outlined, report.phone),
          if (report.formattedCreatedAt.isNotEmpty)
            _buildInfoRow(
              Icons.calendar_today_outlined,
              report.formattedCreatedAt,
            ),
          const SizedBox(height: 16),
          Text(
            report.content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: Color(0xFF343A40),
            ),
          ),
          if (report.evidenceUrl.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(Icons.link_rounded, report.evidenceUrl),
          ],
          const SizedBox(height: 22),
          const Text(
            "Progress Laporan",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D1B4C),
            ),
          ),
          const SizedBox(height: 14),
          ...report.progress.map(_buildProgressStep),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.isEmpty ? '-' : label,
        style: const TextStyle(
          color: Color(0xFF0D57E7),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF8A94A6)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF5B6472),
                fontSize: 14,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(KlinikHoaksReportProgressStep step) {
    final color = step.completed
        ? const Color(0xFF0D57E7)
        : const Color(0xFFB8C0CC);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: step.completed ? color : Colors.white,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: color, width: 2),
            ),
            child: step.completed
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    color: step.completed
                        ? const Color(0xFF0D1B4C)
                        : const Color(0xFF8A94A6),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.description,
                  style: const TextStyle(
                    color: Color(0xFF5B6472),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                if (step.formattedCompletedAt.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    step.formattedCompletedAt,
                    style: const TextStyle(
                      color: Color(0xFF8A94A6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReport() async {
    FocusScope.of(context).unfocus();

    final validationMessage = _validateReportForm();
    if (validationMessage != null) {
      _showSnackBar(validationMessage);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await _klinikHoaksService.createLaporanHoaks(
        KlinikHoaksReportRequest(
          name: namaUser.text.trim(),
          email: emailUser.text.trim(),
          phone: phoneUser.text.trim(),
          content: laporanKlinikHoaks.text.trim(),
          evidenceUrl: linkBukti.text.trim(),
        ),
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });
      await _showReportSuccessDialog(result);
      if (!mounted) {
        return;
      }

      _clearReportForm();
      setState(() {
        activeTab = 1;
        tiketLacak.text = result.ticketCode;
        _trackedReport = result.report;
      });
    } on KlinikHoaksException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
      });
      _showSnackBar(error.message);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
      });
      _showSnackBar('Gagal mengirim laporan hoaks.');
    }
  }

  Future<void> _trackReport() async {
    FocusScope.of(context).unfocus();

    final ticketCode = tiketLacak.text.trim().toUpperCase();
    if (ticketCode.isEmpty) {
      _showSnackBar('Kode tiket laporan wajib diisi.');
      return;
    }

    tiketLacak.value = TextEditingValue(
      text: ticketCode,
      selection: TextSelection.collapsed(offset: ticketCode.length),
    );

    setState(() {
      _isTracking = true;
      _trackedReport = null;
    });

    try {
      final report = await _klinikHoaksService.trackLaporanHoaks(ticketCode);
      if (!mounted) {
        return;
      }

      setState(() {
        _trackedReport = report;
        _isTracking = false;
      });
    } on KlinikHoaksException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isTracking = false;
      });
      _showSnackBar(error.message);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isTracking = false;
      });
      _showSnackBar('Gagal melacak laporan hoaks.');
    }
  }

  String? _validateReportForm() {
    final name = namaUser.text.trim();
    final email = emailUser.text.trim();
    final content = laporanKlinikHoaks.text.trim();
    final evidenceUrl = linkBukti.text.trim();

    if (name.isEmpty) {
      return 'Nama pelapor wajib diisi.';
    }
    if (email.isEmpty) {
      return 'Email pelapor wajib diisi.';
    }
    if (!_isValidEmail(email)) {
      return 'Format email pelapor tidak valid.';
    }
    if (content.isEmpty) {
      return 'Isi laporan wajib diisi.';
    }
    if (evidenceUrl.isNotEmpty && !_isValidHttpUrl(evidenceUrl)) {
      return 'Link bukti harus berupa URL http atau https.';
    }

    return null;
  }

  Future<void> _showReportSuccessDialog(
    KlinikHoaksReportCreateResult result,
  ) async {
    final emailMessage =
        result.emailDelivery.sent && result.emailDelivery.to.isNotEmpty
        ? 'Kode tiket juga sudah dikirim ke ${result.emailDelivery.to}.'
        : 'Email belum terkirim. Simpan kode tiket ini untuk melacak laporan.';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Laporan Terkirim'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(emailMessage),
              const SizedBox(height: 16),
              const Text(
                'Kode tiket',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              SelectableText(
                result.ticketCode,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF0D57E7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: result.ticketCode));
                if (mounted) {
                  _showSnackBar('Kode tiket disalin.');
                }
              },
              child: const Text('Salin Kode'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D57E7),
                foregroundColor: Colors.white,
              ),
              child: const Text('Lacak Tiket'),
            ),
          ],
        );
      },
    );
  }

  void _clearReportForm() {
    namaUser.clear();
    emailUser.clear();
    phoneUser.clear();
    laporanKlinikHoaks.clear();
    linkBukti.clear();
    captchaInput.clear();
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
  }

  bool _isValidHttpUrl(String value) {
    final parsed = Uri.tryParse(value);
    return parsed != null &&
        parsed.hasAuthority &&
        (parsed.scheme == 'http' || parsed.scheme == 'https');
  }
}
