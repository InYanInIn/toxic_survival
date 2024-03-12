import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class GameWidget extends StatefulWidget {
  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  List<String> parts = []; // Список для хранения частей фильтра
  List<String> correctOrder = []; // Правильный порядок частей
  String selectedPart = ''; // Выбранная часть
  int totalParts = 8; // Включая неактивные фильтры
  int activeParts = 5; // Фактическое количество активных фильтров
  int timerSeconds = 3; // Время таймера в секундах
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() async {
    // Генерация правильного порядка всех активных фильтров
    List<String> allFilters = List.generate(8, (index) => 'pubp${index + 1}.png');
    allFilters.shuffle(Random());

    // Сохранение правильного порядка для отображения в правилах
    correctOrder = List.from(allFilters);

    // Инициализация игры с рандомным набором активных фильтров
    int numberOfActiveFilters = Random().nextInt(5) + 3; // От 3 до 7 активных фильтров
    List<String> gameFilters = allFilters.take(numberOfActiveFilters).toList();

    // Добавляем неактивные фильтры в начало и конец
    parts = ['inactive.png'] + gameFilters + ['inactive.png'];

    // Показываем правильный порядок перед началом игры
    await Future.delayed(Duration.zero, () {
      showCorrectOrder();
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (timerSeconds > 0) {
        setState(() {
          timerSeconds--;
        });
      } else {
        t.cancel();
        Navigator.of(context).pop(); // Закрываем диалог, когда таймер достигает нуля
      }
    });
  }

  Future<void> showCorrectOrder() async {
    int timerSeconds = 3; // Установим начальное значение таймера
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Используем Stream.periodic для создания потока, который выпускает значения каждую секунду
        return AlertDialog(
          title: Text('Запомните правильный порядок!'),
          content: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50), // Задайте нужное значение отступа
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.builder(
                    itemCount: correctOrder.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 50,
                        child: Image.asset('assets/${correctOrder[index]}', fit: BoxFit.contain),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 16, // Размещаем текст таймера вверху диалогового окна
                child: StreamBuilder<int>(
                  stream: Stream.periodic(Duration(seconds: 1), (i) => i)
                      .take(timerSeconds + 1) // Берем значения от 0 до timerSeconds включительно
                      .map((i) => timerSeconds - i), // Переворачиваем порядок для обратного отсчета
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Navigator.of(context).pop(); // Закрываем диалог, когда таймер достигает нуля
                      return SizedBox.shrink(); // Возвращаем пустой виджет, когда таймер достигает нуля
                    }
                    return Text(
                      'Таймер: ${snapshot.data ?? timerSeconds}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  void selectPart(String part) {
    if (part == 'pubp8.png') return; // Игнорирование нажатий на неактивные фильтры

    setState(() {
      if (selectedPart.isEmpty) {
        selectedPart = part;
      } else {
        int index1 = parts.indexOf(selectedPart);
        int index2 = parts.indexOf(part);
        // Обмен фильтрами местами, если они соседние
        if ((index1 - index2).abs() == 1) {
          parts[index1] = part;
          parts[index2] = selectedPart;
        }
        selectedPart = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ваш код для отображения виджета игры, включая ListView.builder
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: ListView.builder(
        itemCount: parts.length,
        itemBuilder: (context, index) {
          bool isStatic = index == 0 || index == parts.length - 1;
          return GestureDetector(
            onTap: isStatic ? null : () => selectPart(parts[index]),
            child: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: selectedPart == parts[index] ? Border.all(color: Colors.green, width: 2.0) : null,
              ),
              child: Image.asset(
                'assets/${parts[index]}',
                fit: BoxFit.contain,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Отмена таймера при удалении виджета
    super.dispose();
  }
}
