class ChangePasswordModel {
  final int statusCode;
  final String message;
  final ChangePasswordData data;

  ChangePasswordModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: ChangePasswordData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ChangePasswordData {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String profilePic;
  final String? googleId;
  final String authToken;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  ChangePasswordData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.profilePic,
    this.googleId,
    required this.authToken,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChangePasswordData.fromJson(Map<String, dynamic> json) {
    return ChangePasswordData(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      profilePic: json['profilePic'] ?? '',
      googleId: json['googleId'],
      authToken: json['authToken'] ?? '',
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'profilePic': profilePic,
      'googleId': googleId,
      'authToken': authToken,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
