import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      elevation: 0,
      leading:IconButton(
          icon: Icon(Icons.arrow_back, size: 30,),
          onPressed:(){
          Navigator.pop(context);
        },

          )  ,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
