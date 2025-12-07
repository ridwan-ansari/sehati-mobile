import 'package:flutter/material.dart';

class AnimatedIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset offset;
  
  const AnimatedIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.offset = const Offset(0, 0.2),
  });

  @override
  State<AnimatedIn> createState() => _AnimatedInState();
}

class _AnimatedInState extends State<AnimatedIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _slide = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
