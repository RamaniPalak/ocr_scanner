# OCR Scanner App - Flutter

A mobile application built with Flutter that scans and extracts structured data from physical cards (credit/debit) and bank passbooks using Google ML Kit and manual parsing logic.

## 🚀 Steps to Run the Project

1.  **Generate Platform Folders:**
    Since this repository contains the core logic and UI, you need to generate the platform folders (Android/iOS) if they are missing:
    ```bash
    flutter create .
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the app:**
    *   Connect a physical device (Camera is required for real-time scanning).
    *   Run: `flutter run`

## 🤖 Android Configuration

Ensure the following in `android/app/build.gradle`:
- `minSdkVersion` 21
- `targetSdkVersion` 33

## 📚 Libraries Used

- **`google_mlkit_text_recognition`**: Used for raw text extraction (OCR).
- **`camera`**: For real-time camera feed and capturing images.
- **`image_picker`**: For picking passbook images from the gallery.
- **`path_provider`**: For managing temporary image files.

## 🧠 Assumptions Made

1.  **Card Layout:** Standard ISO/IEC 7810 ID-1 card layouts.
2.  **Language:** English and numeric standard.
3.  **IFSC Pattern:** 11 characters (4 letters, '0', 6 alphanumeric).

## 🛠 What Was Skipped and Why

1.  **Complex Card Brands Detection:** Simplified to 13-19 digits to focus on manual Luhn validation.
2.  **Real-time Bounding Boxes:** Focused on parsing accuracy and structured data display.

## 🧪 Testing

Run tests using:
```bash
flutter test
```
