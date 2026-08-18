.PHONY: run run-local run-android-local linux-deps

linux-deps:
	sudo apt-get install -y libsecret-1-dev

run:
	flutter run

run-local:
	flutter run -d linux --dart-define-from-file=dart_defines/local.json

run-android-local:
	flutter run --dart-define-from-file=dart_defines/android_emulator.json
