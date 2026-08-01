## 1.0.1

- Upgraded Dart SDK and Flutter constraints to meet modern runtime requirements (`sdk: ">=3.4.0 <4.0.0"`, `flutter: ">=3.22.0"`).
- Added full WebAssembly (WASM) compatibility support using `package:web`.
- Updated package metadata and configurations to achieve the full **160/160 pub points** benchmark on pub.dev.

## 1.0.0

- Initial official release of `in_air_update`.
- Introduced static API design for seamless initialization (`InAirUpdate.initialize`) without requiring class instantiation.
- Added remote OTA JSON patch fetching capabilities via `InAirUpdate.checkForUpdates()`.
- Added robust local caching and offline resilience powered by `hive_quick`.
- Added offline fallback support using `InAirUpdate.getCachedPatch()`.
- Added complete documentation and local testing workflow with Python HTTP server and ngrok support.
