class UserModel {
  String uid;
  String userName;
  String userEmail;
  String userType;

  UserModel(
      {required this.uid,
      required this.userName,
      required this.userEmail,
      required this.userType});

  factory UserModel.fromFirestore(dynamic map) {
    return UserModel(
        uid: map['uid'],
        userName: map['userName'],
        userEmail: map['userEmail'],
        userType: map['userType']);
  }
  Map<String,dynamic> toFirestore(){
    return {
      'uid' : uid,
      'userName' : userName,
      'userEmail' : userEmail,
      'userType' : userType,
    };
  }
}
