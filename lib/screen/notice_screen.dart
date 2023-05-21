import 'package:flutter/material.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this, //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.8))),
              child: TabBar(
                  unselectedLabelColor: Colors.grey,
                  unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color.fromRGBO(142, 142, 142, 1)),
                  labelColor: Colors.black,
                  labelPadding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                  labelStyle: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  controller: _tabController,
                  indicatorColor: Colors.blue,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(53, 95, 148, 1), width: 4.0),
                  ),
                  tabs: [
                    Text(
                      '알림',
                    ),
                    Text(
                      '공지',
                    ),
                  ])),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(
            child: Text('바보'),
          ),
          Container(child: Text('보바'))
        ],
      ),
    );
  }
}
