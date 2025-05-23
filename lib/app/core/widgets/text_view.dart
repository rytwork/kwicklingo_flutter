import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  final String? text;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final int maxLines;

  const TextView(
      {Key? key,this.text,
        this.textStyle,
        this.maxLines = 1,
        this.textAlign = TextAlign.start})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text??"",
      style: textStyle,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}
