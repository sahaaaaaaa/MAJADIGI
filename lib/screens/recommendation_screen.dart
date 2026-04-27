import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'category_selection_screen.dart';

class Recommendation {
  final int id; // Tambahkan ID agar unik
  final String title;
  final String description;
  final String logo;

  Recommendation({required this.id,required this.title, required this.description, required this.logo});
}

// List contoh data (variabel yang mudah diotak-atik)
final List<Recommendation> recommendations = [
  Recommendation(id: 1, title: 'RSUD Dr. Saiful...', description: 'Koleksi khas semua tentang Jawa Timur', logo: 'rsud.png'),
  Recommendation(id: 2, title: 'Islamic Center', description: 'Koleksi khas semua tentang Jawa Timur', logo: 'islamic_center.png'),
  Recommendation(id: 3, title: 'Open Data', description: 'Koleksi khas semua tentang Jawa Timur', logo: 'open_data.png'),
  Recommendation(id: 4, title: 'Point Jatim', description: 'Koleksi khas semua tentang Jawa Timur', logo: 'point_jatim.png'),
  Recommendation(id: 5, title: 'Klinik Hoaks', description: 'Koleksi khas semua tentang Jawa Timur', logo: 'klinik_hoaks.png'),
];

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  Set<int> _selectedIds = {};
  
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
                                _buildStepContent(),
                                const SizedBox(height: 24),
                              ],
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

  Widget _buildStepContent() {
  return Container(
    width: 400,
    padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        // Judul Frame
        const Text(
          'Rekomendasi',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Onest',
            fontWeight: FontWeight.w600, // SemiBold
            fontSize: 24,
            height: 32 / 24,
            color: Color(0xFF081131),
          ),
        ),
        const SizedBox(height: 8),
        // Penjelasan Frame
        const Text(
          'Rekomendasi Layanan populer sesuai tempat tinggal anda',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Onest',
            fontWeight: FontWeight.w400, // Regular
            fontSize: 14,
            height: 20 / 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 26),
        // List Pilihan (Grid 2 Kolom)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 145, 
          ),
          itemCount: recommendations.length,
          itemBuilder: (context, index) {
            return _buildRecommendationCard(recommendations[index]);
          },
        ),
      ],
    ),
  );
}

  Widget _buildRecommendationCard(Recommendation item) {
    bool isSelected = _selectedIds.contains(item.id);

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          _selectedIds.remove(item.id); // Batal pilih (uncheck)
        } else {
          _selectedIds.add(item.id); // Tambah pilihan (check)
        }
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF4F8FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0065FF) : const Color(0xFFE8E8E8), 
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Stack( 
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/${item.logo}',
                  width: 32, height: 32,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.business, color: Colors.blue),
                ),
                const SizedBox(height: 12),
                Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
              ],
            ),
            if (isSelected)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.check_circle, color: Color(0xFF0065FF), size: 20),
              ),
          ],
        ),
      ),
    );
  }
  Widget _buildBottomButtons() {
  return Row(
    children: [
      Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PilihKategori())
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFFDCE7F8),
                foregroundColor: const Color(0xFF0E63FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Lewati',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PilihKategori())
                );
                print("Layanan yang dipilih: $_selectedIds");
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF0E63FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Selanjutnya',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,),
                ),
              ),
            ),
          ),
        ],
      );    
    }
  
  


}
