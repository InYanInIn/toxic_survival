import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toxic_survival/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/menu.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50), // Добавьте это для пространства сверху
              ElevatedButton(
                child: Container(), // Удалите виджет Text и замените его на пустой контейнер
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.transparent, backgroundColor: Colors.transparent, shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Убираем скругление углов
                  ),
                  minimumSize: Size(200, 60), // Делаем эффект нажатия прозрачным
                  shadowColor: Colors.transparent, // Делаем тень кнопки прозрачной
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
              ),
              SizedBox(height: 27),
              ElevatedButton(
                child: Container(), // Удалите виджет Text и замените его на пустой контейнер
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.transparent, backgroundColor: Colors.transparent, shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Убираем скругление углов
                ),
                  minimumSize: Size(200, 60), // Делаем эффект нажатия прозрачным
                  shadowColor: Colors.transparent, // Делаем тень кнопки прозрачной
                ),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InteractiveObject {
  int clickCount = 0;
  int imageIndex = 0;
  List<String> images;

  InteractiveObject({required this.images});

  void incrementClickCount(String key) {
    clickCount += 1;
    if (clickCount >= 10) {
      clickCount = 0; // Сбросить счетчик
      imageIndex = (imageIndex + 1); // Перейти к следующему изображению
      GameStorage.saveImageIndex(key, imageIndex); // Сохранить индекс изображения
    }
  }

  String get image => images[imageIndex];
}

class GameStorage {
  static Future<void> saveGameData(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static Future<int> loadGameData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0; // Возвращает 0, если ключ не найден
  }

