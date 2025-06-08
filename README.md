# 📸 Labeling App

**Labeling App** is a multi-platform image labeling tool built with Flutter. It allows users to log in with Google, fill out their profile, and label images stored in Firebase Storage. Labeled data is saved to Firestore for further processing, making this app a useful tool for preparing datasets in machine learning and AI projects.

---

## 🚀 Features

- 🔐 Google Sign-In via Firebase Authentication  
- 👤 User profile form (name, age, experience, position) stored in Firestore  
- 🖼️ Load and label images from Firebase Storage  
- 🏷️ Save labels to Firestore with timestamps  
- ♻️ Relabel images after completion  
- 📱 Cross-platform support: Android, iOS, Web, macOS, Windows, Linux  
- 🎨 Simple and clean UI with gradient backgrounds

---

## 🛠️ Tech Stack

- **Flutter** (Dart)
- **Firebase** (Authentication, Firestore, Storage)
- **Google Sign-In**
- Multi-platform support (mobile, web, desktop)

---

## 📲 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Firebase CLI installed and configured
- Android Studio or Visual Studio Code

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/labeling-app.git
   cd labeling-app

2. Install Flutter dependencies:
   ```bash
   flutter pub get

3. Configure Firebase (if not already):
    ```bash
   flutterfire configure

4. Run the app:
    ```bash
   flutter run
---
## 🧪 Testing

This app includes a basic widget test located in test/widget_test.dart.

Run tests with:
  ```bash
 flutter run
  ```
    
---
## 📁 Project Structure

```bash
  lib/
    ├── firebase_options.dart      # Firebase configuration
    ├── home.dart                  # Google Sign-In screen
    ├── main.dart                  # App entry point
    ├── profile_page.dart          # User profile form
    ├── test_page.dart             # Image labeling interface
    assets/
    ├── google.png                 # Google sign-in icon
  ```

---
## 🤝 Contributing
Contributions are welcome! Feel free to open an issue or submit a pull request.

Steps to contribute:

1. Fork the repository

2. Create a new branch (git checkout -b feature/your-feature)

3. Commit your changes (git commit -am 'Add your feature')

4. Push to the branch (git push origin feature/your-feature)

5. Create a Pull Request

---
## 📝 License

This project is licensed under the MIT License.
See the [LICENSE](LICENSE) file for details.

---
## 🙌 Acknowledgements
This app was created to assist with image dataset preparation and simplify the labeling process.
Feedback and contributions are always appreciated!






