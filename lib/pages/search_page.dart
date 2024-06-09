import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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

  @override
  void initState() {
    super.initState();
    items.add(Member('Asliddin', 'asliddin@gmail.com'));
    items.add(Member('Shahob', 'Shahob@gmail.com'));
    items.add(Member('Asadbek', 'Asadbek@gmail.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Search',style: TextStyle(
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
                          borderSide: BorderSide.none
                      ),
                      fillColor: Colors.grey.withOpacity(0.2),
                      filled: true,
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14)
                  ),
                ),
                const Gap(10),
                //#Member List
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (ctx, index){
                      return _itemOfMember(items[index]);
                    }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemOfMember(Member member){
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
              child: const Image(
                image: AssetImage('assets/images/ic_person.png'),
                width: 45,
                height: 45,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const Gap(15),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(member.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
              Text(member.email, style: const TextStyle(color: Colors.black45, fontSize: 13),),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(width: 1, color: Colors.grey)
                  ),
                  elevation: 0,
                  height: 32,
                  minWidth: 100,
                  color: Colors.white,
                  child: const Text('Follow', style: TextStyle(color: Colors.grey),),
                  onPressed: (){
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
