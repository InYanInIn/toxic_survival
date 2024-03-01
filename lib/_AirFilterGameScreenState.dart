import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui';

class Particle {
  Offset position;
  bool isClean;
  Offset targetPosition;

  Particle({
    required this.position,
    this.isClean = false,
    required this.targetPosition,
  });
}


class AirFilterGameScreen extends StatefulWidget {
  final int initialRedCount;
  final int initialGreenCount;
  final int gameTimeSeconds;
  final Function(bool) onGameEnd;

  AirFilterGameScreen({
    Key? key,
    required this.initialRedCount,
    required this.initialGreenCount,
    required this.gameTimeSeconds,
    required this.onGameEnd,
  }) : super(key: key);

  @override
  _AirFilterGameScreenState createState() => _AirFilterGameScreenState();
}



class _AirFilterGameScreenState extends State<AirFilterGameScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  String? _gameMessage;
  bool _showMessage = false;
  List<Particle> particles = [];
  bool isGameActive = true;
  int redCount = 0;
  int gameTime = 10; // Продолжительность игры в секундах
  bool isGameInitialized = false; // Добавим флаг для избежания повторной инициализации


  void _moveParticles() {
    if (!isGameActive) return;

    final containerWidth = MediaQuery.of(context).size.width * 0.8 - 20; // Учитываем размер частицы
    final containerHeight = MediaQuery.of(context).size.height * 0.8 - 20; // То же для высоты
    final speed = 5.0; // Задаем скорость движения частиц

    setState(() {
      particles.forEach((particle) {
        // Вычисляем вектор направления и обновляем позицию
        Offset direction = particle.targetPosition - particle.position;
        direction = direction / direction.distance * speed;
        particle.position += direction;

        // Переназначение targetPosition, если частица достигла её или если частица достигла границы
        if ((particle.targetPosition - particle.position).distance < speed) {
          final rand = Random();
          particle.targetPosition = Offset(
            rand.nextDouble() * (containerWidth - 20) + 10, // Оставляем поля по 10 пикселей с каждой стороны
            rand.nextDouble() * (containerHeight - 20) + 10,
          );
        }


        // Добавление "упругости" при столкновении с границами
        if (particle.position.dx <= 0 || particle.position.dx >= containerWidth) {
          particle.targetPosition = Offset(-particle.targetPosition.dx * 0.8, particle.targetPosition.dy);
        }
        if (particle.position.dy <= 0 || particle.position.dy >= containerHeight) {
          particle.targetPosition = Offset(particle.targetPosition.dx, -particle.targetPosition.dy * 0.8);
        }

        // Корректировка текущей позиции, чтобы оставаться внутри контейнера
        particle.position = Offset(
          particle.position.dx.clamp(0.0, containerWidth),
          particle.position.dy.clamp(0.0, containerHeight),
        );
      });
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  void _endGame({bool won = false}) {
    isGameActive = false;
    _controller.stop(); // Останавливаем анимацию

    // Теперь устанавливаем сообщение и отображаем его без задержки
    _gameMessage = won ? "Победа" : "Вы проиграли";
    _showMessage = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showMessage = false; // Скрываем сообщение
        });
        Navigator.of(context).pop(); // Закрываем виджет игры
      }
    });
    widget.onGameEnd(won);
  }


  void _initParticles() {
    final rand = Random();
    final screenWidth = MediaQuery.of(context).size.width * 0.9;
    final screenHeight = MediaQuery.of(context).size.height * 0.9;


    particles = [];
    // Создаем красные частицы
    for (int i = 0; i < widget.initialRedCount; i++) {
      particles.add(Particle(
        position: Offset(rand.nextDouble() * screenWidth, rand.nextDouble() * screenHeight),
        isClean: false,
        targetPosition: Offset(rand.nextDouble() * screenWidth, rand.nextDouble() * screenHeight),
      ));
    }
    // Создаем зеленые частицы
    for (int i = 0; i < widget.initialGreenCount; i++) {
      particles.add(Particle(
        position: Offset(rand.nextDouble() * screenWidth, rand.nextDouble() * screenHeight),
        isClean: true,
        targetPosition: Offset(rand.nextDouble() * screenWidth, rand.nextDouble() * screenHeight),
      ));
    }
  }


  void _startTimer() {
    gameTime = widget.gameTimeSeconds; // Устанавливаем время игры

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (gameTime > 0) {
        setState(() {
          gameTime--;
        });
      } else {
        timer.cancel();
        if (isGameActive) {
          _endGame(won: redCount == 0); // Проверяем, все ли красные частицы были "очищены"
        }
      }
    });
  }



  @override
  void initState() {
    super.initState();
    gameTime = widget.gameTimeSeconds;
    redCount = widget.initialRedCount;
    _startTimer();
    _controller = AnimationController(
      duration: const Duration(seconds: 150), // Продолжительный период для циклической анимации
      vsync: this,
    )..repeat(); // Запускаем анимацию на повторение

    _controller.addListener(() {
      _moveParticles(); // Вызываем этот метод на каждый кадр анимации
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initParticles();
  }

  void _cleanParticle(int index) {
    if (!isGameActive || particles[index].isClean) return;

    setState(() {
      particles[index].isClean = true;
      redCount--; // Уменьшаем количество красных частиц
    });

    if (redCount == 0) {
      _endGame(won: true); // Вызываем _endGame с указанием победы
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ...particles.asMap().entries.map((entry) {
            int index = entry.key;
            Particle particle = entry.value;
            return Positioned(
              left: particle.position.dx,
              top: particle.position.dy,
              child: GestureDetector(
                onTap: () => _cleanParticle(index),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: particle.isClean ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }).toList(),
          // Отображение таймера
          if (isGameActive) // Только если игра активна, показываем таймер
            Positioned(
              top: MediaQuery.of(context).padding.top, // Учитывает статус бар
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Время: $gameTime",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          // Отображение сообщения о победе/поражении
          if (_showMessage)
            Center(
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.black.withOpacity(0.5),
                child: Text(
                  _gameMessage ?? "",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}