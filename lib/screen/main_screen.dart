import 'package:flutter/material.dart';
import 'package:every_parking/screen/home_screen.dart';
import 'package:every_parking/screen/my_page_screen.dart';
import 'package:every_parking/screen/notice_screen.dart';
import 'package:every_parking/screen/report_screen.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bottom_indicator_bar_svg/bottom_indicator_bar_svg.dart';

class MainScreen extends StatefulWidget {
  final String userId;
  const MainScreen({Key? key, required this.userId}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _selectedIndex = 0;

  final List<BottomIndicatorNavigationBarItem> items = [
    BottomIndicatorNavigationBarItem(
      icon: 'assets/icons/black/custom.house.fill.2.svg',
      activeIcon: 'assets/icons/blue/custom.house.fill.2.svg',
      label: '홈',
    ),
    BottomIndicatorNavigationBarItem(
      icon:
          'assets/icons/black/custom.bubble.left.and.exclamationmark.bubble.right.svg',
      activeIcon:
          'assets/icons/blue/custom.bubble.left.and.exclamationmark.bubble.right.svg',
      label: '신고',
    ),
    /*BottomIndicatorNavigationBarItem(
      icon: 'assets/icons/black/custom.bell.svg',
      activeIcon: 'assets/icons/blue/custom.bell.svg',
      label: '알림',
    ),*/
    BottomIndicatorNavigationBarItem(
      icon: 'assets/icons/black/custom.person.crop.circle.svg',
      activeIcon: 'assets/icons/blue/custom.person.crop.circle.svg',
      label: '마이페이지',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(
            userId: widget.userId,
          ),
          ReportScreen(
            userId: widget.userId,
          ),
          //NoticeScreen(),
          MyPageScreen(userId: widget.userId),
        ],
      ),
      bottomNavigationBar: BottomIndicatorBar(
        onTap: (index) {
          FocusScope.of(context).unfocus();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        items: items,
        iconSize: 30.0,
        barHeight: 70.0,
        activeColor: Colors.blue,
        inactiveColor: Colors.black,
        indicatorColor: Colors.blue,
        backgroundColor: Colors.white,
      ),
    );
  }
}
