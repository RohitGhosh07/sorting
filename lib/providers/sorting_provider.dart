import 'dart:math';
import 'package:flutter/material.dart';

enum SortingAlgorithm { bubble, merge }

enum SortingState { idle, sorting, paused, completed }

class SortingProvider with ChangeNotifier {
  List<int> _numbers = [];
  SortingAlgorithm _selectedAlgorithm = SortingAlgorithm.bubble;
  SortingState _state = SortingState.idle;
  Set<int> _highlightedIndices = {};
  int _arraySize = 50;
  int _delay = 50; // milliseconds

  // Getters
  List<int> get numbers => _numbers;
  SortingAlgorithm get selectedAlgorithm => _selectedAlgorithm;
  SortingState get state => _state;
  Set<int> get highlightedIndices => _highlightedIndices;
  bool get isSorting => _state == SortingState.sorting;
  bool get isPaused => _state == SortingState.paused;

  SortingProvider() {
    generateRandomArray();
  }

  void setAlgorithm(SortingAlgorithm algorithm) {
    if (_state == SortingState.idle) {
      _selectedAlgorithm = algorithm;
      notifyListeners();
    }
  }

  void generateRandomArray() {
    final random = Random();
    _numbers = List.generate(_arraySize, (index) => random.nextInt(100) + 1);
    _state = SortingState.idle;
    _highlightedIndices.clear();
    notifyListeners();
  }

  void setHighlightedIndices(Set<int> indices) {
    _highlightedIndices = indices;
    notifyListeners();
  }

  void setState(SortingState newState) {
    _state = newState;
    notifyListeners();
  }

  void updateNumbers(List<int> newNumbers) {
    _numbers = newNumbers;
    notifyListeners();
  }

  Future<void> pause() async {
    if (_state == SortingState.sorting) {
      _state = SortingState.paused;
      notifyListeners();
    }
  }

  Future<void> resume() async {
    if (_state == SortingState.paused) {
      _state = SortingState.sorting;
      notifyListeners();
    }
  }

  Future<void> reset() async {
    generateRandomArray();
  }
}
