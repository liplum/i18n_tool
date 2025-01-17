import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class OnLoading extends StatelessWidget {
  final bool blockTap;
  final bool loading;
  final Widget? child;
  final double loadingOpacity;

  const OnLoading({
    super.key,
    this.child,
    this.loading = false,
    this.blockTap = false,
    this.loadingOpacity = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    return [
      AnimatedOpacity(
        opacity: loading ? loadingOpacity : 1,
        duration: Durations.short4,
        child: AbsorbPointer(
          absorbing: blockTap && loading,
          child: child,
        ),
      ),
      if (loading)
        Positioned.fill(
          child: const ProgressRing().center(),
        ),
    ].stack();
  }
}
