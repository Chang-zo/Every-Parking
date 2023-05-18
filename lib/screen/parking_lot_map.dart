import 'package:flutter/material.dart';
import 'dart:convert';
import '';
import '../Model/parkingLotInfo.dart';
import '../Model/parkingarea.dart';
import '../datasource/datasource.dart';
import 'package:every_parking/screen/my_parking_status.dart';

class ParkingMap extends StatefulWidget {
  final String name;
  final String userId;

  const ParkingMap(this.name, this.userId, {Key? key}) : super(key: key);

  @override
  State<ParkingMap> createState() => _ParkingMapState();
}

String appbarName = "";

class _ParkingMapState extends State<ParkingMap> {

  @override
  void initState() {
    super.initState();
    appbarName = widget.name;
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
                  widget.name == "동문주차장" ? "잔여석 : 4/19" : "잔여석 : 6/19",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 19,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Column(children: [
                        ParkingCell1(index, "B", widget.userId),
                        SizedBox(height: 100),
                        ParkingCell2(index, "B", widget.userId),
                        ParkingCell2(index, "A", widget.userId),
                        SizedBox(height: 100),
                        ParkingCell1(index, "A", widget.userId),
                      ])
                    ],
                  );
                },
              )),
            ],
          ),
        ));
  }
}

class ParkingCell1 extends StatelessWidget {
  String Zone;
  int index;
  String userId;
  ParkingCell1(this.index, this.Zone, this.userId, {super.key});

  @override
  Widget build(BuildContext context) {
    int parkingNum = index + 1;
    if (index > 16) {
      parkingNum = parkingNum - 3;
    } else if (index > 10) {
      parkingNum = parkingNum - 2;
    } else if (index > 2) {
      parkingNum = parkingNum - 1;
    }
    if (Zone == "A") {
      parkingNum = parkingNum - 2;
    }
    return index == 2 || index == 10 || index == 16
        ? Container(
            color: Colors.yellow,
            height: 100,
            width: 50,
          )
        : Zone == "A" && index == 0
            ? Container(
                color: Colors.grey,
                height: 100,
                width: 50,
                child: Center(
                    child: Text(
                  "출구",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
              )
            : Zone == "A" && index == 1
                ? Container(
                    color: Colors.grey,
                    height: 100,
                    width: 50,
                    child: Center(
                        child: Text(
                      "입구",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    )),
                  )
                : ParkingCellClick(Zone, parkingNum,userId);
  }
}

class ParkingCell2 extends StatelessWidget {
  String Zone;
  int index;
  String userId;
  ParkingCell2(this.index, this.Zone, this.userId, {super.key});

  @override
  Widget build(BuildContext context) {
    int parkingNum = index + 14;
    if (Zone == "A") {
      parkingNum = parkingNum - 2;
    }

    return index == 0 || index == 1 || index == 17 || index == 18
        ? SizedBox(
            height: 100,
            width: 50,
          )
        : index == 2 || index == 16
            ? Container(
                color: Colors.yellow,
                height: 100,
                width: 50,
              )
            : ParkingCellClick(Zone, parkingNum, userId);
  }
}

//주차가 진행 될 회색 칸
class ParkingCellClick extends StatefulWidget {
  String Zone;
  int parkingNum;
  String userId;
  ParkingCellClick(this.Zone, this.parkingNum, this.userId ,{super.key});

  @override
  _ParkingCellClick createState() => _ParkingCellClick();
}

class _ParkingCellClick extends State<ParkingCellClick> {

  late List<ParkingArea> nowParkingList;

  void _getParkingLotInfo() async {
    List<ParkingArea> nowParkingStatusInfo = await Datasource().nowParkingLotStatus(widget.userId);

    setState(() {
      nowParkingList = nowParkingStatusInfo;
    });
  }

  late int parkingId;
  var ds = new Datasource();

  @override
  void initState() {
    super.initState();
    _getParkingLotInfo();
    if(widget.Zone == "A"){
      parkingId = widget.parkingNum-1;
    } else{
      parkingId = widget.parkingNum + 26;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nowParkingList[parkingId].parkingStatus == false
            ? showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("${widget.Zone}${widget.parkingNum}번"),
                    content: Text('해당 번호에 주차하시겠습니까?'),
                    actions: [
                      TextButton(
                        child: Text('확인'),
                        onPressed: () {
                            ds.setParking(widget.userId, parkingId);

                          setState(() {
                            nowParkingList[parkingId].parkingStatus = true;
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
                builder: (context) =>
                    MyParkingInfo("${widget.Zone}${widget.parkingNum}번"),
              );
      },
      child: Container(
        width: 50,
        height: 100,
        color: nowParkingList[parkingId].parkingStatus ? Colors.red : Colors.grey,
        child: Center(
          child: Text(
            widget.Zone + widget.parkingNum.toString(),
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
