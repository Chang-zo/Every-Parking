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

  @override
  void initState() {
    super.initState();
    appbarName = widget.name;
    _getParkingLotInfo();
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
        appbarName = nowParkingMapStatus?.name ??
            "정보 받아오기 실패하면 하라고 한 "
                "name값도 가져오는데 실패하네 망할";
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                child: Text(
                  '${widget.name} ${nowParkingMapStatus.used}/${nowParkingMapStatus.total}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 56,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Column(children: [ParkingCellClick(index, widget.userId)])
                    ],
                  );
                },
              )),
            ],
          ),
        ));
  }
}

//주차가 진행 될 회색 칸
class ParkingCellClick extends StatefulWidget {
  int parkingNum;
  String userId;
  ParkingCellClick(this.parkingNum, this.userId, {super.key});

  @override
  _ParkingCellClick createState() => _ParkingCellClick();
}

class _ParkingCellClick extends State<ParkingCellClick> {
  var ds = new Datasource();
  late User user;
  late parkingMapStatues nowParkingList;
  late bool state;

  void _getUserInfo() async {
    try {
      User userInfo = await ds.userInfo(widget.userId);

      setState(() {
        user.studentName = userInfo.studentName;
        user.status = userInfo.status;
      });
    } catch (e) {
      setState(() {
        user.studentName = widget.userId;
        user.status = true;
      });
    }
  }

  void _getParkingLotInfo() async {
    parkingMapStatues nowParkingStatusInfo =
        (await ds.nowParkingLotStatus(widget.userId)) as parkingMapStatues;

    setState(() {
      nowParkingList = nowParkingStatusInfo;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _getParkingLotInfo();
    state = nowParkingList.parkingInfoList[widget.parkingNum].parkingStatus;
  }

  void reDraw() {
    _getUserInfo();
    _getParkingLotInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        state == false
            ? showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("${widget.parkingNum}번"),
                    content: Text('해당 번호에 주차하시겠습니까?'),
                    actions: [
                      TextButton(
                        child: Text('확인'),
                        onPressed: () {
                          ds.setParking(widget.userId, widget.parkingNum);
                          reDraw();
                          setState(() {
                            state = true;
                          });
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
              )
            : showDialog(
                context: context,
                builder: (context) => MyParkingInfo("${widget.parkingNum}번"),
              );
      },
      child: Container(
        width: 50,
        height: 100,
        color: state ? Colors.red : Colors.grey,
        child: Center(
          child: Text(
            widget.parkingNum.toString(),
            //시간 정보 받아오는게 진행된다면 여기에 추가하면 될듯!
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
    ;
  }
}
