import 'dart:async';

import 'package:flutter/material.dart';

class Animator extends StatefulWidget {
  final Widget child;
  final Duration time;
  Animator(this.child, this.time);
  @override
  _AnimatorState createState() => _AnimatorState();
}

class _AnimatorState extends State<Animator>
    with SingleTickerProviderStateMixin {
  Timer timer;
  AnimationController animationController;
  Animation animation;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    timer = Timer(widget.time, animationController.forward);
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0.0, (1 - animation.value) * 20),
            child: child,
          ),
        );
      },
    );
  }
}

Timer timer;
Duration duration = Duration();
wait() {
  if (timer == null || !timer.isActive) {
    timer = Timer(Duration(microseconds: 5), () {
      duration = Duration();
    });
  }
  duration += Duration(milliseconds: 5);
  return duration;
}

class WidgetANimator extends StatelessWidget {
  final Widget child;
  WidgetANimator(this.child);
  @override
  Widget build(BuildContext context) {
    return Animator(child, wait());
  }
}