
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login_page.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';
import 'home_page.dart';
import 'rekomendasi_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color primaryColor = Color(0xFF176B5B);
  static const Color upperGreen = Color(0xFF397C70);
  static const Color backgroundColor = Color(0xFFF7FBFA);

  String _namaPengguna = 'PASHA AULIA';
  String? _fotoPengguna;

  // MEMBUKA HOME PAGE
  void _bukaHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
      (route) => false,
    );
  }

  // MEMBUKA HALAMAN REKOMENDASI
  void _bukaRekomendasi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RekomendasiPage(),
      ),
    );
  }

  // MEMBUKA EDIT PROFIL
  Future<void> _bukaEditProfil() async {
    final hasil = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          initialName: _namaPengguna,
          initialImagePath: _fotoPengguna,
        ),
      ),
    );

    if (!mounted || hasil == null) return;

    setState(() {
      _namaPengguna =
          hasil['name'] as String? ?? _namaPengguna;
      _fotoPengguna = hasil['imagePath'] as String?;
    });
  }

  // FOTO DEFAULT
  Widget _fotoDefault() {
    return Image.asset(
      'lib/images/pic.jpeg',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return const ColoredBox(
          color: Color(0xFFECE8DF),
          child: Icon(
            Icons.person,
            size: 70,
            color: Colors.grey,
          ),
        );
      },
    );
  }

  // FOTO PROFIL
  Widget _buildFotoProfil() {
    if (_fotoPengguna == null) {
      return _fotoDefault();
    }

    if (_fotoPengguna!.startsWith('asset:')) {
      return Image.asset(
        _fotoPengguna!.substring(6),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fotoDefault(),
      );
    }

    return Image.file(
      File(_fotoPengguna!),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fotoDefault(),
    );
  }

  // MEMBUKA PENGATURAN
  void _bukaPengaturan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsPage(),
      ),
    );
  }

  // MEMBUKA HALAMAN INFORMASI
  void _bukaInformasi(String judul, _InfoType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _InfoPage(
          title: judul,
          type: type,
        ),
      ),
    );
  }

  // LOGOUT
  void _logout() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.33),
      builder: (dialogContext) {
        return Dialog(
          alignment: const Alignment(0, -0.12),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 58,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              28, 24, 28, 23,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keluar?',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Apakah Kamu Yakin Ingin Keluar?',
                  style: TextStyle(fontSize: 11),
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 33,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: SizedBox(
                        height: 33,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(
                              color: primaryColor,
                              width: 1.6,
                            ),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Keluar',
                            style: TextStyle(
                              fontSize: 13,
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
        );
      },
    );
  }

  // HEADER PROFIL
  Widget _buildHeader() {
    return Container(
      height: 245,
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 42,
              color: upperGreen,
            ),
          ),
          Positioned(
            top: 42,
            left: 0,
            right: 0,
            child: Container(
              height: 82,
              color: primaryColor,
            ),
          ),
          Positioned(
            top: 61,
            child: Container(
              width: 112,
              height: 112,
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: _buildFotoProfil(),
              ),
            ),
          ),
          Positioned(
            top: 183,
            left: 12,
            right: 12,
            child: Text(
              _namaPengguna,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111111),
              ),
            ),
          ),
          Positioned(
            top: 215,
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 181,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
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
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ITEM MENU PROFIL
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 72,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: showDivider
              ? const Border(
                  bottom: BorderSide(
                    color: Color(0xFFD4D4D4),
                    width: 1,
                  ),
                )
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
              child: Icon(
                icon,
                size: 25,
                color: const Color(0xFF171717),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF171717),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 27,
              color: Color(0xFF171717),
            ),
          ],
        ),
      ),
    );
  }

  // MENU PROFIL
  Widget _buildMenuProfile() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 22),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'Pengaturan',
                onTap: _bukaPengaturan,
              ),
              _buildMenuItem(
                icon: Icons.edit_outlined,
                title: 'Edit Profil',
                onTap: _bukaEditProfil,
              ),
              _buildMenuItem(
                icon: Icons.lock_outline,
                title: 'Kebijakan Privasi',
                onTap: () => _bukaInformasi(
                  'Kebijakan Privasi',
                  _InfoType.privacy,
                ),
              ),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'Tentang Kami',
                onTap: () => _bukaInformasi(
                  'Tentang Kami',
                  _InfoType.about,
                ),
              ),
              _buildMenuItem(
                icon: Icons.fact_check_outlined,
                title: 'Ketentuan Layanan',
                onTap: () => _bukaInformasi(
                  'Ketentuan Layanan',
                  _InfoType.terms,
                ),
              ),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Keluar',
                onTap: _logout,
                showDivider: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====================================
  // NAVIGASI BAWAH - DISESUAIKAN HOME
  // ====================================

  Widget _buildBottomNavigation() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double lebar = constraints.maxWidth;
        final double tinggi = lebar * 105 / 393;

        return SizedBox(
          width: lebar,
          height: tinggi,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'lib/images/header_beranda.png',
                width: lebar,
                height: tinggi,
                fit: BoxFit.fill,
                alignment: Alignment.bottomCenter,
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
                errorBuilder: (_, __, ___) {
                  return const ColoredBox(color: primaryColor);
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _bukaHome,
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _bukaRekomendasi,
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: const SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // HALAMAN PROFIL
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight =
        MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: upperGreen,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: statusBarHeight,
                color: upperGreen,
              ),
              _buildHeader(),
              _buildMenuProfile(),
              Transform.translate(
               offset: const Offset(0, 5),
              child: _buildBottomNavigation(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================
// HALAMAN INFORMASI
// ============================

enum _InfoType {
  terms,
  privacy,
  about,
}

class _InfoPage extends StatelessWidget {
  final String title;
  final _InfoType type;

  const _InfoPage({
    required this.title,
    required this.type,
  });

  static const Color green = Color(0xFF176B5B);
  static const Color ink = Color(0xFF151515);

  static const TextStyle bodyText = TextStyle(
    fontSize: 12,
    color: ink,
    height: 1.65,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle sectionText = TextStyle(
    fontSize: 12,
    color: ink,
    height: 1.55,
    fontWeight: FontWeight.w500,
  );

  Widget _logo() {
    return Align(
      alignment: Alignment.centerRight,
      child: Image.asset(
        'lib/images/ecowalkijo.png',
        width: 69,
        height: 26,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return const Text(
            'ECOWALK',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: green,
            ),
          );
        },
      ),
    );
  }

  Widget _text(String text) {
    return Text(
      text,
      style: bodyText,
    );
  }

  Widget _space(double height) {
    return SizedBox(height: height);
  }

  Widget _pageHeading(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: ink,
        height: 1.35,
      ),
    );
  }

  Widget _numberTitle(String text) {
    return Text(
      text,
      style: sectionText,
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: bodyText),
          Expanded(
            child: Text(text, style: bodyText),
          ),
        ],
      ),
    );
  }

  // KETENTUAN LAYANAN
  Widget _termsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _logo(),
        _space(23),
        _pageHeading(
          'KETENTUAN PENGGUNAAN APLIKASI ECOWALK',
        ),
        _space(2),
        const Text(
          'Diperbaharui tanggal 16 Februari 2024',
          style: TextStyle(
            fontSize: 10,
            fontStyle: FontStyle.italic,
            color: Color(0xFF555555),
          ),
        ),
        _space(29),
        _text(
          'Selamat datang di ECOWALK! Dengan menggunakan '
          'aplikasi ini, Anda setuju dengan ketentuan dan '
          'persyaratan berikut:',
        ),
        _space(22),
        _text(
          '1. Dengan menggunakan aplikasi ECOWALK, Anda dapat '
          'menemukan informasi tentang tempat wisata, '
          'rekomendasi tempat, perbandingan harga, dan '
          'layanan peta berbasis lokasi.',
        ),
        _space(21),
        _text(
          '2. Anda bertanggung jawab atas keakuratan data, '
          'termasuk ulasan dan foto, yang Anda masukkan.',
        ),
        _space(21),
        _text(
          '3. Perubahan Layanan ECOWALK berhak mengubah, '
          'menambah, atau menghentikan layanan tanpa '
          'pemberitahuan sebelumnya. Pengguna bertanggung '
          'jawab atas keamanan akun mereka, termasuk kata '
          'sandi. Pengguna juga dilarang menggunakan aplikasi '
          'untuk tujuan yang dapat merugikan pihak lain.',
        ),
        _space(3),
        _text(
          'Informasi yang diberikan oleh sumber seperti '
          'tiket atau biaya transportasi tidak akurat, '
          'dan kami tidak bertanggung jawab atas kesalahan tersebut.',
        ),
        _space(21),
        _numberTitle(
          '4. Penolakan Tanggung Jawab',
        ),
        _space(3),
        _bullet(
          'ECOWALK hanya menyediakan informasi sebagai '
          'referensi dan bukan penyedia layanan wisata '
          'atau transportasi.',
        ),
        _bullet(
          'Kami tidak bertanggung jawab atas perubahan '
          'harga, ketersediaan tempat, atau keterlambatan '
          'transportasi.',
        ),
        _space(24),
        _text(
          'Dengan menggunakan aplikasi ini, Anda menyetujui '
          'semua ketentuan di atas.',
        ),
      ],
    );
  }

  // KEBIJAKAN PRIVASI
  Widget _privacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _logo(),
        _space(23),
        _pageHeading(
          'KEBIJAKAN PRIVASI APLIKASI ECOWALK',
        ),
        _space(2),
        const Text(
          'Diperbaharui tanggal 16 Februari 2024',
          style: TextStyle(
            fontSize: 10,
            fontStyle: FontStyle.italic,
            color: Color(0xFF555555),
          ),
        ),
        _space(29),
        _text(
          'Kami menghargai privasi pengguna. Kebijakan ini '
          'menjelaskan bagaimana ECOWALK mengumpulkan, '
          'menggunakan, dan melindungi data Anda.',
        ),
        _space(21),
        _numberTitle(
          '1. Data yang Kami Kumpulkan',
        ),
        _text(
          'Kami dapat mengumpulkan data berikut:',
        ),
        _bullet(
          'Data Pribadi: Nama, email, dan informasi akun.',
        ),
        _bullet(
          'Data Lokasi: Untuk memberikan rekomendasi wisata '
          'dan perhitungan jarak.',
        ),
        _bullet(
          'Ulasan dan Foto: Jika Anda memposting ulasan '
          'atau berbagi pengalaman wisata.',
        ),
        _space(22),
        _numberTitle(
          '2. Cara Kami Menggunakan Data',
        ),
        _bullet(
          'Memberikan rekomendasi tempat wisata berdasarkan lokasi.',
        ),
        _bullet(
          'Memproses pencarian dan filter destinasi sesuai preferensi.',
        ),
        _bullet(
          'Menampilkan ulasan dan foto yang dibagikan pengguna lain.',
        ),
        _bullet(
          'Menyediakan informasi transportasi berdasarkan data lokasi.',
        ),
        _space(22),
        _numberTitle(
          '3. Keamanan Data',
        ),
        _text(
          'Kami menggunakan enkripsi dan metode keamanan lainnya '
          'untuk melindungi data Anda.',
        ),
        _space(22),
        _numberTitle(
          '4. Hak Pengguna',
        ),
        _bullet(
          'Anda dapat memperbarui atau menghapus informasi '
          'akun kapan saja.',
        ),
        _bullet(
          'Anda dapat menonaktifkan fitur lokasi jika tidak ingin '
          'berbagi data lokasi.',
        ),
        _bullet(
          'Kami tidak akan membagikan data pribadi Anda '
          'kepada pihak lain tanpa persetujuan Anda.',
        ),
      ],
    );
  }

  // TENTANG KAMI
  Widget _aboutContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _logo(),
        _space(22),
        _text(
          'ECOWALK adalah aplikasi wisata yang membantu '
          'pengguna menemukan destinasi terbaik dengan '
          'rekomendasi berdasarkan lokasi, perbandingan '
          'harga, serta informasi transportasi.',
        ),
        _space(23),
        const Text(
          'Misi Kami',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
            color: ink,
          ),
        ),
        _space(5),
        _text(
          'Menyediakan pengalaman wisata yang lebih mudah, '
          'informatif, dan terjangkau bagi semua orang '
          'dengan fokus pada ekowisata yang ramah lingkungan.',
        ),
        _space(23),
        _numberTitle(
          'Apa yang Kami Tawarkan?',
        ),
        _bullet(
          'Rekomendasi tempat wisata berdasarkan lokasi '
          'dan preferensi Anda.',
        ),
        _bullet(
          'Informasi harga tiket, ketersediaan fasilitas, '
          'dan ulasan pengguna.',
        ),
        _bullet(
          'Peta interaktif untuk membantu navigasi di area wisata.',
        ),
        _bullet(
          'Perbandingan harga transportasi untuk perjalanan '
          'yang lebih hemat.',
        ),
        _space(4),
        _text(
          'Kami percaya bahwa menjelajahi dunia harus menjadi '
          'pengalaman yang menyenangkan dan mudah diakses '
          'oleh semua orang, dengan tetap menjaga kelestarian lingkungan.',
        ),
        _space(5),
        _text(
          'Untuk pertanyaan atau saran, hubungi kami di:',
        ),
        _space(20),
        const Row(
          children: [
            Icon(
              Icons.mail,
              size: 18,
              color: Colors.black,
            ),
            SizedBox(width: 12),
            Text(
              'support@ecowalk.com',
              style: TextStyle(
                fontSize: 12,
                color: ink,
              ),
            ),
          ],
        ),
        _space(15),
        const Row(
          children: [
            Icon(
              Icons.phone,
              size: 18,
              color: Colors.black,
            ),
            SizedBox(width: 12),
            Text(
              '0899-1234-4567',
              style: TextStyle(
                fontSize: 12,
                color: ink,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // TAMPILAN HALAMAN INFORMASI
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 55,
                width: double.infinity,
                color: green,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    15, 10, 15, 20,
                  ),
                  child: switch (type) {
                    _InfoType.terms => _termsContent(),
                    _InfoType.privacy => _privacyContent(),
                    _InfoType.about => _aboutContent(),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
