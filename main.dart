import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Handwriting App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HandwritingCanvas(),
    );
  }
}

class HandwritingCanvas extends StatefulWidget {
  const HandwritingCanvas({super.key});

  @override
  State<HandwritingCanvas> createState() => _HandwritingCanvasState();
}

class _HandwritingCanvasState extends State<HandwritingCanvas> {
  List<Offset> points = [];
  List<TouchData> touchData = [];
  TouchData? currentStylusTouch;

  void _handleTouch(PointerEvent event) {
    setState(() {
      TouchData newTouch = TouchData(
        x: event.position.dx,
        y: event.position.dy,
        area: event.size,
      );

      touchData.add(newTouch);

      if (currentStylusTouch == null || newTouch.area < currentStylusTouch!.area) {
        currentStylusTouch = newTouch;
      }

      if (currentStylusTouch != null) {
        points.add(Offset(currentStylusTouch!.x, currentStylusTouch!.y));
      }

      print("Points: $points"); // Added print for debugging
      print("currentStylusTouch: $currentStylusTouch"); //added print for debugging

    });
  }

  void _handleTouchEnd(PointerEvent event) {
    setState(() {
      currentStylusTouch = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        print("Pointer Down");
        _handleTouch(event);
      },
      onPointerMove: (event) {
        print("Pointer Move");
        _handleTouch(event);
      },
      onPointerUp: (event) {
        print("Pointer Up");
        _handleTouchEnd(event);
      },
      onPointerCancel: (event) {
        print("Pointer Cancel");
        _handleTouchEnd(event);
      },
      child: CustomPaint(
        painter: HandwritingPainter(points),
        size: Size.infinite,
      ),
    );
  }
}

class HandwritingPainter extends CustomPainter {
  final List<Offset> points;

  HandwritingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    print("Repainting"); // Added print for debugging
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(HandwritingPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class TouchData {
  final double x;
  final double y;
  final double area;

  TouchData({required this.x, required this.y, required this.area});
}