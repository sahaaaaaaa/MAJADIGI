import 'package:flutter/material.dart';

class KlinikHoaksLayananScreen extends StatefulWidget {
  final int initialTab; // 0 untuk Laporan, 1 untuk Lacak
  const KlinikHoaksLayananScreen({super.key, this.initialTab = 0});

  @override
  State<KlinikHoaksLayananScreen> createState() => _KlinikHoaksLayananScreenState();
}

class _KlinikHoaksLayananScreenState extends State<KlinikHoaksLayananScreen> {
  late int activeTab;

  @override
  void initState() {
    super.initState();
    activeTab = widget.initialTab;
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

  // --- UI FORM LAPORAN ---
  Widget _buildFormLaporan() {
    return Column(
      children: [
        _buildTextField(label: "Nama Anda"),
        _buildTextField(label: "Email"),
        _buildTextField(label: "No handphone"),
        _buildTextField(label: "Isi Laporan...", maxLines: 4),
        _buildTextField(label: "Link Bukti / Website"),
        
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
            Expanded(child: _buildTextField(label: "Kode Captcha")),
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
        _buildTextField(label: "No Tiket"),
        const SizedBox(height: 20),
        _buildSubmitButton("Lacak"),
      ],
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildTextField({required String label, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0D57E7)),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {},
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