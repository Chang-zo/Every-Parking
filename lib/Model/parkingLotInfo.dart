
/* 주차장 이름, 수용 가능 수, 이용 가능 수 */
import 'dart:convert';

class ParkingLotInfo {
  var name;
  var total;
  var used;

  ParkingLotInfo({
    this.name,
    this.total,
    this.used
  });

  factory ParkingLotInfo.fromJson(Map<String, dynamic> json){
    return ParkingLotInfo(
        name : json['name'],
        total : json['total'],
        used : json['used']
    );
  }
}