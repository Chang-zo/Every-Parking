import 'package:every_parking/datasource/APIUrl.dart';
import 'package:flutter/material.dart';
import 'package:every_parking/screen/sign_up_screen.dart';

import '../datasource/datasource.dart';
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

  var datasource = new Datasource();

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
                                  keyboardType: TextInputType.emailAddress,
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
                                              //로그인 버튼을 눌렀을 때 작동될 코드
                                              //정보가 맞다면
                                              //홈 화면으로 이동
                                              //정보가 틀리다면
                                              //틀렸다고 팝업 띄우기
                                              /* 서버와 로그인 통신 .. 성공 -> true / 실패 -> false */
                                              bool check = await datasource.loginUser(id, pass);
                                              print(check);

                                              if (check) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            MainScreen(userId: id,)));
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible:
                                                        true, // 바깥 영역 터치시 닫을지 여부
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: const Text(
                                                            "아이디와 비밀번호를 입력해 주세요"),
                                                        insetPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 80, 0, 80),
                                                        actions: [
                                                          TextButton(
                                                            child: const Text(
                                                                '확인'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              }
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
