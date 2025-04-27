# MazadyApp - Profile Module

This repository contains the implementation of the Profile screen and related modules for MazadyApp, built using **MVVM architecture**, **RxSwift**, and **Kingfisher**.

---

## 📐 Architecture Decisions

- **MVVM (Model-View-ViewModel)**:  
  Clear separation between UI (`ViewController`), logic (`ViewModel`), and data (`UseCase/Repository`).
  
- **Reactive Programming (RxSwift / RxCocoa)**:  
  All UI and data flows are reactive, providing a smooth and maintainable structure with minimal boilerplate code.

- **Networking and Data Handling**:  
  - Network calls are handled using a clean UseCase layer.
  - Errors are mapped and localized using a custom `NetworkError` mapper.
  - Reachability is monitored with `ReachabilityManager` to handle offline cases gracefully.

- **Image Loading (Kingfisher)**:  
  Used for efficient image loading and caching, especially for Profile images and Product grids.

- **Localization**:  
  The app supports both English and Arabic languages dynamically through `LanguageManager`.

- **Loading and Error Handling**:  
  - Centralized loading indicator management through `BaseViewModel` and `BaseViewController`.
  - Global error handling using `SwiftMessagesService` to display user-friendly error messages.

---

## 🚀 How to Run the Project

1. Clone the repository:
    ```bash
    git clone https://github.com/WafaaFarrag/MazadyApp.git
    ```

2. Open the project in **Xcode** (Version 14 or later recommended).

3. Install dependencies (if you use CocoaPods):
    ```bash
    pod install
    open MazadyApp.xcworkspace
    ```

4. If you are using **Swift Package Manager**:  
   Open `MazadyApp.xcodeproj`, packages will resolve automatically.

5. Select a Simulator (e.g., iPhone 15) and **Run** (`⌘ + R`).

6. Make sure you have an active Internet connection for API calls and image loading.

---

## ⚖️ Trade-offs and Assumptions Made

- **Assumptions**:
  - The backend API is available and properly returning the expected data models for User Profile, Products, Ads, and Tags.

- **Trade-offs**:
  - Kingfisher is used for simplicity and performance in image caching, instead of building a custom image downloader.
  - Errors are centralized and generic for simplicity. Detailed custom error handling per screen can be added later.
  - Profile images are cached locally; however, cache clearing upon logout is not yet implemented.

- **UI Decisions**:
  - Profile and Products modules are designed to be modular and expandable.
  - Static spacing, paddings, and font sizes are optimized for general use but may require fine-tuning per device.

---

## 📸 Screenshots

| Profile Screen | Products Grid |
|:--------------:|:--------------:|
| _Coming Soon_ | _Coming Soon_ |

(*You can add screenshots later here if you want!*)

---

## 🛠 Tech Stack

- Swift 5
- UIKit
- RxSwift & RxCocoa
- Kingfisher
- ReachabilitySwift
- SwiftMessages
- MVVM Architecture
- Clean architecture principles

---

## 📬 Contact

For any questions or feedback, please reach out:

**Wafaa Farrag**  
📧 [w.farrag13@gmail.com](mailto:w.farrag13@gmail.com)

---
