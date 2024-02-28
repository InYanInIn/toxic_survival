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

  MenuItem({required this.text, required this.onPressed, required this.description});
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



  void changeResource(int resource1, int resource2, int count){
    print('$resource1 $resource2 $count');
    setState(() {
      switch(resource1){
        case 0:
          oxygen += count;
          break;
        case 1:
          electricity += count;
          break;
        case 2:
          water += count;
          break;
        case 3:
          mood += count;
          break;
      }
      switch(resource2){
        case 0:
          oxygen -= count;
          break;
        case 1:
          electricity -= count;
          break;
        case 2:
          water -= count;
          break;
        case 3:
          mood -= count;
          break;
      }
    });
  }


  List<MenuItem> menuItemsOxygen = [];
  late List<MenuItem> menuItemsMood = [];
  late List<MenuItem> menuItemsElectricity = [];
  late List<MenuItem> menuItemWater = [];

  @override
  void initState() {
    super.initState();
    menuItemsOxygen = [MenuItem(text: 'Открыть окно', onPressed: () => changeResource(0, 1, 5), description: "description")];
    menuItemsMood = [MenuItem(text: 'Выпить воды', onPressed: () => changeResource(3, 2, 5), description: "description")];
    menuItemsElectricity = [MenuItem(text: 'Сжечь мусор', onPressed: () => changeResource(1, 0, 5), description: "description")];
    menuItemWater = [MenuItem(text: 'Отфильтроваить воду', onPressed: () => changeResource(2, 3, 5), description: "description")];
  }


  void showCustomMenu(List<MenuItem> menuItems) {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: menuItems.map((menuItem) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
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
                                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                              ),
                              child: Text('Button'),
                              onPressed: () => menuItem.onPressed(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
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
                          onTap: () => showCustomMenu(menuItemsOxygen),
                          child: Image.asset('assets/object4.png', width: 200, height: 200),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        child: GestureDetector(
                          onTap: () => showCustomMenu(menuItemsElectricity),
                          child: Image.asset('assets/object1.png', width: 80, height: 80),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        child: GestureDetector(
                          onTap: () => showCustomMenu(menuItemWater),
                          child: Image.asset('assets/object2.png', width: 80, height: 80),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        child: GestureDetector(
                          onTap: () => showCustomMenu(menuItemsMood),
                          child: Image.asset('assets/object3.png', width: 80, height: 80),
                        ),
                      ),
                      Positioned(
                        bottom: 200,
                        child: GestureDetector(
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