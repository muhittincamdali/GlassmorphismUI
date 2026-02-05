// GlassButton.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - GlassButton

/// A button with glass styling and press feedback.
///
/// ## Example
///
/// ```swift
/// GlassButton("Submit") {
///     print("Tapped")
/// }
///
/// GlassButton {
///     print("Tapped")
/// } label: {
///     Label("Download", systemImage: "arrow.down.circle")
/// }
/// ```
public struct GlassButton<Label: View>: View {
    
    // MARK: - Properties
    
    private let action: () -> Void
    private let label: Label
    private let style: GlassButtonStyle
    
    @State private var isPressed: Bool = false
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.glassConfiguration) private var configuration
    
    // MARK: - Initialization
    
    /// Creates a glass button with a custom label.
    public init(
        style: GlassButtonStyle = .primary,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.style = style
        self.action = action
        self.label = label()
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: performAction) {
            label
                .font(.body.weight(.medium))
                .foregroundColor(foregroundColor)
                .padding(.horizontal, style.horizontalPadding)
                .padding(.vertical, style.verticalPadding)
                .frame(minWidth: style.minWidth)
                .glass(
                    style: effectiveGlassStyle,
                    cornerRadius: style.cornerRadius
                )
        }
        .buttonStyle(GlassPressStyle(isPressed: $isPressed))
        .opacity(isEnabled ? 1.0 : 0.5)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isPressed)
    }
    
    // MARK: - Private
    
    private var foregroundColor: Color {
        guard isEnabled else { return .secondary }
        
        switch style.variant {
        case .primary:
            return .primary
        case .secondary:
            return .secondary
        case .accent:
            return style.accentColor ?? .accentColor
        case .destructive:
            return .red
        }
    }
    
    private var effectiveGlassStyle: GlassStyle {
        var glassStyle = style.glassStyle
        if isPressed {
            glassStyle = GlassStyle(
                blurIntensity: glassStyle.blurIntensity * 1.2,
                tintColor: glassStyle.tintColor,
                tintOpacity: glassStyle.tintOpacity * 1.5,
                borderOpacity: glassStyle.borderOpacity,
                shadowRadius: glassStyle.shadowRadius * 0.5,
                shadowOpacity: glassStyle.shadowOpacity * 0.5
            )
        }
        return glassStyle
    }
    
    private func performAction() {
        #if os(iOS)
        if configuration.enableHaptics {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        #endif
        action()
    }
}

// MARK: - String Label Convenience

extension GlassButton where Label == Text {
    
    /// Creates a glass button with a text label.
    public init(
        _ title: String,
        style: GlassButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.init(style: style, action: action) {
            Text(title)
        }
    }
}

// MARK: - GlassButtonStyle

/// Defines the visual style of glass buttons.
public struct GlassButtonStyle: Sendable {
    
    /// The button variant.
    public enum Variant: Sendable {
        case primary
        case secondary
        case accent
        case destructive
    }
    
    /// The button size.
    public enum Size: Sendable {
        case small
        case medium
        case large
        
        var horizontalPadding: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 16
            case .large: return 24
            }
        }
        
        var verticalPadding: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 12
            case .large: return 16
            }
        }
    }
    
    let variant: Variant
    let size: Size
    let accentColor: Color?
    let cornerRadius: CGFloat
    let minWidth: CGFloat?
    
    var horizontalPadding: CGFloat { size.horizontalPadding }
    var verticalPadding: CGFloat { size.verticalPadding }
    
    var glassStyle: GlassStyle {
        switch variant {
        case .primary:
            return .regular
        case .secondary:
            return .subtle
        case .accent:
            return GlassStyle(
                tintColor: accentColor ?? .accentColor,
                tintOpacity: 0.15
            )
        case .destructive:
            return GlassStyle(
                tintColor: .red,
                tintOpacity: 0.1
            )
        }
    }
    
    // MARK: - Presets
    
    /// Primary button style.
    public static let primary = GlassButtonStyle(
        variant: .primary,
        size: .medium,
        accentColor: nil,
        cornerRadius: 12,
        minWidth: nil
    )
    
    /// Secondary button style.
    public static let secondary = GlassButtonStyle(
        variant: .secondary,
        size: .medium,
        accentColor: nil,
        cornerRadius: 12,
        minWidth: nil
    )
    
    /// Small button style.
    public static let small = GlassButtonStyle(
        variant: .primary,
        size: .small,
        accentColor: nil,
        cornerRadius: 8,
        minWidth: nil
    )
    
    /// Large button style.
    public static let large = GlassButtonStyle(
        variant: .primary,
        size: .large,
        accentColor: nil,
        cornerRadius: 16,
        minWidth: nil
    )
    
    /// Capsule-shaped button.
    public static let capsule = GlassButtonStyle(
        variant: .primary,
        size: .medium,
        accentColor: nil,
        cornerRadius: 100,
        minWidth: nil
    )
    
    /// Destructive action button.
    public static let destructive = GlassButtonStyle(
        variant: .destructive,
        size: .medium,
        accentColor: nil,
        cornerRadius: 12,
        minWidth: nil
    )
    
    /// Full-width button.
    public static func fullWidth(size: Size = .large) -> GlassButtonStyle {
        GlassButtonStyle(
            variant: .primary,
            size: size,
            accentColor: nil,
            cornerRadius: 16,
            minWidth: .infinity
        )
    }
    
    /// Custom accent color button.
    public static func accent(_ color: Color, size: Size = .medium) -> GlassButtonStyle {
        GlassButtonStyle(
            variant: .accent,
            size: size,
            accentColor: color,
            cornerRadius: 12,
            minWidth: nil
        )
    }
}

// MARK: - GlassPressStyle

private struct GlassPressStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onAppear { isPressed = configuration.isPressed }
            .background(
                PressStateReader(isPressed: configuration.isPressed, binding: $isPressed)
            )
    }
}

private struct PressStateReader: View {
    let isPressed: Bool
    @Binding var binding: Bool
    
    var body: some View {
        Color.clear
            .onAppear { binding = isPressed }
            .onChange(of: isPressed, perform: { binding = $0 })
    }
}

// MARK: - Preview

#if DEBUG
struct GlassButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                GlassButton("Primary") { }
                
                GlassButton("Secondary", style: .secondary) { }
                
                GlassButton("Small", style: .small) { }
                
                GlassButton("Large", style: .large) { }
                
                GlassButton("Capsule", style: .capsule) { }
                
                GlassButton("Delete", style: .destructive) { }
                
                GlassButton("Full Width", style: .fullWidth()) { }
                    .padding(.horizontal)
            }
        }
    }
}
#endif
