import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pocketbase_mobile_flutter/app/data/app_data.dart';
import 'package:pocketbase_mobile_flutter/app/data/storage_service.dart';
import 'package:pocketbase_mobile_flutter/app/views/admin_panel_view.dart';
import 'package:pocketbase_server_flutter/pocketbase_server_flutter.dart';
import 'package:upgrader/upgrader.dart';

import 'app_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final StorageService _storage = StorageService.instance;

  bool _isRunning = false;
  final List<String> _logs = ["Pocketbase logs:"];
  bool _enablePocketbaseApiLogs = true;
  late String basePath;
  late final String staticFolder = "$basePath/pb_static/";
  late final String hooksFolder = "$basePath/pb_hooks/";
  late final String dataFolder = "$basePath/pb_data/";

  bool _isGopherVisible = true;
  final _hostnameEditingController = TextEditingController();
  final _portEditingController = TextEditingController();
  final _adminUsernameEditingController = TextEditingController();
  final _adminPasswordEditingController = TextEditingController();

  String get _adminUrl =>
      "http://${_hostnameEditingController.text}:${_portEditingController.text}/_/";

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  void _addLog(String log) {
    setState(() {
      _logs.add(log);
    });
  }

  void _initialize() async {
    PocketbaseServerFlutter.setEventCallback(
      callback: (event, data) {
        _addLog("$event: $data");
        String eventType = event.trim();
        if (eventType == "error") {
          _showSnackbar(data);
          setState(() {
            _isRunning = false;
          });
        }
      },
    );

    _isRunning = await PocketbaseServerFlutter.isRunning ?? false;
    final info = NetworkInfo();
    String? localIp = await info.getWifiIP();
    final cachePath = (await getApplicationCacheDirectory()).path;
    basePath = "$cachePath/pocketbase_server";

    _hostnameEditingController.text = localIp ?? "127.0.0.1";
    _portEditingController.text = "8080";
    _adminUsernameEditingController.text = _storage.adminUsername;
    _adminPasswordEditingController.text = _storage.adminPassword;
    setState(() {});
  }

  void start() async {
    if (_hostnameEditingController.text.isEmpty ||
        _portEditingController.text.isEmpty) {
      _showSnackbar("Please enter a hostname or port");
      return;
    }
    try {
      setState(() {
        _isRunning = true;
      });

      // Create the folders if they don't exist
      if (!Directory(staticFolder).existsSync()) {
        Directory(staticFolder).createSync(recursive: true);
      }
      if (!Directory(hooksFolder).existsSync()) {
        Directory(hooksFolder).createSync(recursive: true);
      }
      if (!Directory(dataFolder).existsSync()) {
        Directory(dataFolder).createSync(recursive: true);
      }

      await PocketbaseServerFlutter.start(
        superUserEmail: _adminUsernameEditingController.text,
        superUserPassword: _adminPasswordEditingController.text,
        hostName: _hostnameEditingController.text,
        port: _portEditingController.text,
        enablePocketbaseApiLogs: _enablePocketbaseApiLogs,
        staticFilesPath: staticFolder,
        hookFilesPath: hooksFolder,
        dataPath: dataFolder,
      );
      _storage.adminUsername = _adminUsernameEditingController.text;
      _storage.adminPassword = _adminPasswordEditingController.text;
    } catch (e) {
      setState(() {
        _isRunning = false;
      });
      String errorMessage = e.toString();
      if (e is PlatformException) {
        errorMessage = e.message ?? e.toString();
      }
      _showSnackbar(errorMessage);
    }
  }

  void stop() async {
    try {
      await PocketbaseServerFlutter.stop();
      setState(() {
        _isRunning = false;
      });
    } catch (e) {
      String errorMessage = e.toString();
      if (e is PlatformException) {
        errorMessage = e.message ?? e.toString();
      }
      _showSnackbar(errorMessage);
    }
  }

  void openAdminPanel() {
    if (_hostnameEditingController.text.isEmpty ||
        _portEditingController.text.isEmpty) {
      _showSnackbar("Please enter a hostname or port");
      return;
    }
    if (!_isRunning) {
      _showSnackbar("Please start Pocketbase first");
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminPanelView(adminPanelUrl: _adminUrl),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _showFilesInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Files"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Files are stored in the following path:"),
            const SizedBox(height: 10),
            Text(basePath),
            const SizedBox(height: 10),
            Text("StaticFiles: /pb_static/"),
            const SizedBox(height: 10),
            Text("Hooks: /pb_hooks/"),
            const SizedBox(height: 10),
            Text("Data: /pb_data/"),
            const SizedBox(height: 10),
            Text(
              "You can place static files in the /pb_static/ folder and hooks in the /pb_hooks/ folder.",
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _toggleGopher() {
    setState(() {
      _isGopherVisible = !_isGopherVisible;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        appBar: AppBar(
          title: const Text('Pocketbase Mobile'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.circle,
                color: _isRunning ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: _toggleGopher,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 70.0, top: 15),
                      child: Text(
                        "Open Source backend from your mobile",
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    top: _isGopherVisible ? 0 : 30,
                    duration: const Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: _toggleGopher,
                      child: Image.asset(
                        AppAssets.gopherHalf,
                        height: 50,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Container(
                      color: Theme.of(context).colorScheme.tertiary,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _hostnameEditingController,
                              autofocus: false,
                              onTap: _toggleGopher,
                              decoration: InputDecoration(
                                hintText: "Hostname",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 3),
                                ),
                                fillColor:
                                    Theme.of(context).colorScheme.surface,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _portEditingController,
                              autofocus: false,
                              onTap: _toggleGopher,
                              decoration: const InputDecoration(
                                hintText: "Port",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 3),
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Text(
                "Super User Credentials",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "You can change these credentials later from the admin panel",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _adminUsernameEditingController,
                      autofocus: false,
                      onTap: _toggleGopher,
                      decoration: const InputDecoration(
                        hintText: "Username",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _adminPasswordEditingController,
                      autofocus: false,
                      onTap: _toggleGopher,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: start,
                      child: const Text("Start"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: stop,
                      child: const Text("Stop"),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: openAdminPanel,
                      child: const Text("Admin Panel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showFilesInfoDialog,
                      child: const Text("Data Info"),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Enable Api Logs"),
                  Switch(
                    value: _enablePocketbaseApiLogs,
                    onChanged: (value) {
                      setState(() {
                        _enablePocketbaseApiLogs = value;
                      });
                      if (_isRunning) {
                        _showSnackbar("Restart Pocketbase to apply changes");
                      }
                    },
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                    future: PocketbaseServerFlutter.pocketbaseMobileVersion,
                    initialData: "Loading...",
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Text(
                        "Pocketbase Mobile Version: ${snapshot.data}",
                      );
                    },
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _logs.clear();
                      });
                    },
                    child: const Icon(Icons.cancel),
                  )
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Text(_logs[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
