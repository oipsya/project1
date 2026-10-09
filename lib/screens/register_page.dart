import 'package:flutter/material.dart';
import 'verification_email_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool agree = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void register() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data harus diisi.'),
        ),
      );
      return;
    }

    if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konfirmasi kata sandi tidak sama.'),
        ),
      );
      return;
    }

    if (!agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan setujui persyaratan terlebih dahulu.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VerificationEmailPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 85,
              bottom: 45,
            ),
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 55,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BUAT AKUN',
                        style: TextStyle(
                          color: Color(0xFF176B5B),
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Image.asset(
                        'lib/images/ecowalkijo.png',
                        width: 205,
                        height: 41,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // FORM
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Column(
                    children: [
                      _field(
                        controller: nameController,
                        hint: 'Nama Pengguna',
                        icon: Icons.person,
                      ),

                      const SizedBox(height: 27),

                      _field(
                        controller: emailController,
                        hint: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 27),

                      _field(
                        controller: phoneController,
                        hint: 'Nomor Hp',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 27),

                      _passwordField(
                        controller: passwordController,
                        hint: 'Kata Sandi',
                        obscure: obscurePassword,
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),

                      const SizedBox(height: 27),

                      _passwordField(
                        controller: confirmController,
                        hint: 'Konfirmasi Kata Sandi',
                        obscure: obscureConfirm,
                        onPressed: () {
                          setState(() {
                            obscureConfirm = !obscureConfirm;
                          });
                        },
                      ),

                      const SizedBox(height: 32),

                      // CHECKBOX
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: Checkbox(
                              value: agree,
                              onChanged: (value) {
                                setState(() {
                                  agree = value ?? false;
                                });
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'Saya telah membaca dan menyetujui ',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      height: 1.35,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'persyaratan dan\nprivasi pengguna',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF4AB8D0),
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 38),

                      // BUTTON
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 43,
                          child: ElevatedButton(
                            onPressed: register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF176B5B),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              'BUAT AKUN',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // LOGIN
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Sudah punya akun? ',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: 'Masuk',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF4AB8D0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: 43,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 11,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
          prefixIcon: Icon(
            icon,
            size: 18,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              color: Color(0xFFD0D0D0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              color: Color(0xFF176B5B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 43,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(
          fontSize: 11,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
          prefixIcon: const Icon(
            Icons.lock,
            size: 18,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            icon: Icon(
              obscure
                  ? Icons.visibility_off
                  : Icons.visibility,
              size: 17,
              color: Colors.grey,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              color: Color(0xFFD0D0D0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              color: Color(0xFF176B5B),
            ),
          ),
        ),
      ),
    );
  }
}