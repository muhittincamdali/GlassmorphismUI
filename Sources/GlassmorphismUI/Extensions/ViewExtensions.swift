// ViewExtensions.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - Convenience Extensions

public extension View {
    
    /// Applies a subtle glass effect.
    ///
    /// Shorthand for `.glass(style: .subtle)`.
    func subtleGlass(cornerRadius: CGFloat = 16) -> some View {
        glass(style: .subtle, cornerRadius: cornerRadius)
    }
    
    /// Applies a prominent glass effect.
    ///
    /// Shorthand for `.glass(style: .prominent)`.
    func prominentGlass(cornerRadius: CGFloat = 16) -> some View {
        glass(style: .prominent, cornerRadius: cornerRadius)
    }
    
    /// Applies an ultra-thin glass effect.
    ///
    /// Similar to system UI elements like Control Center.
    func ultraThinGlass(cornerRadius: CGFloat = 16) -> some View {
        glass(style: .ultraThin, cornerRadius: cornerRadius)
    }
    
    /// Applies a thick glass effect.
    ///
    /// High-contrast glass for vibrant backgrounds.
    func thickGlass(cornerRadius: CGFloat = 16) -> some View {
        glass(style: .thick, cornerRadius: cornerRadius)
    }
}

// MARK: - Tinted Glass

public extension View {
    
    /// Applies a tinted glass effect.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Text("Blue Tint")
    ///     .padding()
    ///     .tintedGlass(.blue)
    /// ```
    ///
    /// - Parameters:
    ///   - color: The tint color.
    ///   - intensity: The tint intensity (0.0 to 1.0). Default is 0.15.
    ///   - cornerRadius: Corner radius. Default is 16.
    /// - Returns: A view with tinted glass effect.
    func tintedGlass(
        _ color: Color,
        intensity: CGFloat = 0.15,
        cornerRadius: CGFloat = 16
    ) -> some View {
        glass(
            style: GlassStyle(
                tintColor: color,
                tintOpacity: intensity
            ),
            cornerRadius: cornerRadius
        )
    }
}

// MARK: - Bordered Glass

public extension View {
    
    /// Applies a glass effect with a prominent border.
    ///
    /// - Parameters:
    ///   - style: The glass style. Default is `.regular`.
    ///   - borderColor: The border color. Default is white.
    ///   - borderWidth: The border width. Default is 1.
    ///   - cornerRadius: Corner radius. Default is 16.
    /// - Returns: A view with bordered glass effect.
    func borderedGlass(
        style: GlassStyle = .regular,
        borderColor: Color = .white,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 16
    ) -> some View {
        self
            .glass(style: style, cornerRadius: cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(borderColor.opacity(0.3), lineWidth: borderWidth)
            )
    }
}

// MARK: - Glowing Glass

public extension View {
    
    /// Applies a glass effect with an outer glow.
    ///
    /// - Parameters:
    ///   - color: The glow color.
    ///   - radius: The glow radius. Default is 20.
    ///   - cornerRadius: Corner radius. Default is 16.
    /// - Returns: A view with glowing glass effect.
    func glowingGlass(
        _ color: Color,
        radius: CGFloat = 20,
        cornerRadius: CGFloat = 16
    ) -> some View {
        self
            .glass(
                style: GlassStyle(
                    tintColor: color,
                    tintOpacity: 0.1
                ),
                cornerRadius: cornerRadius
            )
            .shadow(color: color.opacity(0.4), radius: radius)
    }
}

// MARK: - Neumorphic Glass

public extension View {
    
    /// Applies a neumorphic glass effect.
    ///
    /// Combines glassmorphism with neumorphic shadow styling.
    ///
    /// - Parameters:
    ///   - cornerRadius: Corner radius. Default is 16.
    ///   - intensity: Effect intensity. Default is 0.5.
    /// - Returns: A view with neumorphic glass effect.
    func neumorphicGlass(
        cornerRadius: CGFloat = 16,
        intensity: CGFloat = 0.5
    ) -> some View {
        self
            .glass(style: .subtle, cornerRadius: cornerRadius)
            .shadow(
                color: .white.opacity(0.7 * intensity),
                radius: 5,
                x: -3,
                y: -3
            )
            .shadow(
                color: .black.opacity(0.2 * intensity),
                radius: 5,
                x: 3,
                y: 3
            )
    }
}

// MARK: - Conditional Glass

public extension View {
    
    /// Conditionally applies a glass effect.
    ///
    /// - Parameters:
    ///   - condition: Whether to apply the effect.
    ///   - style: The glass style.
    ///   - cornerRadius: Corner radius.
    /// - Returns: A view with conditional glass effect.
    @ViewBuilder
    func glass(
        if condition: Bool,
        style: GlassStyle = .regular,
        cornerRadius: CGFloat = 16
    ) -> some View {
        if condition {
            glass(style: style, cornerRadius: cornerRadius)
        } else {
            self
        }
    }
}

// MARK: - Platform-Specific

#if os(iOS)
public extension View {
    
    /// Applies a glass effect that matches iOS system UI.
    ///
    /// Uses `.ultraThinMaterial` for a system-consistent look.
    func systemGlass(cornerRadius: CGFloat = 10) -> some View {
        glass(
            style: .ultraThin,
            cornerRadius: cornerRadius,
            material: .ultraThin
        )
    }
}
#endif

#if os(macOS)
public extension View {
    
    /// Applies a glass effect that matches macOS window chrome.
    ///
    /// Uses styling similar to macOS sidebar and toolbar materials.
    func macGlass(cornerRadius: CGFloat = 8) -> some View {
        glass(
            style: GlassStyle(
                blurIntensity: 0.6,
                tintOpacity: 0.05,
                borderOpacity: 0.1,
                shadowRadius: 3,
                shadowOpacity: 0.1
            ),
            cornerRadius: cornerRadius
        )
    }
}
#endif

// MARK: - Shape Glass

public extension Shape {
    
    /// Fills the shape with a glass effect.
    ///
    /// - Parameters:
    ///   - style: The glass style.
    ///   - material: The blur material.
    /// - Returns: A view with the shape filled with glass.
    func glassBackground(
        style: GlassStyle = .regular,
        material: GlassMaterial = .regular
    ) -> some View {
        ZStack {
            self.fill(material.material)
            self.fill(style.tintColor.opacity(style.tintOpacity))
        }
        .clipShape(self)
        .overlay(
            self.stroke(
                Color.white.opacity(style.borderOpacity),
                lineWidth: 0.5
            )
        )
        .shadow(
            color: .black.opacity(style.shadowOpacity),
            radius: style.shadowRadius
        )
    }
}
