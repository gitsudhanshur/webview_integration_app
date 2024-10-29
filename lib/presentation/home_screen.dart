import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView(
        children: [
          ListTile(title: Text('Game 1')),
          ListTile(title: Text('Game 2')),
          ListTile(title: Text('Game 3')),
        ],
      ),
    );
  }
}
