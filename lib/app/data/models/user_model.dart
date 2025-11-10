import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 3)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String gender;

  @HiveField(3)
  String email;

  @HiveField(4)
  String username;

  @HiveField(5)
  String? phoneNUmber;

  @HiveField(6)
  String? nickName;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.gender,
    this.phoneNUmber,
    this.nickName,
  });
}
