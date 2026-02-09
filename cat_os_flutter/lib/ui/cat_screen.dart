import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../state/cat_controller.dart";
import "widgets/cat_face.dart";
import "widgets/micro_icon_overlay.dart";

class CatScreen extends StatelessWidget {
  const CatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CatController>(
      builder: (BuildContext context, CatController controller, _) {
        return Scaffold(
          backgroundColor: controller.moodPreset.backgroundColor,
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Size screenSize = constraints.biggest;
              final double faceSize = (screenSize.shortestSide * 0.74).clamp(
                220.0,
                320.0,
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
                          faceColor: controller.moodPreset.faceColor,
                          featureColor: controller.moodPreset.featureColor,
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 20,
                        child: Icon(
                          Icons.tune_rounded,
                          color: controller.moodPreset.featureColor
                              .withValues(alpha: 0.22),
                          size: 22,
                        ),
                      ),
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: Icon(
                          Icons.settings_suggest_rounded,
                          color: controller.moodPreset.featureColor
                              .withValues(alpha: 0.22),
                          size: 22,
                        ),
                      ),
                      MicroIconOverlay(
                        icon: controller.microIcon,
                        color: controller.moodPreset.featureColor,
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
