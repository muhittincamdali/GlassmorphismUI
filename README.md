<p align="center">
  <img src="Assets/logo.png" alt="GlassmorphismUI" width="200"/>
</p>

<h1 align="center">GlassmorphismUI</h1>

<p align="center">
  <strong>✨ Cross-platform glassmorphism components for iOS, Flutter & React Native</strong>
</p>

<p align="center">
  <a href="https://github.com/muhittincamdali/GlassmorphismUI/actions/workflows/ci.yml">
    <img src="https://github.com/muhittincamdali/GlassmorphismUI/actions/workflows/ci.yml/badge.svg" alt="CI"/>
  </a>
  <img src="https://img.shields.io/badge/iOS-17.0+-000000?style=flat-square&logo=apple&logoColor=white" alt="iOS"/>
  <img src="https://img.shields.io/badge/Flutter-3.24-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/React_Native-0.75-61DAFB?style=flat-square&logo=react&logoColor=black" alt="React Native"/>
  <img src="https://img.shields.io/badge/SPM-Compatible-FA7343?style=flat-square&logo=swift&logoColor=white" alt="SPM"/>
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License"/>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#platforms">Platforms</a> •
  <a href="#contributing">Contributing</a>
</p>

---

## 📋 Table of Contents

- [Why GlassmorphismUI?](#why-glassmorphismui)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
  - [iOS (Swift)](#ios-swift)
  - [Flutter](#flutter)
  - [React Native](#react-native)
- [Quick Start](#quick-start)
- [Platforms](#platforms)
  - [iOS (SwiftUI)](#ios-swiftui)
  - [Flutter](#flutter-1)
  - [React Native](#react-native-1)
- [Components](#components)
- [Customization](#customization)
- [Contributing](#contributing)
- [License](#license)
- [Star History](#-star-history)

---

## Why GlassmorphismUI?

Glassmorphism looks beautiful but is hard to implement consistently across platforms. **GlassmorphismUI** provides identical glass effects for iOS, Flutter, and React Native with the same API design.

```swift
// iOS
GlassCard(blur: 10, opacity: 0.2) {
    Text("Glass Card")
}
```

```dart
// Flutter
GlassCard(
  blur: 10,
  opacity: 0.2,
  child: Text('Glass Card'),
)
```

```tsx
// React Native
<GlassCard blur={10} opacity={0.2}>
  <Text>Glass Card</Text>
</GlassCard>
```

## Features

| Feature | iOS | Flutter | React Native |
|---------|-----|---------|--------------|
| 🧊 **GlassCard** | ✅ | ✅ | ✅ |
| 🔘 **GlassButton** | ✅ | ✅ | ✅ |
| 📱 **GlassNavBar** | ✅ | ✅ | ✅ |
| 🌈 **AuroraBackground** | ✅ | ✅ | ✅ |
| ✨ **GlowEffect** | ✅ | ✅ | ✅ |
| 🎨 **Custom Blur** | ✅ | ✅ | ✅ |
| 🌙 **Dark Mode** | ✅ | ✅ | ✅ |
| ⚡ **GPU Optimized** | ✅ | ✅ | ✅ |

## Requirements

| Platform | Minimum Version |
|----------|-----------------|
| iOS | 17.0+ |
| macOS | 14.0+ |
| Flutter | 3.24+ |
| React Native | 0.75+ |
| Xcode | 15.0+ |
| Swift | 5.9+ |

## Installation

### iOS (Swift)

**Swift Package Manager:**

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/GlassmorphismUI.git", from: "1.0.0")
]
```

**CocoaPods:**

```ruby
pod 'GlassmorphismUI', '~> 1.0'
```

### Flutter

```yaml
dependencies:
  glassmorphism_ui: ^1.0.0
```

### React Native

```bash
npm install glassmorphism-ui
# or
yarn add glassmorphism-ui
```

## Quick Start

### iOS (SwiftUI)

```swift
import GlassmorphismUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Glass card
            GlassCard(blur: 10, opacity: 0.2) {
                VStack {
                    Text("Welcome")
                        .font(.title)
                    Text("Glassmorphism UI")
                        .font(.headline)
                }
                .padding()
            }
        }
    }
}
```

### Flutter

```dart
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.blue],
        ),
      ),
      child: Center(
        child: GlassCard(
          blur: 10,
          opacity: 0.2,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Welcome', style: TextStyle(fontSize: 24)),
                Text('Glassmorphism UI'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### React Native

```tsx
import { GlassCard } from 'glassmorphism-ui';
import { LinearGradient } from 'expo-linear-gradient';

export default function App() {
  return (
    <LinearGradient colors={['purple', 'blue']} style={styles.container}>
      <GlassCard blur={10} opacity={0.2} style={styles.card}>
        <Text style={styles.title}>Welcome</Text>
        <Text>Glassmorphism UI</Text>
      </GlassCard>
    </LinearGradient>
  );
}
```

## Platforms

### iOS (SwiftUI)

```swift
// GlassCard
GlassCard(blur: 10, opacity: 0.2, cornerRadius: 20) {
    Text("Glass Card")
}

// GlassButton
GlassButton("Press Me", blur: 5) {
    print("Button pressed!")
}

// GlassNavBar
GlassNavBar(items: [
    .init(icon: "house", title: "Home"),
    .init(icon: "magnifyingglass", title: "Search"),
    .init(icon: "person", title: "Profile"),
], selectedIndex: $selectedIndex)
```

### Flutter

```dart
// GlassCard
GlassCard(
  blur: 10,
  opacity: 0.2,
  borderRadius: 20,
  border: GlassBorder(width: 1, color: Colors.white30),
  child: Text('Glass Card'),
)

// GlassButton
GlassButton(
  onPressed: () => print('Pressed!'),
  blur: 5,
  child: Text('Press Me'),
)

// GlassNavBar
GlassNavBar(
  items: [
    GlassNavItem(icon: Icons.home, label: 'Home'),
    GlassNavItem(icon: Icons.search, label: 'Search'),
    GlassNavItem(icon: Icons.person, label: 'Profile'),
  ],
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
)
```

### React Native

```tsx
// GlassCard
<GlassCard blur={10} opacity={0.2} borderRadius={20}>
  <Text>Glass Card</Text>
</GlassCard>

// GlassButton
<GlassButton blur={5} onPress={() => console.log('Pressed!')}>
  <Text>Press Me</Text>
</GlassButton>

// GlassNavBar
<GlassNavBar
  items={[
    { icon: 'home', label: 'Home' },
    { icon: 'search', label: 'Search' },
    { icon: 'person', label: 'Profile' },
  ]}
  currentIndex={currentIndex}
  onSelect={setCurrentIndex}
/>
```

## Components

| Component | Description |
|-----------|-------------|
| **GlassCard** | Container with glass effect |
| **GlassButton** | Button with glass background |
| **GlassNavBar** | Bottom navigation bar |
| **GlassTextField** | Text input with glass styling |
| **GlassAlert** | Alert dialog with glass effect |
| **GlassSheet** | Bottom sheet with glass |

## Customization

All platforms support these properties:

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `blur` | Number | 10 | Blur intensity |
| `opacity` | Number | 0.2 | Background opacity |
| `tint` | Color | white | Tint color |
| `borderRadius` | Number | 16 | Corner radius |
| `borderWidth` | Number | 1 | Border width |
| `borderColor` | Color | white30 | Border color |

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

## License

GlassmorphismUI is released under the MIT License. See [LICENSE](LICENSE) for details.

---

## 📈 Star History

<a href="https://star-history.com/#muhittincamdali/GlassmorphismUI&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/GlassmorphismUI&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/GlassmorphismUI&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=muhittincamdali/GlassmorphismUI&type=Date" />
 </picture>
</a>

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/muhittincamdali">Muhittin Camdali</a>
</p>
