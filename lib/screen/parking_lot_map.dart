import 'package:every_parking/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../Model/parkingLotInfo.dart';
import '../Model/parkingMapStatue.dart';
import '../Model/parkingarea.dart';
import '../Model/parkingstatus.dart';
import '../Model/user.dart';
import '../datasource/datasource.dart';
import 'package:every_parking/screen/my_parking_status.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'main_screen.dart';

//주차장 칸 관련해서 수정하려면 ParkingMap클래스 말고 젤 아래에 있는 _ParkingCellState 건드리면 됨
class ParkingMap extends StatefulWidget {
  final String name;
  final String userId;

  const ParkingMap(this.name, this.userId, {Key? key}) : super(key: key);

  @override
  State<ParkingMap> createState() => _ParkingMapState();
}

class _ParkingMapState extends State<ParkingMap> {
  late parkingMapStatues nowParkingMapStatus;
  List<ParkingArea> nowParkingList = [
    ParkingArea(parkingStatus: "USED", parkingId: 0)
  ];
  var ds = new Datasource();
  String appbarName = "";
  int parkId = 0;

  List<int> yellow = [2, 9, 16, 40, 54, 59, 73, 97, 104, 111];
  List<int> blink = [38, 39, 55, 56, 57, 58, 74, 75];

  @override
  void initState() {
    super.initState();
    appbarName = widget.name;
    nowParkingMapStatus = parkingMapStatues(
      name: "name",
      total: 0,
      used: 0,
      parkingInfoList: [],
    );
    nowParkingList = [ParkingArea(parkingStatus: "USED", parkingId: 0)];
    _getParkingLotInfo();
  }

  void parkingNum(index) async {
    if (index == 0) {
      parkId = 1;
    } else {
      parkId++;
    }
  }

