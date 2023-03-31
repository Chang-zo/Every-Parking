import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({Key? key}) : super(key: key);

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
                  Setting(content: '로그아웃')
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
