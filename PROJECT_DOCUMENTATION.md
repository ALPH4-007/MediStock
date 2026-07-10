# MediStock - Pharmacy Inventory & Expiry Tracker

## 1. Project Overview
**MediStock** is a professional-grade pharmacy management application designed to help pharmacists track inventory, monitor medicine expiry dates, manage suppliers, and streamline order processing. The app follows a "Hybrid Storage" architecture, combining the power of the cloud with the speed and reliability of local offline storage.

## 2. Core Features
### 2.1. Authentication & User Management
*   **Firebase Auth Integration:** Secure login and registration using Email/Password.
*   **Cloud Profiles:** User data (Name, Role, Pharmacy Name) is synced to **Cloud Firestore**.
*   **Personalized Experience:** Dynamic greetings based on the time of day and the user's first name.
*   **Auth Guard:** Protected routes ensure that inventory data is only accessible to authenticated users.

### 2.2. Inventory Management
*   **Medicine Tracking:** Add, edit, and delete medicines with details like Batch Number, Manufacturer, Category, and Storage Location.
*   **Stock Monitoring:** Real-time calculation of total medicines, low-stock items, and out-of-stock items.
*   **Expiry Tracking:** Automatic calculation of days until expiry with visual indicators for items "Expiring Soon" (within 30 days).
*   **Barcode Scanning:** Built-in scanner to quickly identify products or add new stock.

### 2.3. Supplier & Order Management
*   **Supplier Directory:** Maintain a database of suppliers with contact persons, phone numbers, and addresses.
*   **Order System:** Create and manage orders with multiple line items.
*   **Transactional Integrity:** Orders use SQLite transactions to ensure that if an order fails to save, no partial data (like orphaned items) is left behind.

---

## 3. Technical Architecture
### 3.1. Tech Stack
*   **Frontend:** Flutter (Dart)
*   **State Management:** Provider (MultiProvider pattern)
*   **Cloud Backend:** Firebase (Authentication & Cloud Firestore)
*   **Local Database:** SQLite (via `sqflite` and `sqflite_common_ffi`)
*   **Navigation:** Named routes with a centralized `AppRoutes` configuration.

### 3.2. Data Storage Strategy (Hybrid)
| Data Type | Storage Engine | Reason |
| :--- | :--- | :--- |
| User Identity | Firebase Auth | Security & Session persistence |
| User Profiles | Cloud Firestore | Sync across multiple devices |
| Inventory Data | SQLite (Local) | Offline access & high-speed searching |
| Settings | SharedPreferences | Light-weight local preference storage |

---

## 4. Database Schema (SQLite)
The local database `medistock.db` currently operates on **Version 7** with the following tables:

### `medicines`
- `id`: INTEGER (PK)
- `name`: TEXT
- `barcode`: TEXT
- `category`: TEXT
- `quantity`: INTEGER
- `minimumStock`: INTEGER
- `expiryDate`: TEXT (ISO8601)
- `purchasePrice`: REAL
- `sellingPrice`: REAL
- `supplierId`: INTEGER
- `photoPath`: TEXT

### `suppliers`
- `id`: INTEGER (PK)
- `name`: TEXT
- `contactPerson`: TEXT
- `phone`: TEXT
- `email`: TEXT

### `orders` & `order_items`
- Linked via `orderId` with `ON DELETE CASCADE` enabled via PRAGMA foreign keys.

---

## 5. Setup & Installation
### Prerequisites
*   Flutter SDK (>= 3.3.0)
*   Firebase CLI installed and logged in (`firebase login`)
*   **Windows Desktop Support:** Requires "Desktop development with C++" workload from Visual Studio Installer.

### Configuration
1.  Run `flutter pub get` to install dependencies.
2.  Run `dart pub global run flutterfire_cli:flutterfire configure` to link your Firebase project.
3.  Ensure `minSdkVersion 23` in `android/app/build.gradle` for Firestore compatibility.

## 6. Project Structure
```text
lib/
├── app/              # Routes, Constants, Theme
├── database/         # DBHelper, Schema Init, Migrations
├── models/           # Data classes (Medicine, Supplier, Order)
├── providers/        # Business logic & State Management
├── services/         # API & Database interaction layers
├── screens/          # UI Screens (Inventory, Orders, Auth)
└── widgets/          # Reusable UI components (Cards, Dialogs)
```

---
**Developer Note:** This project is optimized for Android and Windows Desktop. Web support is limited due to local file-system requirements for SQLite.
