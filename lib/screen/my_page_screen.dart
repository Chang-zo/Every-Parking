import 'dart:convert';

import 'package:every_parking/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Model/user.dart';
import '../datasource/datasource.dart';

class MyPageScreen extends StatefulWidget {
  final String userId;
  const MyPageScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';

  var ds = Datasource();
  var user = User(studentName: '', status: false);
  String carNum = "";
  String carName = "";

  @override
  void initState() {
    super.initState();
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserState();
    });
    _getUserInfo();
    carInfo();
  }

  Future<void> _getUserInfo() async {
    try {
      print("유저 가져오기 시도");
      User userInfo = await ds.userInfo(widget.userId);
      print("유저정보 가져오기 try문");
      print(widget.userId);
      print(userInfo.studentName);
      setState(() {
        user.studentName = userInfo.studentName;
        user.status = userInfo.status;
      });
    } catch (e) {
      setState(() {
        user.studentName = widget.userId;
        user.status = true;
      });

      print("유저정보 가져오기 catch문");
      print(widget.userId);
    }
  }

  Future<void> carInfo() async {
    try {
      dynamic carInfo = await storage.read(key: 'carNumber');
      var parsedJson = json.decode(carInfo);
      carNum = parsedJson['carNum'];
      carName = parsedJson['carName'];
      print("마이페이지 차량정보 가져오기");
      print(carNum + carName);
    } catch (e) {
      print("마이페이지 차량정보 가져오기 실패");
    }
  }

  logout() async {
    await storage.deleteAll();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  checkUserState() async {
    userInfo = await storage.read(key: 'login');
    if (userInfo == null) {
      print('로그인 페이지로 이동');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      //print('로그인 중');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          /*계정 정보*/
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Container(
              padding: EdgeInsets.all(20),
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 243, 1),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 10),
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          user.studentName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$carNum - $carName',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.withOpacity(0.8)),
                        )
                      ]),
                  Icon(
                    Icons.account_circle_rounded,
                    size: 60,
                  )
                ],
              ),
            ),
          ),
          /* 설정 */
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Container(
              padding: EdgeInsets.all(20),
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    height: 40,
                    child: Text(
                      '계정',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Setting(content: '비밀번호 변경'),
                  Setting(content: '차량 등록'),
                  Setting(content: '위반 내역')
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Container(
              padding: EdgeInsets.all(20),
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    height: 40,
                    child: Text(
                      '기타',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Setting(content: '알람 설정'),
                  Setting(content: '회원 탈퇴'),
                  GestureDetector(
                      onTap: () {
                        logout();
                      },
                      child: Text(
                        '로그아웃',
                        style: TextStyle(fontSize: 18),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}

/* 계정 설정 - tab 하면 화면 전환 할 예정 ..*/
class Setting extends StatelessWidget {
  const Setting({Key? key, required this.content}) : super(key: key);
  final String content; //설정할 목록 이름 ex) 비밀번호 변경

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onContainerClicked();
      },
      child: Container(
        height: 40,
        child: Text(
          content,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void onContainerClicked() {
    print(content);
  }
}
