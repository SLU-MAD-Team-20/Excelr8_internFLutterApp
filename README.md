# Excelerate LMS — Flutter App

A mobile Learning Management System built with Flutter and Firebase, developed by **SLU MAD Team 20** as part of the **Excelerate Mobile App Development with FLutter Internship **.

---

## Features

### Users
- Sign up, sign in, and password reset via Firebase Authentication
- Personalized dashboard with real-time data
- Browse, search, and sort programs
- Enroll and unenroll from programs
- View program details — description, duration, start date, progress
- Submit feedback
- Edit profile display name
- View enrolled programs on profile
- Dark/light mode toggle

### Admin
- Separate admin dashboard with program stats, user count, and feedback overview
- Create, manage, and delete programs
- Post, edit, and delete announcements
- Manage active internship details

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI Framework | Flutter 3.32.0 |
| Language | Dart 3.8.0+ |
| Authentication | Firebase Auth |
| Database | Cloud Firestore |
| State Management | ValueNotifier |

---

## Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.32.0+
- Android Studio with Android SDK
- Android SDK Command-line Tools (SDK Manager → SDK Tools)
- Connected Android device or emulator

Verify setup:
```bash
flutter doctor
```

---

## Getting Started

### 1. Clone the repo
```bash
git clone https://github.com/SLU-MAD-Team-20/Excelr8_internFLutterApp.git
cd Excelr8_internFLutterApp
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Connect a device

**Physical device:**
- Settings → About Phone → tap Build Number 7 times
- Enable USB Debugging
- Connect via USB and accept the prompt on your phone


### 4. Run the app
```bash
flutter run
```

---

## Project Structure

```
lib/
├── constants/        # App-wide colors, styles, and constants
├── models/           # Data models
├── providers/        # State management
├── screens/          # All app screens
├── services/         # Firebase and API services
├── theme/            # Theme definitions
├── utils/            # Validators and helpers
├── widgets/          # Reusable UI components
└── main.dart
```

---

## Common Commands

```bash
flutter pub get          # Install dependencies
flutter run              # Run in debug mode (hot reload enabled)
flutter run --release    # Run in release mode
flutter build apk        # Build release APK
flutter clean            # Clear build cache
flutter doctor           # Check setup health
flutter devices          # List connected devices
```

**While the app is running:**

| Key | Action |
|---|---|
| `r` | Hot reload (keeps state) |
| `R` | Hot restart (resets state) |
| `q` | Quit |

---

## Troubleshooting

| Error | Fix |
|---|---|
| `Gradle build failed` | Run `cd android && ./gradlew clean` then retry |
| `CMake is required` error | No device connected — start emulator or plug in phone first |
| `flutter pub get` version conflict | Run `flutter upgrade` then retry |
| Blank dashboard data | Check internet connection — app needs network on first load |

---

## Team

**SLU MAD Team 20** — Excelerate Mobile App Development Internship
