// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
enum UserRole { //Define at least two user roles
  admin,
  user,
  creator,
  guest
}

class UserModel {
  final String id;
  final String userImage;
  final String name;
  final String email;
  final UserRole role; // Updated parameter type to UserRole enum
  bool emailVerified;

  UserModel({
    this.emailVerified = false,
    required this.id,
    this.userImage =
        'https://w7.pngwing.com/pngs/831/88/png-transparent-user-profile-computer-icons-user-interface-mystique-miscellaneous-user-interface-design-smile-thumbnail.png',
    required this.name,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'userImage': userImage});
    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'role': role.toString().split('.').last}); // Convert enum to String
    result.addAll({'emailVerified': emailVerified});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      userImage: map['userImage'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: UserRole.values.firstWhere(
          (role) => role.toString() == 'UserRole.${map['role']}'), // Convert String to enum
      emailVerified: map['emailVerified'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? id,
    String? userImage,
    String? name,
    String? email,
    UserRole? role,
    bool? emailVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      userImage: userImage ?? this.userImage,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
}
