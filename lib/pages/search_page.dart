import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:instaclone/service/db_service.dart';

import '../model/member_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = false;
  var searchController = TextEditingController();
  List<Member> items = [];

  void _apiSearchMembers(String keyword) {
    setState(() {
      isLoading = true;
    });
    DBService.searchMembers(keyword).then((users) => {
          _respSearchMembers(users),
        });
  }

  void _respSearchMembers(List<Member> member) {
    setState(() {
      items = member;
      isLoading = false;
    });
  }

  void _apiFollowMember(Member someone)async{
    setState(() {
      isLoading = true;
    });
    await DBService.followMember(someone);
    setState(() {
      someone.followed = true;
      isLoading = false;
    });
    DBService.storePostsMyFeed(someone);
  }

  void _apiUnFollowMember(Member someone)async{
    setState(() {
      isLoading = true;
    });
    await DBService.unFollowMember(someone);
    setState(() {
      someone.followed = false;
      isLoading = false;
    });
    DBService.removePostsMyFeed(someone);
  }

  @override
  void initState() {
    super.initState();
    _apiSearchMembers('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Search',
          style: TextStyle(
              color: Colors.black, fontFamily: 'Billabong', fontSize: 25),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                //#Search Member
                TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: searchController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: Colors.grey.shade500,
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none),
                      fillColor: Colors.grey.withOpacity(0.2),
                      filled: true,
                      hintText: 'Search',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                ),
                const Gap(10),
                //#Member List
                Expanded(
                  child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (ctx, index) {
                        return _itemOfMember(items[index]);
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemOfMember(Member member) {
    return SizedBox(
      height: 90,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              border: Border.all(
                width: 1.5,
                color: const Color.fromRGBO(193, 53, 132, 1),
              ),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(22.5),
                child: member.imageUrl.isEmpty
                    ? const Image(
                        image: AssetImage('assets/images/ic_person.png'),
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        member.imageUrl,
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                      )),
          ),
          const Gap(15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.fullName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                member.email,
                style: const TextStyle(color: Colors.black45, fontSize: 13),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: member.followed
                          ? const BorderSide(width: 1, color: Colors.grey)
                          : const BorderSide(width: 1, color: Colors.blueAccent)),
                  elevation: 0,
                  height: 32,
                  minWidth: 100,
                  color: member.followed ? Colors.white : Colors.blueAccent,
                  child: member.followed
                      ? const Text('Following',
                          style: TextStyle(color: Colors.grey))
                      : const Text('Follow',
                          style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    if(member.followed){
                      _apiUnFollowMember(member);
                    }else{
                      _apiFollowMember(member);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
