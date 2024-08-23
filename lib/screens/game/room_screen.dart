import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_provider.dart';

class RoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedGame = Provider.of<GameProvider>(context).selectedGame;

    return Scaffold(
      appBar: AppBar(
        title: Text('Room for $selectedGame'),
      ),
      body: Center(
        child: Text('Welcome to the room of $selectedGame!'),
      ),
    );
  }
}
