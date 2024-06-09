
import 'package:go_router/go_router.dart';
import 'package:instaclone/pages/home_page.dart';
import 'package:instaclone/pages/sign_in_page.dart';
import 'package:instaclone/pages/sign_up_page.dart';
import 'package:instaclone/pages/splash_page.dart';

class RouteNames {
  static const splash = '/';
  static const home = '/home';
  static const signIn = '/signIn';
  static const signUp = '/signUp';
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) {
        return const SplashPage();
      },
    ),
    GoRoute(
      path: RouteNames.home,
      builder: (context, state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: RouteNames.signIn,
      builder: (context, state) {
        return const SignInPage();
      },
    ),
    GoRoute(
      path: RouteNames.signUp,
      builder: (context, state) {
        return const SignUpPage();
      },
    ),

  ],
);
