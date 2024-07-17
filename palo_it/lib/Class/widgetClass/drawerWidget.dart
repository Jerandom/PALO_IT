import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

  // createListTile method
  ListTile createListTile(String title, VoidCallback onTap){
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 280,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 90, // Diameter: 60
                    backgroundImage: AssetImage("assets/icons/ProfileIcon.png"),
                  ),
                  SizedBox(height: 20),
                  Text("Drawer Header",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          createListTile('Item 1', () {
            print('Item 1 tapped');
          }),
          createListTile('Item 2', () {
            print('Item 2 tapped');
          }),
        ],
      ),
    );
  }
}
