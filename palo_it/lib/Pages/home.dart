import 'package:flutter/material.dart';
import '../Class/widgetClass/appBarWidget.dart';
import '../Class/widgetClass/drawerWidget.dart';
import '../Class/widgetClass/textBoxWidget.dart';
import '../Class/widgetClass/listViewWidget.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _counter = 0;
  final List<String> items = ["Item 1", "Item 2", "Item 3"];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Widget appBarIcon(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(spreadRadius: 2,
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/icons/MenuIcon.png", width: 30, height: 30),
        ),
      ),
      onTap: () {

      },
    );
  }

  Widget myBody() {
    return Stack(
      children: <Widget>[
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                child: const TextBoxWidget(
                  headerText: "Filter Search",
                ),
              ),
              const Expanded(
                child: ListViewWidget(),
              ),
            ],
          ),
        ),
      ],
    );
  }
  FloatingActionButton myButton(){
    return FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Home Page",),
      drawer: const DrawerWidget(),
      body: myBody(),
    );
  }
}


