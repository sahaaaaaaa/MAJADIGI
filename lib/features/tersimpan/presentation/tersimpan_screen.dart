import 'package:flutter/material.dart';

import 'package:majadigi/features/auth/data/auth_service.dart';
import 'package:majadigi/features/layanan/data/layanan_service.dart';
import 'package:majadigi/core/widgets/asset_icon_image.dart';
import 'package:majadigi/features/home/presentation/home_service_item.dart';
import 'package:majadigi/core/models/service_model.dart';

class TersimpanScreen extends StatefulWidget {
  const TersimpanScreen({super.key, this.refreshVersion = 0});

  final int refreshVersion;

  @override
  State<TersimpanScreen> createState() => _TersimpanScreenState();
}

class _TersimpanScreenState extends State<TersimpanScreen> {
  late final LayananService _layananService;

  bool _isTerinstallActive = true;
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  List<LayananModel> _installedServices = [];
  List<LayananModel> _favoriteServices = [];
  final Set<int> _busyServiceIds = <int>{};

  @override
  void initState() {
    super.initState();
    _layananService = LayananService();
    _loadServices();
  }

  @override
  void didUpdateWidget(covariant TersimpanScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshVersion != widget.refreshVersion) {
      _loadServices(showLoading: false);
    }
  }

  @override
  void dispose() {
    _layananService.dispose();
    super.dispose();
  }

  Future<void> _loadServices({bool showLoading = true}) async {
    if (AuthService.currentSession == null) {
      setState(() {
        _installedServices = [];
        _favoriteServices = [];
        _isLoading = false;
        _errorMessage = null;
      });
      return;
    }

    if (showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final results = await Future.wait([
        _layananService.getInstalledLayanan(search: _searchQuery),
        _layananService.getFavoriteLayanan(search: _searchQuery),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        _installedServices = results[0];
        _favoriteServices = results[1];
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Layanan tersimpan belum dapat dimuat.';
      });
    }
  }

  List<LayananModel> get _activeServices {
    return _isTerinstallActive ? _installedServices : _favoriteServices;
  }

  @override
  Widget build(BuildContext context) {
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
                angle: -60.94 * (3.14159 / 180),
                child: Container(
                  width: 950,
                  height: 850,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0047B3), Color(0xFF0065FF)],
                    ),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.elliptical(935, 791)),
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
                        onPressed: _showSearchSheet,
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
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
                        _buildTabSwitcher(),
                        if (_searchQuery.isNotEmpty) _buildSearchChip(),
                        const SizedBox(height: 10),
                        Expanded(child: _buildContent()),
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
            border: isActive
                ? Border.all(
                    color: const Color(0xFF0D57E7).withValues(alpha: 0.1),
                  )
                : null,
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

  Widget _buildSearchChip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InputChip(
          label: Text(_searchQuery),
          onDeleted: () {
            setState(() {
              _searchQuery = '';
            });
            _loadServices();
          },
          deleteIcon: const Icon(Icons.close, size: 18),
          backgroundColor: const Color(0xFFF2F6FF),
          side: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (_errorMessage != null) {
      return _buildMessage(
        _errorMessage!,
        actionLabel: 'Muat ulang',
        onAction: _loadServices,
      );
    }

    if (AuthService.currentSession == null) {
      return _buildMessage('Silakan login untuk melihat layanan tersimpan.');
    }

    final services = _activeServices;
    if (services.isEmpty) {
      return _buildMessage(
        _isTerinstallActive
            ? 'Belum ada layanan terinstall.'
            : 'Belum ada layanan favorit.',
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadServices(showLoading: false),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.95,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return GestureDetector(
            onTap: () => _showServiceActions(service),
            child: _buildItemCard(service),
          );
        },
      ),
    );
  }

  Widget _buildMessage(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 12),
              TextButton(onPressed: onAction, child: Text(actionLabel)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(LayananModel service) {
    final isBusy = _busyServiceIds.contains(service.id);

    return Opacity(
      opacity: isBusy ? 0.65 : 1,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _serviceLogo(service, size: 48),
                isBusy
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.more_vert, color: Colors.grey, size: 22),
              ],
            ),
            const Spacer(),
            Text(
              layananDisplayTitle(service.name),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF1A1A1A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              service.description.isEmpty
                  ? layananCategoryName(service.name, service.categoryName)
                  : service.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceLogo(LayananModel service, {required double size}) {
    final homeService = homeServiceFromLayanan(service);
    final assetPath =
        homeService?.image ??
        layananLogoAssetPath(layananLogoAssetName(service.name));

    if (service.iconUrl.startsWith('http')) {
      return Image.network(
        service.iconUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return AssetIconImage(asset: assetPath, width: size, height: size);
        },
      );
    }

    return AssetIconImage(
      asset: assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }

  Future<void> _showServiceActions(LayananModel service) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final maxHeight = MediaQuery.sizeOf(context).height * 0.88;

        return SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _serviceLogo(service, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      layananDisplayTitle(service.name),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.description.isEmpty
                          ? layananCategoryName(
                              service.name,
                              service.categoryName,
                            )
                          : service.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    ListTile(
                      leading: const Icon(Icons.launch, color: Colors.black),
                      title: const Text('Detail Layanan'),
                      onTap: () {
                        Navigator.pop(context);
                        _openService(service);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        service.isFavorite
                            ? Icons.bookmark_remove_outlined
                            : Icons.bookmark_add_outlined,
                        color: const Color(0xFF0D57E7),
                      ),
                      title: Text(
                        service.isFavorite
                            ? 'Hapus dari Favorit'
                            : 'Tambah Favorit',
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _setFavorite(service, !service.isFavorite);
                      },
                    ),
                    if (_isTerinstallActive)
                      ListTile(
                        leading: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        title: const Text(
                          'Hapus Layanan',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _confirmUninstall(service);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openService(LayananModel service) async {
    final homeService = homeServiceFromLayanan(service);
    if (homeService == null) {
      _showSnackBar('Detail layanan belum tersedia.');
      return;
    }

    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: homeService.builder),
    );

    if (mounted) {
      await _loadServices(showLoading: false);
    }
  }

  Future<void> _setFavorite(LayananModel service, bool isFavorite) async {
    if (_busyServiceIds.contains(service.id)) {
      return;
    }

    setState(() {
      _busyServiceIds.add(service.id);
      _installedServices = _installedServices
          .map(
            (item) => item.id == service.id
                ? item.copyWith(isFavorite: isFavorite)
                : item,
          )
          .toList();
      if (!isFavorite) {
        _favoriteServices = _favoriteServices
            .where((item) => item.id != service.id)
            .toList();
      }
    });

    try {
      if (isFavorite) {
        await _layananService.addFavoriteLayanan(service.id);
      } else {
        await _layananService.removeFavoriteLayanan(service.id);
      }

      await _loadServices(showLoading: false);
      _showSnackBar(
        isFavorite
            ? 'Layanan berhasil ditambahkan ke favorit.'
            : 'Layanan berhasil dihapus dari favorit.',
      );
    } catch (_) {
      await _loadServices(showLoading: false);
      _showSnackBar('Gagal memperbarui favorit layanan.');
    } finally {
      if (mounted) {
        setState(() {
          _busyServiceIds.remove(service.id);
        });
      }
    }
  }

  Future<void> _confirmUninstall(LayananModel service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Hapus Layanan',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Apakah anda yakin untuk menghapus layanan yang sudah terinstall?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            SizedBox(
              width: 120,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB4356),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Hapus',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _uninstallService(service);
    }
  }

  Future<void> _uninstallService(LayananModel service) async {
    if (_busyServiceIds.contains(service.id)) {
      return;
    }

    setState(() {
      _busyServiceIds.add(service.id);
    });

    try {
      await _layananService.uninstallLayanan(service.id);
      setState(() {
        _installedServices = _installedServices
            .where((item) => item.id != service.id)
            .toList();
        _favoriteServices = _favoriteServices
            .where((item) => item.id != service.id)
            .toList();
      });
      _showSnackBar('Layanan berhasil dihapus.');
    } catch (_) {
      _showSnackBar('Gagal menghapus layanan.');
    } finally {
      if (mounted) {
        setState(() {
          _busyServiceIds.remove(service.id);
        });
      }
    }
  }

  Future<void> _showSearchSheet() async {
    final controller = TextEditingController(text: _searchQuery);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E5EC),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    Navigator.pop(context);
                    _applySearch(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari layanan tersimpan...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: const Color(0xFFF5F7FB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _applySearch('');
                        },
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _applySearch(controller.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D57E7),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Cari'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    controller.dispose();
  }

  void _applySearch(String value) {
    setState(() {
      _searchQuery = value.trim();
    });
    _loadServices();
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
