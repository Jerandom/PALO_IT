import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'ImageManager.dart';

class AppState {
  final List<dynamic> images;
  final bool isLoading;
  final bool isConnected;
  final String errorMsg;

  AppState({
    required this.images,
    required this.isLoading,
    required this.isConnected,
    required this.errorMsg,
  });

  // A convenient method to create initial state
  factory AppState.initial() {
    return AppState(
      images: [],
      isLoading: false,
      isConnected: true,
      errorMsg: "",
    );
  }

  // Method to create a copy of the state with some fields replaced
  AppState copyWith({
    List<dynamic>? setImages,
    bool? setIsLoading,
    bool? setIsConnected,
    String? setErrorMsg,
  }) {
    return AppState(
      images: setImages ?? images,
      isLoading: setIsLoading ?? isLoading,
      isConnected: setIsConnected ?? isConnected,
      errorMsg: setErrorMsg ?? errorMsg,
    );
  }
}

// Define a state notifier for managing the app state
class StateManager extends StateNotifier<AppState> {
  StateManager() : super(AppState.initial()) {
    //constructor
    checkInitialConnectivity();
  }

  //checking connectivity
  final Connectivity _connectivity = Connectivity();
  Future<void> checkInitialConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setConnected(false);
    } else {
      setConnected(true);
    }
  }

  // Function to load more images
  Future<void> loadMoreImages(int page, int limit) async {
    try {
      final newImages = await fetchImages(page, limit);
      state = state.copyWith(
        setImages: [...state.images, ...newImages],
      );
    } catch (e) {
      setErrorMsg("Failed to load images: \n$e");
      throw Exception("Failed to load images: $e");
    }
  }

  Future<void> checkConnectivity(WidgetRef ref) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      ref.read(stateManagerProvider.notifier).setConnected(false);
    } else {
      ref.read(stateManagerProvider.notifier).setConnected(true);
    }
  }

  // Function to update loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(
      setIsLoading: isLoading,
    );
  }

  // Function to update connectivity state
  void setConnected(bool isConnected) {
    state = state.copyWith(
      setIsConnected: isConnected,
    );
  }

  // Function to update error message state
  void setErrorMsg(String errorMsg) {
    state = state.copyWith(
      setErrorMsg: errorMsg,
    );
  }

  void clearImageList(){
    state = state.copyWith(
      setImages: [],
    );
  }
}

// Define a provider for the StateManager
final stateManagerProvider = StateNotifierProvider<StateManager, AppState>((ref) {
  return StateManager();
});

// Define providers for accessing specific parts of the state
final imagesProvider = Provider<List<dynamic>>((ref) => ref.watch(stateManagerProvider).images);
final loadingProvider = Provider<bool>((ref) => ref.watch(stateManagerProvider).isLoading);
final connectionProvider = Provider<bool>((ref) => ref.watch(stateManagerProvider).isConnected);
final errorProvider = Provider<String>((ref) => ref.watch(stateManagerProvider).errorMsg);
