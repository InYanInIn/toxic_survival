import 'package:flutter/material.dart';
import 'dart:math';

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

class FilterPart {
  final String imageAsset;
  final int correctPosition;
  int currentPosition;
  bool isSelected;

  FilterPart({
    required this.imageAsset,
    required this.correctPosition,
    required this.currentPosition,
    this.isSelected = false,
  });
}

class FilterGameLogic {
  final List<FilterPart> parts;

  FilterGameLogic(this.parts);

  void selectPart(int index) {
    // Если какая-то часть уже выбрана, то меняем их местами
    final selectedIndex = parts.indexWhere((part) => part.isSelected);
    if (selectedIndex != -1 && selectedIndex != index) {
      // Обмен местами текущей и выбранной частей
      final temp = parts[index].currentPosition;
      parts[index].currentPosition = parts[selectedIndex].currentPosition;
      parts[selectedIndex].currentPosition = temp;

      // Сброс выбора для обеих частей
      parts[selectedIndex].isSelected = false;
      parts[index].isSelected = false;
    } else {
      // Выбор или снятие выбора с текущей части
      parts[index].isSelected = !parts[index].isSelected;
    }
  }

  bool isCompleted() {
    // Проверка, находится ли каждая часть на своем месте
    return parts.every((part) => part.currentPosition == part.correctPosition);
  }
}


class FilterGameWidget extends StatefulWidget {
  final Function(bool) onGameEnd;

  FilterGameWidget({required this.onGameEnd});

  @override
  _FilterGameWidgetState createState() => _FilterGameWidgetState();
}

class _FilterGameWidgetState extends State<FilterGameWidget> {
  late List<FilterPart> parts;
  late FilterGameLogic logic;

  @override
  void initState() {
    super.initState();
    logic = FilterGameLogic(parts);
    parts = List.generate(8, (index) {
      return FilterPart(
        imageAsset: 'assets/images/part_${index + 1}.png', // Измените здесь на правильные имена файлов
        correctPosition: index,
        currentPosition: index,
      );
    });

    parts.shuffle(); // Перемешиваем части для начала игры
  }

  List<FilterPart> generateAndShuffleParts() {
    List<FilterPart> parts = List.generate(5, (index) {
      return FilterPart(
        imageAsset: 'assets/part_$index.png',
        correctPosition: index,
        currentPosition: index,
      );
    });

    parts.shuffle();
    return parts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Соберите фильтр'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: parts.length,
        itemBuilder: (context, index) {
          final part = parts[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                  logic.selectPart(index);
              });

              if (logic.isCompleted()) {
                widget.onGameEnd(true);
                Navigator.of(context).pop();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: part.isSelected ? Colors.green : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Image.asset(part.imageAsset),
            ),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void openFilterGame() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FilterGameWidget(
          onGameEnd: (won) {
            if (won) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Поздравляем!'),
                  content: Text('Вы успешно собрали фильтр.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            } else {
              // Обработка проигрыша, если потребуется
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главный экран игры'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: openFilterGame,
          child: Text('Начать мини-игру с фильтром'),
        ),
      ),
    );
  }
}