import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Class/widgetClass/appBarWidget.dart';
import '../Class/widgetClass/drawerWidget.dart';
import '../Class/widgetClass/textBoxWidget.dart';
import '../Class/widgetClass/listViewWidget.dart';

import '../Class/managerClass/stateManager.dart';

int initCounter = 0;
int _page = 0;
int _limit = 5;

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

    void overrideImageList(int page, int limit)
    {
      // set new parameters
      _page = page;
      _limit = limit;

      //clear and reload the images
      ref.read(stateManagerProvider.notifier).clearImageList();
      loadMoreImages();
    }

    //constructor
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(initCounter < 1) {
        loadMoreImages();
        initCounter++;
      }

    });

    Widget searchBar() {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            hasConnection ?
            const Text(
              "Connected",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 18,
              ),
            ) :
            const Text(
              "Disconnected",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
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
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextBoxWidget(
                    headerText: "Filter Limit",
                    inputMode: InputMode.number,
                    controller: _limitTB,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        overrideImageList(int.parse(_pageTB.text), int.parse(_limitTB.text));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      child: const Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
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
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !isLoading) {
            loadMoreImages();
            return true; // Ensure the notification is handled
          }
          return false; // Return false if condition not met
        },
        child: ListViewWidget(
          images: images,
          isLoading: isLoading,
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
                  scrollEvent() : errorMessage(),
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


