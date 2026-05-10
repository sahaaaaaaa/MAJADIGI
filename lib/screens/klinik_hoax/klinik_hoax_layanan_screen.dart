import 'package:flutter/material.dart';

class KlinikHoaksLayananScreen extends StatefulWidget {
  final int initialTab; // 0 untuk Laporan, 1 untuk Lacak
  const KlinikHoaksLayananScreen({super.key, this.initialTab = 0});

  @override
  State<KlinikHoaksLayananScreen> createState() => _KlinikHoaksLayananScreenState();
}

class _KlinikHoaksLayananScreenState extends State<KlinikHoaksLayananScreen> {
  late int activeTab;

  final TextEditingController namaUser = TextEditingController();
  final TextEditingController emailUser = TextEditingController();
  final TextEditingController phoneUser = TextEditingController();
  final TextEditingController laporanKlinikHoaks = TextEditingController(); // Ini yang kamu minta
  final TextEditingController linkBukti = TextEditingController();
  final TextEditingController captchaInput = TextEditingController();
  final TextEditingController tiketLacak = TextEditingController();

  @override
  void initState() {
    super.initState();
    activeTab = widget.initialTab;
  }

  @override
  void dispose() {
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
                          activeTab == 0 ? "Laporan Hoaks" : "Lacak tiket Laporan",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        
                        // Deskripsi Dinamis
                        Text(
                          activeTab == 0 
                            ? "Kirimkan detail informasi yang kamu dapat, akan kami bantu cari klarifikasinya dalam 1x24 jam."
                            : "Masukkan no tiket yang telah dikirim ke WhatsApp dan Email anda.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5),
                        ),
                        const SizedBox(height: 30),

                        // Form Konten
                        activeTab == 0 ? _buildFormLaporan() : _buildFormLacak(),
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
                Text('Kembali', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
        _buildTextField(controller: emailUser, hintText: "Email", keyboardType: TextInputType.emailAddress),
        _buildTextField(controller: phoneUser, hintText: "No handphone", keyboardType: TextInputType.phone),
        _buildTextField(controller: laporanKlinikHoaks, hintText: "Isi Laporan...", maxLines: 4),
        _buildTextField(controller: linkBukti, hintText: "Link Bukti / Website"),
       // Simulasikan Captcha (seperti di image_6c2eb1.png)     
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset('assets/images/captcha_dummy.png', height: 40, errorBuilder: (c, e, s) => const Icon(Icons.image)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildTextField(
                controller: captchaInput, 
                hintText: "Kode Captcha"
                ),
              ),
          ],
        ),
        const SizedBox(height: 30),
        _buildSubmitButton("Kirim!"),
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
            const Icon(Icons.confirmation_number_outlined, size: 40, color: Color(0xFF0D57E7)),
            const SizedBox(height: 12),
            const Text(
              "Nomor Tiket Laporan",
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D1B4C)),
            ),
            const SizedBox(height: 20),
            // Inputan tiket
            _buildTextField(
              controller: tiketLacak, 
              hintText: "Contoh: MJD-12345",
              keyboardType: TextInputType.text,
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      _buildSubmitButton("Cek Status Tiket"),
    ],
  );
}

  Widget _buildSubmitButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D57E7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}