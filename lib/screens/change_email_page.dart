
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'verification_email_page.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  static const Color primaryColor = Color(0xFF176B5B);

  final TextEditingController _emailController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _kirimEmail() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan email terlebih dahulu'),
        ),
      );
      return;
    }

    final emailValid = RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
    ).hasMatch(email);

    if (!emailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan alamat email yang valid'),
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

  Widget _buildHeader(BuildContext context) {
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
            'Ubah Email',
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
              _buildHeader(context),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 34),

                      const Text(
                        'Masukan Email Baru',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 9),

                      SizedBox(
                        height: 42,
                        child: TextField(
                          controller: _emailController,
                          keyboardType:
                              TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          textCapitalization:
                              TextCapitalization.none,
                          autocorrect: false,
                          enableSuggestions: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                              RegExp(r'\s'),
                            ),
                          ],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF888888),
                            ),
                            prefixIcon: const Icon(
                              Icons.mail_outline,
                              color: Color(0xFF777777),
                              size: 18,
                            ),
                            prefixIconConstraints:
                                const BoxConstraints(
                              minWidth: 44,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8F8F8),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFCFCFCF),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: primaryColor,
                                width: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 86),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _kirimEmail,
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
                            'KIRIM',
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
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
