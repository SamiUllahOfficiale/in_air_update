import 'package:flutter/material.dart';
import 'package:hive_quick/hive_quick.dart';
import 'package:in_air_update/in_air_update.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveQuick.init();

  await InAirUpdate.initialize(
    endpointUrl: 'https://a3f2-109-83-64-169.ngrok-free.app/patch.json',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InAirUpdate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const UpdateScreen(),
    );
  }
}

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  Map<String, dynamic>? _patchData;
  bool _isLoading = false;
  String _statusMessage = 'Not checked yet';

  Future<void> _fetchUpdates() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Fetching updates...';
    });

    try {
      final data = await InAirUpdate.checkForUpdates();
      setState(() {
        _patchData = data;
        _isLoading = false;
        _statusMessage = data != null
            ? 'Update fetched successfully!'
            : 'No update found.';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error: $e';
      });
    }
  }

  Future<void> _loadCachedPatch() async {
    final cached = await InAirUpdate.getCachedPatch();
    setState(() {
      _patchData = cached;
      _statusMessage = cached != null
          ? 'Loaded from local cache!'
          : 'No cache found.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final welcomeText = _patchData?['welcome_message'] ?? 'Welcome to OTA App';
    final buttonText = _patchData?['button_text'] ?? 'Check For Remote Updates';
    final bannerImage = _patchData?['banner_image'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('InAirUpdate Enterprise Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _statusMessage,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (bannerImage != null &&
                        bannerImage.toString().isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          bannerImage,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      welcomeText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchUpdates,
              icon: const Icon(Icons.cloud_download),
              label: Text(buttonText),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _loadCachedPatch,
              icon: const Icon(Icons.storage),
              label: const Text('Load Cached Patch (Offline)'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Raw JSON Payload:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _patchData != null
                        ? _patchData.toString()
                        : 'No patch loaded yet.',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
