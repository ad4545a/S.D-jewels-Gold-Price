# S.D. JEWELS - Live Gold Rate App

A premium Flutter application for **S.D. JEWELS**, Agra's trusted bullion dealer. This app provides real-time live rates for Gold and Silver, along with USD/INR currency trends.

## 📱 Features

*   **Live Market Rates**: Real-time fetching of MCX Gold & Silver prices.
*   **Derived Rates**: Automatically calculates 999, 99.50, and other purity rates based on market logic.
*   **USD/INR Tracker**: Live tracking of the Rupee vs Dollar exchange rate.
*   **Premium UI**: Luxurious Gold/Amber theme with animated Splash Screen.
*   **High/Low Indicators**: Visual display of daily High and Low prices.
*   **Information Screens**:
    *   **Bank Details**: One-tap access to bank account info and QR code.
    *   **Contact Us**: Click-to-call support and social media links.
    *   **About Us**: Company profile and legacy.
*   **Side Menu**: Easy navigation between sections.

## 🛠️ Tech Stack

*   **Framework**: Flutter (Dart)
*   **Backend**: Firebase Realtime Database (for instant updates)
*   **Design**: Material 3 with Custom Theming

## 🚀 Getting Started

1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/ad4545a/S.D-jewels-Gold-Price.git
    cd S.D-jewels-Gold-Price
    ```

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the App**:
    ```bash
    flutter run
    ```

## 📦 Build for Release

To generate the APK for Android:

```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`
