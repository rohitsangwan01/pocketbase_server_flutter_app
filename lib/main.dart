import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/routes/app_pages.dart';
import 'app/services/storage_service.dart';

/// Checkout `example.dart` for a simple example
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => StorageService().init());

  runApp(
    GetMaterialApp(
      title: "Pocketbase Mobile",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: FlexThemeData.light(
        scheme: FlexScheme.aquaBlue,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        tertiary: const Color(0xffe4ecec),
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.aquaBlue,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        tertiary: const Color(0xff2a3c3c),
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      themeMode:
          StorageService.to.isDarkMode ? ThemeMode.dark : ThemeMode.light,
    ),
  );
}
