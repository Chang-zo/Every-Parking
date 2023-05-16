import 'package:flutter/material.dart';
import 'package:every_parking/screen/main_screen.dart';
import 'package:every_parking/screen/home_screen.dart';
import 'package:every_parking/screen/login_screen.dart';

void main() async {
  runApp(const MyApp());
}

//실행시 가장 먼저 보이는 창
//일단 로그인으로 하고,
//로그인 한번 한 후엔 MainScreen()이 home 이 되도록 해야함.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0.0,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 24),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      //실행 시키면 가장 먼저 보이는 화면
      //home: const LoginScreen(),
      home: const MainScreen(userId: "바보"),
    );
  }
}
