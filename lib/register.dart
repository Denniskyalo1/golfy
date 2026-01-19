import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'auth_services.dart';
import 'user_prefs.dart';

class Register extends StatefulWidget {
  Register({super.key});

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  void _showDialog(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Success'),
            content: Text(
              'Registration successful!',
            ),
            actions: [
              MaterialButton(
                onPressed: (){
                  Navigator.pop(context);
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/homePage',
                          (route) => false,
                    );
                  }
                },
                child: Text('Ok',
                  style: TextStyle(
                      color: Colors.black
                  ),),

              )
            ],

          );
        }
    );

  }
  List<String> roles = [
    'player',
    'manager',
    'caddie'
  ];

  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TopBar(
        backgroundColor: Colors.transparent,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
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
                      padding:  EdgeInsets.only(top: height*0.11),
                      child: Text(
                        'R E G I S T E R',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.045,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: width * 0.05,
                              right: width * 0.05
                          ),
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaY: 30,sigmaX: 30),
                              child: Container(
                                width: width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height*0.01),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(height: height*0.03,),
                                      CustomTextField(
                                        controller: widget.fullNameController,
                                        hintText: 'Full Names',
                                        obscureText: false,
                                      ),
                                      SizedBox(height: height*0.03,),
                                      CustomTextField(
                                        controller: widget.emailController,
                                        hintText: 'Email',
                                        obscureText: false,
                                      ),
                                      SizedBox(height: height*0.03,),
                                      Container(
                                        height: 55,
                                        padding: EdgeInsets.only(right: width*0.05),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              isExpanded: true,
                                              hint: Text(
                                                'Select role',
                                                style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
                                              ),
                                            value: selectedRole,
                                            items: roles.map((role) {
                                              return DropdownMenuItem<String>(
                                                value: role,
                                                child: Text(
                                                  role == 'manager'
                                                      ? 'Course Manager'
                                                      : role[0].toUpperCase() + role.substring(1),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedRole = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height*0.03,),
                                      CustomTextField(
                                        controller: widget.passwordController,
                                        hintText: 'Password',
                                        obscureText: true,
                                      ),
                                      SizedBox(height: height*0.03,),
                                      CustomTextField(
                                        controller: widget.passwordConfirmController,
                                        hintText: 'Confirm Password',
                                        obscureText: true,
                                      ),
                                      SizedBox(height: height*0.03,),
                                      SizedBox(
                                        height: height*0.05,
                                        width: double.infinity,
                                        child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                side: const BorderSide(color: Colors.white, width: 1.5),
                                                backgroundColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15)
                                                )
                                            ),
                                            onPressed: () async {
                                              final name = widget.fullNameController.text.trim();
                                              final email = widget.emailController.text.trim();
                                              final password = widget.passwordController.text;
                                              final confirmPassword = widget.passwordConfirmController.text;

                                              if(name.isEmpty || email.isEmpty || password.isEmpty ||confirmPassword.isEmpty){
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Please fill in all the fields'))
                                                );
                                                return;
                                              }

                                              if(password != confirmPassword){
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Passwords do not match.Please try again'))
                                                );
                                                return;
                                              }

                                              if (selectedRole == null) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Please select a role')),
                                                );
                                                return;
                                              }

                                              try {
                                                final result = await AuthService.register(
                                                  name: name,
                                                  email: email,
                                                  password: password,
                                                  passwordConfirmation: confirmPassword,
                                                  role: selectedRole!,
                                                );

                                                if (!context.mounted) return;

                                                final status = result['status'];
                                                final body = result['body'];

                                                final user = body['user'];
                                                final token = body['token'];
                                                await UserPrefs.saveUser(
                                                  name: user['name'] ?? '',
                                                  email: user['email'] ?? '',
                                                  role: user['role'] ?? '',
                                                  token: token ?? '',
                                                );

                                                //Successful registration
                                                if(!context.mounted) return;
                                                if (status == 201) {
                                                  _showDialog();
                                                  return;
                                                }

                                                //Validation errors
                                                if(!context.mounted) return;
                                                if (status == 422 && body['errors'] != null) {
                                                  final errors = body['errors'] as Map<String, dynamic>;
                                                  final firstError = errors.values.first[0];

                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text(firstError)),
                                                  );
                                                  return;
                                                }

                                                if(!context.mounted) return;

                                                //Other errors
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text(body['message'] ?? 'Registration failed')),
                                                );
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Server error. Please try again.')),
                                                );
                                              }
                                            },
                                            child: const Text(
                                              'Register',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                        ),
                                      ),
                                      SizedBox(height: height*0.03,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: height * 0.04,
                              left: width * 0.05,
                              right: width * 0.05
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pushReplacementNamed('/login');
                            },
                            child: Text(
                              'Already have an account? Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    widget.fullNameController.dispose();
    widget.emailController.dispose();
    widget.passwordController.dispose();
    widget.passwordConfirmController.dispose();
    super.dispose();
  }
}