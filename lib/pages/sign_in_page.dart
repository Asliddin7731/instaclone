import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:instaclone/router/app_router.dart';

import '../service/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var isLoading = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignIn() {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    if (email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });
    AuthService.signInUser(email, password).then((value) => {
      _responseSignIn(value!),
    });
  }

  _responseSignIn(User firebase){
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
          children:[
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
                          _doSignIn();
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
                      context.pushReplacement(RouteNames.signUp);
                    },
                    child: const Text("Sign Up",
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
        ),
      ),
    );
  }
}
