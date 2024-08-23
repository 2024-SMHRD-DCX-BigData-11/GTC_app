import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_provider.dart';

class GameSelectionScreen extends StatelessWidget {
  final List<String> games = ['Game 1', 'Game 2', 'Game 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Game'),
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(games[index]),
            onTap: () {
              Provider.of<GameProvider>(context, listen: false).selectGame(games[index]);
              Navigator.pushNamed(context, '/room');
            },
          );
        },
      ),
    );
  }
}
