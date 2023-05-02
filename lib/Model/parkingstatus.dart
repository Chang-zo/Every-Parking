class MyParkingStatus {
  var parkingId;
  var remain;
  var carNumber;

  MyParkingStatus({ this.parkingId,this.remain,this.carNumber });

  factory MyParkingStatus.fromJson(Map<String, dynamic> json){
    return MyParkingStatus(
      parkingId : json['parkingId'],
      remain : json['remain'],
      carNumber : json['carNumber'],
    );
  }
}