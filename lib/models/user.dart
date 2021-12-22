class LocalUser {
  late String uid;
  late String username;
  late String phone;
  String image = "";

  LocalUser(String uid, String username, String phone){
    this.uid = uid;
    this.username = username;
    this.phone = phone;
  }

  void setImage(String image){
    this.image = image;
  }
}