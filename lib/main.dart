import 'package:flutter/material.dart';
import 'dart:ui';

import '_AirFilterGameScreenState.dart';

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

class MenuItem {
  final String text;
  final Function onPressed;
  final String description;

  MenuItem(
      {required this.text, required this.onPressed, required this.description});
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, int> resources = {
    'oxygen': 100,
    'electricity': 100,
    'water': 100,
    'mood': 100,
  };

  void _onGameEndOxigen(bool won) {
    if(won) {
      setState(() {
        resources['oxygen'] = (resources['oxygen'] ?? 0) + 100;
      });
    } else {
      setState(() {
        resources['oxygen'] = (resources['oxygen'] ?? 0) - 50;
      });
    }
  }

  void changeResource(String resource1, String resource2, int count) {
    setState(() {
      resources[resource1] = (resources[resource1] ?? 0) + count;
      resources[resource2] = (resources[resource2] ?? 0) - count;
    });
  }

  void _showGameAsDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      // Закрыть диалог, нажав вне его области
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      // Цвет фона за диалогом
      transitionDuration: const Duration(milliseconds: 300),
      // Длительность анимации
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: AirFilterGameScreen(
              initialRedCount: 5, // Примерное количество красных частиц
              initialGreenCount: 30, // Примерное количество зеленых частиц
              gameTimeSeconds: 10,
              onGameEnd: _onGameEndOxigen,// Продолжительность игры в секундах
            ), // Ваш виджет игры
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Анимация появления
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }

  List<MenuItem> menuItemsOxygen = [];
  late List<MenuItem> menuItemsMood = [];
  late List<MenuItem> menuItemsElectricity = [];
  late List<MenuItem> menuItemWater = [];

  @override
  void initState() {
    super.initState();
    menuItemsOxygen = [
      MenuItem(
          text: 'Открыть окно',
          onPressed: () => changeResource('oxygen', 'electricity', 5),
          description: "description")
    ];
    menuItemsOxygen.add(MenuItem(
        text: 'Открыть окно 2',
        onPressed: () => changeResource('oxygen', 'electricity', 10),
        description: "description"));
    menuItemsOxygen.add(MenuItem(
        text: 'Открыть окно 2',
        onPressed: () => changeResource('oxygen', 'electricity', 10),
        description: "description"));
    menuItemsOxygen.add(MenuItem(
        text: 'Открыть окно 2',
        onPressed: () => changeResource('oxygen', 'electricity', 10),
        description: "description"));
    menuItemsOxygen.add(MenuItem(
        text: 'Открыть окно 2',
        onPressed: () => changeResource('oxygen', 'electricity', 10),
        description: "description"));
    menuItemsOxygen.add(MenuItem(
        text: 'Открыть окно 2',
        onPressed: () => changeResource('oxygen', 'electricity', 10),
        description: "description"));
    menuItemsOxygen.add(MenuItem(
        text: 'Открыть окно 2',
        onPressed: () => changeResource('oxygen', 'electricity', 10),
        description: "description"));
    menuItemsMood = [
      MenuItem(
          text: 'Выпить воды',
          onPressed: () => changeResource('mood', 'water', 5),
          description: "description")
    ];
    menuItemsMood.add(MenuItem(
        text: 'Выпить воды 2',
        onPressed: () => changeResource('mood', 'water', 10),
        description: "description"));
    menuItemsElectricity = [
      MenuItem(
          text: 'Сжечь мусор',
          onPressed: () => changeResource('electricity', 'oxygen', 5),
          description: "description")
    ];
    menuItemsElectricity.add(MenuItem(
        text: 'Сжечь мусор 2',
        onPressed: () => changeResource('electricity', 'oxygen', 10),
        description: "description"));
    menuItemWater = [
      MenuItem(
          text: 'Отфильтроваить воду',
          onPressed: () => changeResource('water', 'mood', 5),
          description: "description")
    ];
    menuItemWater.add(MenuItem(
        text: 'Отфильтроваить воду 2',
        onPressed: () => changeResource('water', 'mood', 10),
        description: "description"));
  }

  void showCustomMenu(List<MenuItem> menuItems, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Container(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Улучшить $text',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Добавьте это для пространства между текстом и меню
                    ...menuItems.map((menuItem) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(menuItem.text),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue,
                                ),
                                child: Text('Button'),
                                onPressed: () => menuItem.onPressed(),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void openAirFilterGame() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AirFilterGameScreen(
              initialRedCount: 5, // Примерное количество красных частиц
              initialGreenCount: 30, // Примерное количество зеленых частиц
              gameTimeSeconds: 10,
          onGameEnd: _onGameEndOxigen,// Продолжительность игры в секундах
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showGameAsDialog(context),
        child: Icon(Icons.play_arrow),
      ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('Oxygen: ${resources['oxygen']}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      Text('Electricity: ${resources['electricity']}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text('Water: ${resources['water']}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      Text('Mood: ${resources['mood']}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        top: 100,
                        right: 100,
                        child: GestureDetector(
                          onTap: () =>
                              showCustomMenu(menuItemsOxygen, 'кислород'),
                          child: Image.asset('assets/object4.png',
                              width: 200, height: 200),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        child: GestureDetector(
                          onTap: () => showCustomMenu(
                              menuItemsElectricity, 'элетричество'),
                          child: Image.asset('assets/object1.png',
                              width: 80, height: 80),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        child: GestureDetector(
                          onTap: () => showCustomMenu(menuItemWater, 'воду'),
                          child: Image.asset('assets/object2.png',
                              width: 80, height: 80),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        child: GestureDetector(
                          onTap: () =>
                              showCustomMenu(menuItemsMood, 'настроение'),
                          child: Image.asset('assets/object3.png',
                              width: 80, height: 80),
                        ),
                      ),
                      Positioned(
                        bottom: 200,
                        child: GestureDetector(
                          child: Image.asset('assets/hero.png',
                              width: 200, height: 200),
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
