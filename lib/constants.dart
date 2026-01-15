import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color backgroundColor;
  final bool showBackButton;
  final List<Widget>? actions;

  const TopBar({
    super.key,
    this.title,
    this.backgroundColor=Colors.green,
    this.showBackButton=true,
    this.actions
      });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      title: title!= null? Text(
        title!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: height * 0.03,
      ),) :
      null,
      leading:showBackButton?
      IconButton(
          icon: Icon(Icons.arrow_back, size: 30,),
          onPressed:(){
          Navigator.pop(context);
        },
          )
        : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
