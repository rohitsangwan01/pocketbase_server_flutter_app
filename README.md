# Pocketbase flutter mobile

Pocketbase server app, built using flutter and gomobile

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

## Note

Api's might change, or i might convert this project into a flutter plugin, once this will be stable, feel free to Contribute or Report any Bug!
