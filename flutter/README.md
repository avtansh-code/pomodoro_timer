# Pomodoro Timer - Flutter Application

This is a Pomodoro timer application built with Flutter, designed to be a cross-platform implementation based on the existing native iOS and Android projects.

## Project Overview

This application helps users manage their work and break intervals using the Pomodoro Technique. It provides a configurable timer, session tracking, and statistics.

- **State Management:** BLoC
- **Persistence:** Hive and `shared_preferences`
- **Navigation:** `go_router`

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

You need to have the Flutter SDK installed on your machine. For more information on how to install Flutter, see the [official Flutter documentation](https://flutter.dev/docs/get-started/install).

### Setup and Installation

1.  **Navigate to the project directory:**
    ```shell
    cd flutter
    ```

2.  **Install dependencies:**
    Run the following command to fetch all the required dependencies listed in the `pubspec.yaml` file.
    ```shell
    flutter pub get
    ```

3.  **Run Code Generator:**
    The project uses the Hive database, which requires auto-generated type adapter files. Run the following command to generate them. If you make changes to any models that have Hive annotations, you will need to run this command again.
    ```shell
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the application:**
    Connect a device or start an emulator, and then run the following command to build and launch the application.
    ```shell
    flutter run
    ```

---
This `README.md` provides the standard setup instructions. Please note that due to the current execution environment's restrictions, I am personally unable to run commands like `flutter pub get` or `build_runner`, and I am proceeding by writing the code as if they have been run.
