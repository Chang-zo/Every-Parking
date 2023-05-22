/* 주차장 이름, 수용 가능 수, 이용 가능 수 */
class ParkingLotInfo {
  String name;
  int total;
  int used;

  ParkingLotInfo({required this.name, required this.total, required this.used});

  factory ParkingLotInfo.fromJson(Map<String, dynamic> json) {
    return ParkingLotInfo(
        name: json['name'], total: json['total'], used: json['used']);
  }
}
