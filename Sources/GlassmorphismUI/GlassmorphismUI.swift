// GlassmorphismUI.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - Module Exports

@_exported import SwiftUI

/// GlassmorphismUI provides production-ready glass effects for SwiftUI.
///
/// ## Overview
///
/// This library delivers high-quality glassmorphism effects that work across
/// iOS 15+, macOS 12+, tvOS 15+, watchOS 8+, and visionOS 1.0+.
///
/// ## Quick Start
///
/// ```swift
/// import GlassmorphismUI
///
/// struct ContentView: View {
///     var body: some View {
///         Text("Hello")
///             .padding()
///             .glass()
///     }
/// }
/// ```
///
/// ## Components
///
/// - ``GlassCard``: A card with glass background
/// - ``GlassButton``: A button with glass styling
/// - ``GlassNavigationBar``: A navigation bar with glass effect
/// - ``GlassTabBar``: A tab bar with glass background
/// - ``GlassModal``: A modal sheet with glass styling
///
/// ## Modifiers
///
/// - ``SwiftUI/View/glass(style:cornerRadius:)``
/// - ``SwiftUI/View/frostedGlass(tint:intensity:)``
/// - ``SwiftUI/View/gradientGlass(colors:)``
/// - ``SwiftUI/View/animatedGlass(animation:)``
///
public enum GlassmorphismUI {
    /// The current version of GlassmorphismUI.
    public static let version = "2.0.0"
    
    /// Indicates whether the current platform supports advanced glass effects.
    public static var supportsAdvancedEffects: Bool {
        #if os(iOS)
        if #available(iOS 15, *) { return true }
        return false
        #elseif os(macOS)
        if #available(macOS 12, *) { return true }
        return false
        #elseif os(tvOS)
        if #available(tvOS 15, *) { return true }
        return false
        #elseif os(watchOS)
        if #available(watchOS 8, *) { return true }
        return false
        #elseif os(visionOS)
        return true
        #else
        return false
        #endif
    }
}
