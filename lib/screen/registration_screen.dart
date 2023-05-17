import 'package:every_parking/datasource/datasource.dart';
import 'package:every_parking/screen/home_screen.dart';
import 'package:every_parking/screen/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterCarScreen extends StatefulWidget {
  final String userId;
  const RegisterCarScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<RegisterCarScreen> createState() => _RegisterCarScreen();
}
/* 등록 페이지 */
class _RegisterCarScreen extends State<RegisterCarScreen> {

  var isChecked = [false, false, false]; /* 약관 */
  var carNumber; /* 차량 번호 */
  var modelName; /* 차량 모델 */

  var ds = new Datasource();
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
                            "차량등록",
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
                                        carNumber = text;
                                      });
                                    },
                                    //차량번호 입력되는 칸
                                    decoration:
                                    InputDecoration(labelText: '차량번호'),
                                    keyboardType: TextInputType.text,
                                  ),

                                  TextField(
                                    onChanged: (text) {
                                      setState(() {
                                        modelName = text;
                                      });
                                    },
                                    //실소유주가 입력되는 칸
                                    decoration:
                                    InputDecoration(labelText: '모델명'),
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
                                                value: isChecked[0],
                                                onChanged: (value) {
                                                  setState(() {
                                                    isChecked[0] = value!;
                                                  });
                                                }),
                                            Text("이용약관"),
                                          ],
                                        ),
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
                                        Row(
                                          children: [
                                            Checkbox(
                                                value: isChecked[2],
                                                onChanged: (value) {
                                                  setState(() {
                                                    isChecked[2] = value!;
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
                                          child: const Text("등록"),
                                          onPressed: () {
                                            ds.carRegister(widget.userId ,carNumber, modelName);
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
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MainScreen(userId: widget.userId)
                                                    ));
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

