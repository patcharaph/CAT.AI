import "dart:math";

import "package:flutter/material.dart";

import "../../models/emotion.dart";

class CatFace extends StatelessWidget {
  const CatFace({
    required this.emotion,
    required this.gaze,
    required this.blinkScale,
    required this.size,
    required this.faceColor,
    required this.featureColor,
    super.key,
  });

  final Emotion emotion;
  final Offset gaze;
  final double blinkScale;
  final double size;
  final Color faceColor;
  final Color featureColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: CustomPaint(
          key: ValueKey<Emotion>(emotion),
          painter: _FacePainter(
            emotion: emotion,
            faceColor: faceColor,
            featureColor: featureColor,
            gaze: gaze,
            blinkScale: blinkScale,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _FacePainter extends CustomPainter {
  const _FacePainter({
    required this.emotion,
    required this.faceColor,
    required this.featureColor,
    required this.gaze,
    required this.blinkScale,
  });

  final Emotion emotion;
  final Color faceColor;
  final Color featureColor;
  final Offset gaze;
  final double blinkScale;

  @override
  void paint(Canvas canvas, Size size) {
    final double s = min(size.width, size.height);
    final double ox = (size.width - s) / 2;
    final double oy = (size.height - s) / 2;

    Offset p(double x, double y) => Offset(ox + (x * s), oy + (y * s));

    final Paint stroke = Paint()
      ..color = featureColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.021 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Paint softOutline = Paint()
      ..color = featureColor.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.030 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.006 * s);

    final Paint headFill = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    final Paint featureFill = Paint()
      ..color = featureColor
      ..style = PaintingStyle.fill;

    final Paint earFill = Paint()
      ..color = featureColor.withValues(alpha: 0.92)
      ..style = PaintingStyle.fill;

    final Paint cyberGlow = Paint()
      ..color = const Color(0xFF8AF6FF).withValues(alpha: 0.55)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.035 * s);

    final Paint cyberStroke = Paint()
      ..color = const Color(0xFF74E9F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.01 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Paint cyberNode = Paint()
      ..color = const Color(0xFF92F6FF)
      ..style = PaintingStyle.fill;

    final Path headPath = Path()
      ..moveTo(p(0.22, 0.80).dx, p(0.22, 0.80).dy)
      ..cubicTo(
        p(0.10, 0.73).dx,
        p(0.10, 0.73).dy,
        p(0.10, 0.57).dx,
        p(0.10, 0.57).dy,
        p(0.13, 0.46).dx,
        p(0.13, 0.46).dy,
      )
      ..cubicTo(
        p(0.14, 0.39).dx,
        p(0.14, 0.39).dy,
        p(0.17, 0.35).dx,
        p(0.17, 0.35).dy,
        p(0.18, 0.33).dx,
        p(0.18, 0.33).dy,
      )
      ..quadraticBezierTo(
        p(0.16, 0.15).dx,
        p(0.16, 0.15).dy,
        p(0.23, 0.11).dx,
        p(0.23, 0.11).dy,
      )
      ..quadraticBezierTo(
        p(0.30, 0.11).dx,
        p(0.30, 0.11).dy,
        p(0.40, 0.24).dx,
        p(0.40, 0.24).dy,
      )
      ..quadraticBezierTo(
        p(0.50, 0.20).dx,
        p(0.50, 0.20).dy,
        p(0.60, 0.24).dx,
        p(0.60, 0.24).dy,
      )
      ..quadraticBezierTo(
        p(0.70, 0.11).dx,
        p(0.70, 0.11).dy,
        p(0.77, 0.11).dx,
        p(0.77, 0.11).dy,
      )
      ..quadraticBezierTo(
        p(0.84, 0.15).dx,
        p(0.84, 0.15).dy,
        p(0.82, 0.33).dx,
        p(0.82, 0.33).dy,
      )
      ..cubicTo(
        p(0.83, 0.35).dx,
        p(0.83, 0.35).dy,
        p(0.86, 0.39).dx,
        p(0.86, 0.39).dy,
        p(0.87, 0.46).dx,
        p(0.87, 0.46).dy,
      )
      ..cubicTo(
        p(0.90, 0.57).dx,
        p(0.90, 0.57).dy,
        p(0.90, 0.73).dx,
        p(0.90, 0.73).dy,
        p(0.78, 0.80).dx,
        p(0.78, 0.80).dy,
      )
      ..quadraticBezierTo(
        p(0.50, 0.99).dx,
        p(0.50, 0.99).dy,
        p(0.22, 0.80).dx,
        p(0.22, 0.80).dy,
      )
      ..close();

    canvas.drawPath(headPath, headFill);
    canvas.drawPath(headPath, softOutline);
    canvas.drawPath(headPath, stroke);

    final Path leftEarInner = Path()
      ..moveTo(p(0.25, 0.21).dx, p(0.25, 0.21).dy)
      ..lineTo(p(0.34, 0.23).dx, p(0.34, 0.23).dy)
      ..lineTo(p(0.24, 0.34).dx, p(0.24, 0.34).dy)
      ..close();
    canvas.drawPath(leftEarInner, earFill);

    final Path rightEarInner = Path()
      ..moveTo(p(0.75, 0.21).dx, p(0.75, 0.21).dy)
      ..lineTo(p(0.66, 0.23).dx, p(0.66, 0.23).dy)
      ..lineTo(p(0.76, 0.34).dx, p(0.76, 0.34).dy)
      ..close();
    canvas.drawPath(rightEarInner, earFill);
    canvas.drawPath(rightEarInner, cyberGlow);

    final Offset earTechCenter = p(0.71, 0.26);
    final Path techPath = Path()
      ..moveTo(earTechCenter.dx - (0.045 * s), earTechCenter.dy - (0.022 * s))
      ..lineTo(earTechCenter.dx - (0.010 * s), earTechCenter.dy + 0.001 * s)
      ..lineTo(earTechCenter.dx - (0.020 * s), earTechCenter.dy + (0.036 * s))
      ..lineTo(earTechCenter.dx + (0.015 * s), earTechCenter.dy + (0.008 * s))
      ..lineTo(earTechCenter.dx + (0.034 * s), earTechCenter.dy + (0.029 * s));
    canvas.drawPath(techPath, cyberStroke);
    canvas.drawCircle(
      Offset(earTechCenter.dx - (0.049 * s), earTechCenter.dy - (0.022 * s)),
      0.007 * s,
      cyberNode,
    );
    canvas.drawCircle(
      Offset(earTechCenter.dx - (0.010 * s), earTechCenter.dy + (0.002 * s)),
      0.007 * s,
      cyberNode,
    );
    canvas.drawCircle(
      Offset(earTechCenter.dx + (0.034 * s), earTechCenter.dy + (0.029 * s)),
      0.007 * s,
      cyberNode,
    );

    final Offset gazeOffset = Offset(gaze.dx * 0.026 * s, gaze.dy * 0.020 * s);

    final Offset leftEye = p(0.36, 0.53) + gazeOffset;
    final Offset rightEye = p(0.64, 0.53) + gazeOffset;
    final Offset mouthCenter = p(0.50, 0.69);
    final double eyeScale = max(0.08, blinkScale);
    final double unit = s / 290;

    switch (emotion) {
      case Emotion.neutral:
        _drawEyeCircle(canvas, featureFill, leftEye, 0.048 * s, eyeScale);
        _drawEyeCircle(canvas, featureFill, rightEye, 0.048 * s, eyeScale);
        _drawClassicMouth(canvas, mouthCenter, stroke, p);
        break;
      case Emotion.happy:
        _drawCaretEye(
          canvas,
          stroke,
          leftEye,
          up: true,
          eyeScale: eyeScale,
          scale: unit * 0.94,
        );
        _drawCaretEye(
          canvas,
          stroke,
          rightEye,
          up: true,
          eyeScale: eyeScale,
          scale: unit * 0.94,
        );
        final Rect smileRect =
            Rect.fromCenter(center: mouthCenter, width: 0.22 * s, height: 0.11 * s);
        canvas.drawArc(smileRect, 0.16 * pi, 0.68 * pi, false, stroke);
        break;
      case Emotion.sad:
        _drawCaretEye(
          canvas,
          stroke,
          leftEye,
          up: false,
          eyeScale: eyeScale,
          scale: unit * 0.86,
        );
        _drawCaretEye(
          canvas,
          stroke,
          rightEye,
          up: false,
          eyeScale: eyeScale,
          scale: unit * 0.86,
        );
        final Rect frownRect = Rect.fromCenter(
          center: mouthCenter + Offset(0, 0.025 * s),
          width: 0.20 * s,
          height: 0.09 * s,
        );
        canvas.drawArc(frownRect, pi + 0.22 * pi, 0.56 * pi, false, stroke);
        break;
      case Emotion.angry:
        _drawSlantedEye(
          canvas,
          stroke,
          leftEye,
          left: true,
          eyeScale: eyeScale,
          scale: unit * 0.80,
        );
        _drawSlantedEye(
          canvas,
          stroke,
          rightEye,
          left: false,
          eyeScale: eyeScale,
          scale: unit * 0.80,
        );
        final Path zigzag = Path()
          ..moveTo(p(0.42, 0.70).dx, p(0.42, 0.70).dy)
          ..lineTo(p(0.46, 0.67).dx, p(0.46, 0.67).dy)
          ..lineTo(p(0.50, 0.71).dx, p(0.50, 0.71).dy)
          ..lineTo(p(0.54, 0.67).dx, p(0.54, 0.67).dy)
          ..lineTo(p(0.58, 0.70).dx, p(0.58, 0.70).dy);
        canvas.drawPath(zigzag, stroke);
        break;
      case Emotion.sleepy:
        _drawSleepyEye(canvas, stroke, leftEye, eyeScale, unit * 0.86);
        _drawSleepyEye(canvas, stroke, rightEye, eyeScale, unit * 0.86);
        canvas.drawLine(
          p(0.44, 0.71),
          p(0.56, 0.71),
          stroke,
        );
        break;
      case Emotion.excited:
        _drawEyeCircle(canvas, featureFill, leftEye, 0.055 * s, eyeScale);
        _drawEyeCircle(canvas, featureFill, rightEye, 0.055 * s, eyeScale);
        canvas.drawCircle(p(0.50, 0.71), 0.030 * s, featureFill);
        break;
    }

    if (emotion != Emotion.angry &&
        emotion != Emotion.sleepy &&
        emotion != Emotion.excited) {
      _drawNose(canvas, featureFill, p, s);
    }
  }

  void _drawNose(
    Canvas canvas,
    Paint fill,
    Offset Function(double x, double y) p,
    double scale,
  ) {
    final Path nose = Path()
      ..moveTo(p(0.50, 0.61).dx, p(0.50, 0.61).dy)
      ..lineTo(p(0.46, 0.58).dx, p(0.46, 0.58).dy)
      ..quadraticBezierTo(
        p(0.50, 0.56).dx,
        p(0.50, 0.56).dy,
        p(0.54, 0.58).dx,
        p(0.54, 0.58).dy,
      )
      ..close();
    canvas.drawPath(nose, fill);

    final Paint bridge = Paint()
      ..color = fill.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.018 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(p(0.50, 0.61), p(0.50, 0.67), bridge);
  }

  void _drawClassicMouth(
    Canvas canvas,
    Offset center,
    Paint stroke,
    Offset Function(double x, double y) p,
  ) {
    final Path left = Path()
      ..moveTo(center.dx, center.dy)
      ..quadraticBezierTo(
        p(0.49, 0.76).dx,
        p(0.49, 0.76).dy,
        p(0.43, 0.73).dx,
        p(0.43, 0.73).dy,
      );
    final Path right = Path()
      ..moveTo(center.dx, center.dy)
      ..quadraticBezierTo(
        p(0.51, 0.76).dx,
        p(0.51, 0.76).dy,
        p(0.57, 0.73).dx,
        p(0.57, 0.73).dy,
      );
    canvas.drawPath(left, stroke);
    canvas.drawPath(right, stroke);
  }

  void _drawEyeCircle(
    Canvas canvas,
    Paint fill,
    Offset center,
    double radius,
    double eyeScale,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(1.0, eyeScale);
    canvas.drawCircle(Offset.zero, radius, fill);
    canvas.restore();
  }

  void _drawCaretEye(
    Canvas canvas,
    Paint stroke,
    Offset center, {
    required bool up,
    required double eyeScale,
    required double scale,
  }) {
    final double peakY = up ? -7 * eyeScale * scale : 7 * eyeScale * scale;
    final double sideY = up ? 7 * eyeScale * scale : -7 * eyeScale * scale;
    final Path eyePath = Path()
      ..moveTo(center.dx - 16 * scale, center.dy + sideY)
      ..lineTo(center.dx, center.dy + peakY)
      ..lineTo(center.dx + 16 * scale, center.dy + sideY);
    canvas.drawPath(eyePath, stroke);
  }

  void _drawSlantedEye(
    Canvas canvas,
    Paint stroke,
    Offset center, {
    required bool left,
    required double eyeScale,
    required double scale,
  }) {
    final double rise = 9 * eyeScale * scale;
    if (left) {
      canvas.drawLine(
        Offset(center.dx - 15 * scale, center.dy + rise),
        Offset(center.dx + 15 * scale, center.dy - rise),
        stroke,
      );
    } else {
      canvas.drawLine(
        Offset(center.dx - 15 * scale, center.dy - rise),
        Offset(center.dx + 15 * scale, center.dy + rise),
        stroke,
      );
    }
  }

  void _drawSleepyEye(
    Canvas canvas,
    Paint stroke,
    Offset center,
    double eyeScale,
    double scale,
  ) {
    final Rect rect = Rect.fromCenter(
      center: center + Offset(0, (1 * (1 - eyeScale)) * scale),
      width: 30 * scale,
      height: (8 + (4 * eyeScale)) * scale,
    );
    canvas.drawArc(rect, pi, pi, false, stroke);
  }

  @override
  bool shouldRepaint(covariant _FacePainter oldDelegate) {
    return oldDelegate.emotion != emotion ||
        oldDelegate.faceColor != faceColor ||
        oldDelegate.featureColor != featureColor ||
        oldDelegate.gaze != gaze ||
        oldDelegate.blinkScale != blinkScale;
  }
}
