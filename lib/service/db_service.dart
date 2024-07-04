import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instaclone/model/member_model.dart';
import 'package:instaclone/model/post_model.dart';
import 'package:instaclone/service/auth_service.dart';
import 'package:instaclone/service/utils_service.dart';

class DBService {
  static final _firestore = FirebaseFirestore.instance;

  static String folderUsers = 'users';
  static String folderPosts = 'posts';
  static String folderFeeds = 'feeds';
  static String folderFollowing = 'following';
  static String folderFollowers = 'followers';

  /*
  * Member Relate
   */

  static Future storeMember(Member member) async {
    member.uid = AuthService.currentUserId();
    Map<String, String> params = await Utils.deviceParams();
    if (kDebugMode) {
      print(params.toString());
    }

    member.deviceId = params['deviceId']!;
    member.deviceType = params['deviceType']!;
    member.deviceToken = params['deviceToken']!;

    return _firestore
        .collection(folderUsers)
        .doc(member.uid)
        .set(member.toJson());
  }

  static Future<Member> loadMember() async {
    String uid = AuthService.currentUserId();
    var value = await _firestore.collection(folderUsers).doc(uid).get();
    Member member = Member.fromJson(value.data()!);

    var querySnapshot1 = await _firestore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderFollowing)
        .get();
    member.followingCount = querySnapshot1.docs.length;

    var querySnapshot2 = await _firestore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderFollowers)
        .get();
    member.followersCount = querySnapshot2.docs.length;
    return member;
  }

  static Future<void> updateMember(Member member) async {
    String uid = AuthService.currentUserId();
    await _firestore.collection(folderUsers).doc(uid).update(member.toJson());
  }

  static Future<List<Member>> searchMembers(String keyword) async {
    List<Member> members = [];
    String uid = AuthService.currentUserId();

    var querySnapshot = await _firestore
        .collection(folderUsers)
        .orderBy('email')
        .startAt([keyword]).get();
    if (kDebugMode) {
      print(querySnapshot.docs.length);
    }

    for (var result in querySnapshot.docs) {
      Member newMember = Member.fromJson(result.data());
      if (newMember.uid != uid) {
        members.add(newMember);
      }
    }

    return members;
  }

/*
  * Member Relate
   */
  static Future<Post> storePost(Post post) async {
    Member me = await loadMember();
    post.uid = me.uid;
    post.fullName = me.fullName;
    post.imgUser = me.imageUrl;
    post.date = Utils.currentDate();

    String postId = _firestore
        .collection(folderUsers)
        .doc(me.uid)
        .collection(folderPosts)
        .doc()
        .id;
    post.id = postId;

    await _firestore
        .collection(folderUsers)
        .doc(me.uid)
        .collection(folderPosts)
        .doc(postId)
        .set(post.toJson());

    return post;
  }

  static Future<Post> storeFeed(Post post) async {
    String uid = AuthService.currentUserId();
    await _firestore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderFeeds)
        .doc(post.id)
        .set(post.toJson());

    return post;
  }

  static Future removeFeed(Post post) async {
    String uid = AuthService.currentUserId();
    return await _firestore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderFeeds)
        .doc(post.id)
        .delete();
  }
  static Future removePost(Post post) async {
    String uid = AuthService.currentUserId();
    await removeFeed(post);
    return await _firestore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderPosts)
        .doc(post.id)
        .delete();
  }



  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];
    String uid = AuthService.currentUserId();
    var querySnapshot = await _firestore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderPosts)
        .get();

    for (var result in querySnapshot.docs) {
      posts.add(Post.fromJson(result.data()));
    }

    return posts;
  }

  static Future<List<Post>> loadFeeds() async {
    List<Post> posts = [];
    String uid = AuthService.currentUserId();
    var querySnapshot = await _firestore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderFeeds)
        .get();

    for (var result in querySnapshot.docs) {
      Post post = Post.fromJson(result.data());
      if(post.uid == uid) post.mine = true;
      posts.add(post);
    }

    return posts;
  }

  static Future likePost(Post post, bool liked) async {
    String uid = AuthService.currentUserId();
    post.liked = liked;

    await _firestore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderFeeds)
        .doc(post.id)
        .set(post.toJson());

    if (uid == post.uid) {
      await _firestore
          .collection(folderUsers)
          .doc(uid)
          .collection(folderPosts)
          .doc(post.id)
          .set(post.toJson());
    }
  }

  static Future<List<Post>> loadLikes() async {
    String uid = AuthService.currentUserId();
    List<Post> posts = [];

    var querySnapshot = await _firestore
        .collection(folderUsers)
        .doc(uid)
        .collection(folderFeeds)
        .where('liked', isEqualTo: true)
        .get();

    for (var result in querySnapshot.docs) {
      Post post = Post.fromJson(result.data());
      if (post.uid == uid) post.mine = true;
      posts.add(post);
    }
    return posts;
  }

  static Future<Member> followMember(Member someone) async {
    Member me = await loadMember();

    // I followed to someone
    await _firestore
        .collection(folderUsers)
        .doc(me.uid)
        .collection(folderFollowing)
        .doc(someone.uid)
        .set(someone.toJson());

    // I am in someone's followers
    await _firestore
        .collection(folderUsers)
        .doc(someone.uid)
        .collection(folderFollowers)
        .doc(me.uid)
        .set(me.toJson());

    return someone;
  }

  static Future<Member> unFollowMember(Member someone) async {
    Member me = await loadMember();

    // I un followed to someone
    await _firestore
        .collection(folderUsers)
        .doc(me.uid)
        .collection(folderFollowing)
        .doc(someone.uid)
        .delete();

    // I am not in someone's followers
    await _firestore
        .collection(folderUsers)
        .doc(someone.uid)
        .collection(folderFollowers)
        .doc(me.uid)
        .delete();

    return someone;
  }

  static Future storePostsMyFeed(Member someone) async {
    List<Post> posts = [];

    var querySnapshot = await _firestore
        .collection(folderUsers)
        .doc(someone.uid)
        .collection(folderPosts)
        .get();
    for (var result in querySnapshot.docs) {
      var post = Post.fromJson(result.data());
      post.liked = false;
      posts.add(post);

      for (Post post in posts) {
        storeFeed(post);
      }
    }
  }

  static Future removePostsMyFeed(Member someone) async {
    List<Post> posts = [];
    var querySnapshot = await _firestore
        .collection(folderUsers)
        .doc(someone.uid)
        .collection(folderPosts)
        .get();
    for (var result in querySnapshot.docs) {
      var post = Post.fromJson(result.data());
      post.liked = false;
      posts.add(post);
    }

    for (Post post in posts) {
      removeFeed(post);
    }
  }
}
