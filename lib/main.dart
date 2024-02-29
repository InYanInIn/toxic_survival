import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui';
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

class MenuItem {
  final String text;
  final Function onPressed;
  final String description;

  MenuItem(
      {required this.text, required this.onPressed, required this.description});
}

class Particle {
  Offset position;
  Offset targetPosition;
  bool isClean;

  Particle({required this.position, required this.targetPosition, this.isClean = false});
}

class AirFilterGameScreen extends StatefulWidget {
  @override
  _AirFilterGameScreenState createState() => _AirFilterGameScreenState();
}

class _AirFilterGameScreenState extends State<AirFilterGameScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];
  final rand = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..addListener(_moveParticles)
      ..repeat();

    _initParticles();
  }

  void _initParticles() {
    particles = List.generate(20, (_) => Particle(
      position: Offset(rand.nextDouble() * MediaQuery.of(context).size.width,
          rand.nextDouble() * MediaQuery.of(context).size.height),
      targetPosition: Offset(rand.nextDouble() * MediaQuery.of(context).size.width,
          rand.nextDouble() * MediaQuery.of(context).size.height),
      isClean: rand.nextBool(),
    ));
  }


  void _moveParticles() {
    setState(() {
      for (var particle in particles) {
        final dx = (particle.targetPosition.dx - particle.position.dx) * 0.05;
        final dy = (particle.targetPosition.dy - particle.position.dy) * 0.05;
        particle.position = Offset(particle.position.dx + dx, particle.position.dy + dy);

        // Периодически обновляем целевую позицию
        if (rand.nextDouble() < 0.01) {
          particle.targetPosition = Offset(rand.nextDouble() * MediaQuery.of(context).size.width,
              rand.nextDouble() * MediaQuery.of(context).size.height);
        }
      }
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  void _cleanParticle(int index) {
    setState(() {
      particles[index].isClean = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: particles.map((particle) => Positioned(
          left: particle.position.dx,
          top: particle.position.dy,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: particle.isClean ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        )).toList(),
      ),
    );
  }
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

  void changeResource(String resource1, String resource2, int count) {
    setState(() {
      resources[resource1] = (resources[resource1] ?? 0) + count;
      resources[resource2] = (resources[resource2] ?? 0) - count;
    });
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
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AirFilterGameScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openAirFilterGame,
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
