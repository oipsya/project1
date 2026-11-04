
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'detail_wisata_page.dart';
import 'wisata_data.dart';

class KategoriPage extends StatefulWidget {
  final String initialCategory;

  const KategoriPage({
    super.key,
    this.initialCategory = 'Semua',
  });

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  static const Color primaryColor = Color(0xFF176B5B);
  static const Color dividerColor = Color(0xFFE5E5E5);
  static const Color circleColor = Color(0xFFD9D9D9);

  final TextEditingController _searchController =
      TextEditingController();

  String _kategoriDipilih = 'Semua';

  bool _urutkanRating = false;
  bool _urutkanNama = false;

  bool _tampilkanUrutkan = false;
  bool _tampilkanFilter = false;

  String? _pilihanUrutkan;

  final List<String> _daftarUrutan = [
    'Direkomendasikan',
    'Harga Tertinggi',
    'Harga Terendah',
    'Ulasan Terbaik',
    'Jarak Terdekat',
  ];

  // ==================================
  // STATE FILTER
  // ==================================

  double _jarakDipilih = 500;

  String? _rentangJarakDipilih;
  String? _hargaDipilih;
  String? _lokasiDipilih;
  String? _zonaDipilih;

  final List<String> _lokasiPopuler = [
    'Blok M',
    'Gelora Bung Karno',
    'Senayan',
    'Citra Delapan',
  ];

  // ==================================
  // DATA 7 BARIS DUFAN
  // ==================================

  List<WisataItem> get _tujuhWisata {
    final WisataItem dufan = daftarWisata.first;

    return List<WisataItem>.generate(
      7,
      (index) => dufan,
    );
  }

