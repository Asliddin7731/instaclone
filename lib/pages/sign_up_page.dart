import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:instaclone/service/auth_service.dart';

import '../router/app_router.dart';
import '../service/utils_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var isLoading = false;
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var cPasswordController = TextEditingController();

  _doSignUp() {
    String fullName = fullNameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String cPassword = cPasswordController.text.toString().trim();

    bool isPasswordValid = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$').hasMatch(password);

    if (!isPasswordValid) {
      Utils.fireToast('Password must be at least 6 characters long and contain at least one uppercase letter, one number, and a special character');
      return;
    }

    // if (email.contains('@gmail.com'))return;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty ||
        !email.contains('@gmail.com') || email.contains('#') || '@'.allMatches(email).length != 1
    || !isPasswordValid) return;

    if (password != cPassword){
      Utils.fireToast('Password and confirm password does not match');
      return;
    }
    setState(() {
      isLoading = true;
    });
    AuthService.signUpUser(email, password).then((value) => {
      _responseSignUp(value!),
    });
  }

  _responseSignUp(User firebase){
    setState(() {
      isLoading = false;
    });

    context.pushReplacement(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(193, 53, 132, 1),
                Color.fromRGBO(131, 58, 180, 1),
              ],
            )
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Instagram',
                          style: TextStyle(color: Colors.white, fontSize: 45, fontFamily: 'Billabong'),
                        ),
                        const Gap(20),
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: fullNameController,
                          cursorColor: Colors.red,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none
                              ),
                              fillColor: Colors.white.withOpacity(0.2),
                              filled: true,
                              hintText: 'Full Name',
                              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14)
                          ),
                        ),
                        const Gap(10),
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: emailController,
                          cursorColor: Colors.red,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none
                              ),
                              fillColor: Colors.white.withOpacity(0.2),
                              filled: true,
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14)
                          ),
                        ),
                        const Gap(10),
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                          controller: passwordController,
                          cursorColor: Colors.red,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none
                              ),
                              fillColor: Colors.white.withOpacity(0.2),
                              filled: true,
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14)
                          ),
                        ),
                        const Gap(10),
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                          controller: cPasswordController,
                          cursorColor: Colors.red,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none
                              ),
                              fillColor: Colors.white.withOpacity(0.2),
                              filled: true,
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14)
                          ),
                        ),
                        const Gap(10),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                                width: 3
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          height: 50,
                          minWidth: MediaQuery.sizeOf(context).width,
                          child: const Text('Sign In', style: TextStyle(
                              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          onPressed: (){
                            _doSignUp();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't haven an account?",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),

                    const Gap(20),
                    GestureDetector(
                      onTap: (){
                        context.pushReplacement(RouteNames.signIn);
                      },
                      child: const Text("Sign In",
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),

                  ],
                ),
                const Gap(20),
              ],
            ),

            isLoading
                ? const Center(
                child: CircularProgressIndicator())
                : const SizedBox.shrink(),
          ],
        )
      ),
    );
  }
}