  static Future<void> saveImageIndex(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static Future<int> loadImageIndex(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0; // Возвращает 0, если ключ не найден
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
  InteractiveObject object4 = InteractiveObject(
    images: [
      'assets/fan.png',
      'assets/air_purifier.png',
      'assets/new_image4_2.png',
      'assets/new_image4_3.png',
      'assets/new_image4_4.png',
    ],
  );
  InteractiveObject object3 = InteractiveObject(
    images: [
      'assets/plant_1.png',
      'assets/plant_2.png',
      'assets/plant_3.png',
      'assets/new_image3_3.png',
      'assets/new_image3_4.png',
    ],
  );
  InteractiveObject object2 = InteractiveObject(
    images: [
      'assets/object2.png',
      'assets/new_image2_1.png',
      'assets/new_image2_2.png',
      'assets/new_image2_3.png',
      'assets/new_image2_4.png',
    ],
  );
  InteractiveObject object1 = InteractiveObject(
    images: [
      'assets/flame200.png',
      'assets/new_image1_1.png',
      'assets/new_image1_2.png',
      'assets/new_image1_3.png',
      'assets/new_image1_4.png',
    ],
  );

  Map<String, int> resources = {
    'oxygen': 100,
    'electricity': 100,
    'water': 100,
    'mood': 100,
  };

  void _onGameEndOxigen(bool won) {
    if (won) {
      setState(() {
        resources['oxygen'] = (resources['oxygen'] ?? 0) + 100;
        GameStorage.saveGameData('oxygen', resources['oxygen']!);
      });
    } else {
      setState(() {
        resources['oxygen'] = (resources['oxygen'] ?? 0) - 50;
        GameStorage.saveGameData('oxygen', resources['oxygen']!);
      });
    }
  }

  void changeResource(String resource1, String resource2, int count) {
    setState(() {
      resources[resource1] = (resources[resource1] ?? 0) + count;
      resources[resource2] = (resources[resource2] ?? 0) - count;
      GameStorage.saveGameData(resource1, resources[resource1]!);
      GameStorage.saveGameData(resource2, resources[resource2]!);
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

  void loadSavedData() async {
    resources['oxygen'] = await GameStorage.loadGameData('oxygen');
    resources['electricity'] = await GameStorage.loadGameData('electricity');
    resources['water'] = await GameStorage.loadGameData('water');
    resources['mood'] = await GameStorage.loadGameData('mood');
  }

  @override
  void initState() {
    super.initState();
    loadSavedData();
    menuItemsOxygen = [
      MenuItem(
          text: 'open the window',
          onPressed: () {
            changeResource('oxygen', 'electricity', 5);
            object4.incrementClickCount('oxygenState'); // Увеличиваем счетчик здесь
          },
          description: "description")
    ];
    menuItemsOxygen.add(MenuItem(
        text: 'open the door',
        onPressed: () {
          changeResource('oxygen', 'electricity', 10);
          object4.incrementClickCount('State'); // Увеличиваем счетчик здесь
        },
        description: "description"));
    menuItemsMood = [
      MenuItem(
          text: 'drink water',
          onPressed: () {
            changeResource('mood', 'water', 5);
            object3.incrementClickCount('moodState');  // Увеличиваем счетчик здесь
          },
          description: "description")
    ];
    menuItemsMood.add(MenuItem(
        text: 'drink a pot of water',
        onPressed: () {
          changeResource('mood', 'water', 10);
          object3.incrementClickCount('moodState'); // Увеличиваем счетчик здесь

        },
        description: "description"));
    menuItemsElectricity = [
      MenuItem(
          text: 'burn the garbage',
          onPressed: () {
            changeResource('electricity', 'oxygen', 5);
            object1.incrementClickCount('electricityState');
          },
          description: "description")
    ];
    menuItemsElectricity.add(MenuItem(
        text: 'burn the trash can',
        onPressed: () {
          changeResource('electricity', 'oxygen', 10);
          object1.incrementClickCount('electricityState');
        },
        description: "description"));
    menuItemWater = [
      MenuItem(
          text: 'filter the water',
          onPressed: () {
            changeResource('water', 'mood', 5);
            object2.incrementClickCount('waterState');
          },
          description: "description")
    ];
    menuItemWater.add(MenuItem(
        text: 'filter a lot of water',
        onPressed: () {
          changeResource('water', 'mood', 10);
          object2.incrementClickCount('waterState');
        },
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
                      'Upgrade $text',
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
    showDialog(
      context: context,
      barrierDismissible: false, // Пользователь должен явно закрыть диалог
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Перехватываем и блокируем попытки "назад"
          child: Dialog(
            child: AirFilterGameScreen(
              initialRedCount: 5, // Примерное количество красных частиц
              initialGreenCount: 30, // Примерное количество зеленых частиц
              gameTimeSeconds: 10,
              onGameEnd: _onGameEndOxigen,// Продолжительность игры в секундах
            ),
          ),
        );
      },
    );
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
                        top: 200,
                        right: 60,
                        child: GestureDetector(
                          onTap: () {
                            showCustomMenu(menuItemsOxygen, 'oxygen');
                          },
                          child: Transform.scale(
                            scale: 1.5,
                            child: Image.asset(object4.image,
                                width: 300,
                                height: 300,
                                filterQuality: FilterQuality.none),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        bottom: 270,
                        child: GestureDetector(
                          onTap: () {
                            showCustomMenu(
                                menuItemsElectricity, 'electricity');
                          },
                          child: Transform.scale(
                            scale: 2,
                            child: Image.asset(object1.image,
                                width: 150,
                                height: 150,
                                filterQuality: FilterQuality.none),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 200,
                        child: GestureDetector(
                          onTap: () {
                            showCustomMenu(menuItemWater, 'water');
                          },
                          child: Transform.scale(
                            scale: 2.0, // Увеличиваем в 2 раза
                            child: Image.asset(object2.image,
                                width: 80,
                                height: 80,
                                filterQuality: FilterQuality.none),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 60,
                        bottom: 300,
                        child: GestureDetector(
                          onTap: () {
                            showCustomMenu(menuItemsMood, 'mood');
                          },
                          child: Transform.scale(
                            scale: 2.0, // Увеличиваем в 2 раза
                            child: Image.asset(object3.image,
                                width: 80,
                                height: 80,
                                filterQuality: FilterQuality.none),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 350,
                        child: Transform.scale(
                          scale: 2.0, // Увеличиваем в 2 раза
                          child: Image.asset('assets/hero.png',
                              filterQuality: FilterQuality.none),
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