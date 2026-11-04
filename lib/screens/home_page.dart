
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'profile_page.dart';
import 'kategori_page.dart';
import 'detail_wisata_page.dart';
import 'beri_ulasan_page.dart';
import 'wisata_data.dart';
import 'rekomendasi_page.dart';

const Color warnaHijau = Color(0xFF176B5B);
const Color warnaBiru = Color(0xFF168DE5);

const SystemUiOverlayStyle statusBarPutih = SystemUiOverlayStyle(
  statusBarColor: Colors.white,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
  systemStatusBarContrastEnforced: false,
  systemNavigationBarContrastEnforced: false,
);

// =====================================================
// HEADER HIJAU
// =====================================================

class _HeaderHijau extends StatelessWidget {
  final String judul;
  final VoidCallback onBack;

  const _HeaderHijau({
    required this.judul,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      color: warnaHijau,
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back,
              size: 23,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Text(
              judul,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// HOME PAGE
// =====================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  final List<String> _kategori = [
    'Semua',
    'Kuliner',
    'Sejarah',
    'Alam',
    'Religi',
    'Seni',
  ];

  String _kategoriDipilih = 'Semua';
  bool _tampilkanUlasan = false;
  bool _pernahLihatDufan = false;

  WisataItem get _wisataDufan => daftarWisata.first;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ==================================================
  // NAVIGASI HOME
  // ==================================================

  void _bukaHome() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  void _bukaHalamanCuaca() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const _HalamanCuaca(),
      ),
    );
  }

  void _bukaNotifikasi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NotifikasiPage(item: _wisataDufan),
      ),
    );
  }

  // ==================================================
  // NAVIGASI REKOMENDASI - SUDAH DITAMBAHKAN
  // ==================================================

  void _bukaRekomendasi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RekomendasiPage(),
      ),
    );
  }

  void _bukaProfil() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  void _bukaKategori({String kategori = 'Semua'}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            KategoriPage(initialCategory: kategori),
      ),
    );
  }

  void _bukaDetailWisata() {
    setState(() {
      _pernahLihatDufan = true;
      _tampilkanUlasan = true;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetailWisataPage(item: _wisataDufan),
      ),
    );
  }

  void _bukaBeriUlasan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BeriUlasanPage(item: _wisataDufan),
      ),
    );
  }

  void _tutupUlasan() {
    setState(() {
      _tampilkanUlasan = false;
    });
  }

  void _bukaTerakhirDilihat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TerakhirDilihatPage(item: _wisataDufan),
      ),
    );
  }

  void _bukaRekapPerjalanan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RekapPerjalananPage(item: _wisataDufan),
      ),
    );
  }

  // ==================================================
  // PLACEHOLDER GAMBAR
  // ==================================================

  Widget _gambarError() {
    return const ColoredBox(
      color: Color(0xFFE8F3F0),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: warnaHijau,
          size: 28,
        ),
      ),
    );
  }

  // ==================================================
  // HEADER HOME
  // ==================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 22),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'lib/images/ecowalkijo.png',
                width: 120,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    width: 120,
                    height: 40,
                    child: Icon(
                      Icons.image_outlined,
                      color: warnaHijau,
                    ),
                  );
                },
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _bukaProfil,
            child: ClipOval(
              child: Image.asset(
                'lib/images/pic.jpeg',
                width: 38,
                height: 38,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const CircleAvatar(
                    radius: 19,
                    backgroundColor: Color(0xFFE8F3F0),
                    child: Icon(
                      Icons.person,
                      color: warnaHijau,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 9),
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: warnaHijau,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: _bukaNotifikasi,
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // CUACA HOME
  // ==================================================

  Widget _buildCuaca() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _bukaHalamanCuaca,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: AspectRatio(
            aspectRatio: 369 / 216,
            child: Image.asset(
              'lib/images/cuaca.png',
              width: double.infinity,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return _gambarError();
              },
            ),
          ),
        ),
      ),
    );
  }

  // ==================================================
  // JUDUL BAGIAN
  // ==================================================

  Widget _judulBagian(
    String judul, {
    String? aksi,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              judul,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          if (aksi != null)
            InkWell(
              onTap: onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    aksi,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ==================================================
  // REKOMENDASI HOME - TETAP KE DETAIL WISATA
  // ==================================================

  // Kartu wisata diambil dari gambar gabungan, tanpa mengubah gambar aslinya.
  // Setiap kartu dapat digeser secara horizontal.
  Widget _buildKartuRekomendasiGeser({
    required String gambar,
    required double posisiX,
    required double lebarKartu,
    required double lebarGambar,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _bukaDetailWisata,
      child: SizedBox(
        width: lebarKartu,
        height: 220,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: -posisiX,
                top: 0,
                width: lebarGambar,
                height: 220,
                child: Image.asset(
                  gambar,
                  width: lebarGambar,
                  height: 220,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return _gambarError();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRekomendasi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _judulBagian('Rekomendasi'),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // Kartu 1: Dunia Fantasi, dari Frame_12.png.
              _buildKartuRekomendasiGeser(
                gambar: 'lib/images/Frame_12.png',
                posisiX: 0,
                lebarKartu: 153,
                lebarGambar: 361,
              ),
              const SizedBox(width: 20),
              // Kartu 2: TMII, dari Frame_12.png.
              _buildKartuRekomendasiGeser(
                gambar: 'lib/images/Frame_12.png',
                posisiX: 173,
                lebarKartu: 154,
                lebarGambar: 361,
              ),
              const SizedBox(width: 19),
              // Kartu tambahan menggunakan aset wisata yang sudah ada.
              _buildKartuRekomendasiGeser(
                gambar: 'lib/images/Framewisata.png',
                posisiX: 0,
                lebarKartu: 153,
                lebarGambar: 362,
              ),
              const SizedBox(width: 20),
              _buildKartuRekomendasiGeser(
                gambar: 'lib/images/Framewisata.png',
                posisiX: 173,
                lebarKartu: 154,
                lebarGambar: 362,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================================================
  // KARTU ULASAN HOME
  // ==================================================

  Widget _buildKartuUlasan() {
    if (!_tampilkanUlasan) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 14, 12, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: const Color(0xFFE2E2E2),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Bagaimana Perjalananmu?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Yuk beri ulasan untuk tempat yang baru kamu kunjungi !',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _tutupUlasan,
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _bukaBeriUlasan,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.star_border,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // KATEGORI
  // ==================================================

  Widget _buildKategori() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _judulBagian('Kategori'),
        const SizedBox(height: 9),
        SizedBox(
          height: 34,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _kategori.length,
            separatorBuilder: (context, index) {
              return const SizedBox(width: 6);
            },
            itemBuilder: (context, index) {
              final item = _kategori[index];
              final dipilih = item == _kategoriDipilih;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _kategoriDipilih = item;
                  });
                  _bukaKategori(kategori: item);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: dipilih
                        ? warnaHijau
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: dipilih
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: dipilih
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==================================================
  // PILIHAN TERATAS
  // ==================================================

  // Potongan kartu dari aset Frame_83.png dibuat sebagai item terpisah,
  // sehingga gerakan swipe betul-betul menggeser kartu (bukan gambar statis).
  Widget _kartuWisataMini(double posisiX, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 145,
        height: 107,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: -posisiX,
                top: 0,
                width: 361,
                height: 107,
                child: Image.asset(
                  'lib/images/Frame_83.png',
                  width: 361,
                  height: 107,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) => _gambarError(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _daftarWisataMini(VoidCallback onTap) {
    return SizedBox(
      height: 107,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _kartuWisataMini(0, onTap),
          const SizedBox(width: 15),
          _kartuWisataMini(160, onTap),
          const SizedBox(width: 15),
          _kartuWisataMini(0, onTap),
          const SizedBox(width: 15),
          _kartuWisataMini(160, onTap),
        ],
      ),
    );
  }

  Widget _buildPilihanTeratas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _judulBagian(
          'Pilihan Teratas',
          aksi: 'Jelajahi',
          onTap: () => _bukaKategori(),
        ),
        const SizedBox(height: 13),
        _daftarWisataMini(_bukaDetailWisata),
      ],
    );
  }

  // ==================================================
  // BANNER
  // ==================================================

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: 361 / 103,
          child: Image.asset(
            'lib/images/Frame_349.png',
            width: double.infinity,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return _gambarError();
            },
          ),
        ),
      ),
    );
  }

  // ==================================================
  // KUNJUNGI LAGI
  // ==================================================

  Widget _buildKunjungiLagi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _judulBagian(
          'Kunjungi Lagi',
          aksi: 'Selengkapnya',
          onTap: _bukaRekapPerjalanan,
        ),
        const SizedBox(height: 13),
        _daftarWisataMini(_bukaRekapPerjalanan),
      ],
    );
  }

  // ==================================================
  // TERAKHIR DILIHAT
  // ==================================================

  Widget _buildTerakhirDilihat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _judulBagian(
          'Terakhir Dilihat',
          aksi: 'Selengkapnya',
          onTap: _bukaTerakhirDilihat,
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            height: 225,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (_pernahLihatDufan)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _bukaDetailWisata,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.asset(
                          'lib/images/dufan_rate.png',
                          width: 153,
                          height: 220,
                          fit: BoxFit.fill,
                          errorBuilder:
                              (context, error, stackTrace) {
                            return SizedBox(
                              width: 153,
                              height: 220,
                              child: _gambarError(),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 0,
                  bottom: 25,
                  child: Image.asset(
                    'lib/images/robot.png',
                    width: 60,
                    height: 76,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return SizedBox(
                        width: 60,
                        height: 76,
                        child: _gambarError(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================================================
  // NAVIGASI BAWAH HOME
  // TOMBOL KEDUA SUDAH KE REKOMENDASI
  // ==================================================

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
                'lib/images/Component_4.png',
                width: lebar,
                height: tinggi,
                fit: BoxFit.fill,
                errorBuilder:
                    (context, error, stackTrace) {
                  return const ColoredBox(
                    color: warnaHijau,
                  );
                },
              ),
              Row(
                children: [
                  // HOME
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _bukaHome,
                      child: const SizedBox.expand(),
                    ),
                  ),

                  // REKOMENDASI - SUDAH TERHUBUNG
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _bukaRekomendasi,
                      child: const SizedBox.expand(),
                    ),
                  ),

                  // IKON KETIGA TETAP
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: const SizedBox.expand(),
                    ),
                  ),

                  // PROFILE
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _bukaProfil,
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

  // ==================================================
  // BUILD HOME
  // ==================================================

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarPutih,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            _buildCuaca(),
                            const SizedBox(height: 25),
                            _buildRekomendasi(),
                            if (_tampilkanUlasan) ...[
                              const SizedBox(height: 45),
                              _buildKartuUlasan(),
                              const SizedBox(height: 44),
                            ] else
                              const SizedBox(height: 28),
                            _buildKategori(),
                            const SizedBox(height: 13),
                            _buildPilihanTeratas(),
                            const SizedBox(height: 29),
                            _buildBanner(),
                            const SizedBox(height: 30),
                            _buildKunjungiLagi(),
                            const SizedBox(height: 31),
                            _buildTerakhirDilihat(),
                            const SizedBox(height: 115),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _buildBottomNavigation(),
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

// =====================================================
// HALAMAN CUACA
// =====================================================

class _HalamanCuaca extends StatelessWidget {
  const _HalamanCuaca();

  static const Color backgroundColor = Color(0xFFD2E1DE);

  Widget _buildPrakiraanCuaca() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double lebar = constraints.maxWidth;
        final double ukuranGambar =
            (lebar * 0.49).clamp(115.0, 185.0);

        return SizedBox(
          width: double.infinity,
          height: 160,
          child: Stack(
            children: [
              Positioned(
                left: 3,
                top: 0,
                right: ukuranGambar * 0.65,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Prakiraan Cuaca',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Klapanunggal, Bogor',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 17),
                    Text(
                      '30°C',
                      style: TextStyle(
                        fontSize: 47,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Cerah Berawan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Image.asset(
                  'lib/images/Cuaca_Icon.png',
                  width: ukuranGambar,
                  height: 145,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (context, error, stackTrace) {
                    return SizedBox(
                      width: ukuranGambar,
                      height: 145,
                      child: const Icon(
                        Icons.cloud,
                        size: 88,
                        color: warnaHijau,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKartuInformasi({
    required String judul,
    required String nilai,
    bool ikonUdara = false,
  }) {
    return Container(
      height: 67,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: warnaHijau,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (ikonUdara) ...[
                const Icon(
                  Icons.air,
                  color: Colors.white,
                  size: 12,
                ),
                const SizedBox(width: 5),
              ],
              Flexible(
                child: Text(
                  judul,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            nilai,
            style: const TextStyle(
              fontSize: 24,
              height: 1,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Deretan prakiraan per jam bisa digeser ke kiri dan kanan.
  // Frame_330.png berisi empat kartu berukuran 78 x 90.
  // Potongan dijaga pada ukuran aslinya agar ikon/cuaca tidak gepeng.
  Widget _kartuCuacaPerJam(double posisiX) {
    return SizedBox(
      width: 78,
      height: 90,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: -posisiX,
              top: 0,
              width: 361,
              height: 90,
              child: Image.asset(
                'lib/images/Frame_330.png',
                width: 361,
                height: 90,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    width: 361,
                    height: 90,
                    child: Center(child: Text('Prakiraan cuaca')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCuacaPerJam() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hari ini',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              _kartuCuacaPerJam(0),
              const SizedBox(width: 11),
              _kartuCuacaPerJam(89),
              const SizedBox(width: 11),
              _kartuCuacaPerJam(178),
              const SizedBox(width: 11),
              _kartuCuacaPerJam(267),
              const SizedBox(width: 11),
              _kartuCuacaPerJam(89),
              const SizedBox(width: 11),
              _kartuCuacaPerJam(178),
            ],
          ),
        ),
      ],
    );
  }

  // Gambar dua hari mempertahankan rasio aslinya (369:100), tidak ditarik.
  Widget _buildCuacaDuaHari() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double lebarGambar = 369;
        return ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: SizedBox(
            height: 100,
            width: constraints.maxWidth,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Image.asset(
                'lib/images/Group_198.png',
                width: lebarGambar,
                height: 100,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: lebarGambar,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Hari Ini'),
                            Text('Cerah Berawan'),
                            Text('30°C / 20°C'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Besok'),
                            Text('Cerah Berawan'),
                            Text('30°C / 20°C'),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _aktivitasItem({
    required BuildContext context,
    required IconData ikon,
    required String teks,
    bool tampilkanLink = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 35,
            child: Icon(
              ikon,
              size: 27,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  teks,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
                if (tampilkanLink) ...[
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Lihat Destinasi Wisata',
                      style: TextStyle(
                        fontSize: 10,
                        height: 1.2,
                        color: warnaBiru,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAktivitasHarian(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktivitas Harian',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 17),
        _aktivitasItem(
          context: context,
          ikon: Icons.sentiment_very_satisfied_outlined,
          teks: 'Berjalan-jalan adalah pilihan terbaik saat ini !',
          tampilkanLink: true,
        ),
        _aktivitasItem(
          context: context,
          ikon: Icons.umbrella_outlined,
          teks: 'Jangan lupa bawa payung untuk berjaga-jaga',
        ),
        _aktivitasItem(
          context: context,
          ikon: Icons.home_outlined,
          teks: 'Aktivitas outdoor direkomendasikan',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarPutih,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ColoredBox(
            color: backgroundColor,
            child: Column(
              children: [
                _HeaderHijau(
                  judul: 'Cuaca',
                  onBack: () => Navigator.pop(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      16, 30, 16, 25,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        _buildPrakiraanCuaca(),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildKartuInformasi(
                                judul: 'Kelembapan',
                                nilai: '92%',
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildKartuInformasi(
                                judul: 'Kualitas Udara',
                                nilai: '39.1',
                                ikonUdara: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        _buildCuacaPerJam(),
                        const SizedBox(height: 30),
                        _buildCuacaDuaHari(),
                        const SizedBox(height: 27),
                        _buildAktivitasHarian(context),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// HALAMAN NOTIFIKASI
// =====================================================

class NotifikasiPage extends StatelessWidget {
  final WisataItem item;

  const NotifikasiPage({
    super.key,
    required this.item,
  });

  void _pergiLagi(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetailWisataPage(item: item),
      ),
    );
  }

  void _lihatDestinasiWisata(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const KategoriPage(),
      ),
    );
  }

  Widget _buildStatusSelesai() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle,
          size: 11,
          color: warnaHijau,
        ),
        SizedBox(width: 2),
        Text(
          'Selesai',
          style: TextStyle(fontSize: 9),
        ),
      ],
    );
  }

  Widget _buildNotifikasiDufan(BuildContext context) {
    return InkWell(
      onTap: () => _pergiLagi(context),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 101,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFE5E5E5),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 65,
              height: 59,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      _buildStatusSelesai(),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    '19 Februari 2025',
                    style: TextStyle(
                      fontSize: 8,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF999999),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Transportasi Umum',
                    style: TextStyle(fontSize: 10),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Pergi Lagi',
                    style: TextStyle(
                      fontSize: 11,
                      color: warnaBiru,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifikasiCuaca(BuildContext context) {
    return InkWell(
      onTap: () => _lihatDestinasiWisata(context),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 101,
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFE5E5E5),
            ),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              'lib/images/matahari.png',
              width: 65,
              height: 65,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  width: 65,
                  height: 65,
                  child: Icon(
                    Icons.wb_sunny,
                    color: Color(0xFFFFD600),
                    size: 55,
                  ),
                );
              },
            ),
            const SizedBox(width: 18),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cuaca Sedang Cerah',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '19 Februari 2025',
                    style: TextStyle(
                      fontSize: 8,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF999999),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Yuk keluar dan jalan-jalan !',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Lihat Destinasi Wisata',
                    style: TextStyle(
                      fontSize: 11,
                      color: warnaBiru,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarPutih,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _HeaderHijau(
                judul: 'Notifikasi',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  physics: const ClampingScrollPhysics(),
                  children: [
                    _buildNotifikasiDufan(context),
                    _buildNotifikasiDufan(context),
                    _buildNotifikasiDufan(context),
                    _buildNotifikasiDufan(context),
                    _buildNotifikasiCuaca(context),
                    _buildNotifikasiDufan(context),
                    _buildNotifikasiDufan(context),
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

// =====================================================
// HALAMAN TERAKHIR DILIHAT
// =====================================================

class TerakhirDilihatPage extends StatelessWidget {
  final WisataItem item;

  const TerakhirDilihatPage({
    super.key,
    required this.item,
  });

  void _bukaDetailWisata(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetailWisataPage(item: item),
      ),
    );
  }

  Widget _buildBarisWisata(BuildContext context) {
    return InkWell(
      onTap: () => _bukaDetailWisata(context),
      child: Container(
        height: 86,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFE4E4E4),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 49,
              height: 49,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFC800),
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          '${item.rating.toStringAsFixed(2)}'
                          ' | Open ${item.openHours}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            height: 1.05,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Mulai dari Rp. 200.000',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      height: 1.05,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              size: 25,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarPutih,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _HeaderHijau(
                judul: 'Terakhir Dilihat',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  physics: const ClampingScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return _buildBarisWisata(context);
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

// =====================================================
// HALAMAN REKAP PERJALANAN
// =====================================================

class RekapPerjalananPage extends StatefulWidget {
  final WisataItem item;

  const RekapPerjalananPage({
    super.key,
    required this.item,
  });

  @override
  State<RekapPerjalananPage> createState() =>
      _RekapPerjalananPageState();
}

class _RekapPerjalananPageState
    extends State<RekapPerjalananPage> {
  bool _tampilkanUlasan = true;

  void _bukaBeriUlasan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BeriUlasanPage(item: widget.item),
      ),
    );
  }

  void _pergiLagi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetailWisataPage(item: widget.item),
      ),
    );
  }

  // ==================================================
  // FOTO DUFAN
  // ==================================================

  Widget _buildFotoUtama() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
        child: Image.asset(
          'lib/images/dufan_detail.png',
          width: double.infinity,
          height: 140,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFE5E5E5),
              alignment: Alignment.center,
              child: const Text(
                'Foto Dunia Fantasi (DUFAN)',
                style: TextStyle(fontSize: 12),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==================================================
  // INFO PERJALANAN
  // ==================================================

  Widget _buildInformasiPerjalanan() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 25, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(
                Icons.access_time,
                size: 15,
                color: Color(0xFF9B9B9B),
              ),
              SizedBox(width: 9),
              Text(
                '19 Februari 2025 | 12:00 WIB',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.map_outlined,
                size: 19,
                color: Colors.black,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  widget.item.fullAddress,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.3,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================================================
  // RUTE PERJALANAN
  // ==================================================

  Widget _buildRutePerjalanan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rute Perjalanan',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: double.infinity,
              height: 136,
              child: Image.asset(
                'lib/images/map_dufan.png',
                width: double.infinity,
                height: 136,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFE5E5E5),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.map_outlined,
                      size: 40,
                      color: warnaHijau,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // TRANSPORTASI
  // ==================================================

  Widget _buildTransportasi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transportasi',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'lib/images/ojek.png',
              width: 80,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 120,
                  color: const Color(0xFFE5E5E5),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.two_wheeler,
                    size: 32,
                    color: warnaHijau,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // KARTU PENILAIAN PERJALANAN
  // ==================================================

  Widget _buildKartuUlasan() {
    if (!_tampilkanUlasan) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 15, 14, 19),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: const Color(0xFFE3E3E3),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bagaimana Perjalananmu?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Yuk beri ulasan untuk tempat yang baru kamu kunjungi !',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _tampilkanUlasan = false;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _bukaBeriUlasan,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 7),
                    child: Icon(
                      Icons.star_border,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // TOMBOL PERGI LAGI
  // ==================================================

  Widget _buildTombolPergiLagi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 46,
        child: ElevatedButton(
          onPressed: _pergiLagi,
          style: ElevatedButton.styleFrom(
            backgroundColor: warnaHijau,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text(
            'Pergi Lagi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  // ==================================================
  // HALAMAN REKAP PERJALANAN
  // ==================================================

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarPutih,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _HeaderHijau(
                judul: 'Rekap Perjalanan',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _buildFotoUtama(),
                      _buildInformasiPerjalanan(),
                      const SizedBox(height: 30),
                      _buildRutePerjalanan(),
                      const SizedBox(height: 27),
                      _buildTransportasi(),
                      const SizedBox(height: 29),
                      _buildKartuUlasan(),
                      const SizedBox(height: 47),
                      _buildTombolPergiLagi(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
