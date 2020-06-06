import 'package:flutter/material.dart';
import 'package:skype_clone/utils/app_variables.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leading;
  final Widget title;
  final List<Widget> actions;
  final bool centerTitle;
  const CustomAppBar(
      {Key key,
      @required this.leading,
      @required this.title,
      @required this.actions,
      @required this.centerTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(backgroundColor: AppVariables.blackColor,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
      // padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: AppVariables.separatorColor,
              width: 1.4,
              style: BorderStyle.solid),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}
