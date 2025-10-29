
# Gemini Code Assistant Context

This document provides context for the Gemini code assistant to understand the project structure, conventions, and tasks.

## Project Overview

This is a Flutter-based mobile application for a pharmacy. The app allows users to browse products, manage their cart, and place orders. It is built with a focus on a clean, scalable, and maintainable architecture.

### Core Technologies

*   **Framework:** Flutter
*   **State Management:** Riverpod
*   **Database:** Drift (with SQLite)
*   **Routing:** GoRouter
*   **Dependency Injection:** GetIt & Injectable
*   **Code Generation:** Freezed, JSON Serializable, Riverpod Generator

### Architecture

The project follows a clean architecture pattern, separating the codebase into three main layers:

*   **Data:** Handles data sources, repositories, and models.
    *   `data/local`: Contains Drift database definitions, DAOs, and table structures.
    *   `data/models`: Defines the application's data models.
    *   `data/repositories`: Implements the repository pattern to abstract data sources.
*   **Domain:** Contains business logic, entities, and repository interfaces.
    *   `domain/entities`: Defines the core business objects.
    *   `domain/repositories`: Declares the repository interfaces that the data layer implements.
*   **Presentation:** Contains the UI and state management logic.
    *   `presentation/screens`: Defines the application's screens.
    *   `presentation/widgets`: Contains reusable UI components.
    *   `presentation/providers`: Manages the application's state using Riverpod.

## Building and Running

### Prerequisites

*   Flutter SDK
*   Dart SDK

### Key Commands

*   **Get dependencies:**
    ```bash
    flutter pub get
    ```
*   **Run code generation:**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
*   **Run the app:**
    ```bash
    flutter run
    ```

## Development Conventions

*   **State Management:** Use Riverpod for all state management. Prefer `NotifierProvider` for complex state and `Provider` for simple state.
*   **Database:** Use Drift for all local database operations. All database logic should be implemented in the `data/local` directory.
*   **Routing:** Use GoRouter for all navigation. All routes should be defined in a centralized location.
*   **Dependency Injection:** Use GetIt and Injectable for all dependency injection.
*   **Code Style:** Adhere to the linting rules defined in `analysis_options.yaml`.
*   **Testing:** (TODO) Define testing strategy and conventions.
