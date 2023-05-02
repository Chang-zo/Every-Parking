
//String id, String pass, String s_number, String s_name

class User {
  int studentId;
  late String studentName;
  String userId;
  String password;
  int phoneNumber;
  String email;
  late bool status;

  User({
    this.studentId = 0,
    required this.studentName,
    this.userId = '',
    this.password = '',
    this.phoneNumber = 0,
    this.email = '',
    required this.status ,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      studentName : json['studentName'],
      status : json['status']
    );
  }
}