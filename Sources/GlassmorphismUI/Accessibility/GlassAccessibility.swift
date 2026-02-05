// GlassAccessibility.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - Accessibility Support

/// Accessibility utilities for glass effects.
///
/// GlassmorphismUI automatically respects system accessibility settings:
/// - Reduce Transparency: Falls back to solid backgrounds
/// - Reduce Motion: Disables animations
/// - Increase Contrast: Adjusts border visibility
///
/// ## Manual Override
///
/// ```swift
/// GlassConfiguration.shared.respectReduceTransparency = false
/// ```
public enum GlassAccessibility {
    
    /// Whether the system has "Reduce Transparency" enabled.
    public static var isReduceTransparencyEnabled: Bool {
        #if os(iOS) || os(tvOS)
        return UIAccessibility.isReduceTransparencyEnabled
        #elseif os(macOS)
        return NSWorkspace.shared.accessibilityDisplayShouldReduceTransparency
        #else
        return false
        #endif
    }
    
    /// Whether the system has "Reduce Motion" enabled.
    public static var isReduceMotionEnabled: Bool {
        #if os(iOS) || os(tvOS)
        return UIAccessibility.isReduceMotionEnabled
        #elseif os(macOS)
        return NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        #else
        return false
        #endif
    }
    
    /// Whether the system has "Increase Contrast" enabled.
    public static var isIncreaseContrastEnabled: Bool {
        #if os(iOS) || os(tvOS)
        return UIAccessibility.isDarkerSystemColorsEnabled
        #elseif os(macOS)
        return NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast
        #else
        return false
        #endif
    }
    
    /// Returns a glass style adjusted for current accessibility settings.
    ///
    /// - Parameter style: The base glass style.
    /// - Returns: An adjusted style respecting accessibility preferences.
    public static func adjustedStyle(for style: GlassStyle) -> GlassStyle {
        var adjusted = style
        
        if isIncreaseContrastEnabled {
            adjusted = GlassStyle(
                blurIntensity: style.blurIntensity,
                tintColor: style.tintColor,
                tintOpacity: style.tintOpacity * 1.5,
                borderOpacity: min(1.0, style.borderOpacity * 2.0),
                shadowRadius: style.shadowRadius,
                shadowOpacity: style.shadowOpacity * 1.3,
                useVibrancy: style.useVibrancy
            )
        }
        
        return adjusted
    }
}

// MARK: - Accessibility View Modifier

/// A view modifier that adds accessibility labels to glass elements.
public struct GlassAccessibilityModifier: ViewModifier {
    
    let label: String
    let hint: String?
    let traits: AccessibilityTraits
    
    public init(
        label: String,
        hint: String? = nil,
        traits: AccessibilityTraits = []
    ) {
        self.label = label
        self.hint = hint
        self.traits = traits
    }
    
    public func body(content: Content) -> some View {
        content
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits)
    }
}

// MARK: - View Extension

public extension View {
    
    /// Adds accessibility information to a glass element.
    ///
    /// - Parameters:
    ///   - label: The accessibility label.
    ///   - hint: Optional accessibility hint.
    ///   - traits: Accessibility traits to add.
    /// - Returns: A view with accessibility information.
    func glassAccessibility(
        label: String,
        hint: String? = nil,
        traits: AccessibilityTraits = []
    ) -> some View {
        modifier(GlassAccessibilityModifier(
            label: label,
            hint: hint,
            traits: traits
        ))
    }
}

// MARK: - High Contrast Glass Style

extension GlassStyle {
    
    /// A high-contrast glass style for accessibility.
    ///
    /// This style has stronger borders and higher opacity
    /// for users who need increased visual contrast.
    public static let highContrast = GlassStyle(
        blurIntensity: 0.8,
        tintColor: .white,
        tintOpacity: 0.3,
        borderOpacity: 0.6,
        shadowRadius: 5,
        shadowOpacity: 0.3,
        useVibrancy: false
    )
    
    /// Returns this style adjusted for accessibility if needed.
    public var accessibilityAdjusted: GlassStyle {
        GlassAccessibility.adjustedStyle(for: self)
    }
}

// MARK: - Environment Reader

/// An environment key for tracking accessibility state changes.
private struct GlassAccessibilityEnvironmentKey: EnvironmentKey {
    static let defaultValue = GlassAccessibilityState()
}

/// Represents the current accessibility state relevant to glass effects.
public struct GlassAccessibilityState: Equatable, Sendable {
    public var reduceTransparency: Bool = false
    public var reduceMotion: Bool = false
    public var increaseContrast: Bool = false
    
    public init() {
        self.reduceTransparency = GlassAccessibility.isReduceTransparencyEnabled
        self.reduceMotion = GlassAccessibility.isReduceMotionEnabled
        self.increaseContrast = GlassAccessibility.isIncreaseContrastEnabled
    }
}

extension EnvironmentValues {
    /// The current glass accessibility state.
    public var glassAccessibility: GlassAccessibilityState {
        get { self[GlassAccessibilityEnvironmentKey.self] }
        set { self[GlassAccessibilityEnvironmentKey.self] = newValue }
    }
}
