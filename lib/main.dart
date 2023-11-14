import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GravitySimulationDemo(),
    );
  }
}

class GravitySimulationDemo extends StatefulWidget {
  const GravitySimulationDemo({Key? key}) : super(key: key);

  @override
  State<GravitySimulationDemo> createState() => _GravitySimulationDemoState();
}

class _GravitySimulationDemoState extends State<GravitySimulationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(
      vsync: this,
    );
    _controller.addListener(() {
      if (kDebugMode) {
        print(_controller.value);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    height = (MediaQuery.of(context).size.height -
        (MediaQuery.maybeViewPaddingOf(context)?.vertical ?? 0));
    width = MediaQuery.sizeOf(context).width;
    if (kDebugMode) {
      print(MediaQuery.of(context).size);
      print(MediaQuery.maybeViewPaddingOf(context)?.vertical);
      print(MediaQuery.of(context).devicePixelRatio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: CustomPaint(
            painter: BoxPainter(animation: _controller),
            size: Size(width, height),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          // Magnitude of start velocity must be greater than end velocity.
          // Else Internally dragCoefficient value will be calculated as 1.
          // If the start and ending positions are same then, drgCoefficient will become infinity.
          // Sign of the start and end velocities must be same.
          _controller.animateWith(FrictionSimulation.through(
            0,
            width-20,
            100,
            55
          ));
        },
        label: const Text('Play Simulation'),
      ),
    );
  }
}

class BoxPainter extends CustomPainter {
  final Animation animation;
  BoxPainter({required this.animation}) : super(repaint: animation);
  @override
  void paint(Canvas canvas, Size size) {
    double halfHeight = size.height / 2;
    canvas.save();
    canvas.translate(10, 0);
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(animation.value, halfHeight), width: 20, height: 20),
        Paint()..color = Colors.green);
    canvas.restore();
    canvas.drawRect(
        Rect.fromPoints(
            Offset(0, halfHeight + 10), Offset(size.width, halfHeight + 20)),
        Paint());
  }

  @override
  bool shouldRepaint(BoxPainter oldDelegate) {
    return true;
  }
}
