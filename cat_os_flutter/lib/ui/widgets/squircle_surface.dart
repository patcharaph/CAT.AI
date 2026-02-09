import "dart:math";

import "package:flutter/material.dart";

class SquircleSurface extends StatelessWidget {
  const SquircleSurface({
    required this.size,
    required this.color,
    required this.child,
    super.key,
  });

  final double size;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SquirclePainter(color: color),
        child: ClipPath(
          clipper: const _SuperellipseClipper(),
          child: child,
        ),
      ),
    );
  }
}

class _SquirclePainter extends CustomPainter {
  const _SquirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = _superellipsePath(size, 4.4);

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawPath(path.shift(const Offset(0, 10)), shadowPaint);

    final Paint fillPaint = Paint()..color = color;
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _SquirclePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _SuperellipseClipper extends CustomClipper<Path> {
  const _SuperellipseClipper();

  @override
  Path getClip(Size size) {
    return _superellipsePath(size, 4.4);
  }

  @override
  bool shouldReclip(covariant _SuperellipseClipper oldClipper) {
    return false;
  }
}

Path _superellipsePath(Size size, double n) {
  final double a = size.width / 2;
  final double b = size.height / 2;
  const double step = 0.04;

  final Path path = Path();
  bool hasPoint = false;

  for (double t = 0; t <= (2 * pi) + step; t += step) {
    final double cosT = cos(t);
    final double sinT = sin(t);

    final double x = a * _signedPow(cosT.abs(), 2 / n) * _sign(cosT) + a;
    final double y = b * _signedPow(sinT.abs(), 2 / n) * _sign(sinT) + b;

    if (!hasPoint) {
      path.moveTo(x, y);
      hasPoint = true;
    } else {
      path.lineTo(x, y);
    }
  }

  path.close();
  return path;
}

double _signedPow(double value, double exponent) {
  return pow(value, exponent).toDouble();
}

double _sign(double value) {
  if (value < 0) {
    return -1;
  }
  return 1;
}
