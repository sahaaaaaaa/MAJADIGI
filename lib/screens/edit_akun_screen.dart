import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditAkunScreen extends StatefulWidget {
  const EditAkunScreen({super.key});

  @override
  State<EditAkunScreen> createState() => _EditAkunScreenState();
}

class _EditAkunScreenState extends State<EditAkunScreen> {
  final TextEditingController tanggalController = TextEditingController();

  String? gender;
  File? imageFile;

  final ImagePicker picker = ImagePicker();

  // 🔥 PICK IMAGE FROM GALLERY
  Future<void> pickImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  // 🔥 DATE PICKER
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        tanggalController.text =
            DateFormat('d MMMM yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                  ),
                  const Expanded(
                    child: Text(
                      "Edit Akun",
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
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // 🔥 FOTO PROFILE
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                imageFile != null ? FileImage(imageFile!) : null,
                            child: imageFile == null
                                ? const Icon(Icons.person,
                                    size: 36, color: Color(0xFF0E63FF))
                                : null,
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton(
                            onPressed: pickImage,
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text("Upload Foto"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(child: _field("Nama depan", "Arief")),
                          const SizedBox(width: 12),
                          Expanded(child: _field("Nama belakang", "Wicaksono")),
                        ],
                      ),

                      const SizedBox(height: 14),
                      _field("No HP", "+62 812345678"),
                      const SizedBox(height: 14),
                      _field("Email", "arief@gmail.com"),
                      const SizedBox(height: 14),
                      _field("Alamat", "Malang"),
                      const SizedBox(height: 14),
                      _field("NIK", "1234567890"),

                      const SizedBox(height: 14),

                      // 🔥 TANGGAL LAHIR
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Tgl lahir",
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: tanggalController,
                            readOnly: true,
                            onTap: _pickDate,
                            decoration: InputDecoration(
                              hintText: "Pilih tanggal",
                              suffixIcon:
                                  const Icon(Icons.calendar_today_outlined),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // 🔥 DROPDOWN GENDER
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Jenis Kelamin",
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border:
                                  Border.all(color: const Color(0xFFE0E0E0)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: gender,
                                hint: const Text("Pilih jenis kelamin"),
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(
                                    value: "Laki - Laki",
                                    child: Text("Laki - Laki"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Perempuan",
                                    child: Text("Perempuan"),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // BUTTON
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3EAF5),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Kembali",
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
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF0E63FF), Color(0xFF3A8DFF)],
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Data berhasil disimpan")),
                                  );
                                },
                                child: const Text(
                                  "Simpan",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
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
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _field(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ],
    );
  }
}