# Pocketbase flutter mobile

Pocketbase unofficial server app, built using flutter and gomobile

## Getting Started

To built for android, first download [pocketbaseMobile.aar](https://github.com/rohitsangwan01/pocketbase_mobile/blob/main/pocketbaseMobile.aar) and place in `android/app/libs/`

To built for ios, first download and extract [PocketbaseMobile.xcframework.zip](https://github.com/rohitsangwan01/pocketbase_mobile/blob/main/PocketbaseMobile.xcframework.zip) and import this framework in ios from xcode, check more instructions [here](https://github.com/rohitsangwan01/pocketbase_mobile/tree/main#native-ios-setup)

## Features

Start pocketbaseServer 

```dart
PocketbaseMobileFlutter.start(
  hostName: await PocketbaseMobileFlutter.localIpAddress,
  port: "8080",
  dataPath: null,
  enablePocketbaseApiLogs: true,
);
```

Stop pocketbaseServer

```dart
PocketbaseMobileFlutter.stop();
```

Listen to pocketbaseServer events, setup eventCallback

```dart
PocketbaseMobileFlutter.setEventCallback(
    callback: (event, data){
        // Handle event and data
    },
);
```

Some helper methods

```dart
// To check if pocketBase is running (not reliable)
PocketbaseMobileFlutter.isRunning

// To check pocketbaseMobile version
PocketbaseMobileFlutter.pocketbaseMobileVersion

// To get the ipAddress of mobile ( to run pocketbase with this hostname )
PocketbaseMobileFlutter.localIpAddress
```

## Screenshot


<img src="https://github.com/rohitsangwan01/pocketbase_server_flutter/assets/59526499/7d20a2a4-0df7-4f2a-90bf-2577289e0f7e" height="300">
<img src="https://github.com/rohitsangwan01/pocketbase_server_flutter/assets/59526499/370c007d-51c3-45a9-928c-1287c8def0d3" height="300">
<img src="https://github.com/rohitsangwan01/pocketbase_server_flutter/assets/59526499/657a6e4c-8431-4f49-b29d-a0f599524f6c" height="300">
<img src="https://github.com/rohitsangwan01/pocketbase_server_flutter/assets/59526499/4ecd5f1c-ae2b-4406-a10d-0d9ae3e9900e" height="300">
<img src="https://github.com/rohitsangwan01/pocketbase_server_flutter/assets/59526499/f58f7f5e-d3d0-4328-a8be-f5cf12e15cdb" height="300">


## Note

Api's might change, or i might convert this project into a flutter plugin, once this will be stable, feel free to Contribute or Report any Bug!
