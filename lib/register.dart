import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'providers/register_provider.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegisterProvider>();

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const TopBar(
        backgroundColor: Colors.transparent,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              SizedBox.expand(
                child: Image.asset(
                  'images/registerpic.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.11),
                      child: Text(
                        'R E G I S T E R',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.045,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
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
                                vertical: height * 0.01,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: height * 0.03),

                                  CustomTextField(
                                    controller: provider.fullNameController,
                                    hintText: 'Full Names',
                                    obscureText: false,
                                  ),

                                  SizedBox(height: height * 0.03),

                                  CustomTextField(
                                    controller: provider.emailController,
                                    hintText: 'Email',
                                    obscureText: false,
                                  ),

                                  SizedBox(height: height * 0.03),

                                  Container(
                                    height: 55,
                                    padding: EdgeInsets.only(right: width * 0.05),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'Select role',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        value: provider.selectedRole,
                                        items: RegisterProvider.roles.map((role) {
                                          return DropdownMenuItem(
                                            value: role,
                                            child: Text(provider.formatRoleName(role)),
                                          );
                                        }).toList(),
                                        onChanged: provider.setRole,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: height * 0.03),

                                  CustomTextField(
                                    controller: provider.passwordController,
                                    hintText: 'Password',
                                    obscureText: true,
                                  ),

                                  SizedBox(height: height * 0.03),

                                  CustomTextField(
                                    controller: provider.passwordConfirmController,
                                    hintText: 'Confirm Password',
                                    obscureText: true,
                                  ),

                                  SizedBox(height: height * 0.03),

                                  SizedBox(
                                    height: height * 0.05,
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: provider.isLoading
                                          ? null
                                          : () => provider.register(context),
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
                                        'Register',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: height * 0.03),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.04),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: height * 0.02,
                            decoration: TextDecoration.underline,
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
