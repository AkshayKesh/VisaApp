// User domain model based on the provided response

class User {
  final String? id;
  final String? stripeCustomerId;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? password;
  final String? profilePic;
  final String? googleId;
  final String? authToken;
  final bool? isActive;

  User({
    this.id,
    this.stripeCustomerId,
    this.fullName,
    this.email,
    this.phone,
    this.password,
    this.profilePic,
    this.googleId,
    this.authToken,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String?,
      stripeCustomerId: json['stripeCustomerId'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      profilePic: json['profilePic'] as String?,
      googleId: json['googleId'] as String?,
      authToken: json['authToken'] as String?,
      isActive: json['isActive'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'stripeCustomerId': stripeCustomerId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'profilePic': profilePic,
      'googleId': googleId,
      'authToken': authToken,
      'isActive': isActive,
    };
  }
}



class SignupData {
  final User? user;
  final String? authToken;

  SignupData({this.user, this.authToken});

  factory SignupData.fromJson(Map<String, dynamic> json) {
    return SignupData(
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      authToken: json['authToken'] as String?,
    );
  }
}
