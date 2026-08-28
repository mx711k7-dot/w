import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/vpn_service.dart';
import '../utils/theme.dart';
import '../widgets/connection_button.dart';
import '../widgets/world_map_widget.dart';
import 'server_list_screen.dart';
import 'connection_details_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final VPNService vpnService = Get.put(VPNService());
  late AnimationController _pulseController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Secure VPN',
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppTheme.textSecondary),
            onPressed: () => Get.to(() => const SettingsScreen()),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.background,
              AppTheme.surfaceDark,
              AppTheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Status Card
                  _buildStatusCard(),
                  const SizedBox(height: 20),
                  // World Map
                  const WorldMapWidget(),
                  const SizedBox(height: 20),
                  // Connection Button
                  const ConnectionButton(),
                  const SizedBox(height: 20),
                  // Server Info Card
                  _buildServerInfoCard(),
                  const SizedBox(height: 20),
                  // Stats Grid
                  _buildStatsGrid(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildStatusCard() {
    return Obx(() {
      final isConnected = vpnService.isConnected.value;
      final isConnecting = vpnService.isConnecting.value;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isConnected
              ? const LinearGradient(
                  colors: [Color(0xFF00E676), Color(0xFF1DE9B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isConnected ? null : AppTheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: isConnected
              ? null
              : Border.all(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  width: 1,
                ),
          boxShadow: isConnected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isConnected
                        ? Colors.white
                        : isConnecting
                            ? const Color(0xFFFFD600)
                            : const Color(0xFFFF5252),
                    boxShadow: [
                      BoxShadow(
                        color: (isConnected
                                ? Colors.white
                                : isConnecting
                                    ? const Color(0xFFFFD600)
                                    : const Color(0xFFFF5252))
                            .withOpacity(0.6),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.3, 1.3),
                      duration: 1000.ms,
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.3, 1.3),
                      end: const Offset(1, 1),
                      duration: 1000.ms,
                    ),
                const SizedBox(width: 10),
                Text(
                  vpnService.getStageText(),
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isConnected ? Colors.black : AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            if (isConnected) ...[
              const SizedBox(height: 8),
              Text(
                vpnService.connectionTime.value,
                style: GoogleFonts.cairo(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2,
                ),
              ),
            ],
          ],
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
    });
  }

  Widget _buildServerInfoCard() {
    return Obx(() {
      final server = vpnService.selectedServer.value;
      if (server == null) return const SizedBox.shrink();

      return GestureDetector(
        onTap: () => Get.to(() => const ServerListScreen()),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.primaryGreen.withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    server.flag,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      server.countryAr,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      server.city,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      server.ip,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${server.ping}ms',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppTheme.textMuted,
                size: 18,
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.2, end: 0);
    });
  }

  Widget _buildStatsGrid() {
    return Obx(() {
      final isConnected = vpnService.isConnected.value;

      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
        children: [
          _buildStatCard(
            icon: Icons.download_rounded,
            title: 'التحميل',
            value: vpnService.downloadSpeed.value,
            color: const Color(0xFF00E676),
            isActive: isConnected,
          ),
          _buildStatCard(
            icon: Icons.upload_rounded,
            title: 'الرفع',
            value: vpnService.uploadSpeed.value,
            color: const Color(0xFF1DE9B6),
            isActive: isConnected,
          ),
          _buildStatCard(
            icon: Icons.public_rounded,
            title: 'عنوان IP',
            value: vpnService.currentIP.value,
            color: const Color(0xFF00BFA5),
            isActive: isConnected,
            isIP: true,
          ),
          _buildStatCard(
            icon: Icons.timer_rounded,
            title: 'المدة',
            value: vpnService.connectionTime.value,
            color: const Color(0xFF69F0AE),
            isActive: isConnected,
          ),
        ],
      ).animate().fadeIn(delay: 400.ms, duration: 600.ms);
    });
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isActive,
    bool isIP = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? color.withOpacity(0.3) : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive ? color.withOpacity(0.1) : Colors.transparent,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
              if (isActive)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.5, 1.5),
                      duration: 1000.ms,
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.5, 1.5),
                      end: const Offset(1, 1),
                      duration: 1000.ms,
                    ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.cairo(
                  fontSize: isIP ? 13 : 16,
                  fontWeight: FontWeight.bold,
                  color: isActive ? color : AppTheme.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
            if (index == 1) {
              Get.to(() => const ServerListScreen());
            } else if (index == 2) {
              Get.to(() => const ConnectionDetailsScreen());
            }
          },
          backgroundColor: AppTheme.surfaceDark,
          selectedItemColor: AppTheme.primaryGreen,
          unselectedItemColor: AppTheme.textMuted,
          selectedLabelStyle: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.cairo(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.language_rounded),
              label: 'السيرفرات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart_outlined_rounded),
              label: 'الإحصائيات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }
}
