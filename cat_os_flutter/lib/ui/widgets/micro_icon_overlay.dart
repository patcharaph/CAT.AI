import "package:flutter/material.dart";

class MicroIconOverlay extends StatelessWidget {
  const MicroIconOverlay({
    required this.icon,
    required this.color,
    super.key,
  });

  final String? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.06),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: icon == null
              ? const SizedBox.shrink(key: ValueKey<String>("empty"))
              : Transform.translate(
                  key: ValueKey<String>(icon!),
                  offset: const Offset(0, -150),
                  child: Text(
                    icon!,
                    style: TextStyle(
                      fontSize: 32,
                      color: color,
                      height: 1.0,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
