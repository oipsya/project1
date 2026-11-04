
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'wisata_data.dart';
import 'beri_ulasan_page.dart';

// =====================================================
// DETAIL WISATA
// =====================================================

class DetailWisataPage extends StatefulWidget {
  final WisataItem item;

  const DetailWisataPage({
    super.key,
    required this.item,
  });

  @override
  State<DetailWisataPage> createState() =>
      _DetailWisataPageState();
}

class _DetailWisataPageState extends State<DetailWisataPage> {
  static const Color primaryColor = Color(0xFF176B5B);
  static const Color secondaryGreen = Color(0xFF4D8D7C);

  bool _isFavorite = false;

  void _bukaBeriUlasan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BeriUlasanPage(
          item: widget.item,
        ),
      ),
    );
  }

  // PERBAIKAN UTAMA
  void _bukaNilaiUlasan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NilaiUlasanPage(
          item: widget.item,
        ),
      ),
    );
  }

  void _ubahFavorit() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? 'Wisata ditambahkan ke favorit'
              : 'Wisata dihapus dari favorit',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
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
              size: 23,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              widget.item.title,
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

  // ==================================
  // FOTO UTAMA
  // ==================================

  Widget _buildFotoUtama() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 393 / 302,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'lib/images/dufan_detail.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFE6E6E6),
                      alignment: Alignment.center,
                      child: const Text(
                        'Foto Dunia Fantasi (DUFAN)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  },
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 100,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x00FFFFFF),
                          Color(0xAAFFFFFF),
                          Color(0xF5FFFFFF),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 13,
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 11),
            decoration: BoxDecoration(
              color: secondaryGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Color(0xFFFFCC21),
                  size: 16,
                ),
                const SizedBox(width: 7),
                Text(
                  widget.item.rating.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================================
  // JUDUL WISATA
  // ==================================

  Widget _buildJudulWisata() {
    return SizedBox(
      height: 39,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 63,
            top: 1,
            child: Text(
              widget.item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                height: 1.1,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: -17,
            child: GestureDetector(
              onTap: _ubahFavorit,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: secondaryGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJamOperasional() {
    return Row(
      children: [
        const Icon(
          Icons.access_time,
          color: Colors.black,
          size: 19,
        ),
        const SizedBox(width: 5),
        const Text(
          'Open',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF19C923),
            fontWeight: FontWeight.w700,
          ),
        ),
        Flexible(
          child: Text(
            ' | ${widget.item.openHours}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlamat() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.map_outlined,
          size: 20,
          color: Colors.black,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            widget.item.fullAddress,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeskripsi() {
    return Text(
      widget.item.description,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        fontSize: 13,
        color: Colors.black,
        height: 1.23,
      ),
    );
  }

  Widget _buildHargaTiket() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Harga Tiket Mulai Dari',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            widget.item.priceText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'Harga tergantung hari dan dapat berubah sewaktu-waktu',
          style: TextStyle(
            fontSize: 7,
            fontStyle: FontStyle.italic,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // ==================================
  // NILAI & ULASAN
  // ==================================

  Widget _buildJudulUlasan() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Nilai & Ulasan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
        InkWell(
          // SEKARANG MENUJU DAFTAR NILAI & ULASAN
          onTap: _bukaNilaiUlasan,
          child: const Row(
            children: [
              Text(
                'Lihat Semua',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRingkasanRating() {
    final jumlah = widget.item.reviewsCount
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );

    return Row(
      children: [
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.star,
                color: Color(0xFFFFCC21),
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                widget.item.rating.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rekomendasi Istimewa',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 1),
            Text(
              '$jumlah Ulasan',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  // ==================================
  // GAMBAR ULASAN ASLI TETAP
  // ==================================

  Widget _buildKartuUlasan() {
    return GestureDetector(
      // GAMBAR JUGA MENUJU DAFTAR ULASAN
      onTap: _bukaNilaiUlasan,
      child: SizedBox(
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: 357 / 116,
          child: Image.asset(
            'lib/images/Frame_21.png',
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: const Color(0xFFE9E9E9),
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Kartu Ulasan - Frame_21.png',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ==================================
  // PETA
  // ==================================

  Widget _buildPeta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lihat Peta',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          widget.item.distanceText,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: double.infinity,
            height: 152,
            child: Image.asset(
              'lib/images/map_dufan.png',
              width: double.infinity,
              height: 152,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFE6E6E6),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 33,
                        color: primaryColor,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'map_dufan.png',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // ==================================
  // HALAMAN DETAIL WISATA
  // ==================================

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarECOWALK,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ColoredBox(
                  color: primaryColor,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -2),
                          child: _buildFotoUtama(),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -2),
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.fromLTRB(
                              16, 0, 16, 0,
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _buildJudulWisata(),
                                const SizedBox(height: 0),
                                _buildJamOperasional(),
                                const SizedBox(height: 6),
                                _buildAlamat(),
                                const SizedBox(height: 13),
                                _buildDeskripsi(),
                                const SizedBox(height: 17),
                                _buildHargaTiket(),
                                const SizedBox(height: 25),
                                _buildJudulUlasan(),
                                const SizedBox(height: 8),
                                _buildRingkasanRating(),
                                const SizedBox(height: 10),
                                _buildKartuUlasan(),
                                const SizedBox(height: 22),
                                _buildPeta(),
                                const SizedBox(height: 45),
                              ],
                            ),
                          ),
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
// HALAMAN DAFTAR NILAI & ULASAN
// TETAP DALAM DETAIL_WISATA_PAGE.DART
// =====================================================

class NilaiUlasanPage extends StatefulWidget {
  final WisataItem item;

  const NilaiUlasanPage({
    super.key,
    required this.item,
  });

  @override
  State<NilaiUlasanPage> createState() => _NilaiUlasanPageState();
}

class _NilaiUlasanPageState extends State<NilaiUlasanPage> {
  static const Color primaryColor = Color(0xFF176B5B);
  static const Color biru = Color(0xFF2295DC);
  static const Color kuning = Color(0xFFFFC800);

  bool _hanyaFoto = false;
  int? _filterBintang;
  final Set<int> _komentarTerbuka = {};

  final List<_UlasanContoh> _ulasanContoh = const [
    _UlasanContoh(
      nama: 'Kaisyarani Zahra',
      rating: 5,
      komentar:
          'pokoknya sangat bagus makcik pokoknya sangat bagus '
          'makcik pokoknya sangat bagus makcik pokoknya '
          'sangat bagus makcik pokoknya sangat bagus makcik '
          'pokoknya sangat bagus makcik',
      tanggal: '24 Februari 2026',
    ),
    _UlasanContoh(
      nama: 'Kaisyarani Zahra',
      rating: 5,
      komentar:
          'pokoknya sangat bagus makcik pokoknya sangat bagus '
          'makcik pokoknya sangat bagus makcik pokoknya '
          'sangat bagus makcik pokoknya sangat bagus makcik',
      tanggal: '24 Februari 2026',
      adaFoto: true,
    ),
    _UlasanContoh(
      nama: 'Kaisyarani Zahra',
      rating: 5,
      komentar:
          'pokoknya sangat bagus makcik pokoknya sangat bagus '
          'makcik pokoknya sangat bagus makcik pokoknya '
          'sangat bagus makcik',
      tanggal: '24 Februari 2026',
    ),
    _UlasanContoh(
      nama: 'Kaisyarani Zahra',
      rating: 5,
      komentar:
          'pokoknya sangat bagus makcik pokoknya sangat bagus '
          'makcik pokoknya sangat bagus makcik pokoknya '
          'sangat bagus makcik',
      tanggal: '24 Februari 2026',
    ),
    _UlasanContoh(
      nama: 'Kaisyarani Zahra',
      rating: 4,
      komentar:
          'Tempat wisata sangat menyenangkan dan '
          'banyak wahana yang menarik.',
      tanggal: '24 Februari 2026',
      adaFoto: true,
    ),
  ];

  String get _jumlahUlasan {
    return widget.item.reviewsCount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }

  void _bukaDetailContoh(_UlasanContoh data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _DetailUlasanContohPage(
          data: data,
        ),
      ),
    );
  }

  void _bukaDetailPengguna(DataUlasanPengguna data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailHasilUlasanPage(
          ulasan: data,
        ),
      ),
    );
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
              size: 23,
            ),
          ),
          const SizedBox(width: 3),
          const Text(
            'Nilai & Ulasan',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ==================================
  // RINGKASAN RATING
  // ==================================

  Widget _buildRingkasanRating() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 19, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.item.rating.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) {
                            IconData ikon = Icons.star_border;
                            final nilai = widget.item.rating;

                            if (nilai >= index + 1) {
                              ikon = Icons.star;
                            } else if (nilai >= index + 0.5) {
                              ikon = Icons.star_half;
                            }

                            return Icon(
                              ikon,
                              size: 21,
                              color: kuning,
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '$_jumlahUlasan Ulasan',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Image.asset(
              'lib/images/ecowalkijo.png',
              width: 70,
              height: 23,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'ECOWALK',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==================================
  // FILTER
  // ==================================

  Widget _tombolFilter(
    String teks,
    VoidCallback onTap, {
    bool aktif = false,
    bool panah = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: aktif
              ? const Color(0xFF12594B)
              : primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              teks,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),
            if (panah) ...[
              const SizedBox(width: 5),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pilihFilterBintang() async {
    final pilihan = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Bintang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ListTile(
                title: const Text('Semua Bintang'),
                onTap: () => Navigator.pop(context, 0),
              ),
              for (int i = 5; i >= 1; i--)
                ListTile(
                  title: Text('$i Bintang'),
                  onTap: () => Navigator.pop(context, i),
                ),
            ],
          ),
        );
      },
    );

    if (!mounted || pilihan == null) return;

    setState(() {
      _filterBintang = pilihan == 0 ? null : pilihan;
    });
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 21, 16, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _tombolFilter(
              'Semua',
              () {
                setState(() {
                  _hanyaFoto = false;
                  _filterBintang = null;
                });
              },
              aktif: !_hanyaFoto && _filterBintang == null,
            ),
            const SizedBox(width: 12),
            _tombolFilter(
              'Dengan Foto',
              () {
                setState(() {
                  _hanyaFoto = !_hanyaFoto;
                });
              },
              aktif: _hanyaFoto,
            ),
            const SizedBox(width: 12),
            _tombolFilter(
              _filterBintang == null
                  ? 'Bintang'
                  : '$_filterBintang Bintang',
              _pilihFilterBintang,
              aktif: _filterBintang != null,
              panah: true,
            ),
          ],
        ),
      ),
    );
  }

  // ==================================
  // FOTO PLACEHOLDER CONTOH
  // ==================================

  Widget _fotoContoh() {
    return Container(
      width: 59,
      height: 59,
      color: const Color(0xFFD9D9D9),
    );
  }

  // ==================================
  // KARTU ULASAN CONTOH
  // ==================================

  Widget _buildKartuContoh(int index, _UlasanContoh ulasan) {
    final terbuka = _komentarTerbuka.contains(index);

    return GestureDetector(
      onTap: () => _bukaDetailContoh(ulasan),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 17),
        padding: const EdgeInsets.fromLTRB(13, 13, 13, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: const Color(0xFFECECEC),
            width: 0.6,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              offset: Offset(0, 3),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _barisNamaRating(
              ulasan.nama,
              ulasan.rating,
            ),
            const SizedBox(height: 13),
            Text(
              ulasan.komentar,
              maxLines: terbuka ? null : 4,
              overflow: terbuka
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 10,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 7),
            InkWell(
              onTap: () {
                setState(() {
                  if (terbuka) {
                    _komentarTerbuka.remove(index);
                  } else {
                    _komentarTerbuka.add(index);
                  }
                });
              },
              child: Text(
                terbuka ? 'Lebih Sedikit' : 'Selengkapnya',
                style: const TextStyle(
                  fontSize: 10,
                  color: biru,
                ),
              ),
            ),
            if (ulasan.adaFoto) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  _fotoContoh(),
                  const SizedBox(width: 11),
                  _fotoContoh(),
                ],
              ),
            ],
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Ditulis pada ${ulasan.tanggal}',
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================
  // KARTU HASIL ULASAN PENGGUNA
  // ==================================

  Widget _buildKartuPengguna(DataUlasanPengguna ulasan) {
    return GestureDetector(
      onTap: () => _bukaDetailPengguna(ulasan),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 17),
        padding: const EdgeInsets.fromLTRB(13, 13, 13, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: const Color(0xFFECECEC),
            width: 0.6,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              offset: Offset(0, 3),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _barisNamaRating(
              ulasan.nama,
              ulasan.rating,
            ),
            const SizedBox(height: 13),
            Text(
              ulasan.komentar,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 10,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Selengkapnya',
              style: TextStyle(
                fontSize: 10,
                color: biru,
              ),
            ),
            if (ulasan.fotoPaths.isNotEmpty) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: 59,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ulasan.fotoPaths.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 11);
                  },
                  itemBuilder: (context, index) {
                    return Image.file(
                      File(ulasan.fotoPaths[index]),
                      width: 59,
                      height: 59,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _fotoContoh();
                      },
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Ditulis pada ${ulasan.tanggal.day}/'
                '${ulasan.tanggal.month}/${ulasan.tanggal.year}',
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barisNamaRating(String nama, int rating) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Color(0xFFD8D8D8),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            nama,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          height: 17,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            '$rating.0 / 5.0',
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // ==================================
  // DAFTAR ULASAN
  // ==================================

  Widget _buildDaftarUlasan() {
    return ValueListenableBuilder<List<DataUlasanPengguna>>(
      valueListenable: PenyimpananUlasan.daftar,
      builder: (context, semuaUlasan, child) {
        final kiriman = semuaUlasan.where((ulasan) {
          if (ulasan.wisata != widget.item.title) return false;
          if (_hanyaFoto && ulasan.fotoPaths.isEmpty) return false;
          if (_filterBintang != null &&
              ulasan.rating != _filterBintang) {
            return false;
          }
          return true;
        }).toList();

        final contoh = <int>[];

        for (int i = 0; i < _ulasanContoh.length; i++) {
          final ulasan = _ulasanContoh[i];

          if (_hanyaFoto && !ulasan.adaFoto) continue;
          if (_filterBintang != null &&
              ulasan.rating != _filterBintang) {
            continue;
          }

          contoh.add(i);
        }

        if (kiriman.isEmpty && contoh.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 45),
            child: Center(
              child: Text(
                'Belum ada ulasan untuk filter ini',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // ULASAN BARU MUNCUL PALING ATAS
              for (final ulasan in kiriman)
                _buildKartuPengguna(ulasan),

              // DI BAWAHNYA DATA CONTOH FIGMA
              for (final index in contoh)
                _buildKartuContoh(
                  index,
                  _ulasanContoh[index],
                ),
            ],
          ),
        );
      },
    );
  }

  // ==================================
  // HALAMAN NILAI & ULASAN
  // ==================================

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarECOWALK,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRingkasanRating(),
                      _buildFilterBar(),
                      const SizedBox(height: 33),
                      _buildDaftarUlasan(),
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

// =====================================================
// MODEL DATA CONTOH
// =====================================================

class _UlasanContoh {
  final String nama;
  final int rating;
  final String komentar;
  final String tanggal;
  final bool adaFoto;

  const _UlasanContoh({
    required this.nama,
    required this.rating,
    required this.komentar,
    required this.tanggal,
    this.adaFoto = false,
  });
}

// =====================================================
// DETAIL SATU ULASAN CONTOH
// =====================================================

class _DetailUlasanContohPage extends StatelessWidget {
  final _UlasanContoh data;

  const _DetailUlasanContohPage({
    required this.data,
  });

  static const Color primaryColor = Color(0xFF176B5B);

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
                        size: 23,
                      ),
                    ),
                    const Text(
                      'Nilai & Ulasan',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
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
                                data.nama,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                '${data.rating}.0 / 5.0',
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 17),
                        Text(
                          data.komentar,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 10,
                            height: 1.45,
                          ),
                        ),
                        if (data.adaFoto) ...[
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Container(
                                width: 59,
                                height: 59,
                                color: const Color(0xFFD9D9D9),
                              ),
                              const SizedBox(width: 11),
                              Container(
                                width: 59,
                                height: 59,
                                color: const Color(0xFFD9D9D9),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 18),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Ditulis pada ${data.tanggal}',
                            style: const TextStyle(
                              fontSize: 8,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),
                        const Divider(
                          color: Color(0xFFE4E4E4),
                          thickness: 1,
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
