import 'package:flutter/material.dart';

class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      body: Stack(
        children: [
          // 🔵 HEADER
          Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Color(0xFF0D57E7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 🔹 TITLE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      SizedBox(width: 24),
                      Text(
                        "Akun",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.edit, color: Colors.white),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 PROFILE
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Arief Wicaksono",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "ariefw@gmail.com",
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 20),

                // 🔹 CONTENT
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
                        // 🔸 LAYANAN
                        const Text(
                          "Layanan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        _item(Icons.language, "Bahasa"),
                        _divider(),
                        _item(Icons.notifications, "Notifikasi"),
                        _divider(),
                        _item(Icons.wb_sunny, "Theme",
                            trailing: _chip()),
                        _divider(),
                        _item(Icons.lock, "Ubah Pin"),

                        const SizedBox(height: 24),

                        // 🔸 PERANGKAT
                        const Text(
                          "Perangkat",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        _item(Icons.delete, "Hapus Akun",
                            textColor: Colors.red,
                            iconColor: Colors.red),
                        _divider(),
                        _item(Icons.logout, "Logout"),
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

  // 🔹 ITEM LIST
  static Widget _item(IconData icon, String title,
      {Widget? trailing, Color? textColor, Color? iconColor}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor ?? Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontSize: 16,
        ),
      ),
      trailing:
          trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  static Widget _divider() => const Divider();

  static Widget _chip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "Light",
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}