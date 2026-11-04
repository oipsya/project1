
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_page.dart';
import 'profile_page.dart';
import 'kategori_page.dart';
import 'detail_wisata_page.dart';
import 'wisata_data.dart';

// =======================================================
// ECOWALK - REKOMENDASI
// PENCARIAN, HASIL RUTE, ANALISIS TRANSPORTASI,
// DETAIL TRANSJAKARTA, DAN KEBERANGKATAN
// =======================================================

const Color _hijau = Color(0xFF176B5B);
const Color _biru = Color(0xFF168DE5);

const SystemUiOverlayStyle _statusPutih = SystemUiOverlayStyle(
  statusBarColor: Colors.white,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
  systemStatusBarContrastEnforced: false,
  systemNavigationBarContrastEnforced: false,
);

// =======================================================
// WIDGET BERSAMA UNTUK HALAMAN BARU
// =======================================================

class _HeaderHalaman extends StatelessWidget {
  final String judul;
  final VoidCallback onBack;

  const _HeaderHalaman({
    required this.judul,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: _hijau,
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 23,
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Text(
              judul,
              style: const TextStyle(
                fontSize: 16,
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

class _GambarAset extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;

  const _GambarAset({
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: const Color(0xFFE6ECEA),
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_outlined,
            color: _hijau,
            size: 30,
          ),
        );
      },
    );
  }
}

// =======================================================
// HALAMAN REKOMENDASI UTAMA
// =======================================================

class RekomendasiPage extends StatefulWidget {
  const RekomendasiPage({super.key});

  @override
  State<RekomendasiPage> createState() =>
      _RekomendasiPageState();
}

class _RekomendasiPageState extends State<RekomendasiPage> {
  static const double lebarKartuWisata = 158;
  static const double tinggiKartuWisata = 226;
  static const double jarakKartuWisata = 20;

  final TextEditingController _asalController =
      TextEditingController();

  final TextEditingController _tujuanController =
      TextEditingController();

  final ScrollController _wisataScrollController =
      ScrollController();

  bool _tampilkanHasil = false;
  int _kendaraanDipilih = 0;

  final List<String> _waktuKendaraan = [
    '13 menit',
    '5 menit',
    '4 menit',
    '18 menit',
  ];

  @override
  void dispose() {
    _asalController.dispose();
    _tujuanController.dispose();
    _wisataScrollController.dispose();
    super.dispose();
  }

  // =====================================================
  // NAVIGASI
  // =====================================================

