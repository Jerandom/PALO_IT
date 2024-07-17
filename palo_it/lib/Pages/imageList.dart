import 'package:flutter/material.dart';

import '../Class/widgetClass/appBarWidget.dart';
import '../Class/widgetClass/drawerWidget.dart';
import '../Class/widgetClass/textBoxWidget.dart';
import '../Class/widgetClass/listViewWidget.dart';

import '../Class/managerClass/ImageManager.dart';


class MyImageListPage extends StatefulWidget {
  const MyImageListPage({super.key});

  @override
  State<MyImageListPage> createState() => _MyImageListPageState();
}

class _MyImageListPageState extends State<MyImageListPage> {
  int _page = 1;
  int _limit = 1;
  bool _isLoading = false;
  bool _hasConnection = false;
  List<dynamic> _images = [];

  @override
  void initState() {
    super.initState();
    _loadMoreImages();
  }

  Future<void> _loadMoreImages() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasConnection = true;
    });

    try {
      final List<dynamic> newImages = await fetchImages(_page, _limit);
      setState(() {
        _images.addAll(newImages);
        _page++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasConnection = false;
      });
    }
  }

  Widget searchBar(){
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: TextBoxWidget(
              headerText: "Filter Page",
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: TextBoxWidget(
              headerText: "Filter Limit",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: (){

              },
              child: const Text("Search"),
            ),
          ),
        ],
      ),
    );
  }

  Widget scrollEvent(){
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if(scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !_isLoading){
          _loadMoreImages();
          return true;
        }
        return false;
      },
      child: ListViewWidget(
        images: _images,
        isLoading: _isLoading,
      ),
    );
  }

  Widget errorMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'No connection. Please check your internet and try again.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadMoreImages,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget myBody() {
    return Stack(
      children: <Widget>[
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              searchBar(),
              Expanded(
                child: _hasConnection || _images.isNotEmpty ?
                scrollEvent() : errorMessage(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Image Caching Example",),
      drawer: const DrawerWidget(),
      body: myBody(),
    );
  }
}


