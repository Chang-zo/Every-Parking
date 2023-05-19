//int parkingId, String parkingStatus

class ParkingArea {
  var parkingId;
  bool parkingStatus;

  ParkingArea({
    this.parkingId,
    required this.parkingStatus,
  });

  factory ParkingArea.fromJson(Map<String, dynamic> json) {
    return ParkingArea(
        parkingId: json['parkingId'], parkingStatus: json['parkingStatus']);
  }
}
