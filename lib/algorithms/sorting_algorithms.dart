import 'package:flutter/foundation.dart';

class SortingAlgorithms {
  static Future<void> bubbleSort({
    required List<int> numbers,
    required Function(List<int>) onUpdate,
    required Function(Set<int>) onHighlight,
    required ValueNotifier<bool> isPaused,
    required int delay,
  }) async {
    int n = numbers.length;

    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        // Wait while paused
        while (isPaused.value) {
          await Future.delayed(const Duration(milliseconds: 100));
        }

        // Highlight current comparison
        onHighlight({j, j + 1});
        await Future.delayed(Duration(milliseconds: delay));

        if (numbers[j] > numbers[j + 1]) {
          // Swap elements
          int temp = numbers[j];
          numbers[j] = numbers[j + 1];
          numbers[j + 1] = temp;
          onUpdate(List.from(numbers));
        }
      }
    }

    onHighlight({});
  }

  static Future<void> mergeSort({
    required List<int> numbers,
    required Function(List<int>) onUpdate,
    required Function(Set<int>) onHighlight,
    required ValueNotifier<bool> isPaused,
    required int delay,
  }) async {
    await _mergeSortHelper(
      numbers,
      0,
      numbers.length - 1,
      onUpdate,
      onHighlight,
      isPaused,
      delay,
    );
    onHighlight({});
  }

  static Future<void> _mergeSortHelper(
    List<int> numbers,
    int left,
    int right,
    Function(List<int>) onUpdate,
    Function(Set<int>) onHighlight,
    ValueNotifier<bool> isPaused,
    int delay,
  ) async {
    if (left < right) {
      int mid = (left + right) ~/ 2;

      await _mergeSortHelper(
        numbers,
        left,
        mid,
        onUpdate,
        onHighlight,
        isPaused,
        delay,
      );
      await _mergeSortHelper(
        numbers,
        mid + 1,
        right,
        onUpdate,
        onHighlight,
        isPaused,
        delay,
      );

      await _merge(
        numbers,
        left,
        mid,
        right,
        onUpdate,
        onHighlight,
        isPaused,
        delay,
      );
    }
  }

  static Future<void> _merge(
    List<int> numbers,
    int left,
    int mid,
    int right,
    Function(List<int>) onUpdate,
    Function(Set<int>) onHighlight,
    ValueNotifier<bool> isPaused,
    int delay,
  ) async {
    List<int> leftArray = numbers.sublist(left, mid + 1);
    List<int> rightArray = numbers.sublist(mid + 1, right + 1);

    int i = 0, j = 0, k = left;

    while (i < leftArray.length && j < rightArray.length) {
      // Wait while paused
      while (isPaused.value) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      onHighlight({k});
      await Future.delayed(Duration(milliseconds: delay));

      if (leftArray[i] <= rightArray[j]) {
        numbers[k] = leftArray[i];
        i++;
      } else {
        numbers[k] = rightArray[j];
        j++;
      }
      onUpdate(List.from(numbers));
      k++;
    }

    while (i < leftArray.length) {
      while (isPaused.value) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      onHighlight({k});
      await Future.delayed(Duration(milliseconds: delay));

      numbers[k] = leftArray[i];
      onUpdate(List.from(numbers));
      i++;
      k++;
    }

    while (j < rightArray.length) {
      while (isPaused.value) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      onHighlight({k});
      await Future.delayed(Duration(milliseconds: delay));

      numbers[k] = rightArray[j];
      onUpdate(List.from(numbers));
      j++;
      k++;
    }
  }
}
