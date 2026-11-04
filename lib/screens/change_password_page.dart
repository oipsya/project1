
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  static const Color primaryColor = Color(0xFF176B5B);

  final TextEditingController _oldPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _ubahKataSandi() {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (oldPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua kolom harus diisi'),
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konfirmasi kata sandi tidak sesuai'),
        ),
      );
      return;
    }

    if (oldPassword == newPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kata sandi baru harus berbeda'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Form sudah valid. Perubahan kata sandi perlu '
          'dihubungkan ke sistem akun.',
        ),
      ),
    );
  }

  void _lupaKataSandi() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur lupa kata sandi belum dihubungkan'),
      ),
    );
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
              size: 20,
            ),
          ),
          const Text(
            'Ubah Kata Sandi',
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

  Widget _passwordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 43,
          child: TextField(
            controller: controller,
            obscureText: !visible,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            enableSuggestions: false,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Color(0xFF888888),
              ),
              prefixIcon: const Icon(
                Icons.lock,
                color: Color(0xFF777777),
                size: 19,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 45,
              ),
              suffixIcon: IconButton(
                onPressed: onToggle,
                icon: Icon(
                  visible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off,
                  color: const Color(0xFF888888),
                  size: 19,
                ),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 45,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 9,
                horizontal: 12,
              ),
              filled: true,
              fillColor: const Color(0xFFF8F8F8),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: Color(0xFFCFCFCF),
                  width: 1.1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 1.3,
                ),
              ),
            ),
          ),
        ),
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
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 34),

                      _passwordField(
                        label: 'Kata Sandi Lama',
                        hint: 'Kata Sandi Lama',
                        controller: _oldPasswordController,
                        visible: _showOldPassword,
                        onToggle: () {
                          setState(() {
                            _showOldPassword = !_showOldPassword;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: _lupaKataSandi,
                          child: const Text(
                            'Lupa Kata Sandi?',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF00A9D6),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 19),

                      _passwordField(
                        label: 'Kata Sandi Baru',
                        hint: 'Kata Sandi Baru',
                        controller: _newPasswordController,
                        visible: _showNewPassword,
                        onToggle: () {
                          setState(() {
                            _showNewPassword = !_showNewPassword;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      _passwordField(
                        label: 'Konfirmasi Kata Sandi',
                        hint: 'Konfirmasi Kata Sandi',
                        controller: _confirmPasswordController,
                        visible: _showConfirmPassword,
                        onToggle: () {
                          setState(() {
                            _showConfirmPassword =
                                !_showConfirmPassword;
                          });
                        },
                      ),

                      const SizedBox(height: 57),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _ubahKataSandi,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'UBAH',
                            style: TextStyle(
                              fontSize: 13,
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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFEEEEEE),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
