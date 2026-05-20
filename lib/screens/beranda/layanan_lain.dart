import 'package:flutter/material.dart';

import '../../services/layanan_service.dart';
import '../../widgets/layanan_item.dart';
import 'home_service_item.dart';

class LayananLainScreen extends StatefulWidget {
  const LayananLainScreen({super.key, this.services});

  final List<HomeServiceItem>? services;

  @override
  State<LayananLainScreen> createState() => _LayananLainScreenState();
}

class _LayananLainScreenState extends State<LayananLainScreen> {
  final LayananService _layananService = LayananService();
  bool _isLoading = false;
  List<HomeServiceItem> _services = [];

  @override
  void initState() {
    super.initState();

    final services = widget.services;
    if (services != null) {
      _services = services;
      return;
    }

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
    });

    try {
      final layanan = await _layananService.getInstalledLayanan();
      if (!mounted) {
        return;
      }
      setState(() {
        _services = layanan
            .map(homeServiceFromLayanan)
            .whereType<HomeServiceItem>()
            .toList();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          Container(
            height: 140,
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            decoration: const BoxDecoration(color: Color(0xFF0D57E7)),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                children: [
                  const Text(
                    'Semua layanan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    if (_isLoading) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_services.isEmpty) {
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

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _services.map((service) {
        return LayananItem(
          title: service.title,
          image: service.image,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: service.builder),
            );
          },
        );
      }).toList(),
    );
  }
}
