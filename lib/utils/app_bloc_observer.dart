import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    debugPrint("AppBlocObserver: $change");
    super.onChange(bloc, change);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    debugPrint("AppBlocObserver: $event");
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('AppBlocObserver error: $error');
    debugPrint('AppBlocObserver stackTrace: $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
