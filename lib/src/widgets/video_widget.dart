import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:status_viewer/src/utils/theme.dart';

class VideosListCard extends StatefulWidget {
  final Function() onPressedPlay;
  final File file;

  VideosListCard({
    required this.onPressedPlay,
    required this.file,
  });

  @override
  _VideosListCardState createState() => _VideosListCardState();
}

class _VideosListCardState extends State<VideosListCard> {
  final double _downloadTop = ItemSize.spaceHeight(165);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(minHeight: 50.h, minWidth: 30.w),
          width: 348.w,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.3),
                blurRadius: 7, // soften the shadow
                spreadRadius: 0.0, //extend the shadow
                offset: const Offset(
                  0.0, // Move to right 10  horizontally
                  -.1, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          child: Card(
            shadowColor: Colors.black,
            clipBehavior: Clip.hardEdge,
            // margin: EdgeInsets.only(left: 4.w, right: 4.w),
            elevation: 4,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.slow_motion_video_outlined,
                    size: ItemSize.fontSize(30),
                  ),
                ),
                LayoutBuilder(builder: (context, constraint) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    height: ItemSize.spaceHeight(60),
                    width: constraint.biggest.width.isFinite
                        ? constraint.biggest.width
                        : ItemSize.spaceWidth(300),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: constraint.biggest.width.isFinite
                              ? constraint.biggest.width
                              : ItemSize.spaceWidth(300),
                          child: ClipRRect(
                            child: Hero(
                              tag: "dadsad",
                              child: Image.file(
                                widget.file,
                                height: ItemSize.spaceHeight(200),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 80.h,
                          left: 130.w,
                          child: MaterialButton(
                            elevation: 0.0,
                            visualDensity: VisualDensity.compact,
                            onPressed: widget.onPressedPlay,
                            color: Colors.redAccent.withOpacity(0.8),
                            textColor: Colors.white,
                            child: Icon(
                              Icons.play_arrow,
                              size: ItemSize.fontSize(50),
                            ),
                            padding: EdgeInsets.all(ItemSize.radius(10)),
                            shape: const CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: ItemSize.spaceHeight(20),
        )
      ],
    );
  }

  TextStyle _textStyle1(
      BuildContext context, double fontSize, FontWeight fontWeight) {
    return TextStyle(
        color: Colors.black87.withOpacity(0.8),
        fontWeight: fontWeight,
        fontFamily: Theme.of(context).textTheme.subtitle1!.fontFamily,
        fontSize: fontSize);
  }
}
