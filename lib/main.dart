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
      home: FrictionSimulationDemo(),
    );
  }
}

class FrictionSimulationDemo extends StatefulWidget {
  const FrictionSimulationDemo({Key? key}) : super(key: key);

  @override
  State<FrictionSimulationDemo> createState() => _FrictionSimulationDemoState();
}

class _FrictionSimulationDemoState extends State<FrictionSimulationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);
    _animation = _controller.drive(
      AlignmentTween(
        begin: const Alignment(
          -1,
          0,
        ),
        end: const Alignment(
          1,
          0,
        ),
      ),
    );

    _controller.addListener(() {
      if (kDebugMode) {
        print("Controller ${_controller.value}");
        print("Animation ${_animation.value}");
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                        animation: _animation,
                        child: Container(
                          color: Colors.black,
                          height: 10,
                          width: 10,
                        ),
                        builder: (context, child) {
                          return Align(
                            alignment: _animation.value,
                            child: child,
                          );
                        }),
                    Container(
                      width: double.maxFinite,
                      height: 10,
                      color: Colors.green,
                    )
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    _controller.animateWith(BoundedFrictionSimulation(
                      0.4,
                      0,
                      1,
                      -0.1,
                      1
                    ));
                  },
                  child: const Text('Play Friction Simulation')),
              ElevatedButton(
                  onPressed: () {
                    _controller.stop();
                  },
                  child: const Text('Stop Simulation'))
            ],
          ),
        ),
      ),
    );
  }
}
