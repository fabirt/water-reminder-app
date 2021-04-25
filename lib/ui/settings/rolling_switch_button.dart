import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class RollingSwitchButton extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChange;
  final String textOff;
  final String textOn;
  final Color colorOn;
  final Color colorOff;
  final double textSize;
  final Duration animationDuration;
  final IconData iconOn;
  final IconData iconOff;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onSwipe;

  RollingSwitchButton({
    this.value = false,
    this.textOff = "OFF",
    this.textOn = "ON",
    this.textSize = 14.0,
    this.colorOn = Colors.green,
    this.colorOff = Colors.red,
    this.iconOff = Icons.alarm_off_rounded,
    this.iconOn = Icons.alarm_on_rounded,
    this.animationDuration = const Duration(milliseconds: 450),
    this.onTap,
    this.onDoubleTap,
    this.onSwipe,
    required this.onChange,
  });

  @override
  _RollingSwitchState createState() => _RollingSwitchState();
}

class _RollingSwitchState extends State<RollingSwitchButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late bool _isOn;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isOn = widget.value;

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: widget.value ? 1.0 : 0.0,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(RollingSwitchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isOn = widget.value;
    if (_isOn) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final transitionColor = Color.lerp(
      widget.colorOff,
      widget.colorOn,
      _animation.value,
    );

    return GestureDetector(
      onDoubleTap: () {
        _change();
        widget.onDoubleTap?.call();
      },
      onTap: () {
        _change();
        widget.onTap?.call();
      },
      onPanEnd: (details) {
        _change();
        widget.onSwipe?.call();
      },
      child: Container(
        padding: EdgeInsets.all(5),
        width: 130,
        decoration: BoxDecoration(
          color: transitionColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Stack(
          children: <Widget>[
            Transform.translate(
              offset: Offset(10 * _animation.value, 0),
              child: Opacity(
                opacity: (1 - _animation.value).clamp(0.0, 1.0),
                child: Container(
                  padding: EdgeInsets.only(right: 10),
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: Text(
                    widget.textOff,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.textSize,
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(10 * (1 - _animation.value), 0),
              child: Opacity(
                opacity: _animation.value.clamp(0.0, 1.0),
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  alignment: Alignment.centerLeft,
                  height: 40,
                  child: Text(
                    widget.textOn,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.textSize,
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(80 * _animation.value, 0),
              child: Transform.rotate(
                angle: lerpDouble(0, 2 * pi, _animation.value)!,
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Opacity(
                          opacity: (1 - _animation.value).clamp(0.0, 1.0),
                          child: Icon(
                            widget.iconOff,
                            size: 25,
                            color: transitionColor,
                          ),
                        ),
                      ),
                      Center(
                        child: Opacity(
                          opacity: _animation.value.clamp(0.0, 1.0),
                          child: Icon(
                            widget.iconOn,
                            size: 21,
                            color: transitionColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _change() {
    widget.onChange(!_isOn);
  }
}
