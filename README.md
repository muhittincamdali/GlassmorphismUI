# GlassmorphismUI

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2015+%20|%20macOS%2012+%20|%20tvOS%2015+%20|%20watchOS%208+%20|%20visionOS-blue.svg)](https://developer.apple.com)
[![SPM](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Production-ready glassmorphism effects for SwiftUI.** Beautiful frosted glass UI components with iOS 26 Liquid Glass migration path.

```
┌────────────────────────────────────────────────────────────────────┐
│                                                                    │
│    ╭─────────────────────────────────────────────────────────╮    │
│    │ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │    │
│    │ ░░░░░░░░░░░░░░░ GLASSMORPHISM UI ░░░░░░░░░░░░░░░░░░░░ │    │
│    │ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │    │
│    │ ░░░  Frosted Glass  •  Blur Effects  •  SwiftUI  ░░░ │    │
│    │ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │    │
│    ╰─────────────────────────────────────────────────────────╯    │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

## Features

- 🪟 **Multiple Glass Effects** - Frosted, gradient, animated, liquid glass
- 📦 **Ready-to-Use Components** - Cards, buttons, navigation bars, tab bars, modals
- 🎨 **Highly Customizable** - Styles, materials, corner radii, animations
- ♿ **Accessibility First** - Respects Reduce Transparency & Reduce Motion
- 🌙 **Dark Mode Optimized** - Automatic adjustments for dark appearance
- 🚀 **iOS 26 Ready** - Built-in migration path to native Liquid Glass
- 📱 **Multi-Platform** - iOS, macOS, tvOS, watchOS, visionOS

## Requirements

| Platform | Minimum Version |
|----------|----------------|
| iOS | 15.0+ |
| macOS | 12.0+ |
| tvOS | 15.0+ |
| watchOS | 8.0+ |
| visionOS | 1.0+ |

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/muhittinc/GlassmorphismUI.git", from: "2.0.0")
]
```

### CocoaPods

```ruby
pod 'GlassmorphismUI', '~> 2.0'
```

## Quick Start

```swift
import GlassmorphismUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Your background
            LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            // Glass content
            Text("Hello, Glass!")
                .font(.title)
                .padding(32)
                .glass()
        }
    }
}
```

## Glass Effects

### Basic Glass

```swift
Text("Basic")
    .padding()
    .glass()

// With style preset
Text("Prominent")
    .padding()
    .glass(style: .prominent)

// With custom corner radius
Text("Rounded")
    .padding()
    .glass(cornerRadius: 24)
```

### Frosted Glass

```swift
Text("Frosted")
    .padding()
    .frostedGlass()

// With tint
Text("Blue Frost")
    .padding()
    .frostedGlass(tint: .blue, intensity: 0.4)
```

### Gradient Glass

```swift
Text("Gradient")
    .padding()
    .gradientGlass(colors: [.pink, .purple])

// Aurora effect (animated)
Text("Aurora")
    .padding()
    .auroraGlass(colors: [.cyan, .purple, .pink])
```

### Animated Glass

```swift
Text("Shimmer")
    .padding()
    .animatedGlass(.shimmer)

Text("Pulse")
    .padding()
    .animatedGlass(.pulse)

Text("Rainbow")
    .padding()
    .animatedGlass(.rainbow)
```

### Liquid Glass (iOS 26 Compatible)

```swift
Text("Liquid")
    .padding()
    .liquidGlass()

// With depth
Text("Deep")
    .padding()
    .liquidGlass(depth: 0.8, tint: .blue)
```

## Components

### GlassCard

```swift
GlassCard {
    VStack {
        Image(systemName: "star.fill")
            .font(.largeTitle)
        Text("Featured Content")
    }
}

// With header and footer
GlassCard {
    Text("Main content goes here")
} header: {
    Label("Title", systemImage: "info.circle")
} footer: {
    Button("Learn More") { }
}
```

### GlassButton

```swift
GlassButton("Submit") {
    print("Tapped!")
}

// With custom style
GlassButton("Delete", style: .destructive) {
    deleteItem()
}

// Full width
GlassButton("Continue", style: .fullWidth()) {
    proceed()
}
```

### GlassNavigationBar

```swift
GlassNavigationBar(title: "Settings", subtitle: "Customize your experience") {
    GlassBackButton { dismiss() }
} trailing: {
    Button(action: save) {
        Image(systemName: "checkmark")
    }
}
```

### GlassTabBar

```swift
@State private var selectedTab = "home"

let tabs = [
    GlassTabItem(id: "home", title: "Home", icon: "house"),
    GlassTabItem(id: "search", title: "Search", icon: "magnifyingglass"),
    GlassTabItem(id: "profile", title: "Profile", icon: "person", badge: "3")
]

GlassTabBar(selection: $selectedTab, items: tabs)

// Or use FloatingGlassTabBar for a pill-style tab bar
FloatingGlassTabBar(selection: $selectedTab, items: tabs)
```

### GlassModal

```swift
@State private var showModal = false

Button("Show Modal") { showModal = true }
    .glassModal(isPresented: $showModal) {
        VStack(spacing: 20) {
            Text("Modal Title")
                .font(.title2.bold())
            
            Text("Modal content with glass styling.")
            
            GlassButton("Dismiss") {
                showModal = false
            }
        }
        .padding()
    }
```

## Glass Styles

| Style | Description |
|-------|-------------|
| `.subtle` | Barely-there glass effect |
| `.regular` | Balanced default style |
| `.prominent` | Higher contrast glass |
| `.frosted` | Thick, matte appearance |
| `.ultraThin` | System UI style |
| `.thick` | Maximum blur |

## Configuration

### Global Settings

```swift
// In your App initialization
GlassConfiguration.shared.defaultStyle = .prominent
GlassConfiguration.shared.enableHaptics = true
GlassConfiguration.shared.respectReduceTransparency = true
GlassConfiguration.shared.enableLiquidGlassCompat = true
```

### Per-View Configuration

```swift
ContentView()
    .environment(\.glassConfiguration, customConfig)
```

## Accessibility

GlassmorphismUI automatically respects system accessibility settings:

- **Reduce Transparency**: Falls back to solid backgrounds
- **Reduce Motion**: Disables animations
- **Increase Contrast**: Adjusts borders and shadows

```swift
// Override if needed
GlassConfiguration.shared.respectReduceTransparency = false
```

## iOS 26 Migration

GlassmorphismUI provides a smooth migration path to iOS 26's native Liquid Glass:

```swift
// Your existing code
Text("Hello")
    .glass()  // Uses Material on iOS 15-18

// On iOS 26+, automatically uses native Liquid Glass!
// No code changes required.

// For explicit Liquid Glass style:
Text("Hello")
    .liquidGlass(depth: 0.6)
```

## Performance Tips

1. **Avoid Overlapping Glass**: Multiple overlapping glass layers can impact performance
2. **Use Appropriate Materials**: `.ultraThin` is lighter than `.ultraThick`
3. **Disable Animations When Needed**: Set animation to `.none` for static content
4. **Test on Older Devices**: Use `GlassConfiguration.shared.useAdaptivePerformance = true`

## Architecture

```
GlassmorphismUI/
├── Core/
│   ├── GlassStyle          # Style definitions
│   └── GlassConfiguration  # Global settings
├── Modifiers/
│   ├── GlassModifier       # Basic glass effect
│   ├── FrostedGlassModifier
│   ├── GradientGlassModifier
│   └── AnimatedGlassModifier
├── Components/
│   ├── GlassCard
│   ├── GlassButton
│   ├── GlassNavigationBar
│   ├── GlassTabBar
│   └── GlassModal
├── Accessibility/
│   └── GlassAccessibility  # A11y support
└── Extensions/
    ├── ViewExtensions      # Convenience APIs
    └── LiquidGlassCompat   # iOS 26 compatibility
```

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

## License

MIT License - see [LICENSE](LICENSE) for details.

---

**Made with ❤️ for the SwiftUI community**
