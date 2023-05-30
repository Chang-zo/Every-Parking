import 'dart:convert';

import 'package:every_parking/datasource/APIUrl.dart';
import 'package:every_parking/datasource/datasource.dart';
import 'package:flutter/material.dart';
import 'package:every_parking/screen/sign_up_screen.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'main_screen.dart';

//로그 인 후에는 앱 켤떄 안보이게 하기
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LogInState();
}

class _LogInState extends State<LoginScreen> {
  var id = "";
  var pass = "";

  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';

  var userId;
  var userpass;
  //flutter_secure_storage 사용을 위한 초기화 작업
  @override
  void initState() {
    super.initState();

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key: 'login');
    print(userInfo);

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      print('로그인이 정보가 존재합니다.');
      try {
        var parsedJson = json.decode(userInfo);
        userId = parsedJson['userId'];
        userpass = parsedJson['password'];

        int result = await Datasource().loginUser(userId, userpass);
        print(result);

        if (result == 200) {
          print("로컬데이터 로그인성공");
          id = userId;
          print(userInfo);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(
                        userId: userId,
                        index: 0,
                      )));
        } else {
          print("로컬데이터 로그인실패");
        }
      } catch (e) {
        print("로컬 데이터로 로그인중 예외발생");
      }
    } else {
      print('로그인이 필요합니다');
    }
  }

  loginAction(id, pass) async {
    try {
      int login_result = await Datasource().loginUser(id, pass);

      if (login_result == 200) {
        var val = json.encode({'userId': id, 'password': pass});

        await storage.write(
          key: 'login',
          value: val,
        );

        print("로그인 성공!!!!!!!");
        print(id);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreen(
                      userId: id,
                      index: 0,
                    )));
        print(id);
      } else if (login_result == 400) {
        print("아이디 혹은 비번 오류");
        showDialog(
            context: context,
            barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text("아이디와 비밀번호를 확인해 주세요"),
                insetPadding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
                actions: [
                  TextButton(
                    child: const Text('확인'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      } else {
        print("로그인 실패");
        showDialog(
            context: context,
            barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text("회원가입을 진행해주세요."),
                insetPadding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
                actions: [
                  TextButton(
                    child: const Text('확인'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
    } catch (e) {
      print("로그인 catch문 실행");
      showDialog(
          context: context,
          barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text("회원가입을 진행해주세요"),
              insetPadding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
              actions: [
                TextButton(
                  child: const Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0xff, 0x49, 0x7a, 0xa6),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.95,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 8), // changes position of shadow
                        ),
                      ]),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Text(
                          "로그인",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Form(
                        child: Theme(
                          data: ThemeData(
                            primaryColor:
                                Color.fromARGB(0xff, 0x49, 0x7a, 0xa6),
                            inputDecorationTheme: const InputDecorationTheme(
                                labelStyle: TextStyle(
                                    color:
                                        Color.fromARGB(0xff, 0x49, 0x7a, 0xa6),
                                    fontSize: 15.0)),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                TextField(
                                  onChanged: (text) {
                                    setState(() {
                                      id = text;
                                    });
                                  },
                                  //아이디가 입력되는 칸
                                  decoration: InputDecoration(labelText: 'ID'),
                                  keyboardType: TextInputType.text,
                                ),
                                TextField(
                                  onChanged: (text) {
                                    setState(() {
                                      pass = text;
                                    });
                                  },
                                  //비밀번호가 입력되는 칸
                                  decoration:
                                      InputDecoration(labelText: 'Password'),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                ),
                                const SizedBox(
                                  height: 40.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ButtonTheme(
                                        // 로그인 버튼
                                        minWidth: 150.0,
                                        height: 50.0,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                textStyle:
                                                    MaterialStateProperty.all(
                                                        const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white)),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Color.fromARGB(0xff,
                                                            0x49, 0x7a, 0xa6))),
                                            child: const Text("Log in"),
                                            onPressed: () async {
                                              loginAction(id, pass);
                                            })),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    ButtonTheme(
                                        // 회원가입 버튼
                                        minWidth: 150.0,
                                        height: 50.0,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                textStyle:
                                                    MaterialStateProperty.all(
                                                        const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white)),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Color.fromARGB(0xff,
                                                            0x49, 0x7a, 0xa6))),
                                            child: const Text("Sign up"),
                                            onPressed: () {
                                              //회원가입 화면으로 넘어가기
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SignUpUserScreen()),
                                              );
                                            })),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
