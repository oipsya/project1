
import 'package:flutter/material.dart';
import 'auth_credentials.dart';
import 'login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  final String contact;

  const ResetPasswordPage({
    super.key,
    required this.contact,
  });

  @override
  State<ResetPasswordPage> createState() =>
      _ResetPasswordPageState();
}

class _ResetPasswordPageState
    extends State<ResetPasswordPage> {
  final TextEditingController _passwordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _ubahKataSandi() {
    final password = _passwordController.text.trim();
    final confirmPassword =
        _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua kolom harus diisi.'),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kata sandi minimal 6 karakter.'),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Konfirmasi kata sandi tidak cocok.',
          ),
        ),
      );
      return;
    }

    AuthCredentials.password = password;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Berhasil'),
          content: const Text(
            'Kata sandi berhasil diubah. Silakan masuk kembali.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER DIAGONAL ECOWALK
              SizedBox(
                width: double.infinity,
                height: 205,
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    ClipPath(
                      clipper: _DiagonalHeaderClipper(),
                      child: Container(
                        width: double.infinity,
                        height: 205,
                        color: const Color(0xFFD9E7E4),
                      ),
                    ),

                    // Logo dan judul diposisikan lebih tengah
                    Positioned(
                      top: 72,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'lib/images/ecowalkijo.png',
                            width: 220,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'LUPA KATA SANDI',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF176B5B),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Masukan Kata Sandi Baru',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _buildPasswordField(
                hint: 'Kata Sandi Baru',
                controller: _passwordController,
                obscureText: _obscurePassword,
                onToggle: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),

              const SizedBox(height: 15),

              _buildPasswordField(
                hint: 'Konfirmasi Kata Sandi',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                onToggle: () {
                  setState(() {
                    _obscureConfirmPassword =
                        !_obscureConfirmPassword;
                  });
                },
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: _ubahKataSandi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF176B5B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'UBAH KATA SANDI',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildPasswordField({
    required String hint,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 45,
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
            prefixIcon: const Icon(
              Icons.lock,
              size: 18,
              color: Colors.grey,
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 35,
                minHeight: 35,
              ),
              icon: Icon(
                obscureText
                    ? Icons.visibility_off
                    : Icons.visibility,
                size: 18,
                color: Colors.grey,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFBDBDBD),
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF176B5B),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DiagonalHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height * 0.36)
      ..lineTo(size.width, size.height * 0.74)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(
    covariant CustomClipper<Path> oldClipper,
  ) {
    return false;
  }
}