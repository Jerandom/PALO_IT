import 'package:flutter/material.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget{
  const AppBarWidget({super.key,
    required this.title});

  final String title;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title,
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold
          )
      ),
      elevation: 0.0,
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //leading: appBarIcon(context),
    );
  }
}
