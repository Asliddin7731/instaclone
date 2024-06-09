class Member{
  String uid = '';
  String fullName = '';
  String email = '';
  String password = '';
  String imageUrl = '';

  String deviceId = '';
  String deviceType = '';
  String deviceToken = '';

  Member.fromJson(Map<String, dynamic>json)
  :     uid = json['uid'],
        fullName = json['fullName'],
        email = json['email'],
        password = json['password'],
        imageUrl = json['imageUrl'],

        deviceId = json['deviceId'],
        deviceType = json['deviceType'],
        deviceToken = json['deviceToken'];

  Member(this.fullName, this.email);

  Map<String, dynamic>toJson() =>{
    'uid': uid,
    'fullName': fullName,
    'email':email,
    'password':password,
    'imageUrl':imageUrl,
    'deviceId':deviceId,
    'deviceType':deviceType,
    'deviceToken':deviceToken
  };
}