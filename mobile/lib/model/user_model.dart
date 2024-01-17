import 'dart:convert';

class UserModel {
  String? id;
  String? fullname;
  List? faceCode;

  UserModel({
    this.id,
    this.fullname,
    this.faceCode,
  });

  UserModel.fromMap(Map<String, dynamic> user) {
    id = user['id'];
    fullname = user['fullname'];
    faceCode = jsonDecode(user['faceCode']);
  }
}