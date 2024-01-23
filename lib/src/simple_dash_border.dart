import 'package:flutter/material.dart';

///
class SimpleDashBorder extends Border {
  ///
  const SimpleDashBorder({
    this.width = 14.0,
    this.space = 4,
    this.strokeCap,
    BorderSide side = const BorderSide(),
    this.clipInside = true,
  }) : super(left: side, top: side, right: side, bottom: side);

  /// Dash width
  final double width;

  /// Space after dash
  final double space;

  /// Stroke cap for the dash
  final StrokeCap? strokeCap;

  ///
  final bool clipInside;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    if (top == BorderSide.none) return;

    final paint = top.toPaint()..strokeCap = strokeCap ?? StrokeCap.butt;
    final path = Path();

    if (shape == BoxShape.circle) {
      path.addOval(
        Rect.fromCenter(
          center: rect.center,
          width: rect.shortestSide,
          height: rect.shortestSide,
        ),
      );
    } else if (borderRadius != null) {
      path.addRRect(borderRadius.toRRect(rect));
    } else {
      path.addRect(rect);
    }

    for (final pathMetric in path.computeMetrics()) {
      var distance = 0.0;
      var draw = true;

      while (distance < pathMetric.length) {
        var length = draw ? width : space;
        if (draw) {
          final spaceAfter = pathMetric.length - distance - width;
          if (spaceAfter < space) {
            length -= space - spaceAfter;
          }
          final extractPath = pathMetric.extractPath(
            distance,
            distance + length,
          );
          canvas.drawPath(extractPath, paint);
        }

        distance += length;
        draw = !draw;
      }
    }

    canvas.save();
    if (clipInside) {
      final deflate = top.width / 2;

      if (deflate <= 0) return;

      final clipRect = path.getBounds().deflate(deflate);

      if (shape == BoxShape.circle) {
        canvas.clipPath(Path()..addOval(clipRect));
      } else if (borderRadius != null && borderRadius != BorderRadius.zero) {
        final radius = borderRadius - BorderRadius.circular(deflate);
        canvas.clipRRect(radius.toRRect(clipRect));
      } else {
        canvas.clipRect(clipRect);
      }
    } else {
      canvas.clipPath(path);
    }

    canvas.restore();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SimpleDashBorder &&
        other.top == top &&
        other.width == width &&
        other.space == space &&
        other.strokeCap == strokeCap &&
        other.clipInside == clipInside;
  }

  @override
  int get hashCode => Object.hash(top, width, space, strokeCap, clipInside);
}
