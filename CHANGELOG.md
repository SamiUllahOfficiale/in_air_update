## 1.0.0

- Initial official release of `in_air_update`.
- Introduced static API design for seamless initialization (`InAirUpdate.initialize`) without requiring class instantiation.
- Added remote OTA JSON patch fetching capabilities via `InAirUpdate.checkForUpdates()`.
- Added robust local caching and offline resilience powered by `hive_quick`.
- Added offline fallback support using `InAirUpdate.getCachedPatch()`.
- Added complete documentation and local testing workflow with Python HTTP server and ngrok support.
