[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/19BwrNgF)

# SkillSwap - Campus Skill Exchange Platform

## Introduction

SkillSwap is a mobile application designed to connect university students who want to exchange skills and services. Whether you need help with programming, want to learn a new language, or are looking for a study partner, SkillSwap makes it easy to find others on campus who can help—and who might need your skills in return.

The app allows users to:
- **Post requests** for skills they need (e.g., "Need help with calculus tutoring")
- **Offer skills** they can provide to others (e.g., "Can teach guitar lessons")
- **Claim tasks** to help others and build their reputation
- **Rate and review** other users after skill exchanges
- **Message** other users to coordinate meetups
- **Build a profile** showcasing their skills and ratings

## Technical Architecture

### Overview
SkillSwap is built using **Flutter** for cross-platform mobile development (iOS & Android) with **Firebase** as the backend-as-a-service for authentication, database, and real-time features.

### Architecture Pattern
The app follows **Clean Architecture** principles with the **BLoC (Business Logic Component)** pattern for state management:

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── components/               # Shared UI components
├── navigation/               # App navigation setup
└── features/                 # Feature modules
    ├── auth/                 # Authentication (login, signup)
    ├── posts/                # Post creation and listing
    ├── claims/               # Task claiming system
    ├── profile/              # User profiles
    ├── ratings/              # User rating system
    ├── messages/             # In-app messaging
    ├── notifications/        # Claim notifications
    └── home/                 # Home screen
```

### Each Feature Module Structure
```
feature/
├── domain/
│   ├── entities/            # Business objects
│   └── repositories/        # Abstract repository interfaces
├── data/
│   ├── models/              # Firebase/JSON models
│   ├── datasources/         # Remote data sources
│   └── repositories/        # Repository implementations
└── presentation/
    ├── bloc/                # BLoC (events, states, bloc)
    ├── pages/               # Screen widgets
    └── widgets/             # Feature-specific widgets
```

### Tech Stack
| Layer | Technology |
|-------|------------|
| Frontend | Flutter 3.35+ / Dart |
| State Management | flutter_bloc |
| Backend | Firebase (Firestore, Auth) |
| Authentication | Firebase Auth + Google Sign-In |
| Database | Cloud Firestore |
| Testing | flutter_test, bloc_test, mocktail |

### Firebase Collections
- `users` - User profiles and ratings
- `posts` - Skill requests and offers
- `claims` - Task claims by users
- `conversations` - Chat messages
- `ratings` - User ratings

## Installation Instructions

### Prerequisites
- **Flutter SDK** (3.35.0 or later): [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Xcode** (for iOS development on macOS)
- **Android Studio** or **VS Code** with Flutter extension
- **Firebase CLI** (optional, for Firebase configuration)

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/CS222-UIUC/fa25-fa25-team004.git
   cd fa25-fa25-team004
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # List available devices
   flutter devices
   
   # Run on a specific device
   flutter run
   
   # Or run on iOS Simulator
   flutter run -d ios
   
   # Or run on Android Emulator
   flutter run -d android
   ```

4. **Run tests**
   ```bash
   flutter test
   ```

5. **Run with coverage**
   ```bash
   flutter test --coverage
   ```

### Troubleshooting
- If you encounter iOS build issues, run:
  ```bash
  cd ios && pod install && cd ..
  ```
- Ensure you have the correct iOS simulator runtime installed in Xcode > Settings > Components

## Group Members and Roles

| Name | Role | Responsibilities |
|------|------|------------------|
| **Ryan** |Firebase integration, Unit Testing, Code Formatting, Code Review, Rating System|
| **Tuan** | Profile system, Ratings feature, UI components, Code Review, Messaging System|
| **Bill** | QA & Testing, Unit tests, Integration tests, Code review, Profile Interaction |
| **Gus** | Rating System, Claims system, Auth System, Code Review|

---

*CS 222 - Fall 2025 - University of Illinois at Urbana-Champaign*
