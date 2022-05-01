import 'dart:convert';
import 'dart:math';
import 'find_solutions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:collection/collection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flip Five',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flip Five'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<List<bool>> board = [], startBoard = [];
  int moves = 0;
  int optimalSolution = 0;
  dynamic solutions;
  _MyHomePageState() {
    startBoard.addAll([
      [false, false, false],
      [false, false, false],
      [false, false, false]
    ]);
    _initBoard();
  }

  Future<void> loadSolutions() async {
    await rootBundle.loadString('assets/solutions.json');
    solutions =
        jsonDecode(await rootBundle.loadString('assets/solutions.json'));
  }

  void _initBoard() async {
    var r = Random();
    board.clear();
    moves = 0;
    board.addAll([
      [false, false, false],
      [false, false, false],
      [false, false, false]
    ]);
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        board[i][j] = r.nextBool();
      }
    }
    if (solutions == null) {
      await loadSolutions();
    }
    optimalSolution = solutions![board.toString()]!;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    Function eq = const DeepCollectionEquality().equals;
    if (eq(board, startBoard)) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
            child: Column(
          children: [
            Text("You won! Took ya ${moves} moves. Best is ${optimalSolution}"),
            ElevatedButton(
                onPressed: () => setState(() {
                      _initBoard();
                    }),
                child: Text("Play again"))
          ],
          mainAxisSize: MainAxisSize.min,
        )),
      );
    }

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: 9,
                  itemBuilder: (BuildContext context, int index) =>
                      ElevatedButton(
                        onPressed: () => setState(() {
                          flip(board, index ~/ 3, index % 3);
                          moves++;
                        }),
                        child: null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              board[index ~/ 3][index % 3]
                                  ? Colors.black
                                  : Colors.white),
                        ),
                      ))),
        ));
  }
}
