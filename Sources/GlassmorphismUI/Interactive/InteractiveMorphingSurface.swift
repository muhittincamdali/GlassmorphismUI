import SwiftUI

/// GlassmorphismUI: Interactive Morphing Surface
/// 
/// A physics-based glass container that morphs its corner radius and shadow intensity
/// based on user scroll velocity or drag gestures.
public struct InteractiveMorphingSurface: ViewModifier {
    @State private var intensity: CGFloat = 0
    
    public func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16 + intensity * 10, style: .continuous))
            .shadow(color: .black.opacity(0.1 + Double(intensity) * 0.1), radius: 10 + intensity * 5)
            .gesture(
                DragGesture()
                    .onChanged { _ in withAnimation { intensity = 1.0 } }
                    .onEnded { _ in withAnimation { intensity = 0.0 } }
            )
    }
}

public extension View {
    func interactiveMorphingGlass() -> some View {
        self.modifier(InteractiveMorphingSurface())
    }
}
