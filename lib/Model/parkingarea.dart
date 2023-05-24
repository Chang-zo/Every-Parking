//int parkingId, String parkingStatus

class ParkingArea {
  int parkingId;
  String parkingStatus;

  ParkingArea({
    required this.parkingId,
    required this.parkingStatus,
  });

  factory ParkingArea.fromJson(Map<String, dynamic> json) {
    return ParkingArea(
        parkingId: json['parkingId'], parkingStatus: json['parkingStatus']);
  }
}
