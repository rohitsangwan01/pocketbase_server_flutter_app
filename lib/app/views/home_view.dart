import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pocketbase_mobile_flutter/app/data/app_data.dart';
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
  bool _isRunning = false;
  String _logs = "Pocketbase logs: \n";
  bool _enablePocketbaseApiLogs = true;

  final _hostnameEditingController = TextEditingController();
  final _portEditingController = TextEditingController();

  String get _adminUrl =>
      "http://${_hostnameEditingController.text}:${_portEditingController.text}/_/";

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  void _initialize() async {
    PocketbaseServerFlutter.setEventCallback(
      callback: (event, data) {
        setState(() {
          _logs = "$_logs\n$event: $data \n";
        });
        String eventType = event.trim();
        if (eventType == "error") {
          _showSnackbar(data);
          setState(() {
            _isRunning = false;
          });
        }
      },
    );
    _isRunning = await PocketbaseServerFlutter.isRunning;
    _hostnameEditingController.text =
        await PocketbaseServerFlutter.localIpAddress ?? "127.0.0.1";
    _portEditingController.text = "8080";
    setState(() {});
  }

  void start() async {
    if (_hostnameEditingController.text.isEmpty ||
        _portEditingController.text.isEmpty) {
      _showSnackbar("Please enter a hostname or port");
      return;
    }
    try {
      await PocketbaseServerFlutter.start(
        hostName: _hostnameEditingController.text,
        port: _portEditingController.text,
        enablePocketbaseApiLogs: _enablePocketbaseApiLogs,
      );
      setState(() {
        _isRunning = true;
      });
    } catch (e) {
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
              Row(
                children: [
                  Image.asset(
                    AppAssets.gopherHalf,
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
              TextFormField(
                controller: _hostnameEditingController,
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
              TextFormField(
                controller: _portEditingController,
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
                    onPressed: start,
                    child: const Text("Start"),
                  ),
                  ElevatedButton(
                    onPressed: openAdminPanel,
                    child: const Text("Admin Panel"),
                  ),
                  ElevatedButton(
                    onPressed: stop,
                    child: const Text("Stop"),
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
                        _logs = "";
                      });
                    },
                    child: const Icon(Icons.cancel),
                  )
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_logs),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
