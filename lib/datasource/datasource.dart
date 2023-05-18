import 'dart:convert';
import 'package:every_parking/Model/parkingstatus.dart';
import 'package:every_parking/datasource/APIUrl.dart';
import 'package:http/http.dart' as http;

import '../Model/parkingarea.dart';
import '../Model/user.dart';
import '../Model/parkingLotInfo.dart';

class Datasource {

  var checkCar;
  bool get _checkCar => checkCar;

  /* 회원가입 */
  Future<bool> registerUser(int studentId, String studentName, String userId,
      String password, int phoneNumber, String email) async {
    final response = await http.post(
      Uri.parse('http://everyparking.co.kr/app/member/join'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'studentId': studentId.toInt(),
        'studentName': studentName,
        'userId': userId,
        'password': password,
        'phoneNumber': phoneNumber,
        'email': email
      }),
    );

    if (response.statusCode == 200) {
      print("성공");
      return true;
    } else {
      print("실패");
      return false;
    }
  }

  /* 로그인 요청 */
  Future<bool> loginUser(String userId, String password) async {
    final response = await http.post(
      Uri.parse(APIUrl.loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId, 'password': password}),
    );

    final item = json.decode(response.body);
    this.checkCar = item['registered'];
    print('차량 등록 여부 ${item['registered']}');

    if (response.statusCode == 200) {
      /* jwt 사용 시 .. */
      // final jsonResponse = json.decode(response.body);
      // final token = jsonResponse['token'];
      // print(token);
      // // 서버에서 전달된 JWT 토큰 가져오기
      // if (token != null) {
      //   print(token);
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setString('token', token);
      //   return true;
      // } else {
      //   // JWT 토큰이 존재하지 않는 경우, false 반환
      //   print('토큰 없습니다..');
      //   return false;
      print("성공");
      return true;
    } else {
      // 에러가 발생한 경우, false 반환
      return false;
    }
  }

  /* 홈화면 유저 정보 */
  Future<User> userInfo(String userId) async {
    final response = await http.get(
      Uri.parse(APIUrl.userInfoUrl),
      headers: {'Content-Type': 'application/json', 'userId': userId},
    );

    if (response.statusCode == 200) {
      print("이름 ");
      print(json.decode(response.body));
      var tmp = User.fromJson(json.decode(response.body));
      print(tmp.studentName);
      return tmp;
    } else {
      throw Exception('유저 정보 받기 실패');
    }
  }

  /* 내 주차 정보 확인 */
  Future<MyParkingStatus> myParkingStatus(String userId) async {
    final response = await http.get(
      Uri.parse(APIUrl.userParkingInfoUrl),
      headers: {'Content-Type': 'application/json', 'userId': userId},
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return MyParkingStatus.fromJson(json.decode(response.body));
    } else {
      throw Exception('내 주차 정보 받기 실패');
    }
  }

  /* 주차 현황 확인 */
  Future<List<ParkingLotInfo>> nowParking(String userId) async {
    final response = await http.get(Uri.parse(APIUrl.parkingInfoUrl),
        headers: {'Content-Type': 'application/json', 'userId': userId});

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      final List<dynamic> parsedJson = jsonDecode(response.body);
      return parsedJson.map((json) => ParkingLotInfo.fromJson(json)).toList();
    } else {
      throw Exception('현재 주차장 잔여석 정보 받기 실패');
    }
  }

  /* 주차장 주차 현황 확인 */
  Future<List<ParkingArea>> nowParkingLotStatus(String userId) async {
    final response = await http.get(Uri.parse(APIUrl.parkingListUrl),
        headers: {'Content-Type': 'application/json', 'userId': userId});

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      final List<dynamic> parsedJson = jsonDecode(response.body);
      return parsedJson.map((json) => ParkingArea.fromJson(json)).toList();
    } else {
      throw Exception('현재 주차장 정보 받기 실패');
    }
  }

  /* 차량 등록 */
  Future<bool> carRegister(String userId, String carNumber, String modelName) async {

    final response = await http.post(
      Uri.parse(APIUrl.carRegiUrl),
      headers: {'Content-Type': 'application/json','userId': userId},
      body: json.encode({'carNumber': carNumber, 'modelName': modelName}),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      print('성공');
      return true;
    } else {
      print('실패');
      return false;
    }
  }

  /* 로그인 시 차량 등록 여부 확인 */
  Future<ParkingArea> getCarRegiCheck(String userId) async {
    final response = await http.get(Uri.parse(APIUrl.parkingListUrl),
        headers: {'Content-Type': 'application/json', 'userId': userId});

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return ParkingArea.fromJson(json.decode(response.body));
    } else {
      throw Exception('차 등록 여부 데이터 받기 실패');
    }
  }

  /* 주차장 지도에서 주차 등록할 때 보내는 데이터 */
  Future<bool> setParking(String userId, int parkingId) async {
    final response = await http.post(
      Uri.parse(APIUrl.carRegiUrl),
      headers: {'Content-Type': 'application/json','userId': userId},
      body: json.encode({'parkingId': parkingId}),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      print('성공');
      return true;
    } else {
      print('실패');
      return false;
    }
  }
}
