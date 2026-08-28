import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/vpn_service.dart';
import '../utils/theme.dart';

class ConnectionButton extends StatelessWidget {
  const ConnectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final VPNService vpnService = VPNService.to;

    return Obx(() {
      final isConnected = vpnService.isConnected.value;
      final isConnecting = vpnService.isConnecting.value;

      return GestureDetector(
        onTap: () => vpnService.connect(),
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isConnected
                ? const LinearGradient(
                    colors: [Color(0xFF00E676), Color(0xFF1DE9B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [Color(0xFF152A2E), Color(0xFF1E3A3F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            boxShadow: isConnected
                ? [
                    BoxShadow(
                      color: const Color(0xFF00E676).withOpacity(0.5),
                      blurRadius: 50,
                      spreadRadius: 10,
                    ),
                    BoxShadow(
                      color: const Color(0xFF00E676).withOpacity(0.2),
                      blurRadius: 80,
                      spreadRadius: 20,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring animation
              if (isConnecting)
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFD600).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1.1, 1.1),
                      duration: 1000.ms,
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.1, 1.1),
                      end: const Offset(0.9, 0.9),
                      duration: 1000.ms,
                    ),
              // Inner content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isConnected
                        ? Icons.power_settings_new_rounded
                        : Icons.power_settings_new_outlined,
                    size: 50,
                    color: isConnected ? Colors.black : AppTheme.primaryGreen,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isConnected
                        ? 'قطع الاتصال'
                        : isConnecting
                            ? 'جاري الاتصال...'
                            : 'اتصال',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isConnected ? Colors.black : AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              // Progress ring for connecting
              if (isConnecting)
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFFFFD600).withOpacity(0.8),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

extension on Widget {
  Widget animate({
    required void Function(AnimationController) onPlay,
  }) {
    return this;
  }
}
