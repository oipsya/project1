
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'wisata_data.dart';

const Color warnaHijauECOWALK = Color(0xFF176B5B);

const SystemUiOverlayStyle statusBarECOWALK = SystemUiOverlayStyle(
  statusBarColor: Colors.white,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
  systemStatusBarContrastEnforced: false,
  systemNavigationBarContrastEnforced: false,
);

// =====================================================
// MODEL DAN PENYIMPANAN ULASAN SEMENTARA
// DIGUNAKAN BERSAMA DENGAN DETAIL_WISATA_PAGE.DART
// =====================================================

class DataUlasanPengguna {
  final String wisata;
  final String nama;
  final int rating;
  final String komentar;
  final DateTime tanggal;
  final List<String> fotoPaths;
  final bool sembunyikanNama;

  const DataUlasanPengguna({
    required this.wisata,
    required this.nama,
    required this.rating,
    required this.komentar,
    required this.tanggal,
    this.fotoPaths = const [],
    this.sembunyikanNama = false,
  });
}

class PenyimpananUlasan {
  static final ValueNotifier<List<DataUlasanPengguna>> daftar =
      ValueNotifier<List<DataUlasanPengguna>>([]);

  static void tambah(DataUlasanPengguna ulasan) {
    daftar.value = [ulasan, ...daftar.value];
  }

  static List<DataUlasanPengguna> untukWisata(String namaWisata) {
    return daftar.value
        .where((ulasan) => ulasan.wisata == namaWisata)
        .toList();
  }
}

// =====================================================
// HALAMAN BERI ULASAN
// =====================================================

class BeriUlasanPage extends StatefulWidget {
  final WisataItem item;

  const BeriUlasanPage({
    super.key,
    required this.item,
  });

  @override
  State<BeriUlasanPage> createState() => _BeriUlasanPageState();
}

class _BeriUlasanPageState extends State<BeriUlasanPage> {
  static const Color primaryColor = warnaHijauECOWALK;

  final TextEditingController _ulasanController =
      TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  int _rating = 0;
  bool _sembunyikanNama = false;
  bool _sedangMengirim = false;

  final List<XFile> _fotoDipilih = [];

  String get _ratingText {
    switch (_rating) {
      case 1:
        return 'Buruk';
      case 2:
        return 'Kurang';
      case 3:
        return 'Cukup';
      case 4:
        return 'Bagus';
      case 5:
        return 'Sangat Bagus';
      default:
        return 'Bagus';
    }
  }

  // ==================================
  // PILIH FOTO
  // ==================================

