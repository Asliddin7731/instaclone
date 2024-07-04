import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/model/post_model.dart';
import 'package:instaclone/service/db_service.dart';
import 'package:instaclone/service/file_service.dart';

class UploadPage extends StatefulWidget {
  final PageController? pageController;
  const UploadPage({super.key, this.pageController});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  bool isLoading = false;
  var captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  _uploadNewPost(){
    String caption = captionController.text.trim();
    if(caption.isEmpty) return;
    if(_image == null) return;
    _apiPostImage();
  }

  void _apiPostImage(){
    setState(() {
      isLoading = true;
    });
    FileService.uploadPostImage(_image!).then((downloadUrl) => {
      _resPostImage(downloadUrl),
    });
  }

  void _resPostImage(String downloadUrl){
    String caption = captionController.text.trim();
    Post post = Post(caption, downloadUrl);
    apiStorePost(post);
  }

  void apiStorePost(Post post) async{
    // Post to post
    Post posted = await DBService.storePost(post);
    //Post to Feed
    DBService.storeFeed(posted).then((value) => {
      _moveToFeed()
    });
  }

  _moveToFeed(){
    setState(() {
      isLoading = false;
    });
    captionController.text = '';
    _image = null;
    widget.pageController!.animateToPage(
        0, duration: const Duration(microseconds: 200),
        curve: Curves.easeIn);
  }

  void _gestureTap(){
    showModalBottomSheet(
      shape: LinearBorder.top(),
        context: context,
        builder: (BuildContext context){
          return SizedBox(
            height: 140,
            child: Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      _imgFromGallery();
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(15),
                      height: 50,
                      width: MediaQuery.sizeOf(context).width,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.photo_library, color: Colors.grey,),
                          Gap(20),
                          Text('Pick Photo')
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      _imgFromCamera();
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(15),
                      height: 50,
                      width: MediaQuery.sizeOf(context).width,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.camera_alt, color: Colors.grey,),
                          Gap(20),
                          Text('Take Photo')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
  }
  _imgFromCamera()async{
    XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Upload', style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: (){
              _uploadNewPost();
            },
            icon: const Icon(Icons.drive_folder_upload),
            color: const Color.fromRGBO(193, 53, 132, 1),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      if (_image != null) return;
                      _gestureTap();
                    },
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).width,
                      color: Colors.grey.withOpacity(0.4),
                      child: _image == null ?
                      const Center(
                        child: Icon(Icons.add_a_photo, size: 50,color: Colors.grey,),
                      ): Stack(
                        children: [
                          Image.file(_image!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(icon: const Icon(Icons.highlight_remove),
                                color: Colors.white,
                                onPressed: () {
                                setState(() {
                                  _image = null;
                                });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: TextField(
                      controller: captionController,
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Caption',
                        hintStyle: TextStyle(fontSize: 17, color: Colors.black38),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          isLoading? const Center(
            child: CircularProgressIndicator(),
          ): const SizedBox.shrink(),
        ],
      ),
    );
  }
}
