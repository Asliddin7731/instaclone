import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/pages/feed_page.dart';
import 'package:instaclone/pages/likes_page.dart';
import 'package:instaclone/pages/profile_page.dart';
import 'package:instaclone/pages/search_page.dart';
import 'package:instaclone/pages/upload_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? _pageController;
  int _currentTap = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:PageView(
        controller: _pageController,
        children: [
          FeedPage(pageController: _pageController),
          const SearchPage(),
          UploadPage(pageController: _pageController),
          const LikesPage(),
          const ProfilePage()
        ],
        onPageChanged: (int index){
          setState(() {
            _currentTap = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (int index){
          setState(() {
            _currentTap = index;
            _pageController!.animateToPage(
                index, duration: const Duration(microseconds: 200),
                curve: Curves.easeIn);
          });
          },
        currentIndex: _currentTap,
        activeColor: const Color.fromRGBO(193, 53, 132, 1),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
