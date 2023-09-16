import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pocketbase_mobile_flutter/app/services/storage_service.dart';
import 'package:pocketbase_mobile_flutter/app/views/admin_panel_view.dart';
import 'package:pocketbase_mobile_flutter/app/views/ui.dart';
import 'package:pocketbase_server_flutter/pocketbase_server_flutter.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxBool isRunning = false.obs;
  RxString logs = "Pocketbase logs: \n".obs;
  final hostnameEditingController = TextEditingController();
  final portEditingController = TextEditingController();
  String get _adminUrl =>
      "http://${hostnameEditingController.text}:${portEditingController.text}/_/";
  RxBool isDarkMode = false.obs;
  RxBool enablePocketbaseApiLogs = true.obs;

  @override
  void onInit() {
    isDarkMode.value = StorageService.to.isDarkMode;
    PocketbaseServerFlutter.isRunning.then(
      (value) => isRunning.value = value ?? false,
    );
    _initListener();
    _initHostAndPort();
    super.onInit();
  }

  void start() async {
    if (hostnameEditingController.text.isEmpty ||
        portEditingController.text.isEmpty) {
      UI.presentError("Please enter a hostname or port");
      return;
    }
    try {
      await PocketbaseServerFlutter.start(
        hostName: hostnameEditingController.text,
        port: portEditingController.text,
        enablePocketbaseApiLogs: enablePocketbaseApiLogs.value,
      );
      isRunning.value = true;
    } catch (e) {
      String errorMessage = e.toString();
      if (e is PlatformException) {
        errorMessage = e.message ?? e.toString();
      }
      UI.presentError(errorMessage);
    }
  }

  void stop() async {
    try {
      await PocketbaseServerFlutter.stop();
      isRunning.value = false;
    } catch (e) {
      String errorMessage = e.toString();
      if (e is PlatformException) {
        errorMessage = e.message ?? e.toString();
      }
      UI.presentError(errorMessage);
    }
  }

  void _initListener() {
    PocketbaseServerFlutter.setEventCallback(
      callback: (event, data) {
        logs.value = "${logs.value}\n$event: $data \n";
        if (event.trim().toLowerCase() == "error") {
          UI.presentError(data);
          isRunning.value = false;
        }
      },
    );
  }

  void openAdminPanel() {
    if (hostnameEditingController.text.isEmpty ||
        portEditingController.text.isEmpty) {
      UI.presentError("Please enter a hostname or port");
      return;
    }
    if (!isRunning.value) {
      UI.presentError("Please start Pocketbase first");
      return;
    }
    Get.to(
      () => AdminPanelView(adminPanelUrl: _adminUrl),
      transition: Transition.cupertino,
    );
  }

  void _initHostAndPort() async {
    hostnameEditingController.text =
        await PocketbaseServerFlutter.localIpAddress ?? "127.0.0.1";
    portEditingController.text = "8080";
  }
}
