enum UserPermission { admin, contributor, viewer }

class UserModel {
  final String fullName;
  final String email;
  final DateTime joined;
  final UserPermission permission;

  const UserModel({
    required this.fullName,
    required this.email,
    required this.joined,
    required this.permission,
  });
}
