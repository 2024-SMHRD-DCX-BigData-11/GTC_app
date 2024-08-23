import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  String _selectedGame = '';

  String get selectedGame => _selectedGame;

  void selectGame(String game) {
    _selectedGame = game;
    notifyListeners();
  }
}
