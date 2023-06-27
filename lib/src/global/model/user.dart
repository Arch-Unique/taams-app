class User {
  String school;
  String regno;
  String firstname;
  String surname;
  String role;
  String email;

  User({
    required this.school,
    required this.regno,
    required this.firstname,
    required this.surname,
    required this.role,
    required this.email,
  });

  String get fullName => "$firstname $surname";

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      school: json['SchoolId'],
      regno: json['regno'],
      firstname: json['firstname'],
      surname: json['surname'],
      role: json['role'],
      email: json['email'],
    );
  }
}
