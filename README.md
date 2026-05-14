# OCR Scanner App - Technical Assignment

A specialized Flutter mobile application designed to scan and extract structured data from physical credit/debit cards and bank passbooks. This project focuses on **manual parsing algorithms** and **Luhn validation**.

---

## 🚀 Steps to Run the Project

Based on the current project configuration, follow these steps to run the application:

### 1. Prerequisites
- **Flutter Version:** `3.41.7` (Recommended)
- **FVM (Optional):** If you are using FVM, prefix the commands with `fvm`.

### 2. Environment Setup
Install the specific Flutter version if using FVM:
```bash
fvm install 3.41.7
fvm use 3.41.7
```

### 3. Install Dependencies
Run the following command to fetch all required libraries:
```bash
flutter pub get
```

### 4. Android Configuration
This project uses **Google ML Kit**, which requires a minimum Android SDK version of **21**.
Ensure your `android/app/build.gradle` reflects this:
```gradle
defaultConfig {
    minSdk = 21
    targetSdk = 33 // or latest
}
```

### 5. Run the Application
Connect a **physical device** (required for camera and OCR functionality). Simulators are not recommended for real-time scanning.
```bash
flutter run
```

---

## 📚 Libraries Used

| Library | Version | Purpose |
| :--- | :--- | :--- |
| `google_mlkit_text_recognition` | `^0.11.0` | Raw text extraction (OCR). |
| `camera` | `^0.10.5` | Real-time camera feed and capture. |
| `image_picker` | `^1.0.4` | Gallery upload for documents. |
| `path_provider` | `^2.1.1` | Local file management. |
| `flutter_test` | SDK | Unit testing for algorithms. |

---

## 🧠 Assumptions Made

1.  **Card Standard:** Standard ISO/IEC 7810 ID-1 card layouts.
2.  **Date Formats:** Expiry dates follow `MM/YY`, `MM-YY`, or `MMYY`.
3.  **IFSC Format:** 11-character Indian banking format (`AAAA0BBBBBB`).
4.  **Name Placement:** Cardholder names are in **ALL CAPS**.

---

## 🛠 Edge Cases Handled

- **Blurry/Partial Scans:** RegEx-based filtering to extract segments from noisy text.
- **OCR Misreads:** Manual character correction (`O` → `0`, `I` → `1`) in `CardParser`.
- **Multiple Numbers:** Luhn validation used to distinguish card numbers from other numeric sequences.
- **Missing Fields:** Graceful UI handling with "Not Found" status.

---

## 🚧 What Was Skipped and Why

1.  **Duplicate Scan Prevention:** Skipped to allow users to retry scans immediately.
2.  **Real-time Bounding Boxes:** Prioritized **Parsing Logic (40%)** as per evaluation criteria.

---

## 🧪 Testing

Run unit tests to verify the core algorithms:
```bash
flutter test
```
