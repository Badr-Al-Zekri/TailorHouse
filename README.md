# TailorHouse

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-4C8BF5)

TailorHouse is a Flutter application for managing tailoring workflows: customer lookup, order creation and tracking, measurement capture, and production-stage updates.  
This repository currently reflects a local-first implementation with production-style structure and UI flows.

## Implemented Features

- Multi-screen app flow with splash, onboarding, authentication UI, and tab-based navigation.
- Order management flow:
  - Create orders with customer details, garment type, pricing, and expected delivery date.
  - List/search orders by workflow status.
  - View order details, pricing, timeline, and measurements.
- Customer flow:
  - Search customers from local data.
  - Customer order-status lookup using garment ID + phone.
- Measurement flow:
  - Manual measurement entry with garment-specific required fields.
  - Camera capture flow for AI measurement screens (photo capture UX is present).
- Worker workflow queue:
  - Stage-specific queue loading and status transitions.
- Local persistence with Hive and repository/data-source abstraction.

## Tech Stack and Dependencies

### Core stack
- Flutter + Dart
- BLoC (`flutter_bloc`, `equatable`)
- Navigation: `go_router`
- Dependency injection: `get_it`
- Local storage: `hive`, `hive_flutter`
- Networking: `dio`

### Other verified packages in use
- UI/animation: `google_fonts`, `flutter_svg`, `shimmer`, `flutter_animate`, `smooth_page_indicator`
- Device/features: `camera`, `image_picker`, `connectivity_plus`, `permission_handler`
- Utilities: `intl`, `uuid`, `crypto`, `path_provider`, `shared_preferences`, `flutter_secure_storage`

> Full dependency list: `/home/runner/work/TailorHouse/TailorHouse/pubspec.yaml`

## Project Structure

```text
lib/
  main.dart
  src/
    application/      # Use cases
    domain/           # Entities, enums, value objects, repository contracts
    infrastructure/   # Local/remote data sources, repository implementations, services
    core/             # Router, theme, DI, shared utilities/widgets
    features/         # UI + feature-level logic (auth, orders, measurement, workflow, ...)
assets/
  images/ icons/ animations/ fonts/
Images/              # Repository image files (portfolio/media assets)
android/ ios/ web/ linux/ macos/ windows/
```

## Prerequisites

- Flutter SDK compatible with Dart `^3.7.2` (see `environment` in `pubspec.yaml`)
- A configured Flutter toolchain (`flutter doctor`)
- Android Studio / Xcode (for mobile targets), or desktop/web toolchains as needed

## Setup and Run

From repository root:

```bash
flutter pub get
flutter run
```

Useful commands:

```bash
flutter test
flutter analyze
```

## Configuration and External Services

- No `.env`-based runtime configuration is currently wired.
- A placeholder API base URL is hardcoded in DI setup (`lib/src/core/di/injection.dart`).
- Remote data sources exist, but several JSON mapping methods are intentionally unimplemented and will throw until completed.

## Current Limitations

- Authentication screens are mostly UI/demo flow; real backend auth is marked TODO.
- AI measurement processing service is not integrated yet (capture flow exists, final measurement extraction is placeholder).
- Several screens still use temporary hardcoded user/shop values.
- Android/iOS camera permission setup is not fully configured in platform manifests/plists.
- Some profile/shop/cart actions are present as UI stubs without complete backend behavior.
