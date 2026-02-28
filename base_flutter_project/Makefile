clean:
	fvm flutter clean

pub-get:
	fvm flutter pub get

pub-upgrade:
	fvm flutter pub upgrade

pub-upgrade-major:
	fvm flutter pub upgrade --major-versions

build-runner:
	fvm flutter pub run build_runner build

watch-runner:
	fvm flutter pub run build_runner watch

build-runner-delete:
	fvm flutter pub run build_runner build --delete-conflicting-outputs

watch-runner-delete:
	fvm flutter pub run build_runner watch --delete-conflicting-outputs

gen-l10n:
	fvm flutter gen-l10n

gen-flavor:
	fvm flutter pub run flutter_flavorizr

gen-assets:
	fluttergen -c pubspec.yaml
reset:
	fvm flutter clean
	fvm flutter pub get
	fvm flutter gen-l10n
	fvm flutter pub run build_runner build --delete-conflicting-outputs


build_apk_dev_normal:
ifeq ($(OS),Windows_NT)
	@echo "🪟 Running on Windows (PowerShell)"
	@powershell -ExecutionPolicy Bypass -File ./scripts/build_android.ps1 -FLAVOR "dev" -ENTRYPOINT "lib/main.dart" -FULL_ADS "false"
else
	@echo "🐧 Running on Unix (macOS/Linux)"
	@chmod +x ./scripts/build_android.sh
	@./scripts/build_android.sh "dev" "lib/main.dart" "false"
endif

build_apk_dev_full_ads:
ifeq ($(OS),Windows_NT)
	@echo "🪟 Running on Windows (PowerShell)"
	@powershell -ExecutionPolicy Bypass -File ./scripts/build_android.ps1 -FLAVOR "dev" -ENTRYPOINT "lib/main.dart" -FULL_ADS "true"
else
	@echo "🐧 Running on Unix (macOS/Linux)"
	@chmod +x ./scripts/build_android.sh
	@./scripts/build_android.sh "dev" "lib/main.dart" "true"
endif

build_apk_prod_normal:
ifeq ($(OS),Windows_NT)
	@echo "🪟 Running on Windows (PowerShell)"
	@powershell -ExecutionPolicy Bypass -File ./scripts/build_android.ps1 -FLAVOR "prod" -ENTRYPOINT "lib/main.dart" -FULL_ADS "false"
else
	@echo "🐧 Running on Unix (macOS/Linux)"
	@chmod +x ./scripts/build_android.sh
	@./scripts/build_android.sh "prod" "lib/main.dart" "false"
endif

build_apk_prod_full_ads:
ifeq ($(OS),Windows_NT)
	@echo "🪟 Running on Windows (PowerShell)"
	@powershell -ExecutionPolicy Bypass -File ./scripts/build_android.ps1 -FLAVOR "prod" -ENTRYPOINT "lib/main.dart" -FULL_ADS "true"
else
	@echo "🐧 Running on Unix (macOS/Linux)"
	@chmod +x ./scripts/build_android.sh
	@./scripts/build_android.sh "prod" "lib/main.dart" "true"
endif

build_aab:
ifeq ($(OS),Windows_NT)
	@echo "🪟 Building AAB on Windows"
	@powershell -ExecutionPolicy Bypass -File ./scripts/build_aab.ps1
else
	@echo "🐧 Building AAB on Unix/macOS"
	@chmod +x ./scripts/build_aab.sh
	@./scripts/build_aab.sh
endif
