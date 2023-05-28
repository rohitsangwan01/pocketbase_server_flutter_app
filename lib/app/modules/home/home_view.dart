import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'package:get/get.dart';
import 'package:input_history_text_field/input_history_text_field.dart';
import 'package:pocketbase_mobile_flutter/pocketbase_mobile.dart';
import 'package:upgrader/upgrader.dart';

import '../../views/app_drawer.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: AdvancedDrawer(
        controller: controller.advancedDrawerController,
        backdropColor: Theme.of(context).secondaryHeaderColor,
        drawer: const MainDrawer(),
        openRatio: 0.6,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          appBar: AppBar(
            title: const Text('Pocketbase Mobile'),
            centerTitle: true,
            leading: IconButton(
              onPressed: controller.onMenuTap,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: controller.advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },
              ),
            ),
            actions: [
              Obx(() => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.circle,
                        color: controller.isRunning.value
                            ? Colors.green
                            : Colors.red),
                  )),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/gopher_half.png",
                        height: 50,
                      ),
                      const Expanded(
                        child: Text(
                          "Open Source backend from your mobile",
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  InputHistoryTextField(
                    historyKey: "hostName",
                    textEditingController: controller.hostnameEditingController,
                    autofocus: false,
                    decoration: const InputDecoration(
                      hintText: "Hostname",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InputHistoryTextField(
                    historyKey: "portData",
                    textEditingController: controller.portEditingController,
                    autofocus: false,
                    decoration: const InputDecoration(
                      hintText: "Port",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: controller.start,
                        child: const Text("Start"),
                      ),
                      ElevatedButton(
                        onPressed: controller.openAdminPanel,
                        child: const Text("Admin Panel"),
                      ),
                      ElevatedButton(
                        onPressed: controller.stop,
                        child: const Text("Stop"),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                        future: PocketbaseMobileFlutter.pocketbaseMobileVersion,
                        initialData: "Loading...",
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return Text(
                            "Pocketbase Mobile Version: ${snapshot.data}",
                          );
                        },
                      ),
                      InkWell(
                        onTap: () {
                          controller.logs.value = "";
                        },
                        child: const Icon(Icons.cancel),
                      )
                    ],
                  ),
                  const Divider(),
                  Obx(() => Expanded(
                        child: SingleChildScrollView(
                          child: Text(controller.logs.value),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
