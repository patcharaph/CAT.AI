import "dart:math";

import "package:flutter/material.dart";

import "../../models/emotion.dart";
import "squircle_surface.dart";

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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: size,
      height: size,
      child: SquircleSurface(
        size: size,
        color: faceColor,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: CustomPaint(
            key: ValueKey<Emotion>(emotion),
            painter: _FacePainter(
              emotion: emotion,
              featureColor: featureColor,
              gaze: gaze,
              blinkScale: blinkScale,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _FacePainter extends CustomPainter {
  const _FacePainter({
    required this.emotion,
    required this.featureColor,
    required this.gaze,
    required this.blinkScale,
  });

  final Emotion emotion;
  final Color featureColor;
  final Offset gaze;
  final double blinkScale;

  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width / 290;
    final Paint stroke = Paint()
      ..color = featureColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Paint fill = Paint()
      ..color = featureColor
      ..style = PaintingStyle.fill;

    final Offset gazeOffset = Offset(gaze.dx * 10 * s, gaze.dy * 8 * s);

    final Offset leftEye =
        Offset(size.width * 0.36, size.height * 0.42) + gazeOffset;
    final Offset rightEye =
        Offset(size.width * 0.64, size.height * 0.42) + gazeOffset;
    final Offset mouthCenter = Offset(size.width * 0.50, size.height * 0.66);
    final double eyeScale = max(0.08, blinkScale);

    switch (emotion) {
      case Emotion.neutral:
        _drawEyeCircle(canvas, fill, leftEye, 10 * s, eyeScale);
        _drawEyeCircle(canvas, fill, rightEye, 10 * s, eyeScale);
        canvas.drawLine(
          Offset(size.width * 0.41, mouthCenter.dy),
          Offset(size.width * 0.59, mouthCenter.dy),
          stroke,
        );
        break;
      case Emotion.happy:
        _drawCaretEye(
          canvas,
          stroke,
          leftEye,
          up: true,
          eyeScale: eyeScale,
          scale: s,
        );
        _drawCaretEye(
          canvas,
          stroke,
          rightEye,
          up: true,
          eyeScale: eyeScale,
          scale: s,
        );
        final Rect smileRect = Rect.fromCenter(
          center: mouthCenter,
          width: 82 * s,
          height: 36 * s,
        );
        canvas.drawArc(smileRect, 0.18 * pi, 0.64 * pi, false, stroke);
        break;
      case Emotion.sad:
        _drawCaretEye(
          canvas,
          stroke,
          leftEye,
          up: false,
          eyeScale: eyeScale,
          scale: s,
        );
        _drawCaretEye(
          canvas,
          stroke,
          rightEye,
          up: false,
          eyeScale: eyeScale,
          scale: s,
        );
        final Rect frownRect = Rect.fromCenter(
          center: mouthCenter + Offset(0, 10 * s),
          width: 74 * s,
          height: 30 * s,
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
          scale: s,
        );
        _drawSlantedEye(
          canvas,
          stroke,
          rightEye,
          left: false,
          eyeScale: eyeScale,
          scale: s,
        );
        final Path zigzag = Path()
          ..moveTo(size.width * 0.42, mouthCenter.dy + (5 * s))
          ..lineTo(size.width * 0.46, mouthCenter.dy - (6 * s))
          ..lineTo(size.width * 0.50, mouthCenter.dy + (6 * s))
          ..lineTo(size.width * 0.54, mouthCenter.dy - (6 * s))
          ..lineTo(size.width * 0.58, mouthCenter.dy + (5 * s));
        canvas.drawPath(zigzag, stroke);
        break;
      case Emotion.sleepy:
        _drawSleepyEye(canvas, stroke, leftEye, eyeScale, s);
        _drawSleepyEye(canvas, stroke, rightEye, eyeScale, s);
        canvas.drawLine(
          Offset(size.width * 0.44, mouthCenter.dy + (4 * s)),
          Offset(size.width * 0.56, mouthCenter.dy + (4 * s)),
          stroke,
        );
        break;
      case Emotion.excited:
        _drawEyeCircle(canvas, fill, leftEye, 12 * s, eyeScale);
        _drawEyeCircle(canvas, fill, rightEye, 12 * s, eyeScale);
        canvas.drawCircle(mouthCenter + Offset(0, 2 * s), 9 * s, fill);
        break;
    }
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
        oldDelegate.featureColor != featureColor ||
        oldDelegate.gaze != gaze ||
        oldDelegate.blinkScale != blinkScale;
  }
}
