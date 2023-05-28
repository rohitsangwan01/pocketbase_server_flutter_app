import 'package:flutter/material.dart';

import 'package:pocketbase_mobile_flutter/home_view.dart';

void main() {
  runApp(
    const MaterialApp(
      title: "Pocketbase Mobile",
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    ),
  );
}
