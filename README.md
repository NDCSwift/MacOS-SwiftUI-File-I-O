# 📂 macOS SwiftUI File I/O — Open, Save & Document Management

A macOS SwiftUI app demonstrating native file I/O patterns — open/save panel integration and reading/writing files the way macOS users expect.

---

## 🤔 What this is

MacOS-SwiftUI-File-I-O explores how to work with the file system from a SwiftUI macOS app, going beyond basic documents directory writes to include native open and save panel integration. It shows the idiomatic macOS approach to file handling — letting users pick where their files live, not just writing silently to the sandbox.

## ✅ Why you'd use it

- **Native open/save panels** — present `NSOpenPanel` / `NSSavePanel` from SwiftUI
- **File read/write** — read file contents into the app and write changes back to disk
- **`Note` Codable model** — consistent data structure used throughout the file pipeline
- **Proper macOS UX** — users control where files are saved, not just the app sandbox
- **Pairs with `MacOS-JSON-File-I-O`** — progression from silent persistence to full document-style file management

## 📺 Watch on YouTube

[![Watch on YouTube](https://img.shields.io/badge/YouTube-Watch%20the%20Tutorial-red?style=for-the-badge&logo=youtube)](https://youtu.be/DSuDSzUF-Fw)

> This project was built for the [NoahDoesCoding YouTube channel](https://www.youtube.com/@NoahDoesCoding97).

---

## 🚀 Getting Started

### 1. Clone the Repo
```bash
git clone https://github.com/NDCSwift/MacOS-SwiftUI-File-I-O.git
cd MacOS-SwiftUI-File-I-O
```

### 2. Open in Xcode
Double-click `MacOSNotesAppPersistence.xcodeproj`.

### 3. Set Your Development Team
TARGET → Signing & Capabilities → Team

### 4. Update the Bundle Identifier
Change `com.example.MyApp` to a unique identifier.

---

## 🛠️ Notes
- File access outside the sandbox requires entitlements — check the entitlements file.
- If you see a code signing error, verify Team and Bundle ID match.

## 📦 Requirements
- Xcode 16+
- macOS 13+

📺 [Watch the guide on YouTube](https://youtu.be/DSuDSzUF-Fw)
