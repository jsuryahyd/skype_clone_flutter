import 'package:flutter/material.dart';
import 'package:skype_clone/utils/app_variables.dart';

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subTitle;
  final Widget icon;
  final Widget trailing;
  final EdgeInsets margin;
  final bool isMini;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  CustomTile(
      {@required this.leading,
      @required this.title,
      @required this.subTitle,
      this.margin = const EdgeInsets.all(0),
      this.icon,
      this.trailing,
      this.onLongPress,
      this.isMini,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isMini ? 10 : 5),
        child: Row(
          children: <Widget>[
            leading,
            Expanded(
                          child: Container(
                padding: EdgeInsets.symmetric(vertical: isMini ? 3 : 20),
                margin: EdgeInsets.only(left: isMini ? 10 : 15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom:
                        BorderSide(width: 1, color: AppVariables.separatorColor),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        title,
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[icon ?? Container(), subTitle],
                        )
                      ],
                    ),
                    trailing??Container()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
