import 'dart:async';
import 'dart:developer';

import 'package:every_parking/datasource/datasource.dart';
import 'package:every_parking/Model/user.dart';
import 'package:every_parking/screen/parking_lot_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:every_parking/screen/my_parking_status.dart';

import '../Model/parkingLotInfo.dart';
import '../Model/parkingstatus.dart';

//로그인 후 보이는 첫화면
class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({Key? key, required this.userId}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  var ds = new Datasource();
  var user = new User();
  var myParkingStatus = new MyParkingStatus();
  late List<ParkingLotInfo> nowParkingList;

  int time_h = 0;
  int time_m = 0;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _getUserCarInfo();
    //_startTimer();
    //_getParkingLotInfo();
    nowParkingList = [
      ParkingLotInfo(name: "동문주차장", available: 15, total: 56),
      ParkingLotInfo(name: "남문주차장", available: 13, total: 19),
    ];
  }

  /* 유저 가져오기 */
  void _getUserInfo() async {
    try {
      User userInfo = await ds.userInfo(widget.userId);
      print("유저정보 가져오기 try문");
      print(userInfo);
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
      print(user);
    }
  }

  int i = 5;
  /*내 자동차 정보 가져오기*/
  void _getUserCarInfo() async {
    if (user.status == false) {
      return;
    }

    try {
      MyParkingStatus myParkingStatusInfo =
          await Datasource().myParkingStatus(widget.userId);

      setState(() {
        myParkingStatus.parkingId = myParkingStatusInfo.parkingId;
        myParkingStatus.remain = myParkingStatusInfo.remain;
        myParkingStatus.carNumber = myParkingStatusInfo.carNumber;
        i = myParkingStatus.remain!;
      });
    } catch (e) {
      setState(() {
        myParkingStatus.parkingId = 123;
        myParkingStatus.remain = i;
        myParkingStatus.carNumber = "aaaa";
      });
    }
    time_h = myParkingStatus.remain! ~/ 60;
    time_m = myParkingStatus.remain! % 60;
  }

  /*주차장 상태 가져오기*/
  void _getParkingLotInfo() async {
    List<ParkingLotInfo> nowParkingStatusInfo =
        await ds.nowParking(widget.userId);

    setState(() {
      nowParkingList = nowParkingStatusInfo;
    });
  }

  void _startParkingTimer() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      i--;
      if (myParkingStatus.remain == 0) {
        setState(() {
          myParkingStatus.remain = null;
          user.status = false;
        });

        timer.cancel();
      }
    });
  }

  //1초마다 새로 정보 가져오기
  void _startTimer() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      _getUserInfo();
      _getUserCarInfo();
    });
  }

  Text _reMain() {
    _startParkingTimer();
    return Text("${time_h.toString()}시간\n${time_m.toString()}분");
  }

  Future<void> _refresh() {
    setState(() {
      //서버 연결 후 아래 주석처리 된거 실행시키기!
      //nowParkingList = nowParkingStatusInfo;
      nowParkingList.add(
        ParkingLotInfo(name: "동문주차장", available: 15, total: 56),
      );
    });
    return Future<void>.value();
  }

  void isRegist() {}

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
                        '${user.studentName}님 \n어서오세요!',
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
                          child: RefreshIndicator(
                            onRefresh: _refresh,
                            child: ListView.builder(
                              itemCount: nowParkingList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ParkingMap(
                                              nowParkingList[index].name,
                                              widget.userId)),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(nowParkingList[index].name),
                                        Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          width: 300,
                                          height: 20,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child: LinearProgressIndicator(
                                              value: ((nowParkingList[index]
                                                          .total -
                                                      nowParkingList[index]
                                                          .available) /
                                                  nowParkingList[index].total),
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Color(0xff00ff00)),
                                              backgroundColor:
                                                  Color(0xffD6D6D6),
                                            ),
                                          ),
                                        ),
                                        Text((nowParkingList[index].total -
                                                    nowParkingList[index]
                                                        .available)
                                                .toString() +
                                            "/" +
                                            nowParkingList[index]
                                                .total
                                                .toString()),
                                        Divider(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
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
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  8), // changes position of shadow
                                            ),
                                          ]),
                                      child: user.status == true
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(myParkingStatus.carNumber
                                                    .toString()),
                                                Divider(
                                                  color: Colors.grey,
                                                  thickness: 1,
                                                  indent: 10,
                                                  endIndent: 10,
                                                ),
                                                Text(myParkingStatus.parkingId
                                                    .toString())
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("주차는"),
                                                Divider(
                                                  color: Colors.grey,
                                                  thickness: 1,
                                                  indent: 10,
                                                  endIndent: 10,
                                                ),
                                                Text("하셨나요?")
                                              ],
                                            )),
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
                                        user.status == true
                                            ? _reMain()
                                            : Text("00시간\n00분")
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              user.status == true
                                  ? Row(
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
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      MyParkingInfo("번"),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
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
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      MyParkingInfo("번"),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
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
                                    )
                                  : Container()
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
