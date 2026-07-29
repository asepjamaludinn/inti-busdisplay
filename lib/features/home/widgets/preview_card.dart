import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_provider.dart';
import '../../../core/theme/app_colors.dart';

const double kP5PanelAspectRatio = 3.6;

double _lerp(double a, double b, double t) => a + (b - a) * t;

class PreviewCard extends StatefulWidget {
  const PreviewCard({super.key});

  @override
  State<PreviewCard> createState() => _PreviewCardState();
}

class _PreviewCardState extends State<PreviewCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  String? _lastMode;
  double? _lastSpeed;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Duration _periodFor(String mode, double speed) {
    final t = speed.clamp(0, 100) / 100;
    if (mode == 'Blink') {
      return Duration(milliseconds: _lerp(1600, 260, t).round());
    }
    return Duration(milliseconds: _lerp(7000, 900, t).round());
  }

  void _syncAnimation(String mode, double speed) {
    if (mode == _lastMode && speed == _lastSpeed) return;
    _lastMode = mode;
    _lastSpeed = speed;

    if (mode == 'Static') {
      _controller
        ..stop()
        ..value = 0;
      return;
    }

    final period = _periodFor(mode, speed);
    _controller
      ..stop()
      ..value = 0
      ..repeat(period: period);
  }

  IconData _animIcon(String mode) {
    switch (mode) {
      case 'Blink':
        return Icons.flash_on_rounded;
      case 'Static':
        return Icons.crop_square_rounded;
      case 'Scroll Right':
        return Icons.arrow_forward_rounded;
      case 'Scroll Up':
        return Icons.arrow_upward_rounded;
      case 'Scroll Down':
        return Icons.arrow_downward_rounded;
      default:
        return Icons.arrow_back_rounded;
    }
  }

  Offset _offsetFor(
    String mode,
    double panelW,
    double panelH,
    double textW,
    double textH,
    double t,
  ) {
    final centerX = (panelW - textW) / 2;
    final centerY = (panelH - textH) / 2;
    switch (mode) {
      case 'Scroll Left':
      case 'Running':
        return Offset(_lerp(panelW, -textW, t), centerY);
      case 'Scroll Right':
        return Offset(_lerp(-textW, panelW, t), centerY);
      case 'Scroll Up':
        return Offset(centerX, _lerp(panelH, -textH, t));
      case 'Scroll Down':
        return Offset(centerX, _lerp(-textH, panelH, t));
      default:
        return Offset(centerX, centerY);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeProvider>();
    _syncAnimation(controller.animMode, controller.speed);

    final code = controller.selectedRoute.split(' • ').first;
    final path = controller.selectedRoute.split(' • ').last;
    final parts = path.split(' - ');
    final label = controller.isPergi
        ? '$code | ${parts.first.toUpperCase()} \u2192 ${parts.last.toUpperCase()}'
        : '$code | ${parts.last.toUpperCase()} \u2192 ${parts.first.toUpperCase()}';

    return AspectRatio(
      aspectRatio: kP5PanelAspectRatio,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.ledBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 6,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.ledBackground.withValues(alpha: 0.5),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final panelW = constraints.maxWidth;
            final panelH = constraints.maxHeight;
            final horizontalInset = 20.0;
            double fontSize = panelH * 0.34;

            TextStyle buildStyle(double size) => TextStyle(
              fontFamily: 'Courier',
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: AppColors.ledText,
              fontSize: size,
              shadows: [
                Shadow(color: AppColors.ledText, blurRadius: 12),
                Shadow(color: AppColors.ledText, blurRadius: 24),
              ],
            );

            TextPainter measure(double size) => TextPainter(
              text: TextSpan(text: label, style: buildStyle(size)),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            )..layout();

            var tp = measure(fontSize);

            final travelsHorizontally =
                controller.animMode == 'Scroll Left' ||
                controller.animMode == 'Scroll Right' ||
                controller.animMode == 'Running';
            if (!travelsHorizontally &&
                tp.width > panelW - horizontalInset * 2) {
              final scale = (panelW - horizontalInset * 2) / tp.width;
              fontSize = (fontSize * scale).clamp(10.0, fontSize);
              tp = measure(fontSize);
            }
            final textStyle = buildStyle(fontSize);

            return Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final offset = _offsetFor(
                      controller.animMode,
                      panelW,
                      panelH,
                      tp.width,
                      tp.height,
                      _controller.value,
                    );
                    final opacity = controller.animMode == 'Blink'
                        ? (_controller.value < 0.5 ? 1.0 : 0.12)
                        : 1.0;
                    return Positioned(
                      left: offset.dx,
                      top: offset.dy,
                      child: Opacity(
                        opacity: opacity,
                        child: Text(
                          label,
                          maxLines: 1,
                          softWrap: false,
                          style: textStyle,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  top: 8,
                  child: Row(
                    children: [
                      Icon(
                        Icons.monitor_rounded,
                        color: AppColors.ledText.withValues(alpha: 0.7),
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'P5 PANEL • PRATINJAU LIVE',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _animIcon(controller.animMode),
                        color: Colors.white.withValues(alpha: 0.45),
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        controller.animMode,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  static const double _pitch = 7.0;
  static const double _dotRadius = 1.1;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.06);
    for (double y = _pitch / 2; y < size.height; y += _pitch) {
      for (double x = _pitch / 2; x < size.width; x += _pitch) {
        canvas.drawCircle(Offset(x, y), _dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) => false;
}
