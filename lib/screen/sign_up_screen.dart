import 'package:every_parking/datasource/datasource.dart';
import 'package:every_parking/screen/registration_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//회원가입 화면
//로그 인 후에는 앱 켤떄 안보이게 하기
class SignUpUserScreen extends StatefulWidget {
  const SignUpUserScreen({Key? key}) : super(key: key);

  @override
  State<SignUpUserScreen> createState() => _SignUpUserScreen();
}

class _SignUpUserScreen extends State<SignUpUserScreen> {
  String id = "";
  String email = "";
  String pass = "";
  int s_number = 0;
  String u_name = "";
  int phone_num = 0;

  var isChecked = [false, false, false, false];
  var datasource = new Datasource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0xff, 0x49, 0x7a, 0xa6),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80.0),
            child: FractionallySizedBox(
              widthFactor: 0.95,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
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
                            "살려줘",
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
                                      color: Color.fromARGB(
                                          0xff, 0x49, 0x7a, 0xa6),
                                      fontSize: 15.0)),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(30.0),
                              child: Column(
                                children: [
                                  TextField(
                                    onChanged: (text) {
                                      setState(() {
                                        s_number = int.parse(text);
                                      });
                                    },
                                    //학번 입력되는 칸
                                    decoration:
                                        InputDecoration(labelText: '학번'),
                                    keyboardType: TextInputType.text,
                                  ),
                                  TextField(
                                    onChanged: (text) {
                                      setState(() {
                                        u_name = text;
                                      });
                                    },
                                    //이름 입력되는 칸
                                    decoration:
                                        InputDecoration(labelText: '이름'),
                                    keyboardType: TextInputType.text,
                                  ),
                                  TextField(
                                    onChanged: (text) {
                                      setState(() {
                                        id = text;
                                      });
                                    },
                                    //아이디가 입력되는 칸
                                    decoration:
                                        InputDecoration(labelText: '아이디'),
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
                                        InputDecoration(labelText: '비밀번호'),
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                  ),
                                  TextField(
                                    onChanged: (text) {
                                      setState(() {
                                        phone_num = int.parse(text);
                                      });
                                    },
                                    //전화번호 입력되는 칸
                                    decoration:
                                        InputDecoration(labelText: '전화번호'),
                                    keyboardType: TextInputType.text,
                                  ),
                                  TextField(
                                    onChanged: (text) {
                                      setState(() {
                                        email = text;
                                      });
                                    },
                                    //이메일 입력되는 칸
                                    decoration:
                                        InputDecoration(labelText: '이메일'),
                                    keyboardType: TextInputType.text,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                                value: isChecked[1],
                                                onChanged: (value) {
                                                  setState(() {
                                                    isChecked[1] = value!;
                                                  });
                                                }),
                                            Text("이용약관"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ButtonTheme(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        // 로그인 버튼
                                        minWidth: 100.0,
                                        height: 50.0,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              textStyle:
                                                  MaterialStateProperty.all(
                                                      const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color.fromARGB(0xff, 0x49,
                                                          0x7a, 0xa6))),
                                          child: const Text("가입"),
                                          onPressed: () async {
                                            if (id == "" ||
                                                email == "" ||
                                                pass == "" ||
                                                s_number == 0 ||
                                                u_name == "" ||
                                                phone_num == 0) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: const Text(
                                                        "빈 항목을 채워주세요"),
                                                    insetPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            0, 80, 0, 80),
                                                    actions: [
                                                      TextButton(
                                                        child: const Text('확인'),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              int result =
                                                  await datasource.registerUser(
                                                      s_number,
                                                      u_name,
                                                      id,
                                                      pass,
                                                      phone_num,
                                                      email);
                                              print(result);
                                              if (result == 200) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: const Text(
                                                          "가입에 성공하였습니다."),
                                                      insetPadding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              0, 80, 0, 80),
                                                      actions: [
                                                        TextButton(
                                                          child: const Text(
                                                              '차량등록하러가기'),
                                                          onPressed: () {
                                                            Navigator
                                                                .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      RegisterCarScreen(
                                                                          userId:
                                                                              id)),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else if (result == 400) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: const Text(
                                                          "이미 등록된 아이디입니다.\n다시 시도해주세요"),
                                                      insetPadding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              0, 80, 0, 80),
                                                      actions: [
                                                        TextButton(
                                                          child:
                                                              const Text('확인'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                /* 회원가입 실패 시 */
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: const Text(
                                                          "잠시후 다시 시도해주세요"),
                                                      insetPadding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              0, 80, 0, 80),
                                                      actions: [
                                                        TextButton(
                                                          child:
                                                              const Text('확인'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      ButtonTheme(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      50), //모서리
                                              side: BorderSide(
                                                  color: Color.fromARGB(
                                                      0xff, 0x49, 0x7a, 0xa6))),
                                          // 뒤로 버튼
                                          minWidth: 100.0,
                                          height: 50.0,
                                          child: OutlinedButton(
                                              style: ButtonStyle(
                                                  textStyle:
                                                      MaterialStateProperty.all(
                                                          const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black12)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white)),
                                              child: const Text("뒤로"),
                                              onPressed: () {
                                                //회원가입 화면으로 넘어가기
                                                Navigator.pop(context);
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
      ),
    );
  }
}
