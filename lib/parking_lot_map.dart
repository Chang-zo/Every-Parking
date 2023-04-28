import 'package:flutter/material.dart';

class ParkingMap extends StatefulWidget {
  const ParkingMap({Key? key}) : super(key: key);

  @override
  State<ParkingMap> createState() => _ParkingMapState();
}

class _ParkingMapState extends State<ParkingMap> {
  var noParking = [12, 14, 15, 17, 54, 59, 96, 98, 99, 101];
  var road = [2, 3, 8, 9, 104, 105, 110, 111];
  var using = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "동문주차장",
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
                child: GridView.builder(
                  itemCount: 114,
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 5,
                    childAspectRatio: 2 / 1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    // 조건에 따라 색상 변경

                    Color color = Colors.grey; // 기본 색상

                    if (index % 6 == 1 ||
                        index % 6 == 4 ||
                        road.contains(index)) {
                      color = Colors.white;
                    }
                    if (noParking.contains(index)) {
                      color = Colors.yellow;
                    }
                    if (using.contains(index)) {
                      color = Colors.red;
                    }
                    return Container(
                      color: color,
                      child: Center(
                        child: Text('$index'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
