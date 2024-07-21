import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Class/widgetClass/appBarWidget.dart';
import '../Class/widgetClass/dialogWidget.dart';
import '../Class/widgetClass/drawerWidget.dart';
import '../Class/widgetClass/textBoxWidget.dart';
import '../Class/widgetClass/listViewWidget.dart';

import '../Class/managerClass/stateManager.dart';

int initCounter = 0;
int _page = 0;
int _limit = 5;

bool tbPageError = true;
bool tbLimitError = true;

late final TextEditingController _pageTB = TextEditingController();
late final TextEditingController _limitTB = TextEditingController();

class MyImageListPage extends ConsumerWidget {
  const MyImageListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access state variables
    final appState = ref.watch(stateManagerProvider);
    final images = appState.images;
    final isLoading = appState.isLoading;
    final hasConnection = appState.isConnected;
    final errorMsg = appState.errorMsg;

    // Function to load more images
    Future<void> loadMoreImages() async {
      //reset the error
      ref.read(stateManagerProvider.notifier).clearErrorMsg();

      // to prevent multiple calls of loading more images
      if (isLoading) return;

      // Set loading state to true
      ref.read(stateManagerProvider.notifier).setLoading(true);

      try {
        // Load more images
        await ref.read(stateManagerProvider.notifier).loadMoreImages(_page, _limit);
        _page ++;

        // Set state
        ref.read(stateManagerProvider.notifier).setLoading(false);
        ref.read(stateManagerProvider.notifier).setConnected(true);
      } catch (e) {
        // Handle errors: set loading and connection state to false
        ref.read(stateManagerProvider.notifier).setLoading(false);
        ref.read(stateManagerProvider.notifier).setConnected(false);
      }
    }

    void setPageError(bool? status){
      tbPageError = status!;
    }

    void setLimitError(bool? status){
      tbLimitError = status!;
    }

    void overrideImageList(int page, int limit)
    {
      // set new parameters
      _page = page;
      _limit = limit;

      //clear and reload the images
      ref.read(stateManagerProvider.notifier).clearImageList();
      loadMoreImages();
    }

    Future<void> refreshImage() async {
      // refresh the page
      _page = 0;
      ref.read(stateManagerProvider.notifier).clearImageList();
      await loadMoreImages();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(initCounter < 1) {
        loadMoreImages();
        initCounter++;
      }

      if(errorMsg.isNotEmpty) {
        showPopupDialog(context, "Alert", errorMsg);
      }
    });

    Widget searchBar() {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              hasConnection ? "Connected" : "Disconnected",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: hasConnection ? Colors.green : Colors.red,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextBoxWidget(
                    headerText: "Filter Page",
                    inputMode: InputMode.number,
                    controller: _pageTB,
                    hasError: setPageError,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextBoxWidget(
                    headerText: "Filter Limit",
                    inputMode: InputMode.number,
                    controller: _limitTB,
                    hasError: setLimitError,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if(tbPageError == true || tbLimitError == true)
                    {
                      ref.read(stateManagerProvider.notifier).setErrorMsg("Please enter ensure that both inputs are of correct values");
                    }
                    else{
                      overrideImageList(int.parse(_pageTB.text), int.parse(_limitTB.text));
                    }
                  },
                  child: const Text("Search"),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget scrollEvent() {
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification &&
              scrollInfo.metrics.extentAfter == 0 &&
              !isLoading) {
            loadMoreImages();
            return true;
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: refreshImage,
          child: ListViewWidget(
            images: images,
            isLoading: isLoading,
          ),
        )
      );
    }

    Widget retry() {
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
              onPressed: loadMoreImages,
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
                  child: hasConnection || images.isNotEmpty ?
                  scrollEvent() : retry(),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: const AppBarWidget(title: "Image Caching Example",),
      drawer: const DrawerWidget(),
      body: myBody(),
    );
  }
}