  void _getParkingLotInfo() async {
    try {
      /* 서버 요청  */
      var nowParkingStatusInfo = await ds.nowParkingLotStatus(widget.userId);

      setState(() {
        nowParkingMapStatus = nowParkingStatusInfo;
        nowParkingList.addAll(nowParkingStatusInfo.parkingInfoList);
        print("_getParkingLotInfo 실행");
        print(nowParkingList.length);
      });
    } catch (e) {
      nowParkingMapStatus = parkingMapStatues(
          name: "정보 받아오기 실패ㅐ애ㅐ", total: 10, used: 1, parkingInfoList: []);
      setState(() {
        appbarName = nowParkingMapStatus.name;
        nowParkingList = [];
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.08,
          title: Text(
            appbarName,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(0xff, 0x49, 0x7a, 0xa6),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: Text(
                    '${widget.name} ${nowParkingMapStatus.used}/${nowParkingMapStatus.total}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  //height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 2.5,

                  //정보 불러오는 동안 nowParkingList가 비어있기 때문에 오류 발생
                  //비어있는 동안 CircularProgressIndicator 띄우면서 대기하다가
                  //정보 다 불러와지면 주차장 맵 생성
                  child: nowParkingList.length == 1
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: const Center(
                              child:
                                  CircularProgressIndicator())) // 데이터 로딩 중 표시
                      : GridView.count(
                          shrinkWrap: true, // SingleChildScrollView에 맞게 크기 조정
                          crossAxisCount: 19,
                          childAspectRatio: (0.5 / 1),
                          children: List.generate(
                              nowParkingList.length + 57, //주차 못하는 모든 칸의 수 57개
                              (index) {
                            if (index == 95) {
                              // 출구
                              return Center(
                                child: Container(
                                  width: double.infinity, // 또는 원하는 너비 값
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  color: Colors.blueGrey,
                                  child: Text(
                                    "출구",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            } else if (index == 96) {
                              // 입구
                              return Center(
                                child: Container(
                                  width: double.infinity, // 또는 원하는 너비 값
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  color: Colors.blueGrey,
                                  child: Text(
                                    "입구",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            } else if (yellow.contains(index)) {
                              return Container(
                                color: Colors.yellow,
                              );
                            } else if (blink.contains(index) ||
                                19 <= index && index <= 37 ||
                                76 <= index && index <= 94) {
                              return const SizedBox();
                            } else {
                              //parkingNum 1씩 증가
                              parkingNum(index);
                              return SizedBox(
                                child: ParkingCell(
                                  parkId: parkId,
                                  nowParkingList: nowParkingList,
                                  userId: widget.userId,
                                  parkingLotName: widget.name,
                                ),
                              );
                            }
                          }),
                        ),
                ),
              ))
            ],
          ),
        ));
  }
}

class ParkingCell extends StatefulWidget {
  final int parkId;
  final List<ParkingArea> nowParkingList;
  final String userId;
  final String parkingLotName;

  const ParkingCell({
    Key? key,
    required this.parkId,
    required this.nowParkingList,
    required this.userId,
    required this.parkingLotName,
  }) : super(key: key);

  @override
  State<ParkingCell> createState() =>
      _ParkingCellState(parkId, nowParkingList, userId, parkingLotName);
}

class _ParkingCellState extends State<ParkingCell> {
  final String userId;
  final int parkId;
  final List<ParkingArea> nowParkingList;
  final String parkingLotName;
  static final storage = FlutterSecureStorage();

  int k = 12;
  String parkingName = '0';

  _ParkingCellState(
      this.parkId, this.nowParkingList, this.userId, this.parkingLotName);

  void parkingStatusChange(parkingStatus, parkId) {
    print("parkingStatusChange 실행");
    if (parkingStatus == "AVAILABLE") {
      setState(() {
        nowParkingList[parkId].parkingStatus = "USED";
      });
    }
  }

  String setParkingName(int parkId) {
    if (parkId <= 29) {
      setState(() {
        parkingName = 'B$parkId';
      });
    } else if (parkId <= 42) {
      setState(() {
        parkingName = 'A${parkId - 15}';
      });
    } else {
      setState(() {
        parkingName = 'A${parkId - 42}';
      });
    }
    return parkingName;
  }

  Future<void> parkingLotRent(id, parkingLotId) async {
    try {
      bool result = await Datasource().parkingLotRent(id, parkingLotId);
      if (result) {
        print("주차 성공!!!!");

        print(parkingLotId);
        showDialog(
            context: context,
            barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text("주차 등록이 완료되었습니다."),
                insetPadding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
                actions: [
                  TextButton(
                    child: const Text('확인'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
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
        parkingStatusChange(nowParkingList[parkId].parkingStatus, parkId);

        print("로컬에 저장할 정보 만들기");
        var val = json.encode(
            {'parkId': parkId, 'startTime': DateTime.now().toIso8601String()});
        print(val);

        print("주차 정보 로컬에 저장하기");
        await storage.write(
          key: 'myParkingLot',
          value: val,
        );
        print("주차 정보 로컬에 저장완료");
      } else {
        showDialog(
            context: context,
            barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text("주차등록에 실패했습니다."),
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
              content: const Text("주차장 입장 후 다시 시도하거나\n관리자에게 문의해주세요"),
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
  int myParkingId = 0;
  Future<void> getMyParkingId() async {
    //savedTime 위치에 주차 등록 시간 입력하면 끝!
    carInfo = await storage.read(key: 'myParkingLot');
    if (carInfo != null) {
      var parsedJson = json.decode(carInfo);
      int parkId = parsedJson['parkId'];

      setState(() {
        myParkingId = parkId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await getMyParkingId();
        print("GestureDetector onTap 내부");
        print(parkId);
        print(myParkingId);
        if (nowParkingList[parkId].parkingStatus == "AVAILABLE") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("$parkingName번"),
                content: Text('해당 번호에 주차하시겠습니까?'),
                actions: [
                  TextButton(
                    child: Text('확인'),
                    onPressed: () async {
                      parkingLotRent(userId, parkId);
                    },
                  ),
                  TextButton(
                    child: Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (parkId == myParkingId) {
          showDialog(
              context: context,
              builder: (context) =>
                  MyParkingInfo("$parkingName번", widget.userId, parkId));
        } else {
          showDialog(
              context: context,
              barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
              builder: (BuildContext context) {
                return AlertDialog(
                  content: const Text("해당 사용자가 문제를 일으켰나요?"),
                  insetPadding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
                  actions: [
                    TextButton(
                      child: const Text('신고'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen(
                                      userId: widget.userId,
                                      index: 1,
                                    )));
                      },
                    ),
                    TextButton(
                      child: const Text('취소'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }
      },
      child: Container(
        width: 100,
        height: 50,
        color: nowParkingList[parkId].parkingStatus == "USED"
            ? Colors.red
            : Colors.grey,
        child: Center(
            child: Text(
          setParkingName(parkId),
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        )),
      ),
    );
  }
}
