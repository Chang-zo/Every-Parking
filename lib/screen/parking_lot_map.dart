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

class ParkingMap extends StatefulWidget {
  final String name;
  final String userId;

  const ParkingMap(this.name, this.userId, {Key? key}) : super(key: key);

  @override
  State<ParkingMap> createState() => _ParkingMapState();
}

class _ParkingMapState extends State<ParkingMap> {
  late parkingMapStatues nowParkingMapStatus;
  late List<ParkingArea> nowParkingList;
  var ds = new Datasource();
  String appbarName = "";
  int parkNum = 0;

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
    parkNum = 0;
    nowParkingList = [];
    _getParkingLotInfo();
  }

  void parkingNum(index) async {
    if (index == 0) {
      parkNum = 0;
    } else {
      parkNum++;
      print(parkNum);
    }
  }

  void _getParkingLotInfo() async {
    try {
      /* 서버 요청  */
      var nowParkingStatusInfo = await ds.nowParkingLotStatus(widget.userId);

      setState(() {
        nowParkingMapStatus = nowParkingStatusInfo;
        nowParkingList = nowParkingStatusInfo.parkingInfoList;
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
                  child: nowParkingList.isEmpty
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ) // 데이터 로딩 중 표시
                      : GridView.count(
                          shrinkWrap: true, // SingleChildScrollView에 맞게 크기 조정
                          crossAxisCount: 19,
                          childAspectRatio: (0.5 / 1),
                          children: List.generate(nowParkingList.length + 58,
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
                              return SizedBox();
                            } else {
                              parkingNum(index);
                              return SizedBox(
                                child: ParkingCell(
                                  index: parkNum,
                                  nowParkingList: nowParkingList,
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
  final int index;
  final List<ParkingArea> nowParkingList;

  const ParkingCell({
    Key? key,
    required this.index,
    required this.nowParkingList,
  }) : super(key: key);

  @override
  State<ParkingCell> createState() => _ParkingCellState(index, nowParkingList);
}

class _ParkingCellState extends State<ParkingCell> {
  final int index;
  final List<ParkingArea> nowParkingList;

  _ParkingCellState(this.index, this.nowParkingList);

  bool isMe = false;
  int myParkingNum = 0;

  void parkingStatusChange(parkingStatus, index) {
    if (parkingStatus == "UNAVAILABLE") {
      setState(() {
        nowParkingList[index].parkingStatus = "AVAILABLE";
        myParkingNum = 0;
      });
    } else if (parkingStatus == "AVAILABLE") {
      setState(() {
        nowParkingList[index].parkingStatus = "UNAVAILABLE";
        myParkingNum = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (nowParkingList[index].parkingStatus == "AVAILABLE") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("$index번"),
                content: Text('해당 번호에 주차하시겠습니까?'),
                actions: [
                  TextButton(
                    child: Text('확인'),
                    onPressed: () {
                      parkingStatusChange(
                          nowParkingList[index].parkingStatus, index);
                      Navigator.of(context).pop();
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
        } else {
          showDialog(
            context: context,
            builder: (context) => MyParkingInfo("$index번", myParkingNum),
          );
        }
      },
      child: Container(
        width: 100,
        height: 50,
        color: nowParkingList[index].parkingStatus == "UNAVAILABLE"
            ? Colors.red
            : Colors.grey,
        child: Center(
          child: Text(
            index.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
