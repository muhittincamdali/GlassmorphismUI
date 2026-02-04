<p align="center">
  <img src="Assets/logo.png" alt="GlassmorphismUI" width="200"/>
</p>

<h1 align="center">GlassmorphismUI</h1>

<p align="center">
  <strong>✨ Cross-platform glassmorphism components for iOS, Flutter & React Native</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-17.0+-blue.svg" alt="iOS"/>
  <img src="https://img.shields.io/badge/Flutter-3.24-blue.svg" alt="Flutter"/>
  <img src="https://img.shields.io/badge/React_Native-0.75-blue.svg" alt="React Native"/>
</p>

---

## Why GlassmorphismUI?

Glassmorphism looks beautiful but is hard to implement consistently across platforms. **GlassmorphismUI** provides identical glass effects for iOS, Flutter, and React Native.

## iOS (SwiftUI)

```swift
import GlassmorphismUI

GlassCard(blur: 10, opacity: 0.2) {
    Text("Glass Card")
}

GlassButton("Press Me", blur: 5) {
    // action
}
```

## Flutter

```dart
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

GlassCard(
  blur: 10,
  opacity: 0.2,
  child: Text('Glass Card'),
)

GlassButton(
  onPressed: () {},
  child: Text('Press Me'),
)
```

## React Native

```tsx
import { GlassCard, GlassButton } from 'glassmorphism-ui';

<GlassCard blur={10} opacity={0.2}>
  <Text>Glass Card</Text>
</GlassCard>

<GlassButton onPress={() => {}}>
  <Text>Press Me</Text>
</GlassButton>
```

## Customization

All platforms support:
- Blur intensity
- Opacity
- Border
- Tint color
- Shadow

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT License
