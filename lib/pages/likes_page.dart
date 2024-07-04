import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:instaclone/service/db_service.dart';

import '../model/post_model.dart';
import '../service/utils_service.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {

  bool isLoading = false;
  List<Post> items = [];

  void _apiLoadLike(){
    setState(() {
      isLoading = true;
    });
    DBService.loadLikes().then((value) => {
      _resLoadPost(value)
    });
  }

  void _resLoadPost(List<Post>posts){
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  void _apiPostUnlike(Post post){
    setState(() {
      isLoading = true;
      post.liked = false;
    });
    DBService.likePost(post, false).then((value) => {
      _apiLoadLike()
    });
  }

  _dialogRemovePost (Post post)async{
    var result = await Utils.dialogCommon(context, 'Insta Clone', 'Do you want to delete this post', false);
    if (result != null && result){
      setState(() {
        isLoading = true;
      });
      DBService.removePost(post).then((value) => {
        _apiLoadLike()
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _apiLoadLike();
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
      ),
      body: Stack(
        children: [
          ListView.builder(
            cacheExtent: 999,
            itemCount: items.length,
            itemBuilder: (ctx, index){
              return _itemOfPost(items[index]);
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
                      child:post.imgUser.isEmpty ? const Image(image: AssetImage('assets/images/ic_person.png'),
                        width: 40,
                        height: 40,
                      ): Image.network(post.imgUser, width: 40, height: 40, fit: BoxFit.cover,)
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(post.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const Gap(3),
                        Text(post.date,
                          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade600),
                        )
                      ],
                    ),
                  ],
                ),
                post.mine ? IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: (){
                    _dialogRemovePost(post);
                  },
                ) : const SizedBox.shrink()
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
                  _apiPostUnlike(post);
                },
                icon: post.liked ? const Icon(EvaIcons.heart,
                color: Colors.red,
                ) : const Icon(EvaIcons.heartOutline,
                  color: Colors.black,
                ),
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
                  text: post.caption,
                  style: const TextStyle(color: Colors.black)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
