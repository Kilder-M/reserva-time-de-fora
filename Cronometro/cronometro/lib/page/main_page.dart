import 'package:cronometro/controller/jogador_controller.dart';
import 'package:cronometro/model/jogador.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'AppWidget.dart';

void main() => runApp(AppWidget());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  AnimationController controller;
  JogadorController jogadorController;
  List<Jogador> lista;
  Jogador j1;
  String nomePassado;

  bool isPlaying = false;
  int tempo;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    jogadorController = JogadorController();
    lista = jogadorController.listar();
    //j1 = Jogador('');
    //lista.add(j1);

    tempo = 10;

    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: tempo),
    );

    // ..addStatusListener((status) {
    //     if (controller.status == AnimationStatus.dismissed) {
    //       setState(() => isPlaying = false);
    //     }

    //     print(status);
    //   })
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Racha duzRobaum - Liceu'),
        ),
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  bottom: 110.0,
                  left: 110.0,
                  right: 110.0,
                  top: 110.0,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, Widget child) {
                      return CustomPaint(
                          painter: TimerPainter(
                        animation: controller,
                        backgroundColor: Colors.white,
                        color: themeData.indicatorColor,
                      ));
                    },
                  ),
                ),
                Align(
                  alignment: FractionalOffset.center,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 140,
                      ),
                      Text(
                        "Tempo",
                        style: themeData.textTheme.subhead,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget child) {
                            return Text(
                              timerString,
                              style: TextStyle(
                                fontSize: 40,
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget child) {
                    return Icon(Icons.update);
                  },
                ),
                onPressed: () {
                  setState(() {
                    controller.reset();
                  });
                },
              ),
              SizedBox(width: 5),
              FloatingActionButton(
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget child) {
                    return Icon(controller.isAnimating
                        ? Icons.pause
                        : Icons.play_arrow);
                  },
                ),
                onPressed: () {
                  setState(() => isPlaying = !isPlaying);

                  if (controller.isAnimating) {
                    controller.stop(canceled: true);
                  } else {
                    controller.reverse(
                        from: controller.value == 0.0 ? 1.0 : controller.value);
                  }
                },
              )
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Times de Fora ',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey[900],
              ),
              width: double.infinity,
              height: 400,
              child: ListView.builder(
                  itemCount: jogadorController.listar().length,
                  itemBuilder: (context, index) {
                    return Card(
                        shadowColor: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                            trailing: IconButton(
                                onPressed: () {

                                  setState((){
                                    jogadorController.remover(lista[index]);
                                  });
                                  
                                }, icon: Icon(Icons.delete)),
                            title: Text(
                                lista[index].getNome(),
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white))));
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (text){
                nomePassado = text;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Nome do cara'),
            ),
          ),
          FloatingActionButton(child: Icon(Icons.add), onPressed: () {
            
              setState((){
                j1 = Jogador(nomePassado);
                jogadorController.salvar(j1);
                lista = jogadorController.listar();
                
              });
              
                
              
              
              
            
          })
        ],
      ),
    ));
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
