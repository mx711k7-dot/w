import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/vpn_service.dart';
import '../utils/theme.dart';

class WorldMapWidget extends StatelessWidget {
  const WorldMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final VPNService vpnService = VPNService.to;

    return Obx(() {
      final isConnected = vpnService.isConnected.value;
      final server = vpnService.selectedServer.value;

      return Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isConnected
                ? AppTheme.primaryGreen.withOpacity(0.3)
                : AppTheme.primaryGreen.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isConnected
                  ? AppTheme.primaryGreen.withOpacity(0.1)
                  : Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: CustomPaint(
            size: const Size(double.infinity, 220),
            painter: WorldMapPainter(
              isConnected: isConnected,
              serverCountry: server?.country ?? '',
            ),
          ),
        ),
      );
    });
  }
}

class WorldMapPainter extends CustomPainter {
  final bool isConnected;
  final String serverCountry;

  WorldMapPainter({
    required this.isConnected,
    required this.serverCountry,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryGreen.withOpacity(0.15)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = AppTheme.primaryGreen.withOpacity(isConnected ? 0.4 : 0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3);

    final dotPaint = Paint()
      ..color = isConnected ? AppTheme.primaryGreen : AppTheme.textMuted
      ..style = PaintingStyle.fill;

    final glowDotPaint = Paint()
      ..color = AppTheme.primaryGreen.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Draw simplified world map continents as paths
    _drawContinents(canvas, size, paint);
    _drawContinents(canvas, size, glowPaint);

    // Draw connection dots for major regions
    final dots = [
      Offset(size.width * 0.15, size.height * 0.35), // North America
      Offset(size.width * 0.25, size.height * 0.55), // South America
      Offset(size.width * 0.48, size.height * 0.30), // Europe
      Offset(size.width * 0.52, size.height * 0.45), // Africa
      Offset(size.width * 0.55, size.height * 0.28), // Middle East
      Offset(size.width * 0.65, size.height * 0.35), // Asia
      Offset(size.width * 0.78, size.height * 0.55), // Australia
    ];

    for (final dot in dots) {
      canvas.drawCircle(dot, 6, glowDotPaint);
      canvas.drawCircle(dot, 3, dotPaint);
    }

    // Draw connection line if connected
    if (isConnected) {
      final linePaint = Paint()
        ..color = AppTheme.primaryGreen.withOpacity(0.6)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4);

      final startPoint = Offset(size.width * 0.52, size.height * 0.28);
      final endPoint = Offset(size.width * 0.48, size.height * 0.30);

      final path = Path();
      path.moveTo(startPoint.dx, startPoint.dy);
      path.quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.15,
        endPoint.dx,
        endPoint.dy,
      );

      canvas.drawPath(path, linePaint);

      // Animated pulse on connection
      final pulsePaint = Paint()
        ..color = AppTheme.primaryGreen.withOpacity(0.2)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(startPoint, 12, pulsePaint);
      canvas.drawCircle(endPoint, 12, pulsePaint);
    }
  }

  void _drawContinents(Canvas canvas, Size size, Paint paint) {
    // North America
    final naPath = Path()
      ..moveTo(size.width * 0.05, size.height * 0.20)
      ..lineTo(size.width * 0.20, size.height * 0.15)
      ..lineTo(size.width * 0.25, size.height * 0.25)
      ..lineTo(size.width * 0.22, size.height * 0.40)
      ..lineTo(size.width * 0.10, size.height * 0.45)
      ..lineTo(size.width * 0.05, size.height * 0.35)
      ..close();
    canvas.drawPath(naPath, paint);

    // South America
    final saPath = Path()
      ..moveTo(size.width * 0.18, size.height * 0.48)
      ..lineTo(size.width * 0.28, size.height * 0.50)
      ..lineTo(size.width * 0.30, size.height * 0.70)
      ..lineTo(size.width * 0.22, size.height * 0.85)
      ..lineTo(size.width * 0.15, size.height * 0.75)
      ..close();
    canvas.drawPath(saPath, paint);

    // Europe
    final euPath = Path()
      ..moveTo(size.width * 0.42, size.height * 0.18)
      ..lineTo(size.width * 0.55, size.height * 0.15)
      ..lineTo(size.width * 0.58, size.height * 0.28)
      ..lineTo(size.width * 0.48, size.height * 0.32)
      ..lineTo(size.width * 0.40, size.height * 0.25)
      ..close();
    canvas.drawPath(euPath, paint);

    // Africa
    final afPath = Path()
      ..moveTo(size.width * 0.45, size.height * 0.35)
      ..lineTo(size.width * 0.58, size.height * 0.35)
      ..lineTo(size.width * 0.60, size.height * 0.55)
      ..lineTo(size.width * 0.52, size.height * 0.70)
      ..lineTo(size.width * 0.42, size.height * 0.60)
      ..close();
    canvas.drawPath(afPath, paint);

    // Asia
    final asPath = Path()
      ..moveTo(size.width * 0.58, size.height * 0.18)
      ..lineTo(size.width * 0.85, size.height * 0.15)
      ..lineTo(size.width * 0.90, size.height * 0.35)
      ..lineTo(size.width * 0.82, size.height * 0.50)
      ..lineTo(size.width * 0.65, size.height * 0.48)
      ..lineTo(size.width * 0.60, size.height * 0.30)
      ..close();
    canvas.drawPath(asPath, paint);

    // Australia
    final auPath = Path()
      ..moveTo(size.width * 0.72, size.height * 0.58)
      ..lineTo(size.width * 0.88, size.height * 0.55)
      ..lineTo(size.width * 0.90, size.height * 0.72)
      ..lineTo(size.width * 0.78, size.height * 0.78)
      ..lineTo(size.width * 0.70, size.height * 0.70)
      ..close();
    canvas.drawPath(auPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
