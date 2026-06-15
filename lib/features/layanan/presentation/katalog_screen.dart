import 'package:flutter/material.dart';
import 'package:majadigi/features/home/presentation/home_service_item.dart';
import 'package:majadigi/features/auth/data/auth_service.dart';
import 'package:majadigi/features/layanan/data/layanan_service.dart';
import 'package:majadigi/core/widgets/asset_icon_image.dart';

import 'package:majadigi/core/models/service_model.dart';

class KatalogScreen extends StatefulWidget {
  const KatalogScreen({super.key});

  @override
  State<KatalogScreen> createState() => _KatalogScreenState();
}

class _KatalogScreenState extends State<KatalogScreen> {
  final LayananService _layananService = LayananService();

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
        _services = _rankedServices(services);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _services = [];
        _isLoading = false;
        _errorMessage = 'Katalog layanan belum dapat dimuat.';
      });
    }
  }

  List<LayananModel> _rankedServices(List<LayananModel> services) {
    final ranked = [...services];
    ranked.sort((a, b) {
      final countCompare = b.installCount.compareTo(a.installCount);
      if (countCompare != 0) {
        return countCompare;
      }

      return layananDisplayTitle(a.name).compareTo(layananDisplayTitle(b.name));
    });
    return ranked;
  }

  String _categoryName(LayananModel service) {
    return layananCategoryName(service.name, service.categoryName);
  }

  LayananModel _latestService(LayananModel service) {
    for (final current in _services) {
      if (current.id == service.id) {
        return current;
      }
    }

    return service;
  }

  void _replaceService(LayananModel updatedService) {
    setState(() {
      _services = _rankedServices(
        _services
            .map(
              (service) =>
                  service.id == updatedService.id ? updatedService : service,
            )
            .toList(),
      );
      _installingLayananId = null;
    });
  }

  Future<void> _showServiceActionSheet(LayananModel service) async {
    var sheetService = _latestService(service);
    var isInstalling = false;
    String? sheetError;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isInstalled = sheetService.isInstalled;

            Future<void> installService() async {
              if (!sheetService.isAvailable) {
                setModalState(() {
                  sheetError = 'Layanan belum tersedia';
                });
                return;
              }

              if (AuthService.currentSession == null) {
                setModalState(() {
                  sheetError = 'Silakan login untuk install layanan.';
                });
                return;
              }

              setModalState(() {
                isInstalling = true;
                sheetError = null;
              });
              if (mounted) {
                setState(() {
                  _installingLayananId = sheetService.id;
                });
              }

              try {
                await _layananService.installLayanan(sheetService.id);
                if (!mounted) {
                  return;
                }

                final updatedService = sheetService.copyWith(
                  isInstalled: true,
                  installCount: sheetService.installCount + 1,
                );
                _replaceService(updatedService);
                _showSnackBar(
                  '${layananDisplayTitle(sheetService.name)} berhasil diinstall.',
                );

                if (!sheetContext.mounted) {
                  return;
                }

                setModalState(() {
                  sheetService = updatedService;
                  isInstalling = false;
                });
              } catch (_) {
                if (!mounted) {
                  return;
                }

                setState(() {
                  _installingLayananId = null;
                });

                if (!sheetContext.mounted) {
                  _showSnackBar('Gagal install layanan.');
                  return;
                }

                setModalState(() {
                  isInstalling = false;
                  sheetError = 'Gagal install layanan.';
                });
              }
            }

            void openDetail() {
              Navigator.pop(sheetContext);
              _openInstalledService(sheetService);
            }

            return SafeArea(
              top: false,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  24,
                  18,
                  24,
                  MediaQuery.of(context).viewInsets.bottom + 24,
                ),
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
                    const SizedBox(height: 26),
                    _serviceLogo(sheetService, size: 90),
                    const SizedBox(height: 22),
                    Text(
                      layananDisplayTitle(sheetService.name),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1B53),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _categoryName(sheetService),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      sheetService.description.isEmpty
                          ? 'Detail layanan belum tersedia.'
                          : sheetService.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    if (sheetError != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        sheetError!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFFF2E63),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 54,
                            child: TextButton(
                              onPressed: isInstalling
                                  ? null
                                  : () => Navigator.pop(sheetContext),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFE9EEF9),
                                foregroundColor: const Color(0xFF0E63FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                isInstalled ? 'Tutup' : 'Batal',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: isInstalling
                                  ? null
                                  : isInstalled
                                  ? openDetail
                                  : installService,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0E63FF),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: const Color(
                                  0xFF0E63FF,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: isInstalling
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      isInstalled ? 'Lihat Detail' : 'Install',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
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
      },
    );
  }

  void _openInstalledService(LayananModel service) {
    final homeService = homeServiceFromLayanan(service);
    if (homeService != null) {
      Navigator.push(context, MaterialPageRoute(builder: homeService.builder));
      return;
    }

    _showSnackBar('Detail layanan belum tersedia.');
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  String _serviceLogoPath(LayananModel service) {
    final backendIcon = service.iconUrl.trim();
    if (backendIcon.startsWith('http') || backendIcon.startsWith('assets/')) {
      return backendIcon;
    }
    if (backendIcon.isNotEmpty) {
      return layananLogoAssetPath(backendIcon);
    }

    final homeService = homeServiceFromLayanan(service);
    return homeService?.image ??
        layananLogoAssetPath(layananLogoAssetName(service.name));
  }

  Widget _serviceLogo(LayananModel service, {required double size}) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.17),
      decoration: const BoxDecoration(
        color: Color(0xffF5F7FF),
        shape: BoxShape.circle,
      ),
      child: AssetIconImage(asset: _serviceLogoPath(service)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (_services.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _errorMessage ?? 'Belum ada layanan tersedia.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loadServices,
              child: const Text('Muat ulang'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadServices,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: 120),
        itemCount: _services.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = _services[index];
          return _buildCatalogItem(item, index);
        },
      ),
    );
  }

  Widget _buildCatalogItem(LayananModel item, int index) {
    final isInstalling = _installingLayananId == item.id;

    return GestureDetector(
      onTap: isInstalling ? null : () => _showServiceActionSheet(item),
      child: Opacity(
        opacity: isInstalling ? 0.7 : 1,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xffEAEAEA)),
          ),
          child: Row(
            children: [
              _serviceLogo(item, size: 58),
              const SizedBox(width: 18),
              SizedBox(
                width: 32,
                child: Text(
                  '${index + 1}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      layananDisplayTitle(item.name),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description.isEmpty
                          ? 'Detail layanan belum tersedia.'
                          : item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
