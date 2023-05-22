/* 주차장 맵 구성하는데 쓰이는 것 */
import 'package:every_parking/Model/parkingarea.dart';

class parkingMapStatues {
  String name;
  int total;
  int used;
  List<ParkingArea> parkingInfoList;

  parkingMapStatues(
      {required this.name,
      required this.total,
      required this.used,
      required this.parkingInfoList});

  factory parkingMapStatues.fromJson(Map<String, dynamic> json) {
    List<ParkingArea> parkingInfoList = List<ParkingArea>.from(
        json['parkingInfoList'].map((data) => ParkingArea.fromJson(data)));

    print('parkingId : ${parkingInfoList[0].parkingId}');
    return parkingMapStatues(
      name: json['name'],
      total: json['total'],
      used: json['used'],
      parkingInfoList: parkingInfoList,
    );
  }
}
