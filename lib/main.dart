import 'package:flutter/material.dart';

void main() {
  runApp(MyGame());
}

class MyGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int oxygen = 100;
  int electricity = 100;
  int water = 100;
  int mood = 100;

  void showMenu(String resource) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Menu for $resource'),
          content: TextButton(
            child: Text('Increase $resource'),
            onPressed: () {
              setState(() {
                switch (resource) {
                  case 'Oxygen':
                    oxygen += 5;
                    break;
                  case 'Electricity':
                    electricity += 5;
                    break;
                  case 'Water':
                    water += 5;
                    break;
                  case 'Mood':
                    mood += 5;
                    break;
                }
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Text('Oxygen: $oxygen'),
              Text('Electricity: $electricity'),
              Text('Water: $water'),
              Text('Mood: $mood'),
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        top: 100,
                        right: 100,
                        child: GestureDetector(
                          onTap: () => showMenu('Oxygen'),
                          child: Image.asset('assets/object4.png', width: 200, height: 200),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        child: GestureDetector(
                          onTap: () => showMenu('Electricity'),
                          child: Image.asset('assets/object1.png', width: 80, height: 80),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        child: GestureDetector(
                          onTap: () => showMenu('Water'),
                          child: Image.asset('assets/object2.png', width: 80, height: 80),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        child: GestureDetector(
                          onTap: () => showMenu('Mood'),
                          child: Image.asset('assets/object3.png', width: 80, height: 80),
                        ),
                      ),
                      Positioned(
                        bottom: 200,
                        child: GestureDetector(
                          onTap: () => showMenu('Hero'),
                          child: Image.asset('assets/hero.png', width: 200, height: 200),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
