import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:majadigi/features/auth/data/auth_service.dart';

class EditAkunScreen extends StatefulWidget {
  const EditAkunScreen({super.key, this.initialProfile});

  final AuthProfile? initialProfile;

  @override
  State<EditAkunScreen> createState() => _EditAkunScreenState();
}

class _EditAkunScreenState extends State<EditAkunScreen> {
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  AuthProfile? _profile;
  DateTime? _selectedBirthDate;
  String _gender = 'L';
  String _kabupatenKota = '';
  String _kecamatan = '';
  File? _imageFile;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final initialProfile =
        widget.initialProfile ?? AuthService.currentSession?.profile;
    if (initialProfile != null) {
      _applyProfile(initialProfile);
      _isLoading = false;
    }
    _loadProfile();
  }

  @override
  void dispose() {
    _authService.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _nikController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await _authService.getProfile();
      if (!mounted) {
        return;
      }

      setState(() {
        _applyProfile(profile);
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

  void _applyProfile(AuthProfile profile) {
    _profile = profile;
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _phoneController.text = profile.phone;
    _emailController.text = profile.email.isNotEmpty
        ? profile.email
        : AuthService.currentSession?.user.email ?? '';
    _addressController.text = profile.address;
    _nikController.text = profile.nik;
    _kabupatenKota = profile.kabupatenKota;
    _kecamatan = profile.kecamatan;
    _gender = profile.gender == 'P' ? 'P' : 'L';

    _selectedBirthDate = DateTime.tryParse(profile.birthDate);
    _birthDateController.text = _selectedBirthDate == null
        ? profile.birthDate
        : DateFormat('d MMMM yyyy').format(_selectedBirthDate!);
  }

  ImageProvider? get _avatarImage {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    }

    final photoUrl = _profile?.photoUrl ?? '';
    if (photoUrl.isEmpty) {
      return null;
    }

    return NetworkImage(photoUrl);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null || !mounted) {
      return;
    }

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(now.year - 20),
      firstDate: DateTime(1950),
      lastDate: now,
    );

    if (picked == null || !mounted) {
      return;
    }

    setState(() {
      _selectedBirthDate = picked;
      _birthDateController.text = DateFormat('d MMMM yyyy').format(picked);
    });
  }

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();

    final validationMessage = _validate();
    if (validationMessage != null) {
      _showSnackBar(validationMessage);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final birthDate = _selectedBirthDate == null
          ? _profile?.birthDate ?? ''
          : DateFormat('yyyy-MM-dd').format(_selectedBirthDate!);

      await _authService.updateProfile(
        ProfileUpdateRequest(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          kabupatenKota: _kabupatenKota,
          kecamatan: _kecamatan,
          nik: _nikController.text.trim(),
          birthDate: birthDate,
          gender: _gender,
        ),
      );

      if (_imageFile != null) {
        await _authService.updateProfilePhoto(_imageFile!);
      }

      if (!mounted) {
        return;
      }

      _showSnackBar('Data akun berhasil disimpan.');
      Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSaving = false;
      });
      _showSnackBar(error.message);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSaving = false;
      });
      _showSnackBar('Gagal menyimpan data akun.');
    }
  }

  String? _validate() {
    if (_firstNameController.text.trim().isEmpty) {
      return 'Nama depan wajib diisi.';
    }
    if (_lastNameController.text.trim().isEmpty) {
      return 'Nama belakang wajib diisi.';
    }
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      return 'Email wajib diisi.';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Format email tidak valid.';
    }
    if (_phoneController.text.trim().isEmpty) {
      return 'Nomor handphone wajib diisi.';
    }
    if (_addressController.text.trim().isEmpty) {
      return 'Alamat wajib diisi.';
    }
    if (_nikController.text.trim().isEmpty) {
      return 'NIK wajib diisi.';
    }
    if (_selectedBirthDate == null &&
        _birthDateController.text.trim().isEmpty) {
      return 'Tanggal lahir wajib diisi.';
    }
    return null;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _isSaving
                            ? null
                            : () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Edit Akun',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.white,
                                      backgroundImage: _avatarImage,
                                      child: _avatarImage == null
                                          ? const Icon(
                                              Icons.person,
                                              size: 36,
                                              color: Color(0xFF0E63FF),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    OutlinedButton(
                                      onPressed: _isSaving ? null : _pickImage,
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: const Text('Upload Foto'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _field(
                                        'Nama depan',
                                        _firstNameController,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _field(
                                        'Nama belakang',
                                        _lastNameController,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                _field(
                                  'No HP',
                                  _phoneController,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 14),
                                _field(
                                  'Email',
                                  _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 14),
                                _field('Alamat', _addressController),
                                const SizedBox(height: 14),
                                _field(
                                  'NIK',
                                  _nikController,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 14),
                                _field(
                                  'Tgl lahir',
                                  _birthDateController,
                                  readOnly: true,
                                  onTap: _pickDate,
                                  suffixIcon: const Icon(
                                    Icons.calendar_today_outlined,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                _genderField(),
                                const SizedBox(height: 30),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 50,
                                        child: TextButton(
                                          onPressed: _isSaving
                                              ? null
                                              : () => Navigator.pop(context),
                                          style: TextButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFE3EAF5,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: const Text(
                                            'Kembali',
                                            style: TextStyle(
                                              color: Color(0xFF0E63FF),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: SizedBox(
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: _isSaving
                                              ? null
                                              : _saveProfile,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF0E63FF,
                                            ),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: _isSaving
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Colors.white),
                                                  ),
                                                )
                                              : const Text('Simpan'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          enabled: !_isSaving,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
      ],
    );
  }

  Widget _genderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Jenis Kelamin', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _gender,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'L', child: Text('Laki - Laki')),
                DropdownMenuItem(value: 'P', child: Text('Perempuan')),
              ],
              onChanged: _isSaving
                  ? null
                  : (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _gender = value;
                      });
                    },
            ),
          ),
        ),
      ],
    );
  }
}
