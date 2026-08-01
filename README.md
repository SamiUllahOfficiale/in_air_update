# In Air Update

A lightweight, robust Over-The-Air (OTA) patch and dynamic configuration management package for Flutter. It seamlessly fetches remote JSON patches, caches them locally using `hive_quick`, and provides offline fallback support.

---

## Features

- **Real-time OTA Updates**: Fetch dynamic patches or configurations directly from a remote endpoint.
- **Robust Local Caching**: Powered by `hive_quick` for secure and fast local storage of the latest patch.
- **Offline Resilience**: Automatically falls back to the locally cached patch if network connectivity fails.
- **Simple Static API**: Clean, intuitive syntax with zero boilerplate initialization.

---

## Why It Works Like This (Architecture & Workflow)

The package is built with simplicity, safety, and offline resilience in mind:

1. **Static API Design (`InAirUpdate.initialize` & `InAirUpdate.checkForUpdates`)**:
   - By making methods and state variables `static`, developers don't need to instantiate the class (no need to write `InAirUpdate()`). It acts as a global utility service available anywhere across the widget tree.
2. **Local Caching via `hive_quick`**:
   - If a user opens your app without an active internet connection, calling `checkForUpdates()` would normally fail. Instead, the package catches network exceptions and automatically falls back to the locally saved patch using `hive_quick`, ensuring seamless offline execution.
3. **Dynamic JSON Parsing**:
   - Over-The-Air architectures require flexibility. By parsing payloads into standard `Map<String, dynamic>`, your Flutter app can dynamically read flags, text strings, feature toggles, or configurations without requiring an app store update.

---

## Installation

Add `in_air_update` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  in_air_update: ^1.0.0 # Replace with your version
```

## Usage Guide

Initialize the Package
Initialize `InAirUpdate` early in your app's lifecycle (typically inside `main()`), providing your remote endpoint URL.

```dart
import 'package:flutter/material.dart';
import 'package:in_air_update/in_air_update.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize with your remote endpoint URL
  await InAirUpdate.initialize(
    endpointUrl: '[https://your-server-domain.com/patch.json](https://your-server-domain.com/patch.json)',
  );

  runApp(const MyApp());
}
```

## Check for Remote Updates & Fetch Patches

Invoke `checkForUpdates()` anywhere in your application (e.g., on app startup or via a manual refresh button) to pull the latest configurations:

```dart
Future<void> fetchLatestPatch() async {
  try {
    Map<String, dynamic>? patchData = await InAirUpdate.checkForUpdates();

    if (patchData != null) {
      print('Patch loaded successfully: $patchData');
    }
  } catch (e) {
    print('Error checking for updates: $e');
  }
}
```

## Retrieve Cached Patch (Offline Support)

If you need to access the last saved patch offline without making a network request, use `getCachedPatch()`:

```dart
Future<void> loadCachedConfig() async {
  Map<String, dynamic>? cachedData = await InAirUpdate.getCachedPatch();

  if (cachedData != null) {
    print('Loaded from local cache: $cachedData');
  }
}
```

## How to Test Locally with a Temporary Live URL

You can test your OTA updates locally on your machine before publishing by using a local Python server paired with an Ngrok tunnel.

## Step 1: Create a patch.json file

Inside your local directory, create a file named patch.json:

```json
{
  "version": "1.0.0",
  "message": "Hello from local OTA server!",
  "is_feature_enabled": true
}
```

## Step 2: Run a Local Server & Ngrok Tunnel

You can use a simple batch script or run these commands in your terminal:

```bash
python -m http.server 8000
ngrok http 8000
```

Copy the generated Ngrok forwarding URL (e.g., `https://xxxx-xxxx.ngrok-free.app`).

## Step 3: Verify in Flutter App

Point your initialization URL to your temporary ngrok link:

```dart
await InAirUpdate.initialize(
  endpointUrl: '[https://xxxx-xxxx.ngrok-free.app/patch.json](https://xxxx-xxxx.ngrok-free.app/patch.json)',
);
```

Modify any value in your local `patch.json`, save it, and call `InAirUpdate.checkForUpdates()` inside your app to see live changes instantly!

## License

This project is licensed under the MIT License - see the LICENSE file for details.
