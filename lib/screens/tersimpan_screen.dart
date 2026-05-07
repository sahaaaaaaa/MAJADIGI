import 'package:flutter/material.dart';
import 'service_model.dart';
import 'klinik_hoaks_home_screen.dart';

class TersimpanScreen extends StatefulWidget {
  final Set<int>? selectedIds;
  final List<Recommendation>? allData;

  const TersimpanScreen({
    super.key, 
    this.selectedIds, 
    this.allData, // Tambahkan ini
  });

  @override
  State<TersimpanScreen> createState() => _TersimpanScreenState();
}

class _TersimpanScreenState extends State<TersimpanScreen> {
  bool _isTerinstallActive = true;    
  Set<int> _favoriteIds = {2, 3, 10};

  @override
  Widget build(BuildContext context) {
    final sourceData = (widget.allData == null || widget.allData!.isEmpty) 
      ? recommendations 
      : widget.allData!;

  // Logika filter berdasarkan ID
  final displayList = (widget.selectedIds == null || widget.selectedIds!.isEmpty)
      ? sourceData
      : sourceData.where((item) => widget.selectedIds!.contains(item.id)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7), 
      body: SafeArea(
        bottom: false, 
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: -430,
              child: Transform.rotate(
                angle: -60.94 * (3.14159 / 180), // Konversi derajat ke radian agar sesuai Figma
                child: Container(
                width: 950,
                height: 850,
                decoration: BoxDecoration(
                  gradient: LinearGradient( 
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0047B3), // Warna biru tua dari Figma
                    Color(0xFF0065FF), // Warna biru muda dari Figma
                  ],
                ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  Radius.elliptical(935, 791),
                ),
              ),
                ),
            ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tersimpan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Onest',
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                ),

                // 3. Container Putih Utama (Body)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // 4. Tab Switcher (Terinstall & Favorit)
                        _buildTabSwitcher(),
                        const SizedBox(height: 10),
                        // 5. Grid Layanan yang Terinstall
                        Expanded(
                          child: _isTerinstallActive
                              ? _buildGridTerinstall(widget.allData ?? [])
                              : _buildGridFavorit(widget.allData ?? []),
                        ),
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

  Widget _buildGridTerinstall(List<Recommendation> allItems) {
  // Filter: Hanya ambil item yang ID-nya ada di selectedIds (dari Register Screen)
  final terinstallItems = allItems
      .where((item) => widget.selectedIds?.contains(item.id) ?? false)
      .toList();

  if (terinstallItems.isEmpty) {
    return const Center(
      child: Text("Belum ada layanan terinstall", style: TextStyle(color: Colors.grey)),
    );
  }

  return GridView.builder(
    padding: const EdgeInsets.all(24),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // 2 kolom sesuai desain
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.0,
    ),
    itemCount: terinstallItems.length,
    itemBuilder: (context, index) {
      final item = terinstallItems[index];
      return GestureDetector(
        onTap: () => _showServiceDetails(item, isFavoriteView: false), // Munculkan popup detail/hapus
        child: _buildItemCard(item), // Memanggil fungsi kartu yang sudah kamu punya
      );
    },
  );
}

  Widget _buildTabSwitcher() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          _buildSingleTab('Terinstall', _isTerinstallActive, () {
            setState(() => _isTerinstallActive = true);
          }),
          _buildSingleTab('Favorit', !_isTerinstallActive, () {
            setState(() => _isTerinstallActive = false);
          }),
        ],
      ),
    );
  }

  Widget _buildSingleTab(String title, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFE7F0FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            border: isActive ? Border.all(color: const Color(0xFF0D57E7).withOpacity(0.1)) : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? const Color(0xFF0D57E7) : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(Recommendation item) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 5),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/${item.logo}',
              height: 40,
              width: 40,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.apps, size: 40, color: Colors.blue),
            ),
            const Icon(Icons.more_vert, color: Colors.grey, size: 22),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1A1A1A)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          item.description,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.4),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

  Widget _buildGridFavorit(List<Recommendation> allItems) {
  // 1. Filter: Hanya ambil yang ID-nya ada di _favoriteIds
  // 2. Limit: Ambil maksimal 3 item saja agar lebih ringkas
  final favoriteItems = allItems
      .where((item) => _favoriteIds.contains(item.id))
      .take(3) 
      .toList();

  // Jika daftar favorit kosong
  if (favoriteItems.isEmpty) {
    return const Center(
      child: Text(
        "Belum ada favorit",
        style: TextStyle(color: Colors.grey), // Tampilan teks lebih soft
      ),
    );
  }

  return GridView.builder(
    padding: const EdgeInsets.all(24),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.0,
    ),
    itemCount: favoriteItems.length,
    itemBuilder: (context, index) {
      final item = favoriteItems[index];
      return GestureDetector(
        onTap: () => _showServiceDetails(item, isFavoriteView: true), // Popup khusus favorit
        child: _buildItemCard(item), // Menggunakan card yang sudah dipisah tadi
      );
    },
  );
}

  Widget _buildFavoritPlaceholder() {
    return Center(
      child: Text("Belum ada favorit", style: TextStyle(color: Colors.grey.shade400)),
    );
  }

  void _showServiceDetails(Recommendation item, {bool isFavoriteView = false}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              width: 40, 
              height: 4, 
              decoration: BoxDecoration(
                color: Colors.grey[300], 
                borderRadius: BorderRadius.circular(10)
              )
            ),
            const SizedBox(height: 20),
            
            // Logo & Info
            Image.asset('assets/${item.logo}', height: 64, errorBuilder: (c, e, s) => const Icon(Icons.apps, size: 64)),
            const SizedBox(height: 16),
            Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(item.description, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 24),
            
            // Button 1: Detail (Selalu sama)
            ListTile(
              leading: const Icon(Icons.launch, color: Colors.black),
              title: const Text('Detail Layanan'),
              onTap: () {
                Navigator.pop(context); // Tutup bottom sheet dulu

                // Logika navigasi spesifik untuk Klinik Hoaks
                if (item.title == "Klinik Hoaks") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KlinikHoaksHomeScreen(),
                    ),
                  );
                } else {
                  // Navigasi ke halaman detail umum lainnya jika ada
                  print("Membuka detail untuk: ${item.title}");
                }
              },
            ),

            // Button 2: Hapus (Logika IF ELSE di sini)
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                isFavoriteView ? 'Hapus dari Favorit' : 'Hapus Layanan', // IF ELSE Teks
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                if (isFavoriteView) {
                  _removeFavorite(item); // Aksi hapus favorit
                } else {
                  _showDeleteConfirmation(item); // Aksi hapus terinstall
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

  void _showDeleteConfirmation(Recommendation item) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Layanan', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Apakah anda yakin untuk menghapus layanan yang sudah terinstall?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          SizedBox(
            width: 120,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: const Text('Batal', style: TextStyle(color: Colors.black)),
            ),
          ),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () {
                // Logika hapus data di sini
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEB4356), // Warna merah sesuai Figma
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    },
  );
}

void _showFavoriteDetails(Recommendation item) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ... (Logo dan Deskripsi sama seperti sebelumnya)
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Hapus dari Favorit', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _removeFavorite(item); // Panggil fungsi hapus
              },
            ),
          ],
        ),
      );
    },
  );
}

void _removeFavorite(Recommendation item) {
  setState(() {
    _favoriteIds.remove(item.id);
  });

  // Munculkan SnackBox Hitam sesuai gambar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black, // Warna hitam pekat
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Text(
              'Layanan berhasil dihapus dari favorit',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );
}

}