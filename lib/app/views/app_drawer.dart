import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pocketbase_mobile_flutter/app/modules/home/home_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/app_data.dart';
import '../services/storage_service.dart';
import 'contact_us_view.dart';

class AppDrawer extends Drawer {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Get.width / 1.2,
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(top: 24.0, bottom: 64.0),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(AppAssets.icon),
              ),
              const Divider(thickness: 2),
              DrawerTile(
                Icons.link,
                "About Pocketbase",
                iconColor: Colors.blue,
                onTap: () async {
                  await launchUrl(
                    Uri.parse(AppUtils.pocketbaseUrl),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              Obx(
                () => DrawerTile(
                  Icons.dark_mode,
                  "Dark Mode",
                  iconColor: Colors.black,
                  toggleState: HomeController.to.isDarkMode.value,
                  onTap: () {
                    final themeMode = HomeController.to.isDarkMode.value
                        ? ThemeMode.light
                        : ThemeMode.dark;
                    Get.changeThemeMode(themeMode);
                    HomeController.to.isDarkMode.toggle();
                    StorageService.to.isDarkMode =
                        HomeController.to.isDarkMode.value;
                  },
                ),
              ),
              DrawerTile(
                Icons.share,
                "Share App",
                iconColor: Colors.red,
                onTap: () {
                  String shareMessage =
                      "Check out ${AppUtils.appName}! \n${AppUtils.appDescription} \n${AppUtils.pocketbaseUrl}";
                  Share.share(shareMessage);
                },
              ),
              DrawerTile(
                Icons.contact_mail,
                "Contact",
                iconColor: Colors.green,
                onTap: () {
                  Get.to(() => const ContactUsView());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Color iconColor;
  final Function()? onTap;
  final bool? toggleState;

  const DrawerTile(
    this.iconData,
    this.title, {
    super.key,
    this.iconColor = Colors.grey,
    this.onTap,
    this.toggleState,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 2.0),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          iconData,
          color: iconColor,
        ),
        title: Text(title),
        contentPadding: EdgeInsets.zero,
        trailing: toggleState == null
            ? null
            : Switch(value: toggleState!, onChanged: (value) => onTap?.call()),
      ),
    );
  }
}
