import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'providers/otp_provider.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    otpController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    otpController.dispose();
    otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OtpProvider>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final email = ModalRoute.of(context)?.settings.arguments as String?;

    if (email == null) {
      return const Scaffold(
        body: Center(child: Text('Missing contact information')),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const TopBar(
        backgroundColor: Colors.transparent,
        showBackButton: true,
        route: '/landing',

      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              SizedBox.expand(
                child: Image.asset(
                  'images/background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.11),
                      child: Text(
                        'V E R I F Y   O T P',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.045,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05,
                        vertical: height * 0.02,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 30, sigmaX: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: height * 0.04,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Enter the 5-digit code sent to your email',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height * 0.018,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    provider.getMaskedContact(email),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.018,
                                    ),
                                  ),

                                  SizedBox(height: height * 0.04),

                                  GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).requestFocus(otpFocusNode);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(
                                        OtpProvider.otpLength,
                                            (index) {
                                          final text = otpController.text;
                                          return Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 6),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withOpacity(0.3),
                                              border: Border.all(
                                                color: index < text.length
                                                    ? Colors.white
                                                    : Colors.white.withOpacity(0.5),
                                                width: 2,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              index < text.length ? text[index] : '',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  Opacity(
                                    opacity: 0,
                                    child: TextField(
                                      controller: otpController,
                                      focusNode: otpFocusNode,
                                      keyboardType: TextInputType.number,
                                      maxLength: OtpProvider.otpLength,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        counterText: '',
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: height * 0.04),

                                  SizedBox(
                                    height: height * 0.05,
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: provider.isLoading
                                          ? null
                                          : () async {
                                        final success = await provider.verifyOtp(
                                          email: email,
                                          otp: otpController.text,
                                          context: context
                                        );

                                        if (!context.mounted) return;

                                        if (success) {
                                          Navigator.pushNamed(
                                            context,
                                            '/homePage',
                                            arguments: {
                                              'email': email,
                                              'otp': otpController.text,
                                            },
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                provider.errorMessage ??
                                                    'OTP verification failed',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: provider.isLoading
                                          ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                          : const Text(
                                        'Continue',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: height * 0.02),

                                  GestureDetector(
                                    onTap:  provider.isLoading
                                        ? null
                                        : () async {
                                      final success = await provider.resend(email: email);
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            success['status'] == 200
                                                ? 'Code resent successfully!'
                                                : 'Failed to resend code',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Resend Code',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: height * 0.018,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        Container(
                                          height: 0.8,
                                          width: 95,
                                          color: Colors.black,
                                        ),
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            ),
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
      ),
    );
  }
}