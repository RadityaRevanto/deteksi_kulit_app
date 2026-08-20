import 'dart:ui';
import 'package:flutter/material.dart';

class OvalGuidePainter extends CustomPainter {
  final Color strokeColor;

  OvalGuidePainter({
    this.strokeColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radiusX = size.width * 0.38;
    final radiusY = size.height * 0.36;

    final paint = Paint()
      ..color = strokeColor.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final rect = Rect.fromCenter(
      center: center,
      width: radiusX * 2,
      height: radiusY * 2,
    );

    // Draw dashed oval path
    final path = Path()..addOval(rect);
    final dashPath = _buildDashedPath(path, dashWidth: 8, dashSpace: 5);

    canvas.drawPath(dashPath, paint);
  }

  Path _buildDashedPath(Path originalPath, {required double dashWidth, required double dashSpace}) {
    final Path dashedPath = Path();
    for (final PathMetric metric in originalPath.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double len = (distance + dashWidth < metric.length) ? dashWidth : metric.length - distance;
        dashedPath.addPath(
          metric.extractPath(distance, distance + len),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant OvalGuidePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor;
  }
}
