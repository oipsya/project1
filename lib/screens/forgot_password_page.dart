import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'verification_email_page.dart';
import 'verification_phone_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {
  static const Color darkGreen = Color(0xFF176657);
  static const Color lightGreen = Color(0xFFD9E6E3);
  static const Color linkBlue = Color(0xFF00A9D6);

  final TextEditingController _contactController =
      TextEditingController();

  bool _usePhone = false;

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  // PINDAH ANTARA EMAIL DAN NOMOR HP
  void _switchMode() {
    setState(() {
      _usePhone = !_usePhone;
      _contactController.clear();
    });
  }

  // VALIDASI DAN BUKA HALAMAN VERIFIKASI
  void _submit() {
    final contact = _contactController.text.trim();

    if (contact.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _usePhone
                ? 'Masukkan nomor HP terlebih dahulu.'
                : 'Masukkan alamat Email terlebih dahulu.',
          ),
        ),
      );
      return;
    }

    if (!_usePhone) {
      final emailPattern =
          RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

      if (!emailPattern.hasMatch(contact)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Masukkan alamat Email yang valid.'),
          ),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationEmailPage(
            email: contact,
          ),
        ),
      );
    } else {
      final phonePattern = RegExp(r'^[0-9+]{9,16}$');

      if (!phonePattern.hasMatch(contact)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Masukkan nomor HP yang valid.'),
          ),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationPhonePage(
            phoneNumber: contact,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: lightGreen,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          top: false,
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      // HEADER DIAGONAL DAN LOGO
                      SizedBox(
                        height: 210 + topInset,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter:
                                    _ForgotPasswordHeaderPainter(),
                              ),
                            ),
                            Positioned(
                              top: topInset + 65,
                              left: 24,
                              right: 24,
                              child: Image.asset(
                                'lib/images/ecowalkijo.png',
                                height: 65,
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return const SizedBox(
                                    height: 65,
                                    child: Center(
                                      child: Text(
                                        'ECOWALK',
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight:
                                              FontWeight.w900,
                                          color: darkGreen,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: topInset + 137,
                              left: 0,
                              right: 0,
                              child: const Text(
                                'LUPA KATA SANDI',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: darkGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // KONTEN FORM
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          8,
                          20,
                          28,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // INFORMASI VERIFIKASI
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.notifications_none,
                                  size: 23,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _usePhone
                                        ? 'Periksa dan masukan Nomor Hp untuk mendapatkan kode verifikasi'
                                        : 'Periksa dan masukan alamat Email untuk mendapatkan kode verifikasi',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      height: 1.4,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // LABEL INPUT
                            Text(
                              _usePhone
                                  ? 'Nomor Hp'
                                  : 'Alamat Email',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF777777),
                              ),
                            ),

                            const SizedBox(height: 5),

                            // INPUT GARIS BAWAH
                            TextField(
                              controller: _contactController,
                              keyboardType: _usePhone
                                  ? TextInputType.phone
                                  : TextInputType.emailAddress,
                              inputFormatters: _usePhone
                                  ? [
                                      FilteringTextInputFormatter
                                          .allow(
                                        RegExp(r'[0-9+]'),
                                      ),
                                      LengthLimitingTextInputFormatter(
                                        16,
                                      ),
                                    ]
                                  : null,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                enabledBorder:
                                    UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFAAAAAA),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder:
                                    UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: darkGreen,
                                    width: 1.8,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // LINK GANTI METODE
                            GestureDetector(
                              onTap: _switchMode,
                              child: Text(
                                _usePhone
                                    ? 'Gunakan Email'
                                    : 'Gunakan Nomor Hp',
                                style: const TextStyle(
                                  color: linkBlue,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            // TOMBOL KIRIM
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: darkGreen,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(4),
                                  ),
                                ),
                                child: const Text(
                                  'KIRIM',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// HEADER HIJAU MUDA DENGAN POTONGAN DIAGONAL
class _ForgotPasswordHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD9E6E3);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - 8)
      ..lineTo(0, size.height - 115)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(
    covariant _ForgotPasswordHeaderPainter oldDelegate,
  ) {
    return false;
  }
}

