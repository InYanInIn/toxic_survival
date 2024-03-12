import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piranha Attack!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PiranhaGame(),
    );
  }
}

class PiranhaGame extends StatefulWidget {
  @override
  _PiranhaGameState createState() => _PiranhaGameState();
}

class _PiranhaGameState extends State<PiranhaGame> {
  static const double _playerSize = 50;
  static const double _piranhaSize = 80;
  static const double _speed = 2;

  Timer? _timer;
  List<Offset> _piranhaPositions = [];

  Offset playerTopLeft = Offset.zero;
  Offset playerBottomRight = Offset.zero;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    int i = 0;
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (i >= 10) {
        _addPiranha();
        i = 0;
      }
      _movePiranhas();
      _checkCollision();
      i++;
    });
  }

  void _addPiranha() {
    final random = Random();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final edge = random.nextInt(4);
    double piranhaX = 0, piranhaY = 0;

    switch (edge) {
      case 0: // top edge
        piranhaX = random.nextDouble() * screenWidth;
        piranhaY = -_piranhaSize / 2; // Учитываем центр пираньи
        break;
      case 1: // right edge
        piranhaX = screenWidth + _piranhaSize / 2;
        piranhaY = random.nextDouble() * screenHeight;
        break;
      case 2: // bottom edge
        piranhaX = random.nextDouble() * screenWidth;
        piranhaY = screenHeight + _piranhaSize / 2;
        break;
      case 3: // left edge
        piranhaX = -_piranhaSize / 2;
        piranhaY = random.nextDouble() * screenHeight;
        break;
    }

    setState(() {
      _piranhaPositions.add(Offset(piranhaX, piranhaY));
    });
  }

  void _movePiranhas() {
    setState(() {
      _piranhaPositions = _piranhaPositions.map((position) {
        final playerCenter = Offset(MediaQuery.of(context).size.width / 2,
            MediaQuery.of(context).size.height / 2);
        final dx = position.dx +
            (_speed * (playerCenter.dx - position.dx > 0 ? 1 : -1));
        final dy = position.dy +
            (_speed * (playerCenter.dy - position.dy > 0 ? 1 : -1));
        return Offset(dx, dy);
      }).toList();
    });
  }

  void _checkCollision() {
    final playerTopLeft = Offset(
        MediaQuery.of(context).size.width / 2 - _playerSize / 2,
        MediaQuery.of(context).size.height / 2 - _playerSize / 2);
    final playerBottomRight = Offset(
        MediaQuery.of(context).size.width / 2 + _playerSize / 2,
        MediaQuery.of(context).size.height / 2 + _playerSize / 2);

    setState(() {
      _piranhaPositions = _piranhaPositions.where((piranhaPosition) {
        final piranhaTopLeft = piranhaPosition;
        final piranhaBottomRight = Offset(piranhaPosition.dx + _piranhaSize,
            piranhaPosition.dy + _piranhaSize);

        final playerIntersect =
            piranhaTopLeft.dx < playerBottomRight.dx &&
                piranhaBottomRight.dx > playerTopLeft.dx &&
                piranhaTopLeft.dy < playerBottomRight.dy &&
                piranhaBottomRight.dy > playerTopLeft.dy;

        return !playerIntersect;
      }).toList();
    });
  }

  void _removePiranha(int index) {
    setState(() {
      _piranhaPositions.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Piranha Attack!'),
      ),
      body: GestureDetector(
        onTapDown: (TapDownDetails details) {
          final RenderBox renderBox =
          context.findRenderObject() as RenderBox;
          final Offset localPosition =
          renderBox.globalToLocal(details.globalPosition);

          for (int i = 0; i < _piranhaPositions.length; i++) {
            final piranhaPosition = _piranhaPositions[i];
            final piranhaTopLeft = piranhaPosition;
            final piranhaBottomRight = Offset(piranhaPosition.dx + _piranhaSize,
                piranhaPosition.dy + _piranhaSize);
            final piranhaIntersect = piranhaTopLeft.dx < playerBottomRight.dx &&
                piranhaBottomRight.dx > playerTopLeft.dx &&
                piranhaTopLeft.dy < playerBottomRight.dy &&
                piranhaBottomRight.dy > playerTopLeft.dy;
            if (piranhaIntersect) {
              _removePiranha(i);
              break;
            }
          }
        },
        child: Stack(
          children: [
            Container(
              color: Colors.pink,
              width: double.infinity,
              height: double.infinity,
            ),
            Center(
              child: Container(
                width: _playerSize,
                height: _playerSize,
                color: Colors.blue,
              ),
            ),
            ..._piranhaPositions.map((piranhaPosition) {
              return Positioned(
                left: piranhaPosition.dx - _piranhaSize / 2,
                top: piranhaPosition.dy - _piranhaSize / 2,
                child: GestureDetector(
                  onTap: () {
                    _removePiranha(_piranhaPositions.indexOf(piranhaPosition));
                  },
                  child: Container(
                    width: _piranhaSize,
                    height: _piranhaSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
