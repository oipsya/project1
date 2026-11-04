
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String? initialImagePath;

  const EditProfilePage({
    super.key,
    this.initialName = 'PASHA AULIA',
    this.initialImagePath,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const Color primaryColor = Color(0xFF176B5B);

  final ImagePicker _picker = ImagePicker();
  late final TextEditingController _nameController;

  String? _imagePath;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _imagePath = widget.initialImagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _ambilFotoGaleri() async {
    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1000,
      );

      if (!mounted || foto == null) return;

      final file = File(foto.path);

      if (!await file.exists()) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File foto tidak ditemukan'),
          ),
        );
        return;
      }

      if (!mounted) return;

      setState(() {
        _imagePath = foto.path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto berhasil dipilih'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka Galeri: $e'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _bukaGambarGirl() async {
    final hasil = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (cameraContext) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'lib/images/girl.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return const Center(
                      child: Text(
                        'Gambar girl.png tidak ditemukan',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),

                Positioned(
                  top: 35,
                  left: 12,
                  child: SafeArea(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(cameraContext);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 35,
                  right: 18,
                  child: SafeArea(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.cameraswitch_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 70,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            cameraContext,
                            'asset:lib/images/girl.png',
                          );
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 31,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    if (!mounted || hasil == null) return;

    setState(() {
      _imagePath = hasil;
    });
  }

  void _pilihFoto() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20, 10, 20, 26,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBFBFBF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 27),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _menuFoto(
                      gambar: 'lib/images/Vector.png',
                      judul: 'Kamera',
                      warna: const Color(0xFFF2F2F2),
                      onTap: () async {
                        Navigator.pop(sheetContext);

                        await Future<void>.delayed(
                          const Duration(milliseconds: 250),
                        );

                        if (!mounted) return;
                        await _bukaGambarGirl();
                      },
                    ),

                    const SizedBox(width: 30),

                    _menuFoto(
                      gambar: 'lib/images/solar_gallery-bold.png',
                      judul: 'Galeri',
                      warna: Colors.white,
                      onTap: () async {
                        Navigator.pop(sheetContext);

                        await Future<void>.delayed(
                          const Duration(milliseconds: 300),
                        );

                        if (!mounted) return;
                        await _ambilFotoGaleri();
                      },
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

  Widget _menuFoto({
    required String gambar,
    required String judul,
    required Color warna,
    required VoidCallback onTap,
  }) {
    return Material(
      color: warna,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 86,
          height: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                gambar,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return Icon(
                    judul == 'Kamera'
                        ? Icons.camera_alt_outlined
                        : Icons.photo_library_outlined,
                    size: 32,
                    color: Colors.black,
                  );
                },
              ),

              const SizedBox(height: 7),

              Text(
                judul,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fotoProfil() {
    if (_imagePath != null) {
      if (_imagePath!.startsWith('asset:')) {
        return Image.asset(
          _imagePath!.substring(6),
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fotoDefault(),
        );
      }

      return Image.file(
        File(_imagePath!),
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fotoDefault(),
      );
    }

    return _fotoDefault();
  }

  Widget _fotoDefault() {
    return Image.asset(
      'lib/images/pic.jpeg',
      width: 120,
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return const ColoredBox(
          color: Color(0xFFECE8DF),
          child: Icon(
            Icons.person,
            color: Colors.grey,
            size: 70,
          ),
        );
      },
    );
  }

  void _simpanProfil() {
    final namaBaru = _nameController.text.trim();

    final namaDisimpan = namaBaru.isEmpty
        ? widget.initialName
        : namaBaru;

    Navigator.pop(context, {
      'name': namaDisimpan,
      'imagePath': _imagePath,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,

        // Header hijau dipisahkan dari status bar putih.
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 50,
                width: double.infinity,
                color: primaryColor,
                child: Row(
                  children: [
                    SizedBox(
                      width: 43,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),

                    const Text(
                      'Edit Profil',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 28),

                      Center(
                        child: SizedBox(
                          width: 135,
                          height: 135,
                          child: Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFECE8DF),
                                ),
                                child: ClipOval(
                                  child: _fotoProfil(),
                                ),
                              ),

                              Positioned(
                                right: 7,
                                bottom: 11,
                                child: GestureDetector(
                                  onTap: _pilihFoto,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      TextField(
                        controller: _nameController,
                        textCapitalization:
                            TextCapitalization.words,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Nama Pengguna',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 20,
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 30,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.8,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 100),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _simpanProfil,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'SIMPAN',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                height: 58,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFEEEEEE),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.crop_free,
                      color: Color(0xFF319BE8),
                      size: 18,
                    ),
                    Icon(
                      Icons.crop_free,
                      color: Color(0xFF319BE8),
                      size: 18,
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
