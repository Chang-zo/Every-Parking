/* 서버와의 통신 url */
class APIUrl {

  static const String _baseUrl = 'http://everyparking.co.kr/app';

  static String get joinUrl => '$_baseUrl/member/join';
  static String get loginUrl => '$_baseUrl/member/login';
  static String get userInfoUrl => '$_baseUrl/member/userInfo';
  static String get parkingStatusUrl => '$_baseUrl/parking/parkingStatus';
  static String get parkingInfoUrl => '$_baseUrl/parking/parkingInfo';
  static String get alertUrl => '$_baseUrl/alert/alert';
  static String get parkingListUrl => '$_baseUrl/parking/parkingList';
  static String get rentUrl => '$_baseUrl/parking/parking/rent';
  static String get infoUrl => '$_baseUrl/parking/parking/info';

}