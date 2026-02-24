# Konektz

A Flutter chat application built with **Clean Architecture** and **BLoC** state management.

---

## Table of Contents

- [Konektz](#konektz)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Tech Stack](#tech-stack)
  - [Architecture](#architecture)
    - [Dependency Rule](#dependency-rule)
  - [Project Structure](#project-structure)
  - [Features](#features)
    - [Authentication](#authentication)
    - [Chat (in progress)](#chat-in-progress)
  - [Domain Validation](#domain-validation)
    - [Rules](#rules)
    - [ValidationException](#validationexception)
  - [API Contract](#api-contract)
    - [POST `/register`](#post-register)
    - [POST `/login`](#post-login)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Install dependencies](#install-dependencies)
  - [Running the App](#running-the-app)
    - [Android emulator](#android-emulator)
    - [Physical Android device](#physical-android-device)
    - [Run](#run)
  - [State Management](#state-management)
    - [Snack Bar Colors](#snack-bar-colors)
    - [Events (`sealed class AuthEvent`)](#events-sealed-class-authevent)
    - [States (`sealed class AuthState`)](#states-sealed-class-authstate)
    - [Secure Storage Keys](#secure-storage-keys)
  - [Environment / Network Notes](#environment--network-notes)

---

## Overview

Konektz is a mobile chat application where users can register, log in, and exchange messages. The project follows Clean Architecture principles with a clear separation between **data**, **domain**, and **presentation** layers.

---

## Tech Stack

| Package                    | Version  | Purpose                            |
| -------------------------- | -------- | ---------------------------------- |
| `flutter_bloc`             | ^9.1.1   | State management (BLoC pattern)    |
| `http`                     | ^1.6.0   | REST API calls                     |
| `flutter_secure_storage`   | ^10.0.0  | Secure JWT token & user ID storage |
| `google_fonts`             | ^8.0.2   | Custom typography                  |

**Dart SDK:** `^3.11.0`  
**Flutter:** Latest stable

---

## Architecture

The project follows **Clean Architecture**, dividing each feature into three layers:

```sh
Presentation  →  Domain  ←  Data
   (BLoC)       (entities,    (models,
   (pages)       use cases,    datasources,
   (widgets)     repository    repository
                 contract)     implementation)
```

### Dependency Rule

- `domain` has **zero** Flutter/external dependencies — pure Dart.
- `data` depends on `domain` (implements its contracts).
- `presentation` depends on `domain` (calls use cases via BLoC).

---

## Project Structure

```sh
lib/
├── main.dart                        # App entry point, DI wiring
├── chat_page.dart                   # Chat UI (message list)
├── message_page.dart                # Individual message thread
├── core/
│   └── theme.dart                   # AppTheme, DefaultColors, FontSizes
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── auth_remote_datasource.dart   # abstract + AuthRemoteDatasourceImpl
    │   │   ├── models/
    │   │   │   └── user_model.dart               # UserModel (extends UserEntity)
    │   │   └── repositories/
    │   │       └── auth_repository_implementation.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user_entity.dart              # Pure Dart user model
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart          # Abstract contract
    │   │   ├── usecases/
    │   │   │   ├── login_use_case.dart           # Validates then calls repository
    │   │   │   └── register_use_case.dart        # Validates then calls repository
    │   │   └── validators/
    │   │       └── auth_validator.dart           # Pure Dart rules + ValidationException
    │   └── presentaion/
    │       ├── bloc/
    │       │   ├── auth_bloc.dart
    │       │   ├── auth_event.dart               # sealed class
    │       │   └── auth_state.dart               # sealed class
    │       ├── pages/
    │       │   ├── login_page.dart
    │       │   └── register_page.dart
    │       └── widgets/
    │           ├── auth_button.dart
    │           ├── auth_input_field.dart
    │           ├── register_login_prompt.dart
    │           └── snack_bar.dart                # Custom styled snackbar helper
    └── chat/                        # (in progress)
```

---

## Features

### Authentication

- **Register** — username, email, password → validated in domain layer → creates account via REST API
- **Login** — email, password → validated in domain layer → returns JWT token stored securely
- **Logout** — clears all secure storage entries
- Domain-layer validation fires before any network call (see [Domain Validation](#domain-validation))
- Custom styled SnackBar for success (green) and error (red) feedback
- Loading indicator while requests are in flight
- Automatic navigation to chat on successful login

### Chat (in progress)

- Message list view (`ChatPage`)
- Individual message thread (`MessagePage`)

---

## Domain Validation

All input is validated in `domain/validators/auth_validator.dart` — pure Dart, zero Flutter or HTTP imports. Validation runs **inside the use case**, before the repository is ever called, so no network request is wasted on bad input.

### Rules

| Field      | Rules                                                                |
| ---------- | -------------------------------------------------------------------  |
| `email`    | Required, must match RFC-5322 pattern                                |
| `password` | Required, min 8 chars, at least 1 uppercase letter, at least 1 number|
| `username` | Required, 3-30 chars, letters/numbers/underscores only               |

All fields are evaluated before throwing, so a single `ValidationException` carries every error at once.

### ValidationException

```dart
class ValidationException implements Exception {
  final List<String> errors; // all collected errors
  String get first => errors.first; // shown in SnackBar
}
```

The BLoC catches `ValidationException` separately from generic exceptions:

```dart
catch (e) {
  emit(AuthErrorState(
    error: e is ValidationException
        ? e.first          // clean single-line message
        : e.toString()...  // network / server errors
  ));
}
```

---

## API Contract

Base URL: `http://<host>:5000/auth`

### POST `/register`

**Request body:**

```json
{
  "email": "john@example.com",
  "username": "johndoe",
  "password": "secret"
}
```

**Success response** (`200` or `201`):

```json
{
  "status": "success",
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "f20fd3a4-810c-4ebe-b89b-4991502c5ca9",
      "username": "johndoe",
      "email": "john@example.com",
      "created_at": "2026-02-23T15:34:03.576Z",
      "updated_at": "2026-02-23T15:34:03.576Z"
    }
  }
}
```

### POST `/login`

**Request body:**

```json
{
  "email": "john@example.com",
  "password": "secret"
}
```

**Success response** (`200`):

```json
{
  "status": "success",
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com"
  }
}
```

> The parser handles both `{ "user": {...} }` and `{ "data": { "user": {...} } }` response shapes gracefully.

**Error responses** (any non-success status):

```json
{ "message": "Human-readable error string" }
```

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.11.0`
- A running backend at `http://<host>:5000`

### Install dependencies

```bash
flutter pub get
```

---

## Running the App

### Android emulator

The emulator cannot reach `localhost` on your machine. Use the special AVD alias instead:

```dart
// in auth_remote_datasource.dart
this.baseUrl = 'http://10.0.2.2:5000/auth',
```

### Physical Android device

Use your PC's local network IP:

```dart
this.baseUrl = 'http://192.168.1.X:5000/auth',
```

### Run

```bash
flutter run
```

> **Note:** After any change to `AndroidManifest.xml`, perform a full stop and re-run — hot restart is not sufficient.

---

## State Management

BLoC is used for the `auth` feature. All classes use Dart 3 `sealed` types for exhaustive pattern matching.

Errors from `ValidationException` (domain layer) are surfaced via `e.first` — a clean single-line string. Errors from the network/server come via `Exception.toString()` with the `Exception:` prefix stripped. Both are displayed using the custom `showSnackBar` helper.

### Snack Bar Colors

| Situation          | Color                   |
| ------------------ | ----------------------- |
| Validation error   | `Colors.red.shade700`   |
| Network/API error  | `Colors.red.shade700`   |
| Register success   | `Colors.green.shade700` |

### Events (`sealed class AuthEvent`)

| Event            | Fields                           | Trigger             |
| ---------------- | -------------------------------- | ------------------- |
| `RegisterEvent`  | `username`, `email`, `password`  | Register button tap |
| `LoginEvent`     | `email`, `password`              | Login button tap    |
| `LogoutEvent`    | —                                | Logout action       |

### States (`sealed class AuthState`)

| State                      | Fields             | Meaning             |
| -------------------------- | ------------------ | ------------------- |
| `AuthInitialState`         | —                  | App just started    |
| `AuthLoadingState`         | —                  | Request in flight   |
| `AuthAuthenticatedState`   | `user: UserEntity` | Login successful    |
| `AuthSuccessState`         | `message: String`  | Register successful |
| `AuthErrorState`           | `error: String`    | Any failure         |
| `AuthLoggedOutState`       | —                  | Logout completed    |

### Secure Storage Keys

| Key          | Value                                 |
| ------------ | ------------------------------------- |
| `authToken`  | JWT bearer token (set on login)       |
| `userId`     | Authenticated user ID (set on login)  |

---

## Environment / Network Notes

The following permissions and flags are set in `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<application android:usesCleartextTraffic="true" ...>
```

`usesCleartextTraffic="true"` is required for plain `http://` requests during development. **Remove or restrict this flag before releasing to production** — use HTTPS in production.
