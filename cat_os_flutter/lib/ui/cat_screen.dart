import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../state/cat_controller.dart";
import "widgets/cat_face.dart";
import "widgets/micro_icon_overlay.dart";

class CatScreen extends StatelessWidget {
  const CatScreen({super.key});

  static const Color _pageBackgroundColor = Color(0xFFE5E5E8);
  static const Color _catFillColor = Color(0xFFF7F7F8);
  static const Color _catStrokeColor = Color(0xFF5C5F66);

  @override
  Widget build(BuildContext context) {
    return Consumer<CatController>(
      builder: (BuildContext context, CatController controller, _) {
        return Scaffold(
          backgroundColor: _pageBackgroundColor,
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Size screenSize = constraints.biggest;
              final double faceSize = (screenSize.shortestSide * 0.72).clamp(
                230.0,
                390.0,
              );

              return Listener(
                behavior: HitTestBehavior.opaque,
                onPointerMove: (PointerMoveEvent event) {
                  controller.updateGaze(
                    localPosition: event.localPosition,
                    bounds: screenSize,
                  );
                },
                onPointerDown: (PointerDownEvent event) {
                  controller.updateGaze(
                    localPosition: event.localPosition,
                    bounds: screenSize,
                  );
                },
                onPointerUp: (_) => controller.resetGaze(),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: controller.handleTap,
                  onLongPress: controller.handleLongPress,
                  onHorizontalDragEnd: (DragEndDetails details) {
                    final double velocity = details.primaryVelocity ?? 0;
                    if (velocity.abs() < 180) {
                      return;
                    }
                    controller.handleSwipe(velocity > 0 ? 1 : -1);
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Center(
                        child: CatFace(
                          emotion: controller.emotion,
                          blinkScale: controller.blinkScale,
                          gaze: controller.gaze,
                          size: faceSize,
                          faceColor: _catFillColor,
                          featureColor: _catStrokeColor,
                        ),
                      ),
                      MicroIconOverlay(
                        icon: controller.microIcon,
                        color: _catStrokeColor,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
