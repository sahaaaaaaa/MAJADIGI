import 'package:flutter/material.dart';

import 'package:majadigi/features/auth/data/auth_service.dart';
import 'package:majadigi/features/layanan/data/layanan_service.dart';

class LayananFavoriteButton extends StatefulWidget {
  const LayananFavoriteButton({
    super.key,
    required this.serviceName,
    this.lookupQuery,
    this.iconColor = Colors.white,
    this.activeColor = Colors.white,
    this.size = 24,
    this.onChanged,
  });

  final String serviceName;
  final String? lookupQuery;
  final Color iconColor;
  final Color activeColor;
  final double size;
  final ValueChanged<bool>? onChanged;

  @override
  State<LayananFavoriteButton> createState() => _LayananFavoriteButtonState();
}

class _LayananFavoriteButtonState extends State<LayananFavoriteButton> {
  late final LayananService _layananService;

  int? _layananId;
  bool _isFavorite = false;
  bool _isLoading = true;
  bool _isBusy = false;
  int _requestSerial = 0;

  String get _query => widget.lookupQuery ?? widget.serviceName;

  @override
  void initState() {
    super.initState();
    _layananService = LayananService();
    _loadLayanan();
  }

  @override
  void didUpdateWidget(covariant LayananFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.serviceName != widget.serviceName ||
        oldWidget.lookupQuery != widget.lookupQuery) {
      _loadLayanan();
    }
  }

  @override
  void dispose() {
    _layananService.dispose();
    super.dispose();
  }

  Future<void> _loadLayanan() async {
    final serial = ++_requestSerial;
    setState(() {
      _isLoading = true;
    });

    try {
      final services = await _layananService.getPublicLayanan(search: _query);
      if (!mounted || serial != _requestSerial) {
        return;
      }

      final service = _findMatchingService(services);
      setState(() {
        _layananId = service?.id;
        _isFavorite = service?.isFavorite ?? false;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted || serial != _requestSerial) {
        return;
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  LayananModel? _findMatchingService(List<LayananModel> services) {
    if (services.isEmpty) {
      return null;
    }

    final target = _normalize(_query);
    for (final service in services) {
      final name = _normalize(service.name);
      if (name == target || name.contains(target) || target.contains(name)) {
        return service;
      }
    }

    return services.first;
  }

  String _normalize(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
  }

  Future<void> _toggleFavorite() async {
    if (_isBusy) {
      return;
    }

    if (AuthService.currentSession == null) {
      _showSnackBar('Silakan login untuk menyimpan favorit.');
      return;
    }

    if (_layananId == null) {
      await _loadLayanan();
      if (_layananId == null) {
        _showSnackBar('Layanan belum dapat ditemukan.');
        return;
      }
    }

    final previousValue = _isFavorite;
    final nextValue = !previousValue;

    setState(() {
      _isBusy = true;
      _isFavorite = nextValue;
    });

    try {
      if (nextValue) {
        await _layananService.addFavoriteLayanan(_layananId!);
      } else {
        await _layananService.removeFavoriteLayanan(_layananId!);
      }

      if (!mounted) {
        return;
      }

      widget.onChanged?.call(nextValue);
      _showSnackBar(
        nextValue
            ? '${widget.serviceName} ditambahkan ke favorit.'
            : '${widget.serviceName} dihapus dari favorit.',
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isFavorite = previousValue;
      });
      _showSnackBar('Gagal memperbarui favorit layanan.');
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
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
    if (_isLoading || _isBusy) {
      return SizedBox.square(
        dimension: 48,
        child: Center(
          child: SizedBox.square(
            dimension: widget.size - 6,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(widget.iconColor),
            ),
          ),
        ),
      );
    }

    return IconButton(
      tooltip: _isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
      onPressed: _toggleFavorite,
      icon: Icon(
        _isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        color: _isFavorite ? widget.activeColor : widget.iconColor,
        size: widget.size,
      ),
    );
  }
}