  @override
  void initState() {
    super.initState();

    _kategoriDipilih =
        kategoriWisata.contains(widget.initialCategory)
            ? widget.initialCategory
            : 'Semua';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ==================================
  // DATA WISATA DAN PENCARIAN
  // ==================================

  List<WisataItem> get _hasilWisata {
    List<WisataItem> hasil = _tujuhWisata;

    if (_kategoriDipilih != 'Semua') {
      hasil = hasil.where((item) {
        return item.category.toLowerCase() ==
            _kategoriDipilih.toLowerCase();
      }).toList();
    }

    final String query =
        _searchController.text.trim().toLowerCase();

    if (query.isNotEmpty) {
      hasil = hasil.where((item) {
        return item.title.toLowerCase().contains(query) ||
            item.location.toLowerCase().contains(query);
      }).toList();
    }

    if (_urutkanRating && _pilihanUrutkan == null) {
      hasil.sort(
        (a, b) => b.rating.compareTo(a.rating),
      );
    }

    if (_urutkanNama && _pilihanUrutkan == null) {
      hasil.sort(
        (a, b) => a.title.compareTo(b.title),
      );
    }

    switch (_pilihanUrutkan) {
      case 'Direkomendasikan':
        hasil.sort(
          (a, b) => b.rating.compareTo(a.rating),
        );
        break;

      case 'Harga Tertinggi':
        hasil.sort(
          (a, b) => _hargaAngka(b.priceText)
              .compareTo(_hargaAngka(a.priceText)),
        );
        break;

      case 'Harga Terendah':
        hasil.sort(
          (a, b) => _hargaAngka(a.priceText)
              .compareTo(_hargaAngka(b.priceText)),
        );
        break;

      case 'Ulasan Terbaik':
        hasil.sort((a, b) {
          final rating = b.rating.compareTo(a.rating);

          return rating != 0
              ? rating
              : b.reviewsCount.compareTo(a.reviewsCount);
        });
        break;

      case 'Jarak Terdekat':
        hasil.sort(
          (a, b) => _jarakAngka(a.distanceText)
              .compareTo(_jarakAngka(b.distanceText)),
        );
        break;
    }

    if (_hargaDipilih != null) {
      if (_hargaDipilih == 'Gratis') {
        hasil = hasil.where((item) {
          return item.priceText
              .toLowerCase()
              .contains('gratis');
        }).toList();
      } else {
        final batasHarga = switch (_hargaDipilih) {
          '< Rp 50.000,00' => 50000,
          '< Rp 100.000,00' => 100000,
          '< Rp 300.000,00' => 300000,
          _ => 999999999,
        };

        hasil = hasil.where((item) {
          return _hargaAngka(item.priceText) < batasHarga;
        }).toList();
      }
    }

    if (_rentangJarakDipilih != null &&
        _rentangJarakDipilih != 'Terjauh') {
      hasil = hasil.where((item) {
        return _jarakAngka(item.distanceText) <=
            _jarakDipilih / 1000;
      }).toList();
    }

    if (_lokasiDipilih != null) {
      hasil = hasil.where((item) {
        return item.location.toLowerCase().contains(
              _lokasiDipilih!.toLowerCase(),
            ) ||
            item.fullAddress.toLowerCase().contains(
              _lokasiDipilih!.toLowerCase(),
            );
      }).toList();
    }

    return hasil;
  }

  int _hargaAngka(String harga) {
    final match = RegExp(
      r'Rp\.?\s*([\d.,]+)',
    ).firstMatch(harga);

    if (match == null) return 0;

    final angka = match
        .group(1)!
        .replaceAll(RegExp(r'[^\d]'), '');

    return int.tryParse(angka) ?? 0;
  }

  double _jarakAngka(String jarak) {
    final match = RegExp(
      r'[\d.,]+',
    ).firstMatch(jarak);

    if (match == null) return double.infinity;

    return double.tryParse(
          match.group(0)!.replaceAll(',', '.'),
        ) ??
        double.infinity;
  }

  // ==================================
  // NAVIGASI DETAIL WISATA
  // ==================================

  void _bukaDetail(WisataItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetailWisataPage(item: item),
      ),
    );
  }

  // ==================================
  // BUKA / TUTUP PANEL
  // ==================================

  void _bukaPanelUrutkan() {
    FocusScope.of(context).unfocus();

    setState(() {
      _tampilkanUrutkan = true;
      _tampilkanFilter = false;
    });
  }

  void _tutupPanelUrutkan() {
    setState(() {
      _tampilkanUrutkan = false;
    });
  }

  void _pilihUrutan(String pilihan) {
    setState(() {
      _pilihanUrutkan = pilihan;
      _urutkanRating = false;
      _urutkanNama = false;
      _tampilkanUrutkan = false;
    });
  }

  void _bukaPanelFilter() {
    FocusScope.of(context).unfocus();

    setState(() {
      _tampilkanFilter = true;
      _tampilkanUrutkan = false;
    });
  }

  void _tutupPanelFilter() {
    setState(() {
      _tampilkanFilter = false;
    });
  }

  void _resetFilter() {
    setState(() {
      _jarakDipilih = 500;
      _rentangJarakDipilih = null;
      _hargaDipilih = null;
      _lokasiDipilih = null;
      _zonaDipilih = null;
    });
  }

  // ==================================
  // HEADER HIJAU
  // ==================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 55,
      color: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 10),
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

          const SizedBox(width: 2),

          const Text(
            'Kategori',
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
  // KOLOM PENCARIAN
  // ==================================

  Widget _buildSearch() {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFDADADA),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() {}),
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black,
        ),
        decoration: const InputDecoration(
          hintText: 'Cari destinasi wisata',
          hintStyle: TextStyle(
            fontSize: 11,
            fontStyle: FontStyle.italic,
            color: Color(0xFF555555),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 19,
            color: primaryColor,
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 37,
            minHeight: 36,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 9),
        ),
      ),
    );
  }

  // ==================================
  // IKON FILTER DAN URUTKAN
  // ==================================

  Widget _buildIkonFilter() {
    return const CustomPaint(
      size: Size(27, 27),
      painter: _FilterIconPainter(
        color: primaryColor,
      ),
    );
  }

  Widget _buildIkonUrutkan() {
    return const CustomPaint(
      size: Size(27, 27),
      painter: _SortIconPainter(
        color: primaryColor,
      ),
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: _bukaPanelFilter,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 43,
        height: 43,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: _buildIkonFilter(),
            ),
            const SizedBox(height: 1),
            const Text(
              'Filter',
              style: TextStyle(
                fontSize: 9,
                height: 1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrutkanButton() {
    return InkWell(
      onTap: _bukaPanelUrutkan,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 47,
        height: 43,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: _buildIkonUrutkan(),
            ),
            const SizedBox(height: 1),
            const Text(
              'Urutkan',
              style: TextStyle(
                fontSize: 9,
                height: 1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        12,
        0,
      ),
      child: Row(
        children: [
          Expanded(child: _buildSearch()),
          const SizedBox(width: 13),
          _buildFilterButton(),
          const SizedBox(width: 5),
          _buildUrutkanButton(),
        ],
      ),
    );
  }

  // ==================================
  // TAB KATEGORI
  // ==================================

  Widget _buildKategoriTabs() {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: kategoriWisata.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 24);
        },
        itemBuilder: (context, index) {
          final kategori = kategoriWisata[index];
          final bool aktif =
              kategori == _kategoriDipilih;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _kategoriDipilih = kategori;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  kategori,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: aktif
                        ? FontWeight.w500
                        : FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 9),
                Container(
                  width: aktif ? 44 : 0,
                  height: 2,
                  color: aktif
                      ? primaryColor
                      : Colors.transparent,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==================================
  // LINGKARAN ABU-ABU
  // ==================================

  Widget _buildLingkaran() {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle,
      ),
    );
  }

  // ==================================
  // BARIS WISATA
  // ==================================

  Widget _buildWisataItem(WisataItem item) {
    return InkWell(
      onTap: () => _bukaDetail(item),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 86,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: dividerColor,
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildLingkaran(),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: Color(0xFFFFC400),
                      ),

                      const SizedBox(width: 2),

                      Flexible(
                        child: Text(
                          '${item.rating.toStringAsFixed(2)} | Open ${item.openHours}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
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
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 1),

                  Text(
                    item.priceText.startsWith('Mulai')
                        ? item.priceText
                        : 'Mulai dari ${item.priceText}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 9),

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

  // ==================================
  // DAFTAR WISATA
  // ==================================

  Widget _buildDaftarWisata() {
    final List<WisataItem> hasil = _hasilWisata;

    if (hasil.isEmpty) {
      return const Center(
        child: Text(
          'Destinasi wisata tidak ditemukan',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: hasil.length,
      itemBuilder: (context, index) {
        return _buildWisataItem(hasil[index]);
      },
    );
  }

  // ==================================
  // PANEL URUTKAN
  // TETAP SEPERTI SEBELUMNYA
  // ==================================

  Widget _buildPanelUrutkan() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),

          Container(
            width: 98,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFFDADADA),
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 39,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Urutkan',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _tutupPanelUrutkan,
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        Icons.close,
                        size: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(
            color: Color(0xFFD3D3D3),
            height: 1,
            thickness: 1,
          ),

          ..._daftarUrutan.map((pilihan) {
            final bool dipilih =
                _pilihanUrutkan == pilihan;

            return InkWell(
              onTap: () => _pilihUrutan(pilihan),
              child: SizedBox(
                height: 44,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          pilihan,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryColor,
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: dipilih
                            ? Container(
                                width: 11,
                                height: 11,
                                decoration:
                                    const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 7),
        ],
      ),
    );
  }

  // ==================================
  // FILTER: TOMBOL RENTANG JARAK
  // ==================================

  Widget _chipJarak(String text) {
    final bool aktif =
        _rentangJarakDipilih == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          _rentangJarakDipilih = text;

          if (text == '500 M') {
            _jarakDipilih = 500;
          } else if (text == 'Terdekat') {
            _jarakDipilih = 1000;
          } else {
            _jarakDipilih = 10000;
          }
        });
      },
      child: Container(
        height: 23,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: aktif
              ? const Color(0xFF125A4E)
              : primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            height: 1,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ==================================
  // FILTER: RENTANG JARAK
  // ==================================

  Widget _buildRentangJarak() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        20,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Rentang Jarak',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              SizedBox(
                width: 78,
                child: _chipJarak('500 M'),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 78,
                child: _chipJarak('Terdekat'),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 78,
                child: _chipJarak('Terjauh'),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // SLIDER TIPIS SEPERTI FIGMA
          SizedBox(
            height: 15,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                activeTrackColor: primaryColor,
                inactiveTrackColor:
                    const Color(0xFFBBBBBB),
                thumbColor: primaryColor,
                overlayColor:
                    primaryColor.withValues(alpha: 0.10),
                thumbShape:
                    const RoundSliderThumbShape(
                  enabledThumbRadius: 5.5,
                ),
                overlayShape:
                    const RoundSliderOverlayShape(
                  overlayRadius: 12,
                ),
              ),
              child: Slider(
                value: _jarakDipilih,
                min: 0,
                max: 10000,
                onChanged: (value) {
                  setState(() {
                    _jarakDipilih = value;
                    _rentangJarakDipilih = 'Custom';
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 1),

          const Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Terdekat',
                style: TextStyle(
                  fontSize: 7,
                  color: Colors.black,
                ),
              ),
              Text(
                'Terjauh',
                style: TextStyle(
                  fontSize: 7,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================================
  // FILTER: KOTAK MINIMAL DAN MAKSIMAL
  // ==================================

  Widget _kotakHarga(
    String label,
    String nominal,
  ) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              height: 1,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 2),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              nominal,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 14,
                height: 1,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================
  // FILTER: PILIHAN HARGA
  // ==================================

  Widget _pilihanHarga(String harga) {
    final bool aktif =
        _hargaDipilih == harga;

    return GestureDetector(
      onTap: () {
        setState(() {
          _hargaDipilih =
              aktif ? null : harga;
        });
      },
      child: Container(
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: aktif
              ? const Color(0xFFE1F0EB)
              : Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Text(
          harga,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 11,
            height: 1,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // ==================================
  // FILTER: RENTANG HARGA
  // ==================================

  Widget _buildRentangHarga() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        20,
        16,
        24,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Rentang Harga',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: _kotakHarga(
                  'Minimal',
                  'Rp 100.000,00',
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _kotakHarga(
                  'Maksimal',
                  'Rp 99.999.999,00',
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _pilihanHarga(
                  '< Rp 50.000,00',
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _pilihanHarga(
                  '< Rp 100.000,00',
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _pilihanHarga(
                  '< Rp 300.000,00',
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _pilihanHarga('Gratis'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================================
  // FILTER: LOKASI POPULER
  // ==================================

  Widget _buildLokasiPopuler() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        27,
        16,
        0,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Lokasi Populer',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          ..._lokasiPopuler.map((lokasi) {
            final bool aktif =
                _lokasiDipilih == lokasi;

            return InkWell(
              onTap: () {
                setState(() {
                  _lokasiDipilih =
                      aktif ? null : lokasi;
                });
              },
              child: SizedBox(
                height: 28,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        lokasi,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor,
                          width: 1,
                        ),
                      ),
                      alignment:
                          Alignment.center,
                      child: aktif
                          ? Container(
                              width: 8,
                              height: 8,
                              decoration:
                                  const BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ==================================
  // FILTER: GAMBAR ZONA
  // ==================================

  Widget _zonaCard({
    required String label,
    required String assetPath,
  }) {
    final bool aktif =
        _zonaDipilih == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _zonaDipilih =
              aktif ? null : label;
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          assetPath,
          width: 68,
          height: 68,
          fit: BoxFit.cover,
          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return SizedBox(
              width: 68,
              height: 68,
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildZona() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        25,
        16,
        20,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Zona',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _zonaCard(
                label: 'Dalam Ruangan',
                assetPath:
                    'lib/images/Component_27.png',
              ),

              const SizedBox(width: 15),

              _zonaCard(
                label: 'Luar Ruangan',
                assetPath:
                    'lib/images/Component_25.png',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================================
  // PANEL FILTER SESUAI DESAIN
  // ==================================

  Widget _buildPanelFilter() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // PEGANGAN PANEL
              const SizedBox(height: 18),

              Center(
                child: Container(
                  width: 98,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDADADA),
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // HEADER FILTER
              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: _resetFilter,
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF168DE5),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    GestureDetector(
                      onTap: _tutupPanelFilter,
                      child: const Icon(
                        Icons.close,
                        size: 21,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // JARAK DARI HEADER KE KONTEN
              const SizedBox(height: 30),

              // ISI FILTER BISA DI-SCROLL
              Expanded(
                child: SingleChildScrollView(
                  physics:
                      const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // RENTANG JARAK
                      _buildRentangJarak(),

                      const Divider(
                        color: dividerColor,
                        thickness: 1,
                        height: 1,
                      ),

                      // RENTANG HARGA
                      _buildRentangHarga(),

                      const Divider(
                        color: dividerColor,
                        thickness: 1,
                        height: 1,
                      ),

                      // LOKASI POPULER
                      _buildLokasiPopuler(),

                      // ZONA
                      _buildZona(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================================
  // HALAMAN UTAMA KATEGORI
  // ==================================

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness:
            Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness:
            Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),

              Expanded(
                child: Stack(
                  children: [
                    // HALAMAN KATEGORI ASLI
                    Column(
                      children: [
                        _buildToolbar(),

                        const SizedBox(height: 17),

                        _buildKategoriTabs(),

                        const Divider(
                          color: dividerColor,
                          thickness: 1,
                          height: 1,
                        ),

                        Expanded(
                          child: _buildDaftarWisata(),
                        ),
                      ],
                    ),

                    // LATAR BELAKANG PANEL
                    if (_tampilkanUrutkan ||
                        _tampilkanFilter)
                      Positioned.fill(
                        child: GestureDetector(
                          behavior:
                              HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              _tampilkanUrutkan = false;
                              _tampilkanFilter = false;
                            });
                          },
                          child: Container(
                            color: Colors.black.withValues(
                              alpha: 0.20,
                            ),
                          ),
                        ),
                      ),

                    // PANEL URUTKAN TETAP
                    if (_tampilkanUrutkan)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: _buildPanelUrutkan(),
                      ),

                    // PANEL FILTER
                    if (_tampilkanFilter)
                      Positioned.fill(
                        top: 16,
                        child: _buildPanelFilter(),
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

// ==================================
// CUSTOM PAINTER IKON FILTER
// ==================================

class _FilterIconPainter extends CustomPainter {
  final Color color;

  const _FilterIconPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double w = size.width;
    final double h = size.height;

    canvas.drawLine(
      Offset(w * 0.08, h * 0.20),
      Offset(w * 0.92, h * 0.20),
      paint,
    );

    canvas.drawLine(
      Offset(w * 0.08, h * 0.50),
      Offset(w * 0.92, h * 0.50),
      paint,
    );

    canvas.drawLine(
      Offset(w * 0.08, h * 0.80),
      Offset(w * 0.92, h * 0.80),
      paint,
    );

    canvas.drawCircle(
      Offset(w * 0.65, h * 0.20),
      3.2,
      paint,
    );

    canvas.drawCircle(
      Offset(w * 0.30, h * 0.50),
      3.2,
      paint,
    );

    canvas.drawCircle(
      Offset(w * 0.55, h * 0.80),
      3.2,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _FilterIconPainter oldDelegate,
  ) {
    return oldDelegate.color != color;
  }
}

// ==================================
// CUSTOM PAINTER IKON URUTKAN
// ==================================

class _SortIconPainter extends CustomPainter {
  final Color color;

  const _SortIconPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final double w = size.width;
    final double h = size.height;

    canvas.drawLine(
      Offset(w * 0.07, h * 0.25),
      Offset(w * 0.40, h * 0.25),
      paint,
    );

    canvas.drawLine(
      Offset(w * 0.07, h * 0.52),
      Offset(w * 0.40, h * 0.52),
      paint,
    );

    canvas.drawLine(
      Offset(w * 0.07, h * 0.82),
      Offset(w * 0.93, h * 0.82),
      paint,
    );

    canvas.drawLine(
      Offset(w * 0.75, h * 0.62),
      Offset(w * 0.75, h * 0.12),
      paint,
    );

    canvas.drawLine(
      Offset(w * 0.55, h * 0.32),
      Offset(w * 0.75, h * 0.12),
      paint,
    );

    canvas.drawLine(
      Offset(w * 0.95, h * 0.32),
      Offset(w * 0.75, h * 0.12),
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _SortIconPainter oldDelegate,
  ) {
    return oldDelegate.color != color;
  }
}
