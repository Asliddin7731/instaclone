import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../model/post_model.dart';

class FeedPage extends StatefulWidget {
  final PageController? pageController;
  const FeedPage({super.key,this.pageController,});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  bool isLoading = false;
  List<Post> item = [];

  String image_1 = "https://images.unsplash.com/photo-1712869456131-f20d945004cd";
  String image_2 = "https://images.unsplash.com/photo-1715546658746-27b1f6eb2b21";
  String image_3 = "https://images.unsplash.com/photo-1641943083592-8de0047e5678";

  @override
  void initState() {
    super.initState();
    item.add(Post(image_3, 'Best'));
    item.add(Post(image_2, 'Good'));
    item.add(Post(image_1, 'Beautiful'));
    item.add(Post(image_1, 'Beautiful'));
    item.add(Post(image_2, 'Beautiful'));
    item.add(Post(image_1, 'Beautiful'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Instagram',
          style:  TextStyle(
              color: Colors.black, fontFamily: 'billabong', fontSize: 30),
        ) ,
        actions: [
          IconButton(
              onPressed: (){
                widget.pageController!.animateToPage(
                    2, duration: const Duration(microseconds: 200),
                    curve: Curves.easeIn);
              },
              icon: const Icon(Icons.camera_alt),
            color: const Color.fromRGBO(193, 53, 132, 1),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            cacheExtent: 999,
            itemCount: item.length,
            itemBuilder: (ctx, index){
              return _itemOfPost(item[index]);
            },
          ),

          isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          ) :
          const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _itemOfPost(Post post){
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(),
          //# User info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: const Image(image: AssetImage('assets/images/ic_person.png'),
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const Gap(10),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Asliddin Ummatov',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const Gap(3),
                        Text('21.05.2024  18:24',
                          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade600),
                        )
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: (){
                  },
                ),
              ],
            ),
          ),
          const Gap(8),
          //#Post image
          CachedNetworkImage(
            cacheKey: post.imgPost.toString(),
            useOldImageOnUrlChange: true,
            width: MediaQuery.sizeOf(context).width,
            // height: MediaQuery.sizeOf(context).width,
            imageUrl: post.imgPost.toString(),
            placeholder: (context, url) =>const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
            ),
          //#like share
          Row(
            children: [
              IconButton(
                onPressed: (){
                },
                icon: const Icon(EvaIcons.heartOutline),
                color: Colors.red,
              ),
              IconButton(
                onPressed: (){
                },
                icon: const Icon(EvaIcons.shareOutline),
              ),
            ],
          ),
          //#Caption
          Container(
            width: MediaQuery.sizeOf(context).width,
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                text: '${post.caption}',
                style: const TextStyle(color: Colors.black)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
