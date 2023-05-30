import 'dart:async';
import 'dart:convert';

import 'package:every_parking/datasource/datasource.dart';
import 'package:every_parking/screen/main_screen.dart';
import 'package:every_parking/screen/parking_lot_map.dart';
import 'package:every_parking/screen/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyParkingInfo extends StatefulWidget {
  final String parkingNum;
  final String userId;
  final int parkingId;
  const MyParkingInfo(this.parkingNum, this.userId, this.parkingId, {Key? key})
      : super(key: key);

  @override
  State<MyParkingInfo> createState() => _MyParkingInfoState();
}

class _MyParkingInfoState extends State<MyParkingInfo> {
  static final storage = FlutterSecureStorage();
  dynamic parkingInfo = '';
  int myParkingId = 0;

  int time_h = 0;
  int time_m = 0;

  @override
  void initState() {
    print("MyParkingInfo의 initState 실행");
    super.initState();
    getCarRemainTime();
  }

  Future<void> parkingReturn(userId, parkingId) async {
    try {
      int result = await Datasource().parkingLotReturn(userId, parkingId);
      print("parkingReturn");
      print(result);
      if (result == 200) {
        print("반납 성공!!!!");
        await storage.delete(key: "myParkingLot");
        print("로컬 주차정보 제거 완료");
        showDialog(
            context: context,
            barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text("주차 반납이 완료되었습니다."),
                insetPadding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
                actions: [
                  TextButton(
                    child: const Text('확인'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainScreen(
                                  userId: widget.userId,
                                  index: 0,
                                )),
                      );
                    },
                  ),
                ],
              );
            });
      } else {
        print("반납실패");
        showDialog(
            context: context,
            barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text("반납에 실패하였습니다."),
                insetPadding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
                actions: [
                  TextButton(
                    child: const Text('확인'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
    } catch (e) {
      showDialog(
          context: context,
          barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text("잠시 후 다시 시도해주세요"),
              insetPadding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
              actions: [
                TextButton(
                  child: const Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  dynamic carInfo = "";
  //서버로부터 시간 정보 받아와지면 수정할것
  int i = 10;
  Future<void> getMyCarRemainTime() async {
    //savedTime 위치에 주차 등록 시간 입력하면 끝!
    carInfo = await storage.read(key: 'myParkingLot');
    var parsedJson = json.decode(carInfo);
    String startTimeString = parsedJson['startTime'];
    DateTime savedTime = DateTime.parse(startTimeString);
    //DateTime savedTime = DateTime(2023, 5, 30, 0, 0, 0, 0);
    int remain = 179 -
        DateTime.now()
            .difference(savedTime)
            .inMinutes; // 180분 - (주차 시작시간 - 현재시간)
    i = remain;

    time_h = i ~/ 60;
    time_m = i % 60;
  }

  Future<void> getCarRemainTime() async {
    //savedTime 위치에 주차 등록 시간 입력하면 끝!
    carInfo = await storage.read(key: 'myParkingLot');
    if (carInfo != null) {
      var parsedJson = json.decode(carInfo);
      String startTimeString = parsedJson['startTime'];
      DateTime savedTime = DateTime.parse(startTimeString);
      //DateTime savedTime = DateTime(2023, 5, 30, 0, 0, 0, 0);
      int remain = 179 -
          DateTime.now()
              .difference(savedTime)
              .inMinutes; // 180분 - (주차 시작시간 - 현재시간)
      i = remain;

      setState(() {
        time_h = i ~/ 60;
        time_m = i % 60;
      });

      print(time_h);
      print(time_m);
    }
  }

  Text _reMain() {
    return Text("${time_h.toString()}시간\n${time_m.toString()}분");
  }

  Future<void> timeExtension() async {
    setState(() {
      i = 179;
    });
    var val = json.encode({
      'parkId': widget.parkingId,
      'startTime': DateTime.now().toIso8601String()
    });
    print(val);

    print("주차 정보 로컬에 저장하기");
    await storage.write(
      key: 'myParkingLot',
      value: val,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(0xff, 0x49, 0x7a, 0xa6),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 8), // changes position of shadow
                  ),
                ]),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          widget.parkingNum,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          //width: MediaQuery.of(context).size.width * 0.8,
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 8), // changes position of shadow
                                ),
                              ]),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  "잔여시간",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                const VerticalDivider(
                                  color: Colors.grey,
                                  thickness: 1,
                                  width: 20,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                _reMain()
                              ],
                            ),
                          ),
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 35,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(0xFF, 0x2F, 0x64, 0x96),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible:
                                          true, // 바깥 영역 터치시 닫을지 여부
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text("시간을 연장하시겠습니까?"),
                                          insetPadding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 80, 0, 80),
                                          actions: [
                                            TextButton(
                                              child: const Text('확인'),
                                              onPressed: () {
                                                timeExtension();
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MainScreen(
                                                            userId:
                                                                widget.userId,
                                                            index: 0,
                                                          )),
                                                );
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ParkingMap(
                                                            "테스트",
                                                            widget.userId,
                                                          )),
                                                );
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        MyParkingInfo(
                                                            widget.parkingNum,
                                                            widget.userId,
                                                            widget.parkingId));
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('취소'),
                                              onPressed: () {
                                                timeExtension();
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/white/custom.plus.app.svg',
                                      width: 20,
                                      height: 20,
                                      color: Colors.white,
                                    ),
                                    Text("시간연장")
                                  ],
                                )),
                          ),
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(0xFF, 0x2F, 0x64, 0x96),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      barrierDismissible:
                                          true, // 바깥 영역 터치시 닫을지 여부
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text("반납하시겠습니까?"),
                                          insetPadding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 80, 0, 80),
                                          actions: [
                                            TextButton(
                                              child: const Text('확인'),
                                              onPressed: () {
                                                parkingReturn(
                                                    widget.userId, myParkingId);
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('취소'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/white/custom.return.right.svg',
                                      width: 20,
                                      height: 20,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "반납",
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
