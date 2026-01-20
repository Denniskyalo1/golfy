import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://fallback.url';
final apikey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color backgroundColor;
  final bool showBackButton;
  final List<Widget>? actions;

  const TopBar({
    super.key,
    this.title,
    this.backgroundColor = Colors.green,
    this.showBackButton = true,
    this.actions
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return AppBar(
      backgroundColor: backgroundColor ?? Colors.blueGrey[100],
      elevation: 0,
      centerTitle: true,
      title: title != null
          ? Text(
        title!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: height * 0.03,
        ),
      )
          : null,
      leading: showBackButton
          ? IconButton(
        icon: Icon(Icons.arrow_back_ios_new, size: height*0.03),
        onPressed: () {
          Navigator.pop(context);
        },
      )
          : null,
      actions: actions,


    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.transparent, width: 1.5)

      ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.transparent, width: 1.5)
          ),
        hintText: widget.hintText,
      ),
    );
  }
}


