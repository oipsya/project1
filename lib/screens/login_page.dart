import 'package:flutter/material.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // =========================
  // LOGIN
  // =========================
  void _login() {
    const String correctUsername = 'user30';
    const String correctPassword = '070526';

    final String username = usernameController.text.trim();
    final String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nama pengguna dan kata sandi harus diisi.',
          ),
        ),
      );
      return;
    }

    if (username == correctUsername &&
        password == correctPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nama pengguna atau kata sandi salah.',
          ),
        ),
      );
    }
  }

  // =========================
  // REGISTER
  // =========================
  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  // =========================
  // LUPA PASSWORD
  // =========================
  void _goToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // =========================================
      // FULL LAYAR
      // =========================================
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // =================================
                    // JUDUL
                    // =================================
                    const Center(
                      child: Text(
                        'MASUK',
                        style: TextStyle(
                          color: Color(0xFF176B5B),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // =================================
                    // LOGO ECOWALK
                    // =================================
                    Center(
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF176B5B),
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'lib/images/ecowalk.png',
                          width: 220,
                          height: 55,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 38),

                    // =================================
                    // NAMA PENGGUNA
                    // =================================
                    const Text(
                      'Nama Pengguna',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 48,
                      child: TextField(
                        controller: usernameController,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Nama Pengguna',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            size: 21,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8F8F8),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF176B5B),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // =================================
                    // KATA SANDI
                    // =================================
                    const Text(
                      'Kata Sandi',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 48,
                      child: TextField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Kata Sandi',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            size: 21,
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword =
                                    !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8F8F8),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF176B5B),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // =================================
                    // TOMBOL MASUK
                    // =================================
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF176B5B),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'MASUK',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // =================================
                    // LUPA KATA SANDI
                    // =================================
                    Center(
                      child: GestureDetector(
                        onTap: _goToForgotPassword,
                        child: const Text(
                          'Lupa Kata Sandi?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4AB8D0),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // =================================
                    // PEMBATAS ATAU
                    // =================================
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                          ),
                          child: Text(
                            'Atau',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // =================================
                    // GOOGLE
                    // =================================
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFF8F8F8),
                          side: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'lib/images/google.png',
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Lanjutkan dengan Google',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // =================================
                    // DAFTAR
                    // =================================
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Tidak punya akun? ',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: _goToRegister,
                          child: const Text(
                            'Daftar disini',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF4AB8D0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}