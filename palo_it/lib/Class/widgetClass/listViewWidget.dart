import 'package:flutter/material.dart';

class ListViewWidget extends StatelessWidget {
  const ListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2, // Set the elevation for the Card
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            title: Text("test"),
            subtitle: Text("jaha"),
            leading: Icon(Icons.album), // Example icon
            trailing: Icon(Icons.arrow_forward), // Example icon
            onTap: () {
              // Handle tap on Card
              print("hello");
            },
          ),
        );
      }
    );
  }
}
