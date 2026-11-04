
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'change_phone_page.dart';
import 'change_email_page.dart';
import 'change_password_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const Color primaryColor = Color(0xFF176B5B);

  bool _showDeleteDialog = false;

  void _bukaMenu(String namaMenu) {
    if (namaMenu == 'Ubah Nomor Hp') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChangePhonePage(),
        ),
      );
      return;
    }

    if (namaMenu == 'Ubah Email') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChangeEmailPage(),
        ),
      );
      return;
    }

    if (namaMenu == 'Ubah Kata Sandi') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChangePasswordPage(),
        ),
      );
      return;
    }

    if (namaMenu == 'Hapus Akun') {
      FocusScope.of(context).unfocus();

      setState(() {
        _showDeleteDialog = true;
      });
    }
  }

  void _tutupDeleteDialog() {
    setState(() {
      _showDeleteDialog = false;
    });
  }

  Widget _buildHeader() {
    return Container(
      height: 55,
      width: double.infinity,
      color: primaryColor,
      child: Row(
        children: [
          const SizedBox(width: 2),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 21,
            ),
          ),
          const Text(
            'Pengaturan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemPengaturan({
    required IconData icon,
    required String title,
    required bool garisBawah,
  }) {
    return InkWell(
      onTap: () => _bukaMenu(title),
      child: Container(
        height: 49,
        margin: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: garisBawah
              ? const Border(
                  bottom: BorderSide(
                    color: Color(0xFFD8D8D8),
                    width: 1,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              child: Icon(
                icon,
                size: 22,
                color: const Color(0xFF222222),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF191919),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 26,
              color: Color(0xFF222222),
            ),
            const SizedBox(width: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomArea() {
    return Container(
      height: 58,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }

  Widget _buildPageContent() {
    return Column(
      children: [
        _buildHeader(),

        const SizedBox(height: 8),

        _itemPengaturan(
          icon: Icons.phone_outlined,
          title: 'Ubah Nomor Hp',
          garisBawah: true,
        ),

        _itemPengaturan(
          icon: Icons.mail_outline,
          title: 'Ubah Email',
          garisBawah: true,
        ),

        _itemPengaturan(
          icon: Icons.vpn_key_outlined,
          title: 'Ubah Kata Sandi',
          garisBawah: true,
        ),

        _itemPengaturan(
          icon: Icons.delete_outline,
          title: 'Hapus Akun',
          garisBawah: false,
        ),

        const Spacer(),
      ],
    );
  }

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
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _buildPageContent(),
                    ),

                    if (_showDeleteDialog) ...[
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(
                            alpha: 0.42,
                          ),
                        ),
                      ),

                      Positioned(
                        top: 165,
                        left: 20,
                        right: 20,
                        child: _DeleteAccountDialog(
                          onClose: _tutupDeleteDialog,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              _buildBottomArea(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  final VoidCallback onClose;

  const _DeleteAccountDialog({
    required this.onClose,
  });

  @override
  State<_DeleteAccountDialog> createState() =>
      _DeleteAccountDialogState();
}

class _DeleteAccountDialogState
    extends State<_DeleteAccountDialog> {
  final TextEditingController _passwordController =
      TextEditingController();

  bool _showPassword = false;
  bool _showWarning = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _hapusAkun() {
    if (_passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Masukkan kata sandi terlebih dahulu',
          ),
        ),
      );
      return;
    }

    widget.onClose();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Penghapusan akun belum terhubung ke sistem akun.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 5,
      borderRadius: BorderRadius.circular(13),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          28, 22, 28, 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'HAPUS AKUN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Color(0xFF363636),
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              height: 49,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    top: 7,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      keyboardType:
                          TextInputType.visiblePassword,
                      autocorrect: false,
                      enableSuggestions: false,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Masukan Kata Sandi',
                        hintStyle: const TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFABABAB),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 9,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off,
                            size: 21,
                            color: const Color(0xFF27354A),
                          ),
                        ),
                        suffixIconConstraints:
                            const BoxConstraints(
                          minWidth: 40,
                        ),
                        enabledBorder:
                            const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFF303E),
                            width: 1.7,
                          ),
                          borderRadius: BorderRadius.zero,
                        ),
                        focusedBorder:
                            const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFF303E),
                            width: 1.9,
                          ),
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 0,
                    left: 10,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: const Text(
                        'Kata Sandi',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF343434),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (_showWarning)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 9,
                ),
                color: const Color(0xFFFFE7E7),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Color(0xFFFF3333),
                      size: 18,
                    ),

                    const SizedBox(width: 7),

                    const Expanded(
                      child: Text(
                        'Anda akan menghapus akun anda. '
                        'Tindakan ini tidak dapat dibatalkan. '
                        'Semua data akan hilang.',
                        style: TextStyle(
                          fontSize: 9,
                          height: 1.3,
                          color: Color(0xFF454545),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showWarning = false;
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFF666666),
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: _hapusAkun,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFED262B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Hapus',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                TextButton(
                  onPressed: widget.onClose,
                  style: TextButton.styleFrom(
                    foregroundColor:
                        const Color(0xFF444444),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
