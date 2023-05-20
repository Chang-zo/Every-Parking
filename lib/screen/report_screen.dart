import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../datasource/datasource.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  final String userId;
  const ReportScreen({Key? key,required this.userId}) : super(key: key);
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  Datasource ds = new Datasource();
  var title = "";
  var contents = "";
  List<XFile> imageList = [];
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [ Padding(
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
                  onChanged: (text) {
                    setState(() {
                      this.contents = text;
                    });
                  },
                ),

              ),
              SetText(contents: '이미지 첨부'),
              ImageUploader(
                  onChanged : (value) {
                    setState(() {
                      this.imageList = value;
                    });
                  }
              ),

              /* 신고하기 Button */
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      /* 서버 통신 */
                      print('제목 : ${title}, 내용 : ${contents}, 이미지 : ${imageList}' );
                      ds.reportUser(title, contents, imageList, widget.userId);
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
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _pickedImgs = images;
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
            _pickImg();
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
