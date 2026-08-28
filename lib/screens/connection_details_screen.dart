import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/vpn_service.dart';
import '../utils/theme.dart';

class ConnectionDetailsScreen extends StatelessWidget {
  const ConnectionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VPNService vpnService = VPNService.to;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'تفاصيل الاتصال',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final isConnected = vpnService.isConnected.value;
        final server = vpnService.selectedServer.value;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Connection Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: isConnected
                      ? AppTheme.primaryGradient
                      : const LinearGradient(
                          colors: [AppTheme.surface, AppTheme.surfaceDark],
                        ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: isConnected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isConnected
                            ? Colors.white.withOpacity(0.2)
                            : AppTheme.surfaceLight,
                      ),
                      child: Icon(
                        isConnected
                            ? Icons.shield_moon_rounded
                            : Icons.shield_outlined,
                        size: 40,
                        color: isConnected ? Colors.white : AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isConnected ? 'تم الاتصال بأمان' : 'غير متصل',
                      style: GoogleFonts.cairo(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isConnected ? Colors.black : AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isConnected
                          ? 'اتصالك محمي ومشفر'
                          : 'اضغط على زر الاتصال للبدء',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: isConnected
                            ? Colors.black.withOpacity(0.7)
                            : AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Connection Info
              _buildInfoSection('معلومات الاتصال', [
                _buildInfoRow(
                  icon: Icons.public_rounded,
                  title: 'عنوان IP الجديد',
                  value: vpnService.currentIP.value,
                  color: const Color(0xFF00E676),
                ),
                _buildInfoRow(
                  icon: Icons.location_on_rounded,
                  title: 'الموقع الجديد',
                  value: server != null
                      ? '${server.countryAr} - ${server.city}'
                      : 'غير محدد',
                  color: const Color(0xFF1DE9B6),
                ),
                _buildInfoRow(
                  icon: Icons.dns_rounded,
                  title: 'الخادم',
                  value: server?.fileName ?? 'غير محدد',
                  color: const Color(0xFF00BFA5),
                ),
              ]),
              const SizedBox(height: 24),
              // Statistics
              _buildInfoSection('الإحصائيات', [
                _buildInfoRow(
                  icon: Icons.timer_rounded,
                  title: 'المدة',
                  value: vpnService.connectionTime.value,
                  color: const Color(0xFF69F0AE),
                ),
                _buildInfoRow(
                  icon: Icons.download_rounded,
                  title: 'البيانات المستلمة',
                  value: vpnService.totalDownload.value,
                  color: const Color(0xFF00E676),
                ),
                _buildInfoRow(
                  icon: Icons.upload_rounded,
                  title: 'البيانات المرسلة',
                  value: vpnService.totalUpload.value,
                  color: const Color(0xFF1DE9B6),
                ),
              ]),
              const SizedBox(height: 24),
              // Disconnect Button
              if (isConnected)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => vpnService.disconnect(),
                    icon: const Icon(Icons.power_settings_new_rounded),
                    label: Text(
                      'قطع الاتصال',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5252),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
