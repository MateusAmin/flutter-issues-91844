import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class TrapezoidBorder extends OutlinedBorder {
  final double ratio;

  /// The [side] argument must not be null.
  const TrapezoidBorder(
      {BorderSide side = BorderSide.none,
      double incoming = 3,
      double outgoing = 1})
      : ratio = incoming / outgoing,
        super(side: side);

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(side.width);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // var path = getOuterPath(rect);

    // var matrix = Matrix4.identity();
    // matrix[0] = 1 - (side.width / rect.width);
    // matrix[5] = 1 - (side.width / rect.height);

    // return path.transform(matrix.storage);

    // c^2 = a^2 + b^2
    // a=b
    // c^2 = side.width
    // side.width = a^2 + a^2
    // side.width/2 = a^2
    // a = delte x & y magnitude
    var borderDelta = sqrt(side.width / 2);

    double topDelta = getTopDelta(rect);
    double bottomDelta = getBottomDelta(rect);

    return Path()
      ..addPolygon(
        [
          Offset(
            0 + borderDelta + topDelta,
            0 + borderDelta,
          ),
          Offset(
            rect.width - borderDelta - topDelta,
            0 + borderDelta,
          ),
          Offset(
            rect.width - borderDelta - bottomDelta,
            rect.height - borderDelta,
          ),
          Offset(
            0 + borderDelta + bottomDelta,
            rect.height - borderDelta,
          ),
        ],
        true,
      );
  }

  double getTopDelta(Rect rect) {
    return max(0, (rect.width - rect.width * ratio) / 2);
  }

  double getBottomDelta(Rect rect) {
    return max(0, (rect.width - rect.width / ratio) / 2);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double topDelta = getTopDelta(rect);
    double bottomDelta = getBottomDelta(rect);

    return Path()
      ..addPolygon(
        [
          Offset(
            0 + topDelta,
            0,
          ),
          Offset(
            rect.width - topDelta,
            0,
          ),
          Offset(
            rect.width - bottomDelta,
            rect.height,
          ),
          Offset(
            0 + bottomDelta,
            rect.height,
          ),
        ],
        true,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        canvas.drawPath(
          getInnerPath(rect),
          side.toPaint(),
        );

        break;
    }
  }

  @override
  ShapeBorder scale(double t) {
    return TrapezoidBorder(side: side.scale(t));
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return TrapezoidBorder(side: side ?? this.side);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            ElevatedButton(
              child: null,
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.padded,
                fixedSize: const Size(100, 100),
                primary: Colors.grey,
                shape: const TrapezoidBorder(
                  incoming: 4,
                  outgoing: 1,
                  side: BorderSide(
                    color: Colors.black,
                    width: 0,
                  ),
                ),
              ),
            ),
            const Spacer(),
            FloatingActionButton.large(
              onPressed: () {},
              backgroundColor: Colors.grey,
              shape: const TrapezoidBorder(
                incoming: 4,
                outgoing: 1,
                side: BorderSide(
                  color: Colors.black,
                  width: 0,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
