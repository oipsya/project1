import 'package:flutter/material.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color primaryColor = Color(0xFF176B5B);
  static const Color backgroundColor = Color(0xFFF7FBFA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // HEADER PROFIL
            SizedBox(
              height: 225,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  // Background hijau
                  Container(
                    height: 135,
                    width: double.infinity,
                    color: primaryColor,
                  ),

                  // Foto profil
                  Positioned(
                    top: 48,
                    child: Container(
                      width: 112,
                      height: 112,
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'lib/images/pic.jpeg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const ColoredBox(
                              color: Color(0xFFECE8DF),
                              child: Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Nama pengguna
                  const Positioned(
                    top: 165,
                    child: Text(
                      'PASHA AULIA',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Email
                  Positioned(
                    top: 195,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 175,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'pashaaulia2005@gmail.com',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // MENU PROFIL
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildMenuItem(
                            icon: Icons.settings_outlined,
                            title: 'Pengaturan',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.edit_outlined,
                            title: 'Edit Profil',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.lock_outline,
                            title: 'Kebijakan Privasi',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.info_outline,
                            title: 'Tentang Kami',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.description_outlined,
                            title: 'Ketentuan Layanan',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.logout,
                            title: 'Keluar',
                            onTap: () => _logout(context),
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // NAVIGASI BAWAH
            SizedBox(
              height: 66,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 53,
                    width: double.infinity,
                    color: primaryColor,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavIcon(
                          icon: Icons.home_outlined,
                          label: 'BERANDA',
                          onTap: () {},
                        ),
                        _buildNavIcon(
                          icon: Icons.verified_user,
                          label: 'VERIFIKASI',
                          onTap: () {},
                        ),
                        _buildNavIcon(
                          icon: Icons.favorite,
                          label: 'FAVORIT',
                          onTap: () {},
                        ),
                        const SizedBox(width: 65),
                      ],
                    ),
                  ),

                  // AKUN AKTIF
                  Positioned(
                    right: 25,
                    top: -27,
                    child: Column(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8F3F0),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 30,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'AKUN',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // AREA BAWAH LAYAR
            Container(
              height: 58,
              width: double.infinity,
              color: backgroundColor,
            ),
          ],
        ),
      ),
    );
  }

  // MENU ITEM
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 57,
        width: double.infinity,
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(
                  bottom: BorderSide(
                    color: Color(0xFFDADADA),
                    width: 0.8,
                  ),
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.black87,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 27,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  // NAVIGASI BAWAH
  Widget _buildNavIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 65,
        height: 53,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 23,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // LOGOUT KE HALAMAN LOGIN
  void _logout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Keluar'),
          content: const Text(
            'Apakah kamu yakin ingin keluar dari akun?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
              child: const Text(
                'Keluar',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
