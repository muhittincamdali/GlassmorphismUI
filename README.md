# GlassmorphismUI

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2016+%20|%20macOS%2013+-blue.svg)](https://developer.apple.com)
[![SPM](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)](https://swift.org/package-manager)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

A modern glassmorphism effects library for SwiftUI. Create stunning frosted glass, aurora gradients, and translucent UI components with minimal effort.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🪟 Glass Views | Fully customizable translucent glass panels |
| 🎨 Aurora Glass | Animated gradient-based glass effects |
| ❄️ Frosted Glass | Classic frosted/matte glass appearance |
| 🃏 Glass Card | Pre-built card component with glass styling |
| 🔘 Glass Button | Interactive button with glass background |
| 📱 Glass NavBar | Navigation bar with blur and transparency |
| 🗂 Glass TabBar | Tab bar with glassmorphism styling |
| 🎬 Animations | Shimmer and pulse effects |
| 🌗 Themes | Automatic light/dark mode adaptation |
| 🧩 Modifiers | Simple `.glass()` modifier for any view |

---

## 📦 Installation

### Swift Package Manager

Add GlassmorphismUI to your project via Xcode:

1. Go to **File → Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/muhittincamdali/GlassmorphismUI.git
   ```
3. Select **Up to Next Major Version** → `1.0.0`

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/GlassmorphismUI.git", from: "1.0.0")
]
```

Then add `"GlassmorphismUI"` to your target's dependencies.

---

## 🚀 Quick Start

### Basic Glass Modifier

Apply a glass effect to any SwiftUI view with a single modifier:

```swift
import GlassmorphismUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .blue, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Text("Hello, Glass!")
                .font(.largeTitle)
                .padding(40)
                .glass()
        }
    }
}
```

### Glass Card

```swift
GlassCard {
    VStack(alignment: .leading, spacing: 12) {
        Text("Weather")
            .font(.headline)
        Text("24°C — Partly Cloudy")
            .font(.title2.bold())
        Text("Istanbul, Turkey")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
    .padding()
}
```

### Glass Button

```swift
GlassButton("Get Started", icon: "arrow.right") {
    print("Tapped!")
}
```

### Aurora Glass

```swift
Text("Aurora Effect")
    .padding(32)
    .auroraGlass(colors: [.pink, .purple, .indigo])
```

### Frosted Glass

```swift
Image(systemName: "heart.fill")
    .font(.system(size: 48))
    .padding(40)
    .frostedGlass(opacity: 0.15)
```

---

## 🎛 Configuration

### GlassConfiguration

Fine-tune every aspect of the glass effect:

```swift
let config = GlassConfiguration(
    blurRadius: 20,
    backgroundOpacity: 0.12,
    borderWidth: 0.8,
    borderOpacity: 0.25,
    cornerRadius: 16,
    shadowRadius: 8,
    shadowOpacity: 0.1
)

Text("Custom Glass")
    .padding()
    .glass(configuration: config)
```

### Predefined Materials

Choose from built-in material presets:

```swift
// Thin — subtle, barely-there glass
Text("Thin").glass(material: .thin)

// Regular — balanced default
Text("Regular").glass(material: .regular)

// Thick — prominent frosted look
Text("Thick").glass(material: .thick)

// Ultra — maximum blur and opacity
Text("Ultra").glass(material: .ultra)
```

---

## 🧱 Components

### GlassNavBar

```swift
GlassNavBar(title: "Explore") {
    Button(action: {}) {
        Image(systemName: "line.3.horizontal")
    }
} trailing: {
    Button(action: {}) {
        Image(systemName: "bell")
    }
}
```

### GlassTabBar

```swift
GlassTabBar(
    selectedIndex: $selectedTab,
    items: [
        GlassTabItem(icon: "house", title: "Home"),
        GlassTabItem(icon: "magnifyingglass", title: "Search"),
        GlassTabItem(icon: "person", title: "Profile")
    ]
)
```

---

## 🎬 Animations

### Shimmer

```swift
Text("Loading...")
    .padding()
    .glass()
    .glassShimmer()
```

### Pulse

```swift
Circle()
    .frame(width: 80, height: 80)
    .glass()
    .glassPulse(duration: 2.0)
```

---

## 🌗 Theme Support

GlassmorphismUI automatically adapts to light and dark mode. You can also set a theme explicitly:

```swift
Text("Themed Glass")
    .padding()
    .glass()
    .glassTheme(.dark)
```

| Property | Light | Dark |
|----------|-------|------|
| Background | White 10% | White 8% |
| Border | White 30% | White 20% |
| Shadow | Black 8% | Black 15% |

---

## 🏗 Architecture

```
GlassmorphismUI/
├── Core/
│   ├── GlassView.swift            # Main glass effect view
│   ├── GlassConfiguration.swift   # Configuration struct
│   └── GlassMaterial.swift        # Predefined materials
├── Modifiers/
│   ├── GlassModifier.swift        # .glass() view modifier
│   ├── FrostedGlass.swift         # Frosted glass modifier
│   └── AuroraGlass.swift          # Aurora gradient glass
├── Components/
│   ├── GlassCard.swift            # Glass card component
│   ├── GlassButton.swift          # Glass button
│   ├── GlassNavBar.swift          # Glass navigation bar
│   └── GlassTabBar.swift          # Glass tab bar
├── Animation/
│   └── GlassAnimation.swift       # Shimmer & pulse
├── Theme/
│   └── GlassTheme.swift           # Light/dark themes
└── Extensions/
    └── Color+Glass.swift          # Color helpers
```

---

## 📋 Requirements

| Platform | Minimum Version |
|----------|----------------|
| iOS | 16.0+ |
| macOS | 13.0+ |
| Swift | 5.9+ |
| Xcode | 15.0+ |

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Inspired by the glassmorphism design trend
- Built with SwiftUI and love for clean UI
