class MyParkingStatus {
  int parkingId;
  int remain;
  String carNumber;

  MyParkingStatus(
      {required this.parkingId, required this.remain, required this.carNumber});

  factory MyParkingStatus.fromJson(Map<String, dynamic> json) {
    return MyParkingStatus(
      parkingId: json['parkingId'],
      remain: json['remain'],
      carNumber: json['carNumber'],
    );
  }
}
