import 'package:flutter/material.dart';
import '../service_model.dart';

class LayananSheetContent extends StatefulWidget {
  final String kategori;
  final List<Recommendation> allData;
  final Set<int> initialSelectedIds;
  final Function(int) onToggle;

  const LayananSheetContent({
    super.key,
    required this.kategori,
    required this.allData,
    required this.initialSelectedIds,
    required this.onToggle,
  });

  @override
  State<LayananSheetContent> createState() => _LayananSheetContentState();
}

class _LayananSheetContentState extends State<LayananSheetContent> {
  late Set<int> _tempSelectedIds;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    // Copy data agar perubahan di sheet bisa dipantau secara lokal
    _tempSelectedIds = Set.from(widget.initialSelectedIds);
  }

  @override
  Widget build(BuildContext context) {
    // Filter data berdasarkan kategori DAN search query
    final filteredList = widget.allData.where((item) {
      final matchKategori = item.kategori == widget.kategori;
      final matchSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchKategori && matchSearch;
    }).toList();

    return Container(
      // 1. Latar belakang putih dengan sudut oval di kanan & kiri atas
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      // 2. Mengatur agar tinggi hanya 70-80% layar (tidak menutupi seluruh halaman)
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.94, 
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Agar tinggi mengikuti isi konten
        children: [
          _buildHandleBar(),
          _buildHeaderSection(),
          _buildSearchBar(),
          _buildGridView(filteredList),
          _buildFooterButton(),
        ],
      ),
    );
  }

  // 1. Garis abu-abu kecil di paling atas
  Widget _buildHandleBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // 2. Bagian Gambar Tas dan Judul Kategori
  Widget _buildHeaderSection() {
    String fileName = widget.kategori.toLowerCase().replaceAll(' ', '_');
    print(fileName);
    return Column(
      children: [
        const SizedBox(height: 8),
        Image.asset(
          'assets/images/kategori/$fileName.png', // Pastikan asset ini ada
          height: 90,
          errorBuilder: (context, error, stackTrace) => 
              const Icon(Icons.wallet_travel_rounded, size: 80, color: Colors.orange),
        ),
        Text(
          widget.kategori,
          style: const TextStyle(
            fontSize: 25,
            fontFamily: 'Onest',
            fontWeight: FontWeight.w700,
            color: Color(0xFF0D1B4C),
          ),
        ),
      ],
    );
  }

  // 3. Search Bar Abu-abu
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Cari Layanan',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
            color: Color(0xFFE2E2E2),
            width: 0.8,
            ),
          ),
        ),
      ),
    );
  }

  // 4. Grid Kotak-kotak Layanan
  Widget _buildGridView(List<Recommendation> data) {
    return Expanded(
      child: data.isEmpty 
      ? const Center(child: Text("Layanan tidak ditemukan"))
      : GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.05 // Atur agar kotak proporsional
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            final bool isSelected = _tempSelectedIds.contains(item.id);

            return _buildServiceCard(item, isSelected);
          },
        ),
    );
  }

  // 5. Item Card Satuan (Lengkap dengan Centang Biru)
  Widget _buildServiceCard(Recommendation item, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _tempSelectedIds.remove(item.id);
          } else {
            _tempSelectedIds.add(item.id);
          }
        });
        widget.onToggle(item.id); // Kirim perubahan ke halaman utama
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF0E63FF) : const Color(0xFFE2E2E2),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo Layanan
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset('assets/images/${item.logo}', errorBuilder: (c, e, s) => const Icon(Icons.image)),
                ),
                const SizedBox(height: 14),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.3,fontWeight: FontWeight.w500),
                ),
              ],
            ),
            if (isSelected)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.check_circle, color: Color(0xFF0E63FF), size: 22),
              ),
          ],
        ),
      ),
    );
  }

  // 6. Tombol Pilih di Paling Bawah
  Widget _buildFooterButton() {
    // Hitung berapa banyak yang dipilih khusus di kategori ini
    int currentCatCount = widget.allData
        .where((r) => r.kategori == widget.kategori && _tempSelectedIds.contains(r.id))
        .length;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0E63FF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
          child: Text(
            'Pilih ($currentCatCount)',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}