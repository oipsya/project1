import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'reset_password_page.dart';
import 'verification_email_page.dart';

class VerificationPhonePage extends StatefulWidget {
  final String phoneNumber;

  const VerificationPhonePage({
    super.key,
    this.phoneNumber = '',
  });

  @override
  State<VerificationPhonePage> createState() =>
      _VerificationPhonePageState();
}

class _VerificationPhonePageState
    extends State<VerificationPhonePage> {
  static const Color darkGreen = Color(0xFF176657);
  static const Color lightGreen = Color(0xFFD9E6E3);
  static const Color linkBlue = Color(0xFF00A9D6);

  static const double horizontalPadding = 16.0;
  static const double otpGap = 8.0;

  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
      List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  // VERIFIKASI KODE OTP
  void _verifyCode() {
    final code = _controllers.map((c) => c.text).join();

    if (code.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan kode verifikasi 4 digit.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResetPasswordPage(
          contact: widget.phoneNumber,
        ),
      ),
    );
  }

  // KOTAK OTP
  Widget _otpBox(int index, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          border: Border.all(
            color: const Color(0xFFD8D8D8),
            width: 1.4,
          ),
          borderRadius: BorderRadius.circular(9),
        ),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: darkGreen,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth =
                constraints.maxWidth - horizontalPadding * 2;

            final boxSize =
                (availableWidth - otpGap * 3) / 4;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // HEADER HIJAU
                    SizedBox(
                      height: 220 + topInset,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _VerificationHeaderPainter(),
                            ),
                          ),
                          Positioned(
                            top: topInset + 75,
                            left: 24,
                            right: 24,
                            child: Image.asset(
                              'lib/images/ecowalkijo.png',
                              height: 52,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // KONTEN VERIFIKASI HP
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        horizontalPadding,
                        0,
                        horizontalPadding,
                        28,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.check,
                                size: 21,
                                color: Colors.black,
                              ),
                              SizedBox(width: 9),
                              Text(
                                'VERIFIKASI',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'lib/images/phone.png',
                                width: 29,
                                height: 29,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Periksa dan ketik kode verifikasi yang telah dikirimkan ke ${widget.phoneNumber.isEmpty ? 'nomor HP Anda' : widget.phoneNumber}.',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    height: 1.35,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // KOTAK KODE OTP
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: List.generate(4, (index) {
                                return _otpBox(index, boxSize);
                              }),
                            ),
                          ),

                          const SizedBox(height: 23),

                          // PINDAH KE VERIFIKASI EMAIL
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const VerificationEmailPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Verifikasi menggunakan Email',
                              style: TextStyle(
                                color: linkBlue,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(height: 27),

                          // TOMBOL KIRIM
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: _verifyCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkGreen,
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // KIRIM ULANG KODE
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Fitur kirim ulang perlu '
                                      'dihubungkan ke layanan SMS.',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Kirim Ulang Kode',
                                style: TextStyle(
                                  color: darkGreen,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
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
    );
  }
}

// DESAIN HEADER
class _VerificationHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD9E6E3);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - 24)
      ..lineTo(0, size.height - 105)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
