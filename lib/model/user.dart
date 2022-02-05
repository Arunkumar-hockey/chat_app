class UserInfoList {
  String id;
  String email;

  UserInfoList({
    required this.id,
    required this.email
});

  Map<String, dynamic> toJson() => {
    'id': id,
  'email': email
  };

  static UserInfoList fromJson(Map<String, dynamic> json) => UserInfoList(
      id: json['id'],
      email: json['email']);
}