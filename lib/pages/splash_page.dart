import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instaclone/pages/home_page.dart';
import 'package:instaclone/pages/sign_in_page.dart';
import 'package:instaclone/router/app_router.dart';
import 'package:instaclone/service/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  _initTimer(){
    Timer(const Duration(seconds: 2), () {
      _callNextPage();
    });
  }

  _callNextPage(){
    if(AuthService.isLoggedIn()){
      context.pushReplacement(RouteNames.home);
    }else{
      context.pushReplacement(RouteNames.signIn);
    }
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
        child: const Column(
          children: [
            Expanded(
              child: Center(
                child: Text('Instagram',
                style: TextStyle(color: Colors.white, fontSize: 45, fontFamily: 'Billabong'),
                ),
              ),
            ),
            Text('All rights reserved',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
