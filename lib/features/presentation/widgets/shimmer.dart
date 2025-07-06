  import 'package:flutter/material.dart';

  class Shimmer extends StatefulWidget {
    static _ShimmerState? of(BuildContext context) {
      return context.findAncestorStateOfType<_ShimmerState>();
    }

    const Shimmer({
      super.key,
      required this.linearGradient,
      this.child,
    });

    factory Shimmer.fromColors({
      Key? key,
      required Color baseColor,
      required Color highlightColor,
      double? direction,
      Widget? child,
    }) {
      return Shimmer(
        key: key,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            baseColor,
            highlightColor,
            baseColor,
          ],
          stops: const <double>[
            0.0,
            0.5,
            1.0,
          ],
        ),
        child: child,
      );
    }

    final LinearGradient linearGradient;
    final Widget? child;

    @override
    _ShimmerState createState() => _ShimmerState();
  }

  class _ShimmerState extends State<Shimmer> {
    @override
    Widget build(BuildContext context) {
      return Container();
    }
  }
