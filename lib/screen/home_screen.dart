import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//로그인 후 보이는 첫화면
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //정보란
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "여어\n어서오시게",
                        style: TextStyle(fontSize: 20),
                        maxLines: 2,
                      ),
                      SvgPicture.asset(
                        'assets/icons/black/custom.person.crop.circle.svg',
                        width: 50,
                        height: 50,
                      )
                    ],
                  ),
                ],
              ),
              //알림창
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/black/custom.bell.svg',
                      width: 25,
                      height: 25,
                    ),
                    Text(
                      " 알람읽으시게~",
                      style: TextStyle(fontSize: 15),
                      maxLines: 2,
                    )
                  ],
                ),
              ),
              //주차정보
              Container(
                child: Stack(
                  children: [
                    // 하단 컨테이너
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 8), // changes position of shadow
                              ),
                            ]),
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: double.infinity,
                        child: ListView.separated(
                          itemCount: 10,
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(
                            color: Colors.grey,
                            thickness: 1.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text('Item ${index + 1}'),
                            );
                          },
                        )),
                    // 상단 고정 컨테이너
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(0xff, 0x49, 0x7a, 0xa6),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 8), // changes position of shadow
                              ),
                            ]),
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              textAlign: TextAlign.left,
                              "주차정보",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                8), // changes position of shadow
                                          ),
                                        ]),
                                    child: Column(
                                      children: [
                                        Text("자리번호"),
                                        Divider(
                                          color: Colors.grey,
                                          thickness: 1.0,
                                        ),
                                        Text("차량번호")
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                8), // changes position of shadow
                                          ),
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("잔여시간"),
                                        VerticalDivider(
                                          color: Colors.grey,
                                          thickness: 1,
                                          width: 20,
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                        Text("00시\n00분")
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
    );
  }
}