  void _cariRute() {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _tampilkanHasil = true;
      _kendaraanDipilih = 0;
    });
  }

  void _kembaliKePencarian() {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _tampilkanHasil = false;
    });
  }

  void _bukaHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
      (route) => false,
    );
  }

  void _bukaProfile() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfilePage(),
      ),
      (route) => false,
    );
  }

  void _bukaKategori() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const KategoriPage(),
      ),
    );
  }

  void _bukaDetailWisata(String namaWisata) {
    final hasil = daftarWisata.where((wisata) {
      return wisata.title
          .toLowerCase()
          .contains(namaWisata.toLowerCase());
    }).toList();

    if (hasil.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Detail $namaWisata belum tersedia.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailWisataPage(
          item: hasil.first,
        ),
      ),
    );
  }

  void _bukaDetailTransportasi(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const _DetailOjekPage(),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const _DetailTransportasiUmumPage(),
        ),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const _KendaraanPribadiPage(),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const _DetailPilihanPage(
            index: 6,
            pribadi: false,
          ),
        ),
      );
    }
  }

  // =====================================================
  // LOGO
  // =====================================================

  Widget _buildLogo() {
    return const _GambarAset(
      path: 'lib/images/ecowalkijo.png',
      width: 120,
      height: 40,
      fit: BoxFit.contain,
    );
  }

  // =====================================================
  // NAVIGASI BAWAH PENCARIAN
  // =====================================================

  Widget _buildNavigasiBawah() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double lebar = constraints.maxWidth;
        final double tinggi = lebar * 106 / 393;

        return SizedBox(
          width: lebar,
          height: tinggi,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _GambarAset(
                path: 'lib/images/Component_21.png',
                width: lebar,
                height: tinggi,
                fit: BoxFit.fill,
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
                      onTap: () {
                        if (_tampilkanHasil) {
                          _kembaliKePencarian();
                        }
                      },
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _bukaKategori,
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _bukaProfile,
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

  // =====================================================
  // INPUT LOKASI
  // =====================================================

  Widget _buildInputLokasi({
    required TextEditingController controller,
    required String petunjuk,
    required IconData ikon,
  }) {
    return Container(
      height: 43,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(
            ikon,
            size: 24,
            color: const Color(0xFF575757),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: petunjuk,
                hintStyle: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF777777),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormLokasi() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
      decoration: BoxDecoration(
        color: _hijau,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildInputLokasi(
            controller: _asalController,
            petunjuk: 'Masukan Lokasi Asal',
            ikon: Icons.search,
          ),
          const SizedBox(height: 11),
          _buildInputLokasi(
            controller: _tujuanController,
            petunjuk: 'Masukan Lokasi Tujuan',
            ikon: Icons.location_on_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildTombolCariRute() {
    return SizedBox(
      width: 116,
      height: 29,
      child: ElevatedButton(
        onPressed: _cariRute,
        style: ElevatedButton.styleFrom(
          backgroundColor: _hijau,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: const Text(
          'Cari Rute',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // KARTU WISATA ASLI
  // =====================================================

  Widget _buildFotoWisata({
    required double posisiX,
    required String namaWisata,
  }) {
    const double skala = tinggiKartuWisata / 220;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _bukaDetailWisata(namaWisata),
      child: SizedBox(
        width: lebarKartuWisata,
        height: tinggiKartuWisata,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: -posisiX * skala,
                top: 0,
                width: 362 * skala,
                height: tinggiKartuWisata,
                child: const _GambarAset(
                  path: 'lib/images/Framewisata.png',
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPotonganKetiga() {
    const double skala = tinggiKartuWisata / 220;

    return SizedBox(
      width: 15 * skala,
      height: tinggiKartuWisata,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: -347 * skala,
              top: 0,
              width: 362 * skala,
              height: tinggiKartuWisata,
              child: const _GambarAset(
                path: 'lib/images/Framewisata.png',
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRekomendasiTujuan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rekomendasi Tujuan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 19),
        SizedBox(
          height: tinggiKartuWisata,
          child: ListView(
            controller: _wisataScrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              _buildFotoWisata(
                posisiX: 0,
                namaWisata: 'Moja',
              ),
              const SizedBox(width: jarakKartuWisata),
              _buildFotoWisata(
                posisiX: 173,
                namaWisata: 'Ocean Park',
              ),
              const SizedBox(width: jarakKartuWisata),
              _buildPotonganKetiga(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHalamanPencarian() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(),
          const SizedBox(height: 29),
          const Text(
            'MAU KEMANA HARI INI?',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 9),
          _buildFormLokasi(),
          const SizedBox(height: 22),
          _buildTombolCariRute(),
          const SizedBox(height: 41),
          _buildRekomendasiTujuan(),
        ],
      ),
    );
  }

  // =====================================================
  // HALAMAN HASIL RUTE
  // =====================================================

  Widget _buildTitikRute({
    required String label,
    required String lokasi,
    required bool awal,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 32,
          child: Icon(
            awal ? Icons.circle : Icons.location_on_outlined,
            size: awal ? 12 : 19,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFFD2E6E1),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                lokasi,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKartuRute() {
    final asal = _asalController.text.trim().isEmpty
        ? 'KLAPANUNGGAL'
        : _asalController.text.trim();

    final tujuan = _tujuanController.text.trim().isEmpty
        ? 'Trans Studio Cibubur'
        : _tujuanController.text.trim();

    return Container(
      height: 108,
      padding: const EdgeInsets.fromLTRB(16, 13, 30, 10),
      decoration: BoxDecoration(
        color: _hijau,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTitikRute(
            label: 'Titik Awal',
            lokasi: asal,
            awal: true,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 31, top: 4),
            child: Divider(
              color: Colors.white,
              thickness: 1,
              height: 2,
            ),
          ),
          const SizedBox(height: 6),
          _buildTitikRute(
            label: 'Titik Akhir',
            lokasi: tujuan,
            awal: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPilihanWaktu(int index, IconData ikon) {
    final dipilih = _kendaraanDipilih == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _kendaraanDipilih = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: dipilih
              ? const Color(0xFFF3F3F3)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: dipilih
              ? const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ikon, size: 17),
            const SizedBox(width: 3),
            Text(
              _waktuKendaraan[index],
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarisWaktu() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildPilihanWaktu(
            0,
            Icons.directions_walk,
          ),
          const SizedBox(width: 9),
          _buildPilihanWaktu(
            1,
            Icons.directions_car_outlined,
          ),
          const SizedBox(width: 9),
          _buildPilihanWaktu(
            2,
            Icons.two_wheeler,
          ),
          const SizedBox(width: 9),
          _buildPilihanWaktu(
            3,
            Icons.directions_bus_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildPeta() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: const SizedBox(
        height: 207,
        width: double.infinity,
        child: _GambarAset(
          path: 'lib/images/map_dufan.png',
        ),
      ),
    );
  }

  Widget _buildFotoKendaraan({
    required String path,
    required int index,
    required double lebarKartu,
  }) {
    final dipilih = _kendaraanDipilih == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _kendaraanDipilih = index;
        });
        _bukaDetailTransportasi(index);
      },
      child: Container(
        width: lebarKartu,
        height: 108,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: dipilih
              ? Border.all(color: _hijau, width: 1)
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: _GambarAset(
          path: path,
          width: lebarKartu,
          height: 108,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  // Kartu Kendaraan Pribadi pada Opsi Kendaraan.
  // Isi dan navigasi halaman Kendaraan Pribadi tidak diubah.
  Widget _buildKartuPribadi(double lebarKartu) {
    final dipilih = _kendaraanDipilih == 4;
    return GestureDetector(
      onTap: () {
        setState(() => _kendaraanDipilih = 4);
        _bukaDetailTransportasi(4);
      },
      child: Container(
        width: lebarKartu,
        height: 108,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: dipilih ? Border.all(color: _hijau) : null,
        ),
        // Foto sudah memiliki judul dan keterangan di dalam aset.
        // Tidak perlu menumpuk teks/gradient tambahan di atas gambar.
        // Zoom hanya pada foto kartu kecil agar bingkai putih bawaan aset
        // tidak terlihat. Ukuran kartu dan halaman detail tetap sama.
        child: Transform.scale(
          scale: 1.28,
          child: const _GambarAset(
            path: 'lib/images/ojeek.jpeg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildOpsiKendaraan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Opsi Kendaraan',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            // Sesuai referensi: dua kartu kecil rata kiri, bukan melebar
            // memenuhi seluruh baris.
            final double lebarKartu =
                ((constraints.maxWidth - 8) / 2).clamp(0.0, 75.0).toDouble();
            return Row(
              children: [
                _buildKartuPribadi(lebarKartu),
                const SizedBox(width: 8),
                _buildFotoKendaraan(
                  path: 'lib/images/Frame_51.png',
                  index: 3,
                  lebarKartu: lebarKartu,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTipsTransportasi() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 12, 12, 12),
      decoration: BoxDecoration(
        color: _hijau,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mau cepat & murah? 👉 Ojek Online',
            style: TextStyle(fontSize: 12, color: Colors.white, height: 1.65),
          ),
          Text(
            'Mau lebih hemat? 👉 Transportasi Umum',
            style: TextStyle(fontSize: 12, color: Colors.white, height: 1.65),
          ),
          Text(
            'Mau nyaman & fleksibel? 👉 Kendaraan Pribadi',
            style: TextStyle(fontSize: 12, color: Colors.white, height: 1.65),
          ),
        ],
      ),
    );
  }

  Widget _buildHalamanHasil() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 29, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKartuRute(),
          const SizedBox(height: 15),
          _buildLogo(),
          const SizedBox(height: 12),
          _buildBarisWaktu(),
          const SizedBox(height: 12),
          _buildPeta(),
          const SizedBox(height: 13),
          _buildOpsiKendaraan(),
          const SizedBox(height: 17),
          _buildTipsTransportasi(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_tampilkanHasil,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _tampilkanHasil && mounted) {
          _kembaliKePencarian();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: _statusPutih,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            bottom: _tampilkanHasil,
            child: Column(
              children: [
                if (_tampilkanHasil)
                  _HeaderHalaman(
                    judul: 'Rekomendasi',
                    onBack: _kembaliKePencarian,
                  ),
                Expanded(
                  child: _tampilkanHasil
                      ? _buildHalamanHasil()
                      : _buildHalamanPencarian(),
                ),
                if (!_tampilkanHasil)
                  Transform.translate(
                    offset: const Offset(0, 8),
                    child: _buildNavigasiBawah(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =======================================================
// KOMPONEN ANALISIS PERJALANAN
// =======================================================

class _BarisAnalisis extends StatelessWidget {
  final String label;
  final String nilai;

  // TAMBAHAN:
  // AGAR GARIS BAWAH KENYAMANAN BISA DIHILANGKAN
  final bool tampilkanGaris;

  const _BarisAnalisis({
    required this.label,
    required this.nilai,
    this.tampilkanGaris = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        border: tampilkanGaris
            ? const Border(
                bottom: BorderSide(
                  color: Color(0xFFD0D0D0),
                  width: 0.8,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Text(
            nilai,
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

class _KelompokAnalisis extends StatelessWidget {
  final String judul;
  final String waktu;
  final String hemat;
  final String kenyamanan;

  const _KelompokAnalisis({
    required this.judul,
    required this.waktu,
    required this.hemat,
    required this.kenyamanan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          judul,
          style: const TextStyle(
            color: _hijau,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        _BarisAnalisis(
          label: 'Waktu',
          nilai: waktu,
        ),
        _BarisAnalisis(
          label: 'Hemat',
          nilai: hemat,
        ),

        // GARIS BAWAH KENYAMANAN DIHILANGKAN
        _BarisAnalisis(
          label: 'Kenyamanan',
          nilai: kenyamanan,
          tampilkanGaris: false,
        ),
      ],
    );
  }
}

class _KartuAnalisis extends StatelessWidget {
  final bool ojek;

  const _KartuAnalisis({
    required this.ojek,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 14, 13, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(11),
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
        children: [
          const Text(
            'Analisis Perjalanan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),

          if (ojek) ...[
            const _KelompokAnalisis(
              judul: 'Dibandingkan Naik Taxi',
              waktu: '5 mnt Lebih cepat',
              hemat: 'Ojek Online',
              kenyamanan: 'Taxi',
            ),
            const SizedBox(height: 8),
            const _KelompokAnalisis(
              judul: 'Dibandingkan Kendaraan Umum',
              waktu: '15 mnt Lebih lambat',
              hemat: 'Kendaraan Umum',
              kenyamanan: 'Taxi',
            ),
            const SizedBox(height: 8),
            const _KelompokAnalisis(
              judul: 'Dibandingkan Kendaraan Pribadi',
              waktu: '10-25 mnt lebih cepat (estimasi)',
              hemat: 'Tergantung perjalanan',
              kenyamanan: 'Kendaraan Pribadi',
            ),
          ] else ...[
            const _KelompokAnalisis(
              judul: 'Dibandingkan Naik Ojek Online',
              waktu: '30 mnt Lebih lambat',
              hemat: 'Kendaraan Umum',
              kenyamanan: 'Taxi',
            ),
            const SizedBox(height: 8),
            const _KelompokAnalisis(
              judul: 'Dibandingkan Taxi',
              waktu: '20-40 mnt Lebih cepat',
              hemat: 'Kendaraan Umum',
              kenyamanan: 'Taxi',
            ),
            const SizedBox(height: 8),
            const _KelompokAnalisis(
              judul: 'Dibandingkan Kendaraan Pribadi',
              waktu: '60-75 mnt lebih lambat (estimasi)',
              hemat: 'Kendaraan Umum',
              kenyamanan: 'Kendaraan Pribadi',
            ),
          ],
        ],
      ),
    );
  }
}

// =======================================================
// HALAMAN ANALISIS OJEK ONLINE
// =======================================================

class _DetailOjekPage extends StatelessWidget {
  const _DetailOjekPage();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusPutih,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _HeaderHalaman(
                judul: 'Rekomendasi',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // FOTO OJEK ONLINE:
                          // ORANG SEDANG NAIK MOTOR
                          const _GambarAset(
                            path: 'lib/images/image_15.png',
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 16,
                            bottom: -14,
                            child: _labelPutih('Tercepat'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 17),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Text(
                          'OJEK ONLINE',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(height: 9),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.payments_outlined,
                              size: 18,
                            ),
                            SizedBox(width: 7),
                            Text(
                              'Rp. 30.000 - 45.000',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 3),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 18,
                            ),
                            SizedBox(width: 7),
                            Text(
                              '20 Menit',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(11),
                          ),
                          child: _GambarAset(
                            path: 'lib/images/map_dufan.png',
                            width: double.infinity,
                            height: 207,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: _KartuAnalisis(ojek: true),
                      ),

                      const SizedBox(height: 35),
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

// =======================================================
// HALAMAN KENDARAAN PRIBADI - 4 PILIHAN
// =======================================================

class _KendaraanPribadiPage extends StatelessWidget {
  const _KendaraanPribadiPage();

  static const List<String> _nama = [
    'Motor', 'Mobil', 'Ojek Online', 'Taxi Online',
  ];
  static const List<String> _emoji = [
    '🏍️', '🚗', '🛵', '🚕',
  ];
  static const List<String> _deskripsi = [
    'Kendaraan roda dua pribadi',
    'Kendaraan roda empat pribadi',
    'Transportasi motor online',
    'Transportasi mobil online',
  ];

  void _bukaDetail(BuildContext context, int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const _DetailPilihanPage(
            index: 2,
            pribadi: true,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _DetailPilihanPage(
            index: index,
            pribadi: true,
          ),
        ),
      );
    }
  }

  Widget _pilihan(BuildContext context, int index) {
    return InkWell(
      onTap: () => _bukaDetail(context, index),
      child: Container(
        height: 57,
        decoration: BoxDecoration(
          border: index < _nama.length - 1
              ? const Border(
                  bottom: BorderSide(color: Color(0xFFC6C6C6), width: 1),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 47,
              height: 39,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(_emoji[index], style: const TextStyle(fontSize: 21)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_nama[index], style: const TextStyle(fontSize: 14)),
                  Text(
                    _deskripsi[index],
                    style: const TextStyle(fontSize: 12, color: _hijau),
                  ),
                ],
              ),
            ),
            const Text('Detail', style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildOpsiPribadi(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(11),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          _nama.length,
          (index) => _pilihan(context, index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusPutih,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _HeaderHalaman(
                judul: 'Rekomendasi',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const _GambarAset(
                            path: 'lib/images/image_15.png',
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            right: 16,
                            bottom: -14,
                            child: _labelPutih('Kendaraan Pribadi'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 17),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'KENDARAAN PRIBADI',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(Icons.payments_outlined, size: 18),
                            SizedBox(width: 7),
                            Text('Biaya tergantung kendaraan',
                                style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, size: 18),
                            SizedBox(width: 7),
                            Text('Estimasi tergantung kondisi jalan',
                                style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(11)),
                          child: _GambarAset(
                            path: 'lib/images/map_dufan.png',
                            width: double.infinity,
                            height: 207,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: _AnalisisPribadi(),
                      ),
                      const SizedBox(height: 26),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Opsi Kendaraan Pribadi',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildOpsiPribadi(context),
                      ),
                      const SizedBox(height: 60),
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

class _AnalisisPribadi extends StatelessWidget {
  const _AnalisisPribadi();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 14, 13, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(11),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analisis Perjalanan',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 18),
          _KelompokAnalisis(
            judul: 'Dibandingkan Kendaraan Umum',
            waktu: '60-75 mnt lebih cepat (estimasi)',
            hemat: 'Kendaraan Umum',
            kenyamanan: 'Kendaraan Pribadi',
          ),
          SizedBox(height: 8),
          _KelompokAnalisis(
            judul: 'Dibandingkan Ojek Online',
            waktu: '10-25 mnt lebih lambat (estimasi)',
            hemat: 'Tergantung perjalanan',
            kenyamanan: 'Kendaraan Pribadi',
          ),
          SizedBox(height: 8),
          _KelompokAnalisis(
            judul: 'Dibandingkan Taxi',
            waktu: '0-15 mnt lebih cepat (estimasi)',
            hemat: 'Kendaraan Pribadi',
            kenyamanan: 'Taxi',
          ),
        ],
      ),
    );
  }
}

// =======================================================
// HALAMAN ANALISIS TRANSPORTASI UMUM
// =======================================================

class _DetailTransportasiUmumPage extends StatelessWidget {
  const _DetailTransportasiUmumPage();

  static const List<String> _namaTransportasi = [
    'TransJakarta',
    'MRT Jakarta',
    'LRT Jabodetabek',
    'KRL Commuter Line',
    'Mikrotrans (JakLingko)',
    'Ojek Online',
    'Taxi',
  ];

  static const List<String> _durasi = [
    '± 40 menit',
    '± 25 menit',
    '± 30 menit',
    '± 35 menit',
    '± 50 menit',
    '± 20 menit',
    '± 25 menit',
  ];

  static const List<String> _emoji = [
    '🚌 ',
    '🚇',
    '🚋',
    '🚆',
    '🚐',
    '🛵',
    '🚕',
  ];

  void _bukaDetail(
    BuildContext context,
    int index,
  ) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const _TransJakartaPage(),
        ),
      );
    } else if (index == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const _DetailPilihanPage(
            index: 5,
            pribadi: false,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _DetailPilihanPage(
            index: index,
            pribadi: false,
          ),
        ),
      );
    }
  }

  Widget _barisTransportasi(
    BuildContext context,
    int index,
  ) {
    return InkWell(
      onTap: () => _bukaDetail(context, index),
      child: Container(
        height: 57,
        decoration: BoxDecoration(
          border: index < _namaTransportasi.length - 1
              ? const Border(
                  bottom: BorderSide(
                    color: Color(0xFFC6C6C6),
                    width: 1,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 47,
              height: 39,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _emoji[index],
                style: const TextStyle(fontSize: 21),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _namaTransportasi[index],
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    _durasi[index],
                    style: const TextStyle(
                      fontSize: 12,
                      color: _hijau,
                    ),
                  ),
                ],
              ),
            ),

            const Text(
              'Detail',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpsiTransportasi(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        13, 12, 13, 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(11),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          _namaTransportasi.length,
          (index) => _barisTransportasi(
            context,
            index,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusPutih,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _HeaderHalaman(
                judul: 'Rekomendasi',
                onBack: () => Navigator.pop(context),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const _GambarAset(
                            path: 'lib/images/image_16.png',
                            width: double.infinity,
                            height: 180,
                          ),
                          Positioned(
                            right: 16,
                            bottom: -14,
                            child: _labelPutih('Termurah'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 17),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Text(
                          'TRANSPORTASI UMUM',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(height: 9),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.payments_outlined,
                              size: 18,
                            ),
                            SizedBox(width: 7),
                            Text(
                              'Rp. 0 - 20.000',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 3),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 18,
                            ),
                            SizedBox(width: 7),
                            Text(
                              '1 Jam 45 Menit',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(11),
                          ),
                          child: _GambarAset(
                            path: 'lib/images/map_dufan.png',
                            height: 207,
                            width: double.infinity,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: _KartuAnalisis(ojek: false),
                      ),

                      const SizedBox(height: 26),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Text(
                          'Opsi Transportasi Umum',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: _buildOpsiTransportasi(context),
                      ),

                      const SizedBox(height: 60),
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

// =======================================================
// DETAIL PILIHAN TRANSPORTASI TAMBAHAN
// Gambar dapat diganti melalui lib/images.
// Estimasi di bawah adalah contoh untuk desain UI,
// bukan hasil pelacakan rute langsung.
// =======================================================

class _DetailPilihanPage extends StatefulWidget {
  final int index;
  final bool pribadi;

  const _DetailPilihanPage({
    required this.index,
    required this.pribadi,
  });

  @override
  State<_DetailPilihanPage> createState() => _DetailPilihanPageState();
}

class _DetailPilihanPageState extends State<_DetailPilihanPage> {
  final List<bool> _terbuka = List<bool>.filled(6, false);

  void _ubahAccordion(int index) {
    setState(() => _terbuka[index] = !_terbuka[index]);
  }

  Widget _accordion({
    required int index,
    required String judul,
    required Widget isi,
    bool hijau = false,
  }) {
    final bool terbuka = _terbuka[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: hijau ? _hijau : Colors.white,
        border: hijau
            ? null
            : Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: hijau
            ? const [
                BoxShadow(
                  color: Color(0x30000000),
                  blurRadius: 4,
                  offset: Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _ubahAccordion(index),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      judul,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: hijau ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    terbuka
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 26,
                    color: hijau
                        ? Colors.white
                        : const Color(0xFF555555),
                  ),
                ],
              ),
            ),
          ),
          if (terbuka)
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 14),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 13,
                  color: hijau ? Colors.white : Colors.black,
                  height: 1.35,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: isi,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _isiKeberangkatan(String nama, String titik) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi keberangkatan $nama:',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 3),
        Text(
          titik,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 7),
        const Text(
          'Jadwal dan waktu tunggu belum terhubung dengan data langsung.',
          style: TextStyle(
            color: Colors.red,
            fontSize: 10,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 15),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _KeberangkatanPilihanPage(
                    nama: nama,
                    titik: titik,
                  ),
                ),
              );
            },
            child: const Text(
              'Selengkapnya',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF21BDFF),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _isiKepadatan(String nama, bool pribadi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pribadi
              ? 'Kepadatan lalu lintas untuk perjalanan $nama belum tersedia.'
              : 'Informasi kepadatan penumpang $nama belum tersedia.',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 4),
        const Text(
          'Kondisi dapat berubah menurut waktu dan lokasi.',
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _isiKelebihanKekurangan(
    String kelebihan,
    String kekurangan,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kelebihan',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        Text('• $kelebihan'),
        const SizedBox(height: 8),
        const Text(
          'Kekurangan',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        Text('• $kekurangan'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String nama;
    final String gambar;
    final String biaya;
    final String durasi;
    final String titik;
    final String rute;
    final String kelebihan;
    final String kekurangan;

    if (widget.pribadi) {
      switch (widget.index) {
        case 0:
          nama = 'Motor';
          gambar = 'lib/images/motor.jpg';
          biaya = 'Biaya BBM dan parkir mengikuti perjalanan';
          durasi = '± 30 menit (ilustrasi)';
          titik = 'Berangkat dari lokasi asal yang dipilih';
          rute = 'Perjalanan mengikuti jalan yang dapat dilalui motor. '
              'Rute rinci ditentukan setelah titik asal dan tujuan terhubung.';
          kelebihan = 'Fleksibel dan praktis untuk perjalanan pribadi.';
          kekurangan = 'Terpapar hujan dan panas serta memiliki kapasitas terbatas.';
          break;
        case 1:
          nama = 'Mobil';
          gambar = 'lib/images/mobil.jpg';
          biaya = 'Biaya BBM, tol, dan parkir mengikuti perjalanan';
          durasi = '± 45 menit (ilustrasi)';
          titik = 'Berangkat dari lokasi asal yang dipilih';
          rute = 'Perjalanan mengikuti jalan untuk mobil. '
              'Jalur dan waktu dapat berubah karena kemacetan.';
          kelebihan = 'Nyaman dan memungkinkan membawa beberapa penumpang.';
          kekurangan = 'Memerlukan parkir dan dapat terjebak kemacetan.';
          break;
        case 2:
          nama = 'Ojek Online';
          gambar = 'lib/images/image_15.png';
          biaya = 'Rp. 30.000 - 45.000 (estimasi)';
          durasi = '± 20 menit (ilustrasi)';
          titik = 'Titik penjemputan sesuai lokasi asal';
          rute = 'Pesan ojek online, tunggu pengemudi tiba di titik '
              'penjemputan, lalu ikuti rute menuju tujuan. '
              'Jalur dapat berubah sesuai keadaan jalan.';
          kelebihan = 'Praktis untuk perjalanan singkat dan mudah dipesan.';
          kekurangan = 'Terpengaruh cuaca, kemacetan, dan waktu tunggu pengemudi.';
          break;
        default:
          nama = 'Taxi Online';
          gambar = 'lib/images/taxi.jpg';
          biaya = 'Tarif sesuai jarak dan aplikasi pemesanan';
          durasi = '± 25 menit (ilustrasi)';
          titik = 'Penjemputan sesuai titik pada aplikasi';
          rute = 'Pesan kendaraan melalui aplikasi, tunggu penjemputan, '
              'lalu ikuti rute menuju tujuan.';
          kelebihan = 'Tidak perlu membawa kendaraan atau mencari parkir.';
          kekurangan = 'Tarif dan waktu tunggu dapat berubah.';
      }
    } else {
      switch (widget.index) {
        case 1:
          nama = 'MRT Jakarta';
          gambar = 'lib/images/mrt.jpg';
          biaya = 'Tarif sesuai stasiun asal dan tujuan';
          durasi = '± 25 menit (ilustrasi)';
          titik = 'Stasiun keberangkatan sesuai rute';
          rute = 'Masuk melalui stasiun MRT terdekat, naik kereta ke '
              'stasiun tujuan dan lanjutkan perjalanan sesuai kebutuhan.';
          kelebihan = 'Perjalanan relatif terjadwal dan tidak terjebak macet jalan.';
          kekurangan = 'Harus menuju stasiun dan mungkin perlu transit.';
          break;
        case 2:
          nama = 'LRT Jabodetabek';
          gambar = 'lib/images/lrt.jpg';
          biaya = 'Tarif mengikuti rute dan ketentuan operator';
          durasi = '± 30 menit (ilustrasi)';
          titik = 'Stasiun keberangkatan sesuai rute';
          rute = 'Menuju stasiun LRT, naik rangkaian sesuai arah, '
              'kemudian keluar di stasiun yang mendekati tujuan.';
          kelebihan = 'Mengurangi ketergantungan pada lalu lintas jalan.';
          kekurangan = 'Jangkauan stasiun terbatas pada koridor layanan.';
          break;
        case 3:
          nama = 'KRL Commuter Line';
          gambar = 'lib/images/krl.jpg';
          biaya = 'Tarif berdasarkan perjalanan dan ketentuan operator';
          durasi = '± 35 menit (ilustrasi)';
          titik = 'Stasiun KRL sesuai rute';
          rute = 'Naik KRL dari stasiun keberangkatan menuju stasiun '
              'terdekat dengan tujuan; lakukan transit bila diperlukan.';
          kelebihan = 'Cocok untuk perjalanan antarkawasan yang dilayani rel.';
          kekurangan = 'Bisa padat pada jam sibuk dan memerlukan akses stasiun.';
          break;
        case 4:
          nama = 'Mikrotrans (JakLingko)';
          gambar = 'lib/images/jaklingko.jpg';
          biaya = 'Tarif sesuai ketentuan layanan yang berlaku';
          durasi = '± 50 menit (ilustrasi)';
          titik = 'Titik naik Mikrotrans sesuai rute';
          rute = 'Datangi titik naik pada lintasan Mikrotrans, '
              'naik kendaraan yang menuju kawasan tujuan, lalu turun '
              'di titik pemberhentian yang sesuai.';
          kelebihan = 'Melayani akses kawasan dan penghubung transportasi umum.';
          kekurangan = 'Waktu perjalanan bergantung pada lalu lintas dan berhenti.';
          break;
        case 5:
          nama = 'Ojek Online';
          gambar = 'lib/images/image_15.png';
          biaya = 'Rp. 30.000 - 45.000 (estimasi)';
          durasi = '± 20 menit (ilustrasi)';
          titik = 'Titik penjemputan sesuai lokasi asal';
          rute = 'Pesan ojek online, tunggu pengemudi tiba di titik '
              'penjemputan, lalu ikuti rute menuju tujuan. '
              'Jalur dapat berubah sesuai keadaan jalan.';
          kelebihan = 'Praktis untuk perjalanan singkat dan mudah dipesan.';
          kekurangan = 'Terpengaruh cuaca, kemacetan, dan waktu tunggu pengemudi.';
          break;
        default:
          nama = 'Taxi';
          gambar = 'lib/images/taxi.jpg';
          biaya = 'Tarif sesuai jarak dan ketentuan layanan';
          durasi = '± 25 menit (ilustrasi)';
          titik = 'Titik penjemputan sesuai permintaan';
          rute = 'Naik taksi dari lokasi penjemputan, '
              'lalu lanjutkan ke tujuan sesuai rute yang dipilih.';
          kelebihan = 'Lebih privat dan tidak perlu mencari tempat parkir.';
          kekurangan = 'Biaya dapat meningkat saat perjalanan jauh atau macet.';
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusPutih,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _HeaderHalaman(
                judul: widget.pribadi && widget.index == 2
                    ? 'Ojek Online'
                    : widget.pribadi
                        ? 'Kendaraan Pribadi'
                        : 'Transportasi Umum',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _GambarAset(
                            path: gambar,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: -14,
                            right: 16,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: _labelPutih('Rekomendasi'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          nama.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _accordion(
                              index: 0,
                              judul: 'Biaya',
                              isi: Text(biaya,
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic)),
                            ),
                            _accordion(
                              index: 1,
                              judul: 'Estimasi',
                              isi: Text(
                                '$durasi. Dapat berubah menurut kondisi perjalanan.',
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            _accordion(
                              index: 2,
                              judul: 'Keberangkatan',
                              isi: _isiKeberangkatan(nama, titik),
                            ),
                            _accordion(
                              index: 3,
                              judul: 'Informasi Kepadatan',
                              isi: _isiKepadatan(nama, widget.pribadi),
                            ),
                            _accordion(
                              index: 4,
                              judul: 'Rute yang dilalui',
                              isi: Text(rute,
                                  style: const TextStyle(fontSize: 13)),
                            ),
                            _accordion(
                              index: 5,
                              judul: 'Kelebihan & Kekurangan',
                              isi: _isiKelebihanKekurangan(
                                kelebihan,
                                kekurangan,
                              ),
                              hijau: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 65),
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

// Halaman ini mengikuti tata letak Keberangkatan TransJakarta,
// tetapi tidak mengarang jadwal aktual transportasi lain.
class _KeberangkatanPilihanPage extends StatelessWidget {
  final String nama;
  final String titik;

  const _KeberangkatanPilihanPage({
    required this.nama,
    required this.titik,
  });

  Widget _labelKuning(String label) {
    return Container(
      width: 65,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFAA00),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _kartuKeberangkatan(int nomor) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(15, 11, 15, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFB8D4CC),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Keberangkatan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        _labelKuning(nama.length > 9
                            ? nama.substring(0, 9)
                            : nama),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            titik,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '--:--',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 7),
          const Text(
            'Jadwal belum tersedia',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Informasi perlu diperiksa melalui operator atau aplikasi terkait',
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusPutih.copyWith(
        systemNavigationBarColor: const Color(0xFFCDDDDA),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _HeaderHalaman(
                judul: 'Keberangkatan',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(color: _hijau),
                    ),
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: _GambarAset(
                        path: 'lib/images/Frame_30.png',
                        height: 339,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      top: 284,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
                        children: [
                          for (int i = 0; i < 6; i++)
                            _kartuKeberangkatan(i),
                        ],
                      ),
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

// =======================================================
// LABEL KECIL DI SAMPING FOTO
// =======================================================

Widget _labelPutih(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 13,
      vertical: 8,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: const [
        BoxShadow(
          color: Color(0x44000000),
          blurRadius: 4,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: _hijau,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

// =======================================================
// DETAIL TRANSJAKARTA
// ACCORDION BISA DIBUKA DAN DITUTUP
// =======================================================

class _TransJakartaPage extends StatefulWidget {
  const _TransJakartaPage();

  @override
  State<_TransJakartaPage> createState() =>
      _TransJakartaPageState();
}

class _TransJakartaPageState
    extends State<_TransJakartaPage> {
  final List<bool> _terbuka = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  void _ubahAccordion(int index) {
    setState(() {
      _terbuka[index] = !_terbuka[index];
    });
  }

  void _bukaKeberangkatan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const _KeberangkatanPage(),
      ),
    );
  }

  Widget _accordion({
    required int index,
    required String judul,
    required Widget isi,
    bool hijau = false,
  }) {
    final bool terbuka = _terbuka[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: hijau ? _hijau : Colors.white,
        border: hijau
            ? null
            : Border.all(
                color: Colors.black,
                width: 1,
              ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: hijau
            ? const [
                BoxShadow(
                  color: Color(0x30000000),
                  blurRadius: 4,
                  offset: Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _ubahAccordion(index),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      judul,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: hijau
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    terbuka
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 26,
                    color: hijau
                        ? Colors.white
                        : const Color(0xFF555555),
                  ),
                ],
              ),
            ),
          ),
          if (terbuka)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                15, 0, 15, 14,
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 13,
                  color: hijau
                      ? Colors.white
                      : Colors.black,
                  height: 1.35,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: isi,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _isiBiaya() {
    return const Text(
      'Rp 3.500 (tarif flat TransJakarta)',
      style: TextStyle(
        fontSize: 13,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _isiEstimasi() {
    return const Text(
      '±60-75 menit (tergantung kondisi lalu lintas\n'
      'dan waktu tunggu)',
      style: TextStyle(
        fontSize: 13,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _isiKeberangkatan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perkiraan keberangkatan dari Halte Duri Kepa:',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 3),

        const Text(
          'Pukul 18.00 WIB',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          'Bisa berubah tergantung kepadatan lalu lintas',
          style: TextStyle(
            color: Colors.red,
            fontSize: 10,
            fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 15),

        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: _bukaKeberangkatan,
            child: const Text(
              'Selengkapnya',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF21BDFF),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _isiKepadatan() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: TextStyle(fontStyle: FontStyle.italic),
            children: [
              TextSpan(text: 'Kepadatan di Halte SSSSS tergolong '),
              TextSpan(
                text: 'Rendah',
                style: TextStyle(color: Color(0xFF22B522)),
              ),
              TextSpan(text: '/'),
            ],
          ),
        ),

        SizedBox(height: 3),

        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Sedang',
                style: TextStyle(
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextSpan(
                text: '/Tinggi',
                style: TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _isiRute() {
    return const Text(
      'Dari Kedoya Selatan, naik mikrotrans atau ojek '
      'online menuju ke halte Kedoya Green Garden\n'
      '⋮\n'
      'Naik Koridor 8 TransJakarta menuju Halte Harmoni\n'
      '⋮\n'
      'Transit di Halte Harmoni, lalu naik ke Koridor 1 '
      'ke Halte Monas',
      style: TextStyle(fontSize: 13),
    );
  }

  Widget _isiKelebihanKekurangan() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kelebihan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text('• Biaya Terjangkau'),
        Text(
          '• Jalur khusus bus mengurangi risiko\n'
          '  terjebak macet',
        ),
        SizedBox(height: 8),
        Text(
          'Kekurangan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '• Perlu transit dan menunggu bus di setiap\n'
          '  halte',
        ),
        Text('• Kepadatan penumpang pada jam sibuk'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusPutih,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _HeaderHalaman(
                judul: 'Transportasi Umum',
                onBack: () => Navigator.pop(context),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const _GambarAset(
                            path: 'lib/images/image_32.png',
                            width: double.infinity,
                            height: 180,
                          ),

                          Positioned(
                            bottom: -14,
                            right: 16,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: _labelPutih('Rekomendasi'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Text(
                          'TRANSJAKARTA',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Column(
                          children: [
                            _accordion(
                              index: 0,
                              judul: 'Biaya',
                              isi: _isiBiaya(),
                            ),
                            _accordion(
                              index: 1,
                              judul: 'Estimasi',
                              isi: _isiEstimasi(),
                            ),
                            _accordion(
                              index: 2,
                              judul: 'Keberangkatan',
                              isi: _isiKeberangkatan(),
                            ),
                            _accordion(
                              index: 3,
                              judul: 'Informasi Kepadatan',
                              isi: _isiKepadatan(),
                            ),
                            _accordion(
                              index: 4,
                              judul: 'Rute yang dilalui',
                              isi: _isiRute(),
                            ),
                            _accordion(
                              index: 5,
                              judul: 'Kelebihan & Kekurangan',
                              isi: _isiKelebihanKekurangan(),
                              hijau: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 65),
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

// =======================================================
// HALAMAN KEBERANGKATAN
// =======================================================

class _KeberangkatanPage extends StatelessWidget {
  const _KeberangkatanPage();

  Widget _labelKuning(String label) {
    return Container(
      width: 65,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFAA00),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _kartuKeberangkatan({
    required bool pertama,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(15, 11, 15, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFB8D4CC),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Keberangkatan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        _labelKuning(
                          pertama ? 'Koridor' : 'Bus 2',
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            pertama
                                ? 'Ta → Kota'
                                : 'lorem ipsum → blablabla',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    pertama ? '11' : '23.23',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (pertama)
                    const Text(
                      'mnt',
                      style: TextStyle(fontSize: 10),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 7),

          Text(
            pertama ? 'Terlambat 11 mnt' : 'Dijadwalkan',
            style: TextStyle(
              fontSize: 12,
              color: pertama
                  ? Colors.red
                  : const Color(0xFF777777),
              fontWeight: pertama
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Bisa berubah tergantung kepadatan lalu lintas',
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusPutih.copyWith(
        systemNavigationBarColor: const Color(0xFFCDDDDA),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _HeaderHalaman(
                judul: 'Keberangkatan',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(color: _hijau),
                    ),
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: _GambarAset(
                        path: 'lib/images/Frame_30.png',
                        height: 339,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      top: 284,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(
                          16, 0, 16, 25,
                        ),
                        children: [
                          _kartuKeberangkatan(pertama: true),
                          for (int i = 0; i < 5; i++)
                            _kartuKeberangkatan(
                              pertama: false,
                            ),
                        ],
                      ),
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
