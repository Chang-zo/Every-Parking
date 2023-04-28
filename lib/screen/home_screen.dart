import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:every_parking/parking_lot_map.dart';

//로그인 후 보이는 첫화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
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
                height: 40,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/black/custom.bell.svg',
                        width: 20,
                        height: 20,
                      ),
                      Text(
                        " 알람읽으시게~",
                        style: TextStyle(fontSize: 15),
                        maxLines: 2,
                      )
                    ],
                  ),
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
                        height: MediaQuery.of(context).size.height * 0.65,
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.22),
                          child: ListView.builder(
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ParkingMap()),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(_items[index].title),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        width: 300,
                                        height: 20,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          child: LinearProgressIndicator(
                                            value:
                                                (_items[index].usedParkingCell /
                                                    _items[index]
                                                        .amountParkingCell),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Color(0xff00ff00)),
                                            backgroundColor: Color(0xffD6D6D6),
                                          ),
                                        ),
                                      ),
                                      Text(_items[index]
                                              .usedParkingCell
                                              .toString() +
                                          "/" +
                                          _items[index]
                                              .amountParkingCell
                                              .toString()),
                                      Text(_items[index].subtitle),
                                      Divider(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
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
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      textAlign: TextAlign.left,
                                      "주차정보",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //주차 정보 안에 하햔 네모네모들
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 80,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("자리번호"),
                                        Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                        Text("차량번호")
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 80,
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
                                        Text("잔여\n시간"),
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
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 35,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromARGB(
                                              0xFF, 0x2F, 0x64, 0x96),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/white/custom.plus.app.svg',
                                              width: 20,
                                              height: 20,
                                            ),
                                            Text("시간연장")
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    height: 35,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromARGB(
                                              0xFF, 0x2F, 0x64, 0x96),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/white/custom.return.right.svg',
                                              width: 20,
                                              height: 20,
                                            ),
                                            Text("반납")
                                          ],
                                        )),
                                  )
                                ],
                              ),
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
    );
  }
}

class ListItem {
  final String title;
  final String subtitle;
  final num amountParkingCell;
  final num usedParkingCell;

  ListItem(
      {required this.title,
      required this.subtitle,
      required this.amountParkingCell,
      required this.usedParkingCell});
}

List<ListItem> _items = [
  ListItem(
      title: "동문 주차장",
      subtitle: "계명대학교",
      amountParkingCell: 95,
      usedParkingCell: 20),
  ListItem(
      title: "남문 주차장",
      subtitle: "계명대학교",
      amountParkingCell: 100,
      usedParkingCell: 13),
  // ...
];
