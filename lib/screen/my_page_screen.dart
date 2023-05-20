import 'package:every_parking/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';

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
      print('로그인 중');
    }
  }

  @override
  void initState() {
    super.initState();

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserState();
    });
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
                          'Name',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '차량 번호 - 코나',
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
