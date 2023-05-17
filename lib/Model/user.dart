//String id, String pass, String s_number, String s_name

class User {
  String? studentName;
  bool? status;

  User({
    this.studentName,
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(studentName: json['studentName'], status: json['status']);
  }
}
