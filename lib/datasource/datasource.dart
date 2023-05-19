import 'dart:convert';
import 'package:every_parking/Model/parkingstatus.dart';
import 'package:every_parking/datasource/APIUrl.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Model/parkingMapStatue.dart';
import '../Model/parkingarea.dart';
import '../Model/user.dart';
import '../Model/parkingLotInfo.dart';

class Datasource {
  /* 회원가입 */
  Future<int> registerUser(int studentId, String studentName, String userId,
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
      print("회원가입 성공");
      return 200;
    } else if (response.statusCode == 400) {
      print("이미 등록된 아이디입니다.");
      return 400;
    } else {
      print("회원가입 실패");
      return 0;
    }
  }

  /* 로그인 요청 */
  Future<int> loginUser(String userId, String password) async {
    final response = await http.post(
      Uri.parse(APIUrl.loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId, 'password': password}),
    );

    if (response.statusCode == 200) {
      print("로그인 성공");

      return 0;
    } else if (response.statusCode == 400) {
      print("아이디 혹은 비번 오류");
      return 1;
    } else {
      print("로그인 실패");
      return 1;
    }
  }

  /* 홈화면 유저 정보 */
  Future<User> userInfo(String userId) async {
    final response = await http.get(
      Uri.parse(APIUrl.userInfoUrl),
      headers: {'Content-Type': 'application/json', 'userId': userId},
    );

    if (response.statusCode == 200) {
      /*TODO 임시 - 인코딩 해결*/
      String userName = json.decode(utf8.decode(response.bodyBytes));
      print(userName);
      // print(json.decode(response.body));

      var tmp = User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      print("홈화면 유저 정보 받아오기 성공 ");
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
      print("내 주차 정보 받아오기 성공" + json.decode(response.body));
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
      print("주차장 현황 받아오기 성공");
      return parsedJson.map((json) => ParkingLotInfo.fromJson(json)).toList();
    } else {
      throw Exception('현재 주차장 잔여석 정보 받기 실패');
    }
  }

  /* 주차장 주차 현황 확인 */
  Future<Iterable<parkingMapStatues>> nowParkingLotStatus(String userId) async {
    final response = await http.get(Uri.parse(APIUrl.parkingListUrl),
        headers: {'Content-Type': 'application/json', 'userId': userId});

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      final List<dynamic> parsedJson = jsonDecode(response.body);
      return parsedJson.map((json) => parkingMapStatues.fromJson(json));
    } else {
      throw Exception('현재 주차장 정보 받기 실패');
    }
  }

  /* 차량 등록 */
  Future<int> carRegister(
      String userId, String carNumber, String modelName) async {
    final response = await http.post(
      Uri.parse(APIUrl.carRegiUrl),
      headers: {'Content-Type': 'application/json', 'userId': userId},
      body: json.encode({'carNumber': carNumber, 'modelName': modelName}),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      print('차량 등록 성공');
      return 200;
    } else if (response.statusCode == 400) {
      print('중복된 차량');
      return 400;
    } else {
      print('차량등록 실패');
      return 0;
    }
  }

  /* 로그인 시 차량 등록 여부 확인 */
  Future<bool> getCarRegiCheck(String userId) async {
    final response = await http.get(Uri.parse(APIUrl.parkingListUrl),
        headers: {'Content-Type': 'application/json', 'userId': userId});

    if (response.statusCode == 200) {
      print("차량 등록");
      print(json.decode(response.body));
      return true;
    } else {
      print("차량 미등록 ");
      print(json.decode(response.body));
      return false;
    }
  }

  /* 주차장 지도에서 주차 등록할 때 보내는 데이터 */
  Future<bool> setParking(String userId, int parkingId) async {
    final response = await http.post(
      Uri.parse(APIUrl.carRegiUrl),
      headers: {'Content-Type': 'application/json', 'userId': userId},
      body: json.encode({'parkingId': parkingId}),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      print('주차 성공');
      return true;
    } else {
      print('주차 실패');
      return false;
    }
  }
}
