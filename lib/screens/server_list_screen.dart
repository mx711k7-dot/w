import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../models/server_model.dart';
import '../services/vpn_service.dart';
import '../utils/theme.dart';

class ServerListScreen extends StatefulWidget {
  const ServerListScreen({super.key});

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen> {
  final VPNService vpnService = VPNService.to;
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;
  final RxBool _isLoading = false.obs;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServerModel> get filteredServers {
    if (_searchQuery.value.isEmpty) return allServers;
    return allServers.where((s) =>
      s.countryAr.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
      s.country.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
      s.city.toLowerCase().contains(_searchQuery.value.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
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
          'اختيار السيرفر',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => _searchQuery.value = value,
                style: GoogleFonts.cairo(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: 'ابحث عن دولة أو مدينة...',
                  hintStyle: GoogleFonts.cairo(color: AppTheme.textMuted),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                  suffixIcon: Obx(() => _searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppTheme.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          _searchQuery.value = '';
                        },
                      )
                    : const SizedBox.shrink()),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
          ),
          // Server Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Obx(() => Text(
                    '${filteredServers.length} سيرفر',
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Server List
          Expanded(
            child: Obx(() {
              final servers = filteredServers;
              if (servers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 60,
                        color: AppTheme.textMuted.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد نتائج',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: servers.length,
                itemBuilder: (context, index) {
                  final server = servers[index];
                  return _buildServerCard(server);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildServerCard(ServerModel server) {
    return Obx(() {
      final isSelected = vpnService.selectedServer.value?.id == server.id;
      final isConnected = vpnService.isConnected.value && isSelected;

      return GestureDetector(
        onTap: () {
          vpnService.selectServer(server);
          if (vpnService.isConnected.value) {
            vpnService.disconnect().then((_) {
              Future.delayed(const Duration(milliseconds: 500), () {
                vpnService.connect();
              });
            });
          }
          Get.back();
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.surfaceLight : AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryGreen.withOpacity(0.5)
                  : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.primaryGreen.withOpacity(0.15),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: isSelected ? AppTheme.primaryGradient : null,
                  color: isSelected ? null : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    server.flag,
                    style: const TextStyle(fontSize: 26),
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      server.city,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      server.ip,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: AppTheme.primaryGreen.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isConnected)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'متصل',
                            style: GoogleFonts.cairo(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'محدد',
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPingColor(server.ping).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${server.ping}ms',
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getPingColor(server.ping),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Color _getPingColor(int ping) {
    if (ping < 50) return const Color(0xFF00E676);
    if (ping < 100) return const Color(0xFFFFD600);
    return const Color(0xFFFF5252);
  }
}
