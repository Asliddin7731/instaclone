import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/model/member_model.dart';
import 'package:instaclone/router/app_router.dart';
import 'package:instaclone/service/auth_service.dart';
import 'package:instaclone/service/db_service.dart';
import 'package:instaclone/service/file_service.dart';

import '../model/post_model.dart';
import '../service/utils_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  int axisCount = 1;
  List<Post> items = [];
  File? _image;
  String fullName = '', email = '', imageUrl = '';
  int countPost = 0, countFollowers = 0, countFollowing = 0;

  final ImagePicker _picker = ImagePicker();

  _apiLoadPosts(){
    DBService.loadPosts().then((value) => {
      _resLoadPosts(value)
    });
  }

  _resLoadPosts(List<Post> posts){
    setState(() {
      items = posts;
      countPost = posts.length;
    });
  }

  _dialogRemovePost (Post post)async{
    var result = await Utils.dialogCommon(context, 'Insta Clone', 'Do you want to delete this post', false);
    if (result != null && result){
      setState(() {
        isLoading = true;
      });
      DBService.removePost(post).then((value) => {
        _apiLoadPosts()
      });
    }
  }

  _dialogLogout ()async{
    var result = await Utils.dialogCommon(context, 'Insta Clone', 'Do you want to logout', false);
    if (result != null ){
      setState(() {
        isLoading = true;
      });
      AuthService.signOutUser(context);
      context.pushReplacement(RouteNames.signIn);
    }
  }

  @override
  void initState() {
    super.initState();
    _apiLoadMember();
    _apiLoadPosts();
  }

  _apiUpdateUser(String downloadUrl) async{
    Member member = await DBService.loadMember();
    member.imageUrl = downloadUrl;
    await DBService.updateMember(member);
    _apiLoadMember();
  }

  void _showPicker(){
    showModalBottomSheet(
     context: context,
     builder: (BuildContext context ){
       return SafeArea(
         child: Wrap(
           children: [
             ListTile(
               leading: const Icon(Icons.photo_library),
               title: const Text('Pick Photo'),
               onTap: (){
                 _imgFromGallery();
                 Navigator.of(context).pop();
               },
             ),
             ListTile(
               leading: const Icon(Icons.photo_camera),
               title: const Text('Take Photo'),
               onTap: (){
                 _imgFromCamera();
                 Navigator.of(context).pop();
               },
             ),
           ],
         ),
       );
     }

    );
  }

  _imgFromGallery()async{
    XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
    _apiChengPhoto();
  }
  _imgFromCamera()async{
    XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
    _apiChengPhoto();
  }

  void _apiChengPhoto(){
    setState(() {
      isLoading = true;
    });

    FileService.uploadUserImage(_image!).then((downloadUrl) => {
      _apiUpdateUser(downloadUrl)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(
          color: Colors.black, fontFamily: 'Billabong', fontSize: 25)
        ),
        actions: [
          IconButton(
            onPressed: (){
              _dialogLogout();
            },
            icon: const Icon(Icons.exit_to_app),
            color: const Color.fromRGBO(193, 53, 132, 1),

          )
        ],
      ),
      body:Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                //#My photo
                GestureDetector(
                  onTap: (){
                    _showPicker();
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          border: Border.all(
                            width: 1.5,
                            color: const Color.fromRGBO(193, 53, 132, 1),
                          )
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: imageUrl.isEmpty
                              ? const Image(
                            image: AssetImage('assets/images/ic_person.png'),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          )
                              : Image.network(imageUrl,
                            width: 70,
                            height:70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                        width: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(Icons.add_circle, color: Colors.purple,),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //#My info
                const Gap(10),
                Text(fullName.toUpperCase(), style: const TextStyle(
                    color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Gap(3),
                Text(email, style: const TextStyle(
                    color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  height: 65,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(countPost.toString(), style: const TextStyle(
                                color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                            const Text('POSTS', style: TextStyle(
                                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        width: 3,
                        indent: 12,
                        endIndent: 28,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(countFollowers.toString(), style: const TextStyle(
                                color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                            const Text('FOLLOWERS', style: TextStyle(
                                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        indent: 12,
                        endIndent: 28,
                        width: 3,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(countFollowing.toString(), style: const TextStyle(
                                color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                             const Text('FOLLOWING', style: TextStyle(
                                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: (){
                          setState(() {
                            axisCount = 1;
                          });
                        },
                        icon: const Icon(Icons.list_alt,size: 25,color: Colors.black87,),
                      ),
                      IconButton(
                        onPressed: (){
                          setState(() {
                            axisCount = 2;
                          });
                        },
                        icon: const Icon(Icons.grid_view, size: 25, color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                //#My posts
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: axisCount),
                    itemCount: items.length,
                    itemBuilder: (ctx, index) {
                      return _itemOfPost(items[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _apiLoadMember(){
    setState(() {
      isLoading = true;
    });
    DBService.loadMember().then((value) => {
      _showMemberInfo(value),
    });
  }

  void _showMemberInfo(Member member) {
    setState(() {
      isLoading = true;
      fullName = member.fullName;
      email = member.email;
      imageUrl = member.imageUrl;
      countFollowers = member.followersCount;
      countFollowing = member.followingCount;
    });
  }

  Widget _itemOfPost(Post post){
    return
      GestureDetector(
        onLongPress: (){
          _dialogRemovePost(post);
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                child: CachedNetworkImage(
                  width: double.infinity,
                  imageUrl: post.imgPost.toString(),
                  placeholder: (context, url)=> const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error)=> const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              const Gap(5),
              Text(post.caption.toString(), style: TextStyle(color: Colors.black87.withOpacity(0.7)),
              maxLines: 2,
              ),
            ],
          ),
        ),
      );
  }
}
