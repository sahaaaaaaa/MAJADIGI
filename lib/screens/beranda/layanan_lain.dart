import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/layanan_service.dart';
import '../service_model.dart';
import 'home_service_item.dart';

class LayananLainScreen extends StatefulWidget {
  const LayananLainScreen({super.key});

  @override
  State<LayananLainScreen> createState() => _LayananLainScreenState();
}

class _LayananLainScreenState extends State<LayananLainScreen> {
  final LayananService _layananService = LayananService();
  final Set<String> _expandedCategories = <String>{};

  bool _isLoading = true;
  String? _errorMessage;
  int? _installingLayananId;
  List<LayananModel> _services = [];

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  @override
  void dispose() {
    _layananService.dispose();
    super.dispose();
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final services = await _layananService.getPublicLayanan();
      if (!mounted) {
        return;
      }

      setState(() {
        _services = _installedFirst(services);
        _isLoading = false;
        final grouped = _groupedServices;
        if (_expandedCategories.isEmpty && grouped.isNotEmpty) {
          _expandedCategories.add(grouped.keys.first);
        }
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Layanan belum dapat dimuat.';
      });
    }
  }

  Map<String, List<LayananModel>> get _groupedServices {
    final grouped = <String, List<LayananModel>>{};
    for (final service in _services) {
      final category = _categoryName(service);
      grouped.putIfAbsent(category, () => <LayananModel>[]).add(service);
    }

    final entries = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Map<String, List<LayananModel>>.fromEntries(entries);
  }

  String _categoryName(LayananModel service) {
    return layananCategoryName(service.name, service.categoryName);
  }

  List<LayananModel> _installedFirst(List<LayananModel> services) {
    final installed = <LayananModel>[];
    final notInstalled = <LayananModel>[];

    for (final service in services) {
      if (service.isInstalled) {
        installed.add(service);
      } else {
        notInstalled.add(service);
      }
    }

    return [...installed, ...notInstalled];
  }

  Future<void> _handleServiceTap(LayananModel service) async {
    if (service.isInstalled) {
      _openInstalledService(service);
      return;
    }

    await _confirmInstall(service);
  }

  void _openInstalledService(LayananModel service) {
    final homeService = homeServiceFromLayanan(service);
    if (homeService != null) {
      Navigator.push(context, MaterialPageRoute(builder: homeService.builder));
      return;
    }

    _showServiceDetail(service);
  }

  Future<void> _confirmInstall(LayananModel service) async {
    if (AuthService.currentSession == null) {
      _showSnackBar('Silakan login untuk install layanan.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Install layanan?'),
          content: Text(
            'Apakah anda ingin install ${layananDisplayTitle(service.name)} agar layanan ini muncul di Beranda?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E63FF),
                foregroundColor: Colors.white,
              ),
              child: const Text('Install'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _installService(service);
    }
  }

  Future<void> _installService(LayananModel service) async {
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
        _services = _installedFirst(refreshed);
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

  void _showServiceDetail(LayananModel service) {
    showModalBottomSheet<void>(
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
              _serviceLogo(service, size: 90),
              const SizedBox(height: 24),
              Text(
                layananDisplayTitle(service.name),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1B53),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _categoryName(service),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 14),
              Text(
                service.description.isEmpty
                    ? 'Detail layanan belum tersedia.'
                    : service.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 160,
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/latar_belakang.png'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Layanan Lain',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loadServices,
              child: const Text('Muat ulang'),
            ),
          ],
        ),
      );
    }

    if (_services.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada layanan tersedia.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final grouped = _groupedServices;

    return RefreshIndicator(
      onRefresh: _loadServices,
      child: ListView(
        children: [
          const Text(
            'Semua layanan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildServiceGrid(_services),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 8),
          ...grouped.entries.map((entry) {
            return _buildCategorySection(entry.key, entry.value);
          }),
        ],
      ),
    );
  }

  Widget _buildServiceGrid(List<LayananModel> services) {
    return GridView.builder(
      itemCount: services.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 18,
        crossAxisSpacing: 10,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        return _buildServiceTile(services[index]);
      },
    );
  }

  Widget _buildCategorySection(String category, List<LayananModel> services) {
    final isExpanded = _expandedCategories.contains(category);

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (isExpanded) {
                _expandedCategories.remove(category);
              } else {
                _expandedCategories.add(category);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: isExpanded ? 18 : 17,
                      fontWeight: isExpanded
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '${services.length}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(width: 10),
                Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: 4),
          _buildServiceGrid(services),
          const SizedBox(height: 16),
        ],
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildServiceTile(LayananModel service) {
    final isInstalled = service.isInstalled;
    final isInstalling = _installingLayananId == service.id;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: isInstalling ? null : () => _handleServiceTap(service),
      child: Opacity(
        opacity: isInstalled || isInstalling ? 1 : 0.55,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox.square(
                  dimension: 58,
                  child: Center(child: _serviceLogo(service, size: 56)),
                ),
                Positioned(
                  right: -6,
                  top: -5,
                  child: _statusBadge(service, isInstalling: isInstalling),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              layananDisplayTitle(service.name),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, height: 1.25),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(LayananModel service, {required bool isInstalling}) {
    if (isInstalling) {
      return Container(
        width: 20,
        height: 20,
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Color(0xFF0E63FF),
          shape: BoxShape.circle,
        ),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (service.isInstalled) {
      return const Icon(Icons.check_circle, size: 20, color: Color(0xFF23A55A));
    }

    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Color(0xFFFFB020),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add, size: 14, color: Colors.white),
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
          return Image.asset(assetPath, width: size, height: size);
        },
      );
    }

    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
