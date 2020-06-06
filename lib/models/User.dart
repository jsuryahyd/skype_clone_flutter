class User {
  String uid;
  String name;
  String email;
  String userName;
  String status;
  String state;
  String profilePhoto;

  User({
    this.uid,
    this.name,
    this.email,
    this.userName,
    this.status,
    this.state,
    this.profilePhoto,
  });

  toMap() {
    final data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['email'] = this.email;
    data['userName'] = this.userName;
    data['status'] = this.status;
    data['state'] = this.state;
    data['profilePhoto'] = this.profilePhoto;
    return data;
  }

  User.fromMap(userMap){
    this.uid = userMap['uid'];
    this.name = userMap['name'];
    this.email = userMap['email'];
    this.userName = userMap['userName'];
    this.status = userMap['status'];
    this.state = userMap['state'];
    this.profilePhoto = userMap['profilePhoto'];
  }
}
