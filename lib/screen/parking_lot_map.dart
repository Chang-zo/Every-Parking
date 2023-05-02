import 'package:flutter/material.dart';
import 'dart:convert';
import '';

class ParkingMap extends StatefulWidget {
  var name;

  ParkingMap(this.name, {Key? key}) : super(key: key);

  @override
  State<ParkingMap> createState() => _ParkingMapState();
}

class _ParkingMapState extends State<ParkingMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name,
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
                  "잔여석 : 20/95",
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
                        ParkingCell1(index, "B"),
                        SizedBox(height: 100),
                        ParkingCell2(index, "B"),
                        ParkingCell2(index, "A"),
                        SizedBox(height: 100),
                        ParkingCell1(index, "A"),
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
  ParkingCell1(this.index, this.Zone, {super.key});

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
                : ParkingCellClick(Zone, parkingNum);
  }
}

class ParkingCell2 extends StatelessWidget {
  String Zone;
  int index;
  ParkingCell2(this.index, this.Zone, {super.key});

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
            : ParkingCellClick(Zone, parkingNum);
  }
}

//주차가 진행 될 회색 칸
class ParkingCellClick extends StatelessWidget {
  String Zone;
  int parkingNum;
  ParkingCellClick(this.Zone, this.parkingNum, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(Zone + parkingNum.toString() + "번"),
              content: Text('해당 번호에 주차하시겠습니까?'),
              actions: [
                TextButton(
                  child: Text('확인'),
                  onPressed: () {
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
      },
      child: Container(
        width: 50,
        height: 100,
        color: Colors.grey,
        child: Center(
          child: Text(
            Zone + parkingNum.toString(),
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
