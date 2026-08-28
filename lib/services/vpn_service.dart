import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/server_model.dart';

class VPNService extends GetxController {
  static VPNService get to => Get.find();

  late OpenVPN engine;

  final Rx<VPNStage?> stage = Rx<VPNStage?>(null);
  final Rx<VPNStatus?> status = Rx<VPNStatus?>(null);
  final Rx<ServerModel?> selectedServer = Rx<ServerModel?>(null);
  final RxBool isConnecting = false.obs;
  final RxBool isConnected = false.obs;
  final RxString connectionTime = '00:00:00'.obs;
  final RxString downloadSpeed = '0 B'.obs;
  final RxString uploadSpeed = '0 B'.obs;
  final RxString totalDownload = '0 B'.obs;
  final RxString totalUpload = '0 B'.obs;
  final RxString currentIP = '---'.obs;
  final RxString connectionError = ''.obs;

  Timer? _timer;
  int _seconds = 0;

  @override
  void onInit() {
    super.onInit();
    _initializeVPN();
    _loadSelectedServer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _initializeVPN() {
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        status.value = data;
        _updateStats();
      },
      onVpnStageChanged: (data, raw) {
        stage.value = data;
        _handleStageChange(data);
      },
    );

    engine.initialize(
      groupIdentifier: "group.com.securevpn.app",
      providerBundleIdentifier: "com.securevpn.app.VPNExtension",
      localizedDescription: "Secure VPN",
      lastStage: (stage) {
        this.stage.value = stage;
      },
      lastStatus: (status) {
        this.status.value = status;
      },
    );
  }

  void _handleStageChange(VPNStage? stage) {
    if (stage == null) return;

    switch (stage) {
      case VPNStage.connected:
        isConnected.value = true;
        isConnecting.value = false;
        connectionError.value = '';
        _startTimer();
        _fetchCurrentIP();
        break;
      case VPNStage.disconnected:
        isConnected.value = false;
        isConnecting.value = false;
        _stopTimer();
        break;
      case VPNStage.connecting:
      case VPNStage.authenticating:
      case VPNStage.wait_connection:
      case VPNStage.get_config:
      case VPNStage.assign_ip:
        isConnecting.value = true;
        break;
      case VPNStage.error:
        isConnecting.value = false;
        isConnected.value = false;
        connectionError.value = 'فشل الاتصال، يرجى المحاولة مرة أخرى';
        _stopTimer();
        break;
      default:
        break;
    }
  }

  void _startTimer() {
    _seconds = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      final hours = (_seconds ~/ 3600).toString().padLeft(2, '0');
      final minutes = ((_seconds % 3600) ~/ 60).toString().padLeft(2, '0');
      final secs = (_seconds % 60).toString().padLeft(2, '0');
      connectionTime.value = '$hours:$minutes:$secs';
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _seconds = 0;
    connectionTime.value = '00:00:00';
  }

  void _updateStats() {
    if (status.value != null) {
      downloadSpeed.value = _formatBytes(status.value!.byteIn ?? 0);
      uploadSpeed.value = _formatBytes(status.value!.byteOut ?? 0);
      totalDownload.value = _formatBytes(status.value!.byteIn ?? 0);
      totalUpload.value = _formatBytes(status.value!.byteOut ?? 0);
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<void> _fetchCurrentIP() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.ipify.org?format=json'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        currentIP.value = data['ip'] ?? '---';
      }
    } catch (e) {
      currentIP.value = 'غير متاح';
    }
  }

  Future<void> _loadSelectedServer() async {
    final prefs = await SharedPreferences.getInstance();
    final serverId = prefs.getString('selected_server');
    if (serverId != null) {
      final server = allServers.firstWhereOrNull((s) => s.id == serverId);
      if (server != null) {
        selectedServer.value = server;
      }
    }
    if (selectedServer.value == null && allServers.isNotEmpty) {
      selectedServer.value = allServers.firstWhere((s) => s.id == 'ma');
    }
  }

  Future<void> _saveSelectedServer() async {
    final prefs = await SharedPreferences.getInstance();
    if (selectedServer.value != null) {
      await prefs.setString('selected_server', selectedServer.value!.id);
    }
  }

  void selectServer(ServerModel server) {
    selectedServer.value = server;
    _saveSelectedServer();
  }

  Future<void> connect() async {
    if (selectedServer.value == null) {
      Get.snackbar(
        'تنبيه',
        'الرجاء اختيار سيرفر أولاً',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (isConnected.value) {
      await disconnect();
      return;
    }

    try {
      isConnecting.value = true;
      connectionError.value = '';

      // Fetch OVPN config from GitHub
      final config = await _fetchConfig(selectedServer.value!.rawUrl);

      if (config.isEmpty) {
        throw Exception('تعذر تحميل إعدادات السيرفر');
      }

      engine.connect(
        config,
        selectedServer.value!.countryAr,
        username: 'vpn',
        password: 'vpn',
        certIsRequired: false,
      );
    } catch (e) {
      isConnecting.value = false;
      connectionError.value = 'خطأ: ${e.toString()}';
      Get.snackbar(
        'خطأ في الاتصال',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<String> _fetchConfig(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      }
      throw Exception('فشل تحميل الإعدادات: ${response.statusCode}');
    } catch (e) {
      throw Exception('فشل الاتصال بالسيرفر: $e');
    }
  }

  Future<void> disconnect() async {
    engine.disconnect();
    isConnected.value = false;
    isConnecting.value = false;
    _stopTimer();
    currentIP.value = '---';
  }

  String getStageText() {
    if (stage.value == null) return 'غير متصل';
    switch (stage.value!) {
      case VPNStage.connected:
        return 'متصل';
      case VPNStage.connecting:
        return 'جاري الاتصال...';
      case VPNStage.authenticating:
        return 'جاري المصادقة...';
      case VPNStage.wait_connection:
        return 'في انتظار الاتصال...';
      case VPNStage.get_config:
        return 'جاري الحصول على الإعدادات...';
      case VPNStage.assign_ip:
        return 'جاري تعيين IP...';
      case VPNStage.disconnected:
        return 'غير متصل';
      case VPNStage.disconnecting:
        return 'جاري قطع الاتصال...';
      case VPNStage.error:
        return 'خطأ في الاتصال';
      default:
        return 'غير متصل';
    }
  }

  Color getStageColor() {
    if (stage.value == null) return Colors.grey;
    switch (stage.value!) {
      case VPNStage.connected:
        return const Color(0xFF00E676);
      case VPNStage.connecting:
      case VPNStage.authenticating:
      case VPNStage.wait_connection:
      case VPNStage.get_config:
      case VPNStage.assign_ip:
        return const Color(0xFFFFD600);
      case VPNStage.error:
        return const Color(0xFFFF1744);
      default:
        return Colors.grey;
    }
  }
}
