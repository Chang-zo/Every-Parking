import 'package:every_parking/datasource/datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyParkingInfo extends StatefulWidget {
  final String userId;
  final String parkingNum;
  final int parkingId;
  const MyParkingInfo(this.parkingNum, this.parkingId, this.userId, {Key? key})
      : super(key: key);

  @override
  State<MyParkingInfo> createState() => _MyParkingInfoState();
}

class _MyParkingInfoState extends State<MyParkingInfo> {
  //주차 칸이 0이면 주차하지 않은것
  //주차 칸이 0이 아니라면, 해당 칸에 ㅊ주차를 한것
  int myParkingId = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      myParkingId = widget.parkingId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(0xff, 0x49, 0x7a, 0xa6),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 8), // changes position of shadow
                  ),
                ]),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          widget.parkingNum,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          //width: MediaQuery.of(context).size.width * 0.8,
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 8), // changes position of shadow
                                ),
                              ]),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "잔여시간",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.grey,
                                  thickness: 1,
                                  width: 20,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                Text(
                                  "00시 00분",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      myParkingId != 0
                          ? ButtonBar(
                              alignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(
                                            0xFF, 0x2F, 0x64, 0x96),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        try {
                                          if (await Datasource()
                                              .parkingLotReturn(
                                                  widget.userId, myParkingId)) {
                                            print("반납 성공!!!!");
                                            showDialog(
                                                context: context,
                                                barrierDismissible:
                                                    true, // 바깥 영역 터치시 닫을지 여부
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: const Text(
                                                        "주차 반납이 완료되었습니다."),
                                                    insetPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            0, 80, 0, 80),
                                                    actions: [
                                                      TextButton(
                                                        child: const Text('확인'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          } else {
                                            showDialog(
                                                context: context,
                                                barrierDismissible:
                                                    true, // 바깥 영역 터치시 닫을지 여부
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: const Text(
                                                        "주차반납에 실패했습니다."),
                                                    insetPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            0, 80, 0, 80),
                                                    actions: [
                                                      TextButton(
                                                        child: const Text('확인'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          }
                                        } catch (e) {
                                          showDialog(
                                              context: context,
                                              barrierDismissible:
                                                  true, // 바깥 영역 터치시 닫을지 여부
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: const Text(
                                                      "잠시 후 다시 시도해주세요"),
                                                  insetPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 80, 0, 80),
                                                  actions: [
                                                    TextButton(
                                                      child: const Text('확인'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/white/custom.return.right.svg',
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text(
                                            "반납",
                                            style: TextStyle(fontSize: 15),
                                          )
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(
                                            0xFF, 0x2F, 0x64, 0x96),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/white/custom.plus.app.svg',
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text("시간연장")
                                        ],
                                      )),
                                ),
                              ],
                            )
                          : ButtonBar(
                              alignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(
                                            0xFF, 0x2F, 0x64, 0x96),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/white/custom.return.right.svg',
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text("사용자 신고")
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(
                                            0xFF, 0x2F, 0x64, 0x96),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/white/custom.plus.app.svg',
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text("쪽지보내기")
                                        ],
                                      )),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