  Future<void> _pilihGambar() async {
    try {
      final hasil = await _imagePicker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (!mounted || hasil.isEmpty) return;

      setState(() {
        final sisa = 5 - _fotoDipilih.length;
        if (sisa > 0) {
          _fotoDipilih.addAll(hasil.take(sisa));
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memilih gambar'),
        ),
      );
    }
  }

  void _hapusGambar(int index) {
    setState(() {
      _fotoDipilih.removeAt(index);
    });
  }

  // ==================================
  // KIRIM ULASAN
  // ==================================

  void _kirimUlasan() {
    if (_sedangMengirim) return;

    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih rating bintang dahulu'),
        ),
      );
      return;
    }

    final komentar = _ulasanController.text.trim();

    if (komentar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan tulis ulasan terlebih dahulu'),
        ),
      );
      return;
    }

    setState(() {
      _sedangMengirim = true;
    });

    final ulasan = DataUlasanPengguna(
      wisata: widget.item.title,
      nama: _sembunyikanNama
          ? 'Pengguna Anonim'
          : 'Kaisyarani Zahra',
      rating: _rating,
      komentar: komentar,
      tanggal: DateTime.now(),
      fotoPaths: _fotoDipilih.map((foto) => foto.path).toList(),
      sembunyikanNama: _sembunyikanNama,
    );

    // SIMPAN AGAR MUNCUL DI DAFTAR NILAI & ULASAN
    PenyimpananUlasan.tambah(ulasan);

    // SETELAH KIRIM LANGSUNG TAMPILKAN HASIL
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DetailHasilUlasanPage(
          ulasan: ulasan,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ulasanController.dispose();
    super.dispose();
  }

  // ==================================
  // HEADER
  // ==================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 55,
      color: primaryColor,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 5),
          const Text(
            'Beri Ulasan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ==================================
  // FOTO WISATA
  // SHADOW DAN GAMBAR ASLI DIPERTAHANKAN
  // ==================================

  Widget _buildFotoWisata() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
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
                blurRadius: 9,
                spreadRadius: 0,
                offset: Offset(0, 5),
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
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 140,
                  color: const Color(0xFFE5E5E5),
                  alignment: Alignment.center,
                  child: const Text(
                    'Foto Wisata Dufan',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: -20,
          child: Container(
            width: 115,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: Text(
              widget.item.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================================
  // RATING BINTANG
  // ==================================

  Widget _buildRating() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...List.generate(5, (index) {
            final nilaiBintang = index + 1;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _rating = nilaiBintang;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  _rating >= nilaiBintang
                      ? Icons.star
                      : Icons.star_border,
                  size: 38,
                  color: _rating >= nilaiBintang
                      ? const Color(0xFFFFC107)
                      : Colors.black,
                ),
              ),
            );
          }),
          const SizedBox(width: 1),
          Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: Text(
              _ratingText,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF42B938),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================
  // INPUT ULASAN
  // ==================================

  Widget _buildInputUlasan() {
    return Container(
      width: double.infinity,
      height: 94,
      decoration: const BoxDecoration(
        color: Color(0xFFF4F4F4),
      ),
      child: TextField(
        controller: _ulasanController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black,
        ),
        decoration: const InputDecoration(
          hintText: 'Ketik disini...',
          hintStyle: TextStyle(
            fontSize: 11,
            fontStyle: FontStyle.italic,
            color: Color(0xFFB0B0B0),
          ),
          contentPadding: EdgeInsets.all(12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // ==================================
  // KOTAK TAMBAH FOTO
  // ==================================

  Widget _buildKotakTambahFoto() {
    return GestureDetector(
      onTap: _pilihGambar,
      child: CustomPaint(
        painter: _DashedBorderPainter(),
        child: const SizedBox(
          width: 62,
          height: 62,
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.black,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFotoDipilih(int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Image.file(
            File(_fotoDipilih[index].path),
            width: 62,
            height: 62,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 62,
                height: 62,
                color: const Color(0xFFD9D9D9),
              );
            },
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: () => _hapusGambar(index),
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================================
  // TAMBAHKAN GAMBAR
  // IMAGE.PNG TIDAK DIHAPUS
  // ==================================

  Widget _buildTambahGambar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tambahkan Gambar?',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 13),
        SizedBox(
          height: 72,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              if (_fotoDipilih.length < 5)
                _buildKotakTambahFoto(),

              const SizedBox(width: 12),

              // PREVIEW ASLI TETAP
              Image.asset(
                'lib/images/image.png',
                width: 62,
                height: 62,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 62,
                    height: 62,
                    color: const Color(0xFFE5E5E5),
                    alignment: Alignment.center,
                    child: const Text(
                      'Foto',
                      style: TextStyle(fontSize: 11),
                    ),
                  );
                },
              ),

              for (int i = 0; i < _fotoDipilih.length; i++) ...[
                const SizedBox(width: 12),
                _buildFotoDipilih(i),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ==================================
  // SEMBUNYIKAN NAMA
  // ==================================

  Widget _buildSembunyikanNama() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _sembunyikanNama = !_sembunyikanNama;
        });
      },
      child: Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: Checkbox(
              value: _sembunyikanNama,
              onChanged: (value) {
                setState(() {
                  _sembunyikanNama = value ?? false;
                });
              },
              activeColor: primaryColor,
              side: const BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Sembunyikan Nama Pengguna',
            style: TextStyle(
              fontSize: 11,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ==================================
  // TOMBOL KIRIM
  // ==================================

  Widget _buildTombolKirim() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: _sedangMengirim ? null : _kirimUlasan,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: const Text(
          'Kirim',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ==================================
  // HALAMAN BERI ULASAN
  // ==================================

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarECOWALK,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFotoWisata(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16, 32, 16, 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hai, Kaisyarani !',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'bagaimana perjalananmu?',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 13),
                            _buildRating(),
                            const SizedBox(height: 28),
                            _buildInputUlasan(),
                            const SizedBox(height: 24),
                            _buildTambahGambar(),
                            const SizedBox(height: 22),
                            _buildSembunyikanNama(),
                            const SizedBox(height: 24),
                            _buildTombolKirim(),
                          ],
                        ),
                      ),
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

// =====================================================
// HALAMAN DETAIL HASIL ULASAN
// MUNCUL KETIKA TOMBOL KIRIM DITEKAN
// =====================================================

class DetailHasilUlasanPage extends StatelessWidget {
  final DataUlasanPengguna ulasan;

  const DetailHasilUlasanPage({
    super.key,
    required this.ulasan,
  });

  String _formatTanggal(DateTime tanggal) {
    const bulan = [
      'Januari', 'Februari', 'Maret', 'April',
      'Mei', 'Juni', 'Juli', 'Agustus',
      'September', 'Oktober', 'November', 'Desember',
    ];

    return '${tanggal.day} '
        '${bulan[tanggal.month - 1]} ${tanggal.year}';
  }

  void _bukaFoto(BuildContext context, String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FotoHasilUlasanPage(
          fotoPath: path,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarECOWALK,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 55,
                width: double.infinity,
                color: warnaHijauECOWALK,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Nilai & Ulasan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      26, 20, 26, 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 29,
                              height: 29,
                              decoration: const BoxDecoration(
                                color: Color(0xFFD9D9D9),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Text(
                                ulasan.nama,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              height: 17,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: warnaHijauECOWALK,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                '${ulasan.rating}.0 / 5.0',
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 17),
                        Text(
                          ulasan.komentar,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 10,
                            height: 1.45,
                            color: Colors.black,
                          ),
                        ),

                        if (ulasan.fotoPaths.isNotEmpty) ...[
                          const SizedBox(height: 18),
                          Wrap(
                            spacing: 11,
                            runSpacing: 11,
                            children: [
                              for (final path in ulasan.fotoPaths)
                                GestureDetector(
                                  onTap: () => _bukaFoto(context, path),
                                  child: Image.file(
                                    File(path),
                                    width: 59,
                                    height: 59,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        width: 59,
                                        height: 59,
                                        color: const Color(0xFFD9D9D9),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 18),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Ditulis pada ${_formatTanggal(ulasan.tanggal)}',
                            style: const TextStyle(
                              fontSize: 8,
                              color: Color(0xFF777777),
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),
                        const Divider(
                          color: Color(0xFFE4E4E4),
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    ),
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

// =====================================================
// HALAMAN FOTO ULASAN
// =====================================================

class FotoHasilUlasanPage extends StatelessWidget {
  final String fotoPath;

  const FotoHasilUlasanPage({
    super.key,
    required this.fotoPath,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarECOWALK,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 55,
                color: warnaHijauECOWALK,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Foto Ulasan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: Image.file(
                      File(fotoPath),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image_outlined,
                          size: 60,
                          color: Colors.grey,
                        );
                      },
                    ),
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

// =====================================================
// GARIS PUTUS-PUTUS
// =====================================================

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const double dashWidth = 3;
    const double dashSpace = 3;

    for (
      double x = 0;
      x < size.width;
      x += dashWidth + dashSpace
    ) {
      final endX = (x + dashWidth).clamp(0.0, size.width);
      canvas.drawLine(
        Offset(x, 0),
        Offset(endX, 0),
        paint,
      );
      canvas.drawLine(
        Offset(x, size.height),
        Offset(endX, size.height),
        paint,
      );
    }

    for (
      double y = 0;
      y < size.height;
      y += dashWidth + dashSpace
    ) {
      final endY = (y + dashWidth).clamp(0.0, size.height);
      canvas.drawLine(
        Offset(0, y),
        Offset(0, endY),
        paint,
      );
      canvas.drawLine(
        Offset(size.width, y),
        Offset(size.width, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
