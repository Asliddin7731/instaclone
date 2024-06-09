//
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:instaclone/model/member_model.dart';
// import 'package:instaclone/service/auth_service.dart';
// import 'package:instaclone/service/utils_service.dart';
//
// class DBService{
//   static final _firestore = FirebaseStorage.instance;
//
//   static String folderUsers = 'users';
//
//   static Future storeMember(Member member)async {
//     member.uid = AuthService.currentUserId();
//     Map<String,String> params = await Utils.deviceParams();
//     print(params.toString());
//
//     member.deviceId = params['deviceId']!;
//     member.deviceType = params['deviceType']!;
//     member.deviceToken = params['deviceToken']!;
//
//     return _firestore.collection(folderUsers)
//         .doc(member.uid)
//         .set(member.toJson());
//   }
// }