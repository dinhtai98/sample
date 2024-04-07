import 'package:flutter/cupertino.dart';

extension CollectionExtension on List? {
  bool get isNullOrEmpty =>
      this == null || this is! List || (this as List).isEmpty;

  bool get notNullOrEmpty =>
      this != null && this is List && (this as List).isNotEmpty;

  T? getOrNull<T>(int index) {
    if (this == null) {
      return null;
    }
    if (index >= 0 && index < this!.length) {
      return this![index];
    }
    return null;
  }

  List<T> mapNotNull<T>(T? Function(dynamic e) block) {
    List<T> mapList = [];
    if (this == null) {
      return mapList;
    }
    this?.forEach((element) {
      try {
        if (element != null) {
          final e = block(element);
          if (e != null) {
            mapList.add(e);
          }
        }
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    });
    return mapList;
  }

  bool validIndex(int index) {
    if (this == null) return false;
    if (this!.isEmpty) return false;
    return index < this!.length && index >= 0;
  }
}

bool areListsEqual<T>(List<T>? a, List<T>? b,
    {bool Function(T a, T b)? compare}) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  if (compare != null) {
    for (int index = 0; index < a.length; index += 1) {
      if (!compare(a[index], b[index])) {
        return false;
      }
    }
  } else {
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) {
        return false;
      }
    }
  }
  return true;
}

extension ListExtension<T> on Iterable<T> {
  Iterable<T> except(Iterable<T> elements) {
    var result = List<T>.from(this);
    if (elements.isEmpty) return result;

    for (var element in elements) {
      while (result.contains(element)) {
        result.remove(element);
      }

      if (result.isEmpty) {
        break;
      }
    }
    return result;
  }

  Iterable<T> intersect(Iterable<T> elements) {
    var result = <T>[];
    if (elements.isEmpty) return [];

    for (var element in elements) {
      if (contains(element)) {
        result.add(element);
      }
    }
    return result.toSet().toList();
  }
}
