import 'package:flutter/material.dart';
import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'dart:math' as math;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Wrapper());
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Body();
  }
}

class Body extends StatefulWidget {
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  math.Random random = new math.Random();
  Soundpool pool = Soundpool(streamType: StreamType.notification);

  int myHp = 10;
  int eneHp = 8;
  String myMsg = "敵が現れた";
  bool isMyTurn = true;
  bool warIsOver = false;
  bool whenWarIsStart = true;

  void myTurn() async {
    int soundId =
        await rootBundle.load("assets/sounds/beep.wav").then((soundData) {
      return pool.load(soundData);
    });
    await pool.play(soundId, rate: 1);
    setState(() {
      eneHp -= 1;
      isMyTurn = false;
      myMsg = "攻撃！";
    });

    if (eneHp < 1) {
      setState(() {
        myMsg = "勝利！";
        warIsOver = true;
      });
    }
  }

  void eneTurn() async {
    int soundId =
        await rootBundle.load("assets/sounds/beep.wav").then((soundData) {
      return pool.load(soundData);
    });
    await pool.play(soundId, rate: 0.25);
    setState(() {
      myHp -= 1;
      myMsg = "被弾！";
      isMyTurn = true;
    });

    print(myHp);

    if (myHp < 1) {
      setState(() {
        myMsg = "敗北…";
        warIsOver = true;
      });
    }
  }

  void turn() {
    if (warIsOver) {
      return;
    }
    if (whenWarIsStart) {
      setState(() {
        whenWarIsStart = false;
        myHp += random.nextInt(5);
        eneHp += random.nextInt(5);
      });
    }

    if (isMyTurn) {
      myTurn();
    } else {
      eneTurn();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Flutter'),
      ),
      body: Center(
        child: Text(myMsg),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_upward),
        onPressed: turn,
      ),
    ));

    throw UnimplementedError();
  }
}
