import 'dart:async';
import 'package:flutter/material.dart';
import 'home_service_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'layanan_lain.dart';
import 'layanan_daerah.dart';
import '../../widgets/asset_icon_image.dart';
import '../../widgets/layanan_item.dart';
import '../../services/auth_service.dart';
import '../../services/layanan_service.dart';
import '../service_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.refreshVersion = 0});

  final int refreshVersion;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController();
  final LayananService _layananService = LayananService();
  int _currentPage = 1;
  Timer? _bannerTimer;
  bool _hasLoadedLayanan = false;
  List<LayananModel> _installedLayanan = [];

  String get _firstName => AuthService.currentSession?.firstName ?? 'Pengguna';

  final List<String> banners = [
    "assets/images/welcome_hero2.jpg",
    "assets/images/welcome_hero.png",
    "assets/images/welcome_hero3.jpg",
  ];
  String selectedDaerah = "Jawa Timur";

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
    _loadInstalledLayanan();

    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        _currentPage = (_currentPage + 1) % banners.length;

        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshVersion != widget.refreshVersion) {
      _loadInstalledLayanan();
    }
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _controller.dispose();
    _layananService.dispose();
    super.dispose();
  }

  Future<void> _loadInstalledLayanan() async {
    try {
      final layanan = await _layananService.getInstalledLayanan();
      if (!mounted) {
        return;
      }
      setState(() {
        _installedLayanan = layanan;
        _hasLoadedLayanan = true;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _hasLoadedLayanan = true;
      });
    }
  }

  Future<void> _openLayananLain() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => const LayananLainScreen()),
    );

    if (!mounted) {
      return;
    }
    await _loadInstalledLayanan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER + SLIDER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, bottom: 70),

                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/latar_belakang.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),

                child: Column(
                  children: [
                    // HEADER TOP
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Colors.blue),
                          ),

                          const SizedBox(width: 12),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const Text(
                                "Selamat Datang",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),

                              Text(
                                _firstName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          IconButton(
                            onPressed: _showLayananSearchSheet,
                            icon: const Icon(Icons.search, color: Colors.white),
                          ),

                          const SizedBox(width: 4),

                          const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SLIDER
                    SizedBox(
                      height: 180,

                      child: PageView.builder(
                        controller: _controller,
                        itemCount: banners.length,

                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },

                        itemBuilder: (context, index) {
                          return _bannerImage(banners[index]);
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    // DOT INDICATOR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: List.generate(
                        banners.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),

                          width: _currentPage == index ? 18 : 6,

                          height: 6,

                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.5),

                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // MAIN CONTENT
              Transform.translate(
                offset: const Offset(0, -30),

                child: Container(
                  padding: const EdgeInsets.all(20),

                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Layanan",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          GestureDetector(
                            onTap: _openLayananLain,
                            child: const Text(
                              "Semua layanan",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // GRID MENU
                      _buildLayananSection(),

                      const SizedBox(height: 28),

                      // JATIM DALAM ANGKA
                      const Text(
                        "Jatim Dalam Angka",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: const [
                          Expanded(
                            child: _StatCard(
                              "42.089.271",
                              "Jumlah Penduduk",
                              "assets/images/icon_user.png",
                            ),
                          ),

                          SizedBox(width: 12),

                          Expanded(
                            child: _StatCard(
                              "0,73 %",
                              "Pertumbuhan Penduduk",
                              "assets/images/icon_penduduk.png",
                            ),
                          ),

                          SizedBox(width: 12),

                          Expanded(
                            child: _StatCard(
                              "9,56 %",
                              "Presentase Penduduk Miskin",
                              "assets/images/icon_ekonomi.png",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // LAYANAN DAERAH
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.layers_outlined,
                                color: Color(0xFFFF2E63),
                                size: 20,
                              ),

                              SizedBox(width: 8),

                              Text(
                                "Layanan Daerah",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const SemuaLayananDaerahScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Lihat semua",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _chip("Jawa Timur", true),

                          _chip("Kabupaten Banyuwangi", false),

                          _chip("Kabupaten Tuban", false),

                          _chip("Kota Surabaya", false),

                          _chip("Kabupaten Lamongan", false),

                          _chip("Kabupaten Tulungagung", false),
                        ],
                      ),
                      const SizedBox(height: 20),

                      const SizedBox(height: 20),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          "assets/images/mapsjatim.png",
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ================= LAYANAN ITEM =================
                      _serviceItem(
                        context,
                        "assets/images/logo_majadigi.png",
                        "Paket Kunjungan Agrowisata",
                        "Layanan wisata agro Jawa Timur untuk edukasi dan kunjungan perkebunan.",
                      ),

                      _serviceItem(
                        context,
                        "assets/images/islamic_center.png",
                        "Islamic Center",
                        "Pusat informasi dan layanan kegiatan Islami Provinsi Jawa Timur.",
                      ),

                      _serviceItem(
                        context,
                        "assets/images/open_data.png",
                        "Badan Pendapatan Daerah (BAPENDA) Jawa Timur",
                        "Layanan informasi pajak daerah dan pendapatan Provinsi Jawa Timur.",
                      ),

                      _serviceItem(
                        context,
                        "assets/images/logo_majadigi.png",
                        "Data Penerima & Info Program Bansos (SAPA BANSOS)",
                        "Informasi penerima bantuan sosial dan program bansos Jawa Timur.",
                      ),

                      _serviceItem(
                        context,
                        "assets/images/rsud_haji.png",
                        "RS Paru Manguharjo Provinsi Jawa Timur",
                        "Layanan kesehatan paru dan konsultasi medis Provinsi Jawa Timur.",
                      ),

                      _serviceItem(
                        context,
                        "assets/images/logo_majadigi.png",
                        "RS Paru Jember",
                        "Rumah sakit khusus paru wilayah Jember dan sekitarnya.",
                      ),

                      _serviceItem(
                        context,
                        "assets/images/logo_majadigi.png",
                        "Forum Konsultasi Disnak Jatim",
                        "Forum konsultasi peternakan dan kesehatan hewan Jawa Timur.",
                      ),

                      _serviceItem(
                        context,
                        "assets/images/logo_majadigi.png",
                        "Rumah ASN",
                        "Platform layanan dan informasi Aparatur Sipil Negara Jawa Timur.",
                      ),

                      _serviceItem(
                        context,
                        "assets/images/rsud_haji.png",
                        "RSUD Haji Prov. Jatim",
                        "Layanan rumah sakit umum daerah milik Pemerintah Provinsi Jawa Timur.",
                      ),

                      _serviceItem(
                        context,
                        "assets/images/logo_majadigi.png",
                        "SIMPEL K3 (Sistem Pelayanan K3L)",
                        "Sistem pelayanan keselamatan dan kesehatan kerja Provinsi Jawa Timur.",
                      ),

                      _serviceItem(
                        context,
                        "assets/images/logo_majadigi.png",
                        "Beasiswa LPPD Jatim",
                        "Informasi dan pendaftaran program beasiswa Pemerintah Provinsi Jawa Timur.",
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: _CategoryCard(
                              image: "assets/images/mpp.png",
                              title: "Mall Pelayanan Publik (MPP)",
                              subtitle: "15 Mall Pelayanan Publik (MPP)",
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: _CategoryCard(
                              image: "assets/images/rs.png",
                              title: "Rumah Sakit",
                              subtitle: "8 Rumah Sakit",
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: _CategoryCard(
                              image: "assets/images/sma.png",
                              title: "SMA/SMK",
                              subtitle: "",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // AGENDA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.campaign_outlined,
                                color: Color(0xFFFF2E63),
                                size: 20,
                              ),

                              SizedBox(width: 8),

                              Text(
                                "Agenda Jawa Timur",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const Text(
                            "Lihat semua",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _agendaCard(
                        title: "BAHANA BERSAHAJA",
                        location: "Kabupaten Madiun",
                      ),

                      const SizedBox(height: 14),

                      _agendaCard(
                        title: "Gelar kesenian dan Pameran Produk Ekraf",
                        location: "Kabupaten Tulungagung",
                      ),

                      const SizedBox(height: 14),

                      _agendaCard(
                        title: "Vespa Portugis",
                        location: "Kabupaten Kediri",
                      ),

                      const SizedBox(height: 30),

                      // BERITA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.newspaper,
                                color: Color(0xFFFF2E63),
                                size: 20,
                              ),

                              SizedBox(width: 8),

                              Text(
                                "Berita Jawa Timur",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const Text(
                            "Lihat semua",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        height: 260,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _newsCard(
                              "assets/images/berita1.png",
                              "Kepala Bakorwil Malang Hadiri Pelantikan DPD IKADIN Jatim",
                              "https://kominfo.jatimprov.go.id/berita/kepala-bakorwil-malang-hadiri-pelantikan-dpd-ikadin-jatim",
                            ),

                            const SizedBox(width: 14),

                            _newsCard(
                              "assets/images/berita2.png",
                              "Gubernur Khofifah Apresiasi Mitra Usaha pada 50 Tahun PT Dharma Lautan Utama",
                              "https://kominfo.jatimprov.go.id/berita/gubernur-khofifah-apresiasi-mitra-usaha-pada-50-tahun-pt-dharma-lautan-utama",
                            ),

                            const SizedBox(width: 14),

                            _newsCard(
                              "assets/images/berita3.png",
                              "Jaga Infrastruktur Sumber Daya Air",
                              "https://kominfo.jatimprov.go.id/berita/jaga-infrastruktur-sumber-daya-air-pjt-i-jadwalkan-flushing-bendungan-wlingi-dan-lodoyo",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // CUACA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.wb_sunny_outlined,
                                color: Color(0xFFFF2E63),
                                size: 20,
                              ),

                              SizedBox(width: 8),

                              Text(
                                "Perkiraan Cuaca Jawa Timur",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const Text(
                            "Lihat semua",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        height: 260,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(bottom: 60),
                          children: [
                            _weatherCard("Jombang"),

                            const SizedBox(width: 14),

                            _weatherCard("Bojonegoro"),

                            const SizedBox(width: 14),

                            _weatherCard("Tuban"),

                            const SizedBox(width: 14),

                            _weatherCard("Lamongan"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerImage(String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(path, fit: BoxFit.cover),
      ),
    );
  }

  Future<void> _showLayananSearchSheet() async {
    final searchController = TextEditingController();
    Timer? searchDebounce;
    var results = <LayananModel>[];
    var isLoading = false;
    var currentQuery = '';
    String? errorMessage;
    int? installingLayananId;
    var isSheetOpen = true;

    Future<void> loadResults(StateSetter setModalState, String query) async {
      final keyword = query.trim();
      currentQuery = keyword;

      if (keyword.isEmpty) {
        setModalState(() {
          results = [];
          errorMessage = null;
          isLoading = false;
        });
        return;
      }

      setModalState(() {
        isLoading = true;
        errorMessage = null;
      });

      try {
        final layanan = await _layananService.getPublicLayanan(search: keyword);
        if (!mounted || !isSheetOpen || currentQuery != keyword) {
          return;
        }

        setModalState(() {
          results = layanan;
          isLoading = false;
        });
      } catch (_) {
        if (!mounted || !isSheetOpen || currentQuery != keyword) {
          return;
        }

        setModalState(() {
          results = [];
          isLoading = false;
          errorMessage = 'Pencarian layanan belum dapat dimuat.';
        });
      }
    }

    Future<void> installLayanan(
      StateSetter setModalState,
      LayananModel layanan,
    ) async {
      if (!layanan.isAvailable) {
        setModalState(() {
          errorMessage = 'Layanan belum tersedia';
        });
        return;
      }

      if (AuthService.currentSession == null) {
        setModalState(() {
          errorMessage = 'Silakan login untuk install layanan.';
        });
        return;
      }

      setModalState(() {
        installingLayananId = layanan.id;
        errorMessage = null;
      });

      try {
        await _layananService.installLayanan(layanan.id);
        await _loadInstalledLayanan();
        final refreshed = currentQuery.isEmpty
            ? <LayananModel>[]
            : await _layananService.getPublicLayanan(search: currentQuery);
        if (!mounted || !isSheetOpen) {
          return;
        }

        setModalState(() {
          results = refreshed;
          installingLayananId = null;
        });
        _showHomeSnackBar('${layanan.name} berhasil diinstall.');
      } catch (_) {
        if (!mounted || !isSheetOpen) {
          return;
        }

        setModalState(() {
          installingLayananId = null;
          errorMessage = 'Gagal install layanan.';
        });
      }
    }

    void scheduleSearch(StateSetter setModalState, String query) {
      searchDebounce?.cancel();
      searchDebounce = Timer(
        const Duration(milliseconds: 350),
        () => loadResults(setModalState, query),
      );
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return FractionallySizedBox(
              heightFactor: 0.82,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1E5EC),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Cari Layanan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: searchController,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: (value) =>
                          scheduleSearch(setModalState, value),
                      onSubmitted: (value) => loadResults(setModalState, value),
                      decoration: InputDecoration(
                        hintText: 'Cari layanan...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  searchController.clear();
                                  loadResults(setModalState, '');
                                },
                              ),
                        filled: true,
                        fillColor: const Color(0xFFF5F7FB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Color(0xFFFF2E63)),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          }

                          if (currentQuery.isEmpty) {
                            return const Center(
                              child: Text(
                                'Ketik nama layanan yang ingin dicari.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          if (results.isEmpty) {
                            return const Center(
                              child: Text(
                                'Layanan tidak ditemukan.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          return ListView.separated(
                            itemCount: results.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final layanan = results[index];
                              return _buildSearchResultTile(
                                layanan: layanan,
                                isInstalling: installingLayananId == layanan.id,
                                onOpen: () {
                                  Navigator.pop(sheetContext);
                                  Future.microtask(
                                    () => _openLayananFromSearch(layanan),
                                  );
                                },
                                onInstall: () =>
                                    installLayanan(setModalState, layanan),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      isSheetOpen = false;
      searchDebounce?.cancel();
      searchController.dispose();
    });
  }

  Widget _buildSearchResultTile({
    required LayananModel layanan,
    required bool isInstalling,
    required VoidCallback onOpen,
    required VoidCallback onInstall,
  }) {
    final homeService = homeServiceFromLayanan(layanan);
    final image = homeService?.image ?? 'assets/images/logo_majadigi.svg';

    return Material(
      color: const Color(0xFFF8FAFF),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: layanan.isInstalled ? onOpen : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: AssetIconImage(asset: image, fit: BoxFit.contain),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      layanan.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        if (layanan.categoryName.isNotEmpty)
                          layanan.categoryName,
                        layanan.isInstalled ? 'Terpasang' : 'Belum terpasang',
                      ].join(' • '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (layanan.isInstalled)
                const Icon(Icons.chevron_right, color: Color(0xFF0D57E7))
              else
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: isInstalling ? null : onInstall,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D57E7),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: isInstalling
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Install'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLayananFromSearch(LayananModel layanan) {
    final homeService = homeServiceFromLayanan(layanan);
    if (homeService != null) {
      Navigator.push(context, MaterialPageRoute(builder: homeService.builder));
      return;
    }

    _showLayananPopup(
      context: context,
      title: layanan.name,
      image: 'assets/images/logo_majadigi.svg',
      desc: layanan.description.isEmpty
          ? 'Detail layanan belum tersedia.'
          : layanan.description,
    );
  }

  void _showHomeSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Widget _buildLayananSection() {
  if (!_hasLoadedLayanan) {
    return const SizedBox(
      height: 96,
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  final services = _installedLayanan;

  if (services.isEmpty) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: const Text(
        'Belum ada layanan yang dipilih.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  final hasMoreServices = services.length > 8;

  final visibleServices = hasMoreServices
      ? services.take(7).toList()
      : services;

  final serviceItems = <Widget>[
    ...visibleServices.map(_buildInstalledLayananItem),
  ];

  if (hasMoreServices) {
    serviceItems.add(
      LayananItem(
        title: 'Lainnya',
        image: 'assets/images/icons/lainnya.svg',
        iconScale: 0.5,
        onTap: _openLayananLain,
      ),
    );
  }

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    itemCount: serviceItems.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 8,
      childAspectRatio: 0.85,
    ),
    itemBuilder: (context, index) {
      return serviceItems[index];
    },
  );
}

  LayananItem _buildInstalledLayananItem(LayananModel layanan) {
    final homeService = homeServiceFromLayanan(layanan);
    final backendIcon = layanan.iconUrl.trim();

    return LayananItem(
      title: homeService?.title ?? layananDisplayTitle(layanan.name),
      image: backendIcon.startsWith('http')
          ? backendIcon
          : homeService?.image ??
                layananLogoAssetPath(layananLogoAssetName(layanan.name)),
      onTap: () => _openInstalledLayanan(layanan),
    );
  }

  void _openInstalledLayanan(LayananModel layanan) {
    final homeService = homeServiceFromLayanan(layanan);
    if (homeService != null) {
      Navigator.push(context, MaterialPageRoute(builder: homeService.builder));
      return;
    }

    _showLayananPopup(
      context: context,
      title: layananDisplayTitle(layanan.name),
      image: layananLogoAssetPath(layananLogoAssetName(layanan.name)),
      desc: layanan.description.isEmpty
          ? 'Detail layanan belum tersedia.'
          : layanan.description,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String icon;

  const _StatCard(this.value, this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon, width: 24),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

Widget _chip(String text, bool active) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: active ? const Color(0xFFFF2E63) : Colors.white,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: active ? const Color(0xFFFF2E63) : Colors.grey.shade300,
      ),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: active ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget _serviceItem(
  BuildContext context,
  String image,
  String title,
  String desc,
) {
  return GestureDetector(
    onTap: () {
      _showLayananPopup(
        context: context,
        title: title,
        image: image,
        desc: desc,
      );
    },

    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),

      child: Row(
        children: [
          Image.asset(image, width: 40, height: 40),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ),
  );
}

void _showLayananPopup({
  required BuildContext context,
  required String title,
  required String image,
  required String desc,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,

    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(24),

        decoration: const BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
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

            const SizedBox(height: 30),

            Image.asset(image, height: 90),

            const SizedBox(height: 24),

            Text(
              title,
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B1B53),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              desc,
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 54,

                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EEF9),

                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      child: const Text(
                        "Detail Layanan",

                        style: TextStyle(
                          color: Color(0xFF0E63FF),

                          fontWeight: FontWeight.w600,

                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Container(
                    height: 54,

                    decoration: BoxDecoration(
                      color: const Color(0xFF0E63FF),

                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: TextButton(
                      onPressed: () {},

                      child: const Text(
                        "Install",

                        style: TextStyle(
                          color: Colors.white,

                          fontWeight: FontWeight.w600,

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

class _CategoryCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const _CategoryCard({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        children: [
          Image.asset(image, height: 70),

          const SizedBox(height: 14),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

Widget _agendaCard({required String title, required String location}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE8E8E8)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.calendar_today, size: 15, color: Colors.green),

                  SizedBox(width: 6),

                  Text(
                    "Sabtu, 16 Mei 2026",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),

                  const SizedBox(width: 4),

                  Text(location, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 14),

        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFFDDF0FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset("assets/images/logo_majadigi.svg"),
          ),
        ),
      ],
    ),
  );
}

Widget _newsCard(String image, String title, String url) {
  return GestureDetector(
    onTap: () async {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    },

    child: Container(
      width: 340,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),

            child: Image.asset(
              image,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: const [
                    Icon(Icons.calendar_today, size: 15, color: Colors.green),

                    SizedBox(width: 6),

                    Text(
                      "Sabtu, 16 Mei 2026",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _weatherCard(String city) {
  return Container(
    width: 180,
    padding: const EdgeInsets.all(16),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE8E8E8)),
    ),

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          city,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        const Icon(Icons.cloud_outlined, size: 70, color: Color(0xFF7AA6D9)),

        const SizedBox(height: 12),

        const Text(
          "Berawan",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    ),
  );
}