class MyParkingStatus {
  int? parkingId;
  int? remain;
  String? carNumber;

  MyParkingStatus({this.parkingId, this.remain, this.carNumber});

  factory MyParkingStatus.fromJson(Map<String, dynamic> json) {
    return MyParkingStatus(
      parkingId: json['parkingId'],
      remain: json['remain'],
      carNumber: json['carNumber'],
    );
  }
}
