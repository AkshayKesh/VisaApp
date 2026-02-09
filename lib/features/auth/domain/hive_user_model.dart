import 'package:hive/hive.dart';

part 'hive_user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String token;

  @HiveField(4)
  final String phoneNumber;
  @HiveField(5)
  final String profilePic;

  UserModel({required this.id, required this.name, required this.email, required this.token, required this.phoneNumber, required this.profilePic});
}
