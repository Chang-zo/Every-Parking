import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../datasource/datasource.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';

import 'main_screen.dart';

class ReportScreen extends StatefulWidget {
  final String userId;
  const ReportScreen({Key? key, required this.userId}) : super(key: key);
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  Datasource ds = new Datasource();
  var title = "";
  var contents = "";

  List<XFile> imageList = [];
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: '제목',
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                contentPadding: EdgeInsets.only(left: 11),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
              ),
              controller: _textEditingController2,
              onChanged: (text) {
                setState(() {
                  this.title = text;
                });
              },
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              height: 10 * 24.0,
              color: Color.fromRGBO(250, 250, 250, 1),
              child: TextField(
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(250, 250, 250, 1),
                    hintText: '내용',
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
                controller: _textEditingController,
                onChanged: (text) {
                  setState(() {
                    this.contents = text;
                  });
                },
              ),
            ),
            SetText(contents: '이미지 첨부'),
            ImageUploader(onChanged: (value) {
              setState(() {
                this.imageList = value;
              });
            }),

            /* 신고하기 Button */
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  onPressed: () async {
                    /* 서버 통신 */
                    print(
                        '제목 : ${title}, 내용 : ${contents}, 이미지 : ${imageList}');
                    var checkReport = await ds.report(
                        title, contents, imageList, widget.userId);

                    if (checkReport) {
                      showDialog(
                          context: context,
                          barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text("신고가 접수되었습니다."),
                              insetPadding:
                                  const EdgeInsets.fromLTRB(0, 80, 0, 80),
                              actions: [
                                TextButton(
                                  child: const Text('확인'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainScreen(
                                                userId: widget.userId,
                                                index: 0,
                                              )),
                                    );
                                  },
                                ),
                              ],
                            );
                          });
                      reloadPage();
                    }
                  },
                  child: Text(
                    '신고하기',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(53, 95, 148, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  void reloadPage() {
    setState(() {
      _textEditingController.text = '';
      _textEditingController2.text = '';
      this.imageList.clear();
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textEditingController2.dispose();
    super.dispose();
  }
}

class SetText extends StatelessWidget {
  const SetText({required this.contents, Key? key}) : super(key: key);

  final String contents;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        contents,
        style: TextStyle(
            fontFamily: "Roboto", fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class ImageUploader extends StatefulWidget {
  const ImageUploader({Key? key, this.onChanged}) : super(key: key);
  final ValueChanged<List<XFile>>? onChanged;

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  @override
  void initState() {
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];

  Future<void> _pickImg() async {
    final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 10);

    if (images != null) {
      setState(() {
        _pickedImgs = images;
      });
      widget.onChanged?.call(_pickedImgs);
    }
  }

  Future<void> _cameraImg() async {
    final XFile? images = await _picker.pickImage(source: ImageSource.camera);

    if (images != null) {
      setState(() {
        _pickedImgs.add(images);
      });
      widget.onChanged?.call(_pickedImgs);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPadMode = MediaQuery.of(context).size.width > 700;

    List<Widget> _boxContents = [
      IconButton(
          onPressed: () {
            showAdaptiveActionSheet(
              context: context,
              actions: <BottomSheetAction>[
                BottomSheetAction(
                  title: const Text('갤러리에서 가져오기'),
                  onPressed: (_) {
                    _pickImg();
                    Navigator.pop(context);
                  },
                ),
                BottomSheetAction(
                  title: const Text('사진 촬영'),
                  onPressed: (_) {
                    _cameraImg();
                    Navigator.pop(context);
                  },
                ),
              ],
              cancelAction: CancelAction(title: const Text('Cancel')),
            );
            // _pickImg();
          },
          icon: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6), shape: BoxShape.circle),
              child: Icon(
                CupertinoIcons.camera,
                color: Color.fromRGBO(53, 95, 148, 1),
              ))),
      Container(),
      Container(),
      _pickedImgs.length <= 4
          ? Container()
          : FittedBox(
              child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      shape: BoxShape.circle),
                  child: Text(
                    '+${(_pickedImgs.length - 4).toString()}',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ))),
    ];

    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.all(2),
      crossAxisCount: isPadMode ? 4 : 4,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      children: List.generate(
          4,
          (index) => DottedBorder(
              child: Container(
                child: Center(child: _boxContents[index]),
                decoration: index <= _pickedImgs.length - 1
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(_pickedImgs[index].path))))
                    : null,
              ),
              color: Colors.grey,
              dashPattern: [5, 3],
              borderType: BorderType.RRect,
              radius: Radius.circular(10))).toList(),
    );
  }
}
