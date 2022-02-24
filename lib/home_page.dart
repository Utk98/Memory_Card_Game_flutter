import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

int level = 8;

class Home extends StatefulWidget {
  final int size;

  const Home({Key? key, this.size = 8}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  List<bool> cardFlips = [];
  List<String> data = [];
  int previousIndex = -1;
  bool flip = false;

  int time = 0;
  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i = 0; i < widget.size; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
      cardFlips.add(true);
    }

    // for(var i =0;i<widget.size;i++){
    //   cardStateKeys.add(GlobalKey<FlipCardState>());
    //   cardFlips.add(true);
    // }
    for (var i = 0; i < widget.size ~/ 2; i++) {
      // cardStateKeys.add(GlobalKey<FlipCardState>());
      // cardFlips.add(true);
      data.add(i.toString());
      // cardFlips.add(true);
    }
    for (var i = 0; i < widget.size ~/ 2; i++) {
      // cardStateKeys.add(GlobalKey<FlipCardState>());
      // cardFlips.add(true);
      data.add(i.toString());
      // cardFlips.add(true);
    }
    startTimer();
    data.shuffle();
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        time = time + 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade600,
        title: Text("MEMORY CARD GAME!!"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "$time",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Theme(
                data: ThemeData.dark(),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) => FlipCard(
                      key: cardStateKeys[index],
                      onFlip: () {
                        if (!flip) {
                          flip = true;
                          previousIndex = index;
                        } else {
                          flip = false;
                          if (previousIndex != index) {
                            if (data[previousIndex] != data[index]) {
                              cardStateKeys[previousIndex]
                                  .currentState!
                                  .toggleCard();
                              previousIndex = index;
                            } else {
                              cardFlips[previousIndex] = false;
                              cardFlips[index] = false;
                              print(cardFlips);
                              if (cardFlips.every((t) => t == false)) {
                                print("Won");
                                showResult();
                              }
                              // print("matched");
                            }
                          }
                        }
                      },
                      direction: FlipDirection.HORIZONTAL,
                      flipOnTouch: cardFlips[index],
                      front: Container(
                        margin: EdgeInsets.all(4.0),
                        color: Colors.deepOrange.withOpacity(0.3),
                      ),
                      back: Container(
                          margin: EdgeInsets.all(4.0),
                          color: Colors.deepOrange,
                          child: Center(
                            child: Text(
                              "${data[index]}",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          )),
                    ),
                    itemCount: data.length,
                    // 2;06
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(DiagnosticsProperty<Timer>('timer', timer));
  // }

  showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Won!!!"),
        content: Text(
          " Time $time",
          style: Theme.of(context).textTheme.headline3,
        ),
        actions: [
          // FlatButton(onPressed: onPressed, child: child)
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Home(
                    size: level,
                  ),
                ),
              );
              level *= 2;
            },
              child: Text("Next",
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                )),
            ),

        ],
      ),
    );
  }
}
