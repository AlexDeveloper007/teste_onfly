class UserModel{

  String? id;
  String? login;
  String? userName;
  String? token;

  UserModel();

  UserModel.map(Map<String, dynamic> json) {
    id = json["record"]['id'] ?? "";
    userName = json["record"]['username'] ?? "";
    token = json['token'] ?? "";
  }

  @override
  String toString() {
    return 'UserModel{id: $id, userName: $userName, token: $token}';
  }
}