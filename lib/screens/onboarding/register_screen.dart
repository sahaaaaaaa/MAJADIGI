import 'package:flutter/material.dart';
import 'recommendation_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int currentStep = 1;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final TextEditingController searchController = TextEditingController();

  String? selectedCity;
  String? selectedDistrict;
  String? selectedGender;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final List<String> cities = [
    'Kabupaten Bangkalan',
    'Kabupaten Banyuwangi',
    'Kabupaten Blitar',
    'Kabupaten Bojonegoro',
    'Kabupaten Bondowoso',
    'Kabupaten Gresik',
  ];

  final List<String> districts = [
    'Kecamatan A',
    'Kecamatan B',
    'Kecamatan C',
    'Kecamatan D',
  ];

  final List<String> genders = ['Laki-laki', 'Perempuan'];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    nikController.dispose();
    birthDateController.dispose();
    genderController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void nextStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep > 1) {
      setState(() {
        currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20),
      firstDate: DateTime(1950),
      lastDate: now,
    
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0065FF), // Warna header & lingkaran tanggal terpilih (Biru Majadigi)
              onPrimary: Colors.white,    // Warna teks di atas primary
              onSurface: Color(0xFF2F2F2F), // Warna teks tanggal
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0065FF), // Warna tombol OK/Cancel
              ),
            ),
          ),
          child: child!,
        );
      }
    );
      if (picked != null) {
      setState(() {
        birthDateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -140,
              left: -120,
              child: Container(
                width: 520,
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 12),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: previousStep,
                        borderRadius: BorderRadius.circular(20),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Kembali',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(34),
                        topRight: Radius.circular(34),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildTopHeader(),
                        const SizedBox(height: 28),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildTitleSection(),
                                const SizedBox(height: 26),
                                _buildStepIndicator(),
                                const SizedBox(height: 10),
                                _buildStepLabel(),
                                const SizedBox(height: 26),
                                _buildStepContent(),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                        _buildBottomButtons(),
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

  Widget _buildTopHeader() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 42,
                height: 42,
                child: Image.asset(
                  'assets/images/logo_majadigi.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.bubble_chart_rounded,
                      color: Color(0xFF0E63FF),
                      size: 36,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MAJADIGI',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1453D1),
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    'Majapahit Digital',
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF888888),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE2E2E2), width: 1),
          ),
          child: const Row(
            children: [
              Icon(Icons.language, size: 18, color: Color(0xFF4F4F4F)),
              SizedBox(width: 6),
              Text(
                'Bahasa Indonesia',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4F4F4F),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    String title = '';
    String subtitle = '';

    if (currentStep == 1) {
      title = 'Daftar';
      subtitle =
          'Daftarkan diri Anda dan nikmati akses layanan Jawa Timur dalam genggaman.';
    } else if (currentStep == 2) {
      title = 'Data Diri';
      subtitle =
          'Masukkan informasi identitas Anda untuk integrasi data yang aman.';
    } else {
      title = 'Pilih Layanan';
      subtitle =
          'Pilih layanan publik yang sesuai dengan kebutuhan layanan Anda.';
    }

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0D1B4C),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(2, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber <= currentStep;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == 1 ? 0 : 8),
            height: 5,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF0E63FF)
                  : const Color(0xFFE1E1E1),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStepLabel() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Langkah $currentStep dari 2',
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF555555),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    if (currentStep == 1) {
      return Column(
        children: [
          _buildTextField(
            controller: firstNameController,
            hintText: 'Nama depan',
          ),
          const SizedBox(height: 18),
          _buildTextField(
            controller: lastNameController,
            hintText: 'Nama belakang',
          ),
          const SizedBox(height: 18),
          _buildTextField(
            controller: phoneController,
            hintText: 'No Handphone',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 18),
          _buildTextField(
            controller: emailController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E63FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            child: const Text(
              'Selanjutnya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ), 
          ),
          const SizedBox(height: 16),
          _buildLoginRedirect(),
        ],
      );
    }

    if (currentStep == 2) {
      return Column(
        children: [
          _buildTextField(
            controller: addressController, 
            hintText: 'Alamat'),
          const SizedBox(height: 18),
          
          DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            initialValue: selectedCity,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6B6B6B)),
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFA0A0A0), // warna teks utama
              fontFamily: 'Onest',
            ),
            hint: const Text(
              'Kabupaten / Kota',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFA0A0A0), // abu sama kayak TextField
                fontFamily: 'Onest',
                fontWeight: FontWeight.w400,
              ),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18), // Radius 18 sama dengan Tanggal Lahir
                borderSide: const BorderSide(color: Color(0xFFE2E2E2), width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Color(0xFF0E63FF), width: 1.4),
              ),
            ),
            items: cities.map((String city) {
              return DropdownMenuItem<String>(
                value: city,
                child: Text(
                  city, 
                  style: const TextStyle(color: Color(0xFF2F2F2F)),)
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCity = value;
              });
            },
         ),
          
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            initialValue: selectedDistrict,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6B6B6B)),
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFA0A0A0), // warna teks utama
              fontFamily: 'Onest',
            ),
            hint: const Text(
              'Kecamatan',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFA0A0A0), // abu sama kayak TextField
                fontFamily: 'Onest',
                fontWeight: FontWeight.w400,
              ),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18), // Radius 18 sama dengan Tanggal Lahir
                borderSide: const BorderSide(color: Color(0xFFE2E2E2), width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Color(0xFF0E63FF), width: 1.4),
              ),
            ),
            items: districts.map((String district) {
              return DropdownMenuItem<String>(
                value: district,
                child: Text(
                  district,
                  style: const TextStyle(color: Color(0xFF2F2F2F)),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedDistrict = value;
              });
            },
         ),
          const SizedBox(height: 18),
          _buildTextField(
            controller: nikController,
            hintText: 'NIK',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 18),
          _buildDateField(),
          const SizedBox(height: 18),
          _buildGenderField(),
          const SizedBox(height: 18),
          _buildPasswordField(
            controller: passwordController,
            hintText: 'Kata sandi',
            obscureText: obscurePassword,
            onToggle: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
          ),
          const SizedBox(height: 18),
          _buildPasswordField(
            controller: confirmPasswordController,
            hintText: 'Ulangi kata sandi',
            obscureText: obscureConfirmPassword,
            onToggle: () {
              setState(() {
                obscureConfirmPassword = !obscureConfirmPassword;
              });
            },
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 16),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE2E2E2), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF0E63FF), width: 1.4),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String hintText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hintText,
            style: const TextStyle(
              fontFamily: 'Onest',
              color: Color(0xFFA0A0A0), 
              fontWeight: FontWeight.w400,
              fontSize: 16),
          ),
          dropdownColor: const Color(0xFFFFFFFF),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF8C8C8C),
            size: 24,
          ),
          borderRadius: BorderRadius.circular(18),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontFamily: 'Onest',
                  fontSize: 16,
                  fontWeight: FontWeight.w400, 
                  color: Color(0xFF2F2F2F)),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: birthDateController,
      readOnly: true,
      onTap: pickBirthDate,
      decoration: InputDecoration(
        hintText: 'Tanggal lahir',
        hintStyle: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 16),
        suffixIcon: IconButton(
          onPressed: pickBirthDate,
          icon: const Icon(
            Icons.calendar_today_outlined,
            color: Color(0xFF6B6B6B),
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE2E2E2), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF0E63FF), width: 1.4),
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      initialValue: genders.contains(genderController.text)
          ? genderController.text
          : null,
      isExpanded: true,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFFA0A0A0), 
        fontFamily: 'Onest',
      ),
      hint: const Text(
        'Jenis Kelamin',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFA0A0A0), 
          fontFamily: 'Onest',
          fontWeight: FontWeight.w400,
        ),
      ),
    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6B6B6B)),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18), // Radius 18 agar membulat rapi
        borderSide: const BorderSide(color: Color(0xFFE2E2E2), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF0E63FF), width: 1.4),
      ),
    ),
    items: genders.map((String gender) {
      return DropdownMenuItem<String>(
        value: gender,
        child: Text(
          gender,
          style: const TextStyle(fontSize: 16, color: Color(0xFF2F2F2F)),
        ),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        genderController.text = value ?? '';
      });
    },
  );
}

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 16),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xFF8C8C8C),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE2E2E2), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF0E63FF), width: 1.4),
        ),
      ),
    );
  }

  Widget _buildLoginRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Sudah punya akun? ',
          style: TextStyle(fontSize: 15, color: Color(0xFF555555)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          child: const Text(
            'Masuk',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF0E63FF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    if (currentStep == 2) {
      return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: previousStep,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFFDCE7F8),
                foregroundColor: const Color(0xFF0E63FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Kembali',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecommendationScreen(data: [])),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF0E63FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Selanjutnya',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,),
                ),
              ),
            ),
          ),
        ],
      );    
    }
  return const SizedBox.shrink();
  }
}