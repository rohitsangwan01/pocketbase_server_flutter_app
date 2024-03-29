import 'package:flutter/material.dart';
import 'package:pocketbase_server_flutter/pocketbase_server_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isServiceRunning = false;
  String status = "";

  @override
  void initState() {
    PocketbaseServerFlutter.isRunning.then(
      (value) => setState(() => isServiceRunning = value),
    );
    PocketbaseServerFlutter.pocketbaseMobileVersion.then(
      (value) => _updateText("PocketbaseMobileVersion: $value"),
    );
    PocketbaseServerFlutter.setEventCallback(
      callback: (event, data) => _updateText("$event: $data"),
    );
    super.initState();
  }

  void _updateText(String data) {
    setState(() {
      status = "$status \n$data \n";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pocketbase Mobile'),
          centerTitle: true,
          actions: [
            Icon(
              Icons.circle,
              color: isServiceRunning ? Colors.green : Colors.red,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        PocketbaseServerFlutter.start(
                          hostName:
                              await PocketbaseServerFlutter.localIpAddress,
                          port: "8080",
                          enablePocketbaseApiLogs: true,
                        );
                        setState(() {
                          isServiceRunning = true;
                        });
                      },
                      child: const Text("Start"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await PocketbaseServerFlutter.stop();
                        setState(() {
                          isServiceRunning = false;
                        });
                      },
                      child: const Text("Stop"),
                    ),
                  ],
                ),
                const Divider(thickness: 1),
                Text(status),
              ],
            ),
          ),
        ));
  }
}
