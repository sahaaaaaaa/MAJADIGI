import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi/features/auth/presentation/auth_controller.dart';

import '../../services/auth_service.dart';
import '../onboarding/login_screen.dart';
import 'bahasa_screen.dart';
import 'edit_akun_screen.dart';
import 'ubah_password_screen.dart';

class AkunScreen extends ConsumerStatefulWidget {
  const AkunScreen({super.key});

  @override
  ConsumerState<AkunScreen> createState() => _AkunScreenState();
}

class _AkunScreenState extends ConsumerState<AkunScreen> {
  final AuthService _authService = AuthService();
  AuthProfile? _profile;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _profile = AuthService.currentSession?.profile;
    _loadProfile();
  }

  @override
  void dispose() {
    _authService.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoadingProfile = true;
    });

    try {
      final profile = await _authService.getProfile();
      if (!mounted) {
        return;
      }

      setState(() {
        _profile = profile;
        _isLoadingProfile = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  String get _displayName {
    final fullName = _profile?.fullName ?? '';
    if (fullName.isNotEmpty) {
      return fullName;
    }
    return AuthService.currentSession?.firstName ?? 'Pengguna';
  }

  String get _displayEmail {
    final profileEmail = _profile?.email ?? '';
    if (profileEmail.isNotEmpty) {
      return profileEmail;
    }
    return AuthService.currentSession?.user.email ?? '';
  }

  ImageProvider? get _avatarImage {
    final photoUrl = _profile?.photoUrl ?? '';
    if (photoUrl.isEmpty) {
      return null;
    }
    return NetworkImage(photoUrl);
  }

  Future<void> _openEditProfile() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditAkunScreen(initialProfile: _profile),
      ),
    );

    if (updated == true) {
      await _loadProfile();
    }
  }

  Future<void> _deleteAccount(StateSetter setDialogState) async {
    setDialogState(() {});

    try {
      await ref.read(authControllerProvider.notifier).deleteAccount();
      if (!mounted) {
        return;
      }

      Navigator.pop(context);
      _goToLogin();
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
      _showSnackBar(error.message);
    } catch (_) {
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
      _showSnackBar('Gagal menghapus akun.');
    }
  }

  void _showDeleteDialog() {
    var isDeleting = false;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Hapus Akun',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Apakah anda yakin untuk menghapus akunmu?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isDeleting
                                ? null
                                : () => Navigator.pop(dialogContext),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Batal',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isDeleting
                                ? null
                                : () {
                                    setDialogState(() {
                                      isDeleting = true;
                                    });
                                    unawaited(_deleteAccount(setDialogState));
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF2D55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: isDeleting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Hapus',
                                    style: TextStyle(color: Colors.white),
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

  Future<void> _logout() async {
    await ref.read(authControllerProvider.notifier).logout();
    if (!mounted) {
      return;
    }
    _goToLogin();
  }

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen(
        showBackButton: false,
      )),
      (route) => false,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      const Text(
                        'Akun',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: _openEditProfile,
                        icon: const Icon(Icons.edit, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  backgroundImage: _avatarImage,
                  child: _avatarImage == null
                      ? const Icon(Icons.person, size: 40, color: Colors.blue)
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  _displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _displayEmail,
                  style: const TextStyle(color: Colors.white70),
                ),
                if (_isLoadingProfile) ...[
                  const SizedBox(height: 8),
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      children: [
                        const Text(
                          'Informasi Lain',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _item(
                          Icons.lock_outline,
                          'Ubah Kata Sandi',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const UbahPasswordScreen(),
                              ),
                            );
                          },
                        ),
                        _divider(),
                        _item(
                          Icons.language,
                          'Ganti Bahasa',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BahasaScreen(),
                              ),
                            );
                          },
                        ),
                        _divider(),
                        _item(Icons.info_outline, 'Tentang Majadigi'),
                        _divider(),
                        _item(Icons.star_border, 'Beri Rating'),
                        _divider(),
                        _item(
                          Icons.description_outlined,
                          'Syarat dan Ketentuan',
                        ),
                        _divider(),
                        _item(Icons.privacy_tip_outlined, 'Kebijakan Privasi'),
                        const SizedBox(height: 24),
                        const Text(
                          'Perangkat',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _item(
                          Icons.delete_outline,
                          'Hapus Akun',
                          textColor: Colors.red,
                          iconColor: Colors.red,
                          onTap: _showDeleteDialog,
                        ),
                        _divider(),
                        _item(
                          Icons.logout,
                          'Logout',
                          onTap: () {
                            unawaited(_logout());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _item(
    IconData icon,
    String title, {
    Color? textColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor ?? Colors.black54),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? Colors.black87, fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  static Widget _divider() => const Divider(height: 1);
}
