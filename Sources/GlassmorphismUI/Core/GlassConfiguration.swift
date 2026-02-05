// GlassConfiguration.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - GlassConfiguration

/// Global configuration for GlassmorphismUI behavior.
///
/// Use this to customize default behaviors across your entire app.
///
/// ## Example
///
/// ```swift
/// // In your App initialization
/// GlassConfiguration.shared.defaultStyle = .prominent
/// GlassConfiguration.shared.reduceTransparency = false
/// ```
public final class GlassConfiguration: ObservableObject, @unchecked Sendable {
    
    // MARK: - Singleton
    
    /// The shared configuration instance.
    public static let shared = GlassConfiguration()
    
    // MARK: - Properties
    
    /// The default glass style used when none is specified.
    @Published public var defaultStyle: GlassStyle = .regular
    
    /// The default corner style for glass elements.
    @Published public var defaultCornerStyle: GlassCornerStyle = .large
    
    /// Whether to honor the system's "Reduce Transparency" setting.
    @Published public var respectReduceTransparency: Bool = true
    
    /// Whether to disable animations for accessibility.
    @Published public var respectReduceMotion: Bool = true
    
    /// The default animation for glass transitions.
    @Published public var defaultAnimation: Animation = .easeInOut(duration: 0.3)
    
    /// Whether to enable haptic feedback on glass button interactions.
    @Published public var enableHaptics: Bool = true
    
    /// Global tint adjustment for dark mode.
    @Published public var darkModeTintMultiplier: CGFloat = 0.7
    
    /// Global shadow adjustment for dark mode.
    @Published public var darkModeShadowMultiplier: CGFloat = 1.3
    
    // MARK: - Performance
    
    /// Whether to use reduced quality effects on older devices.
    @Published public var useAdaptivePerformance: Bool = true
    
    /// The minimum iOS version for Material effects (below this uses fallbacks).
    public let materialMinimumVersion: Double = 15.0
    
    // MARK: - iOS 26 Migration
    
    /// Enable iOS 26 Liquid Glass compatibility mode.
    ///
    /// When iOS 26 is available, this will automatically use native Liquid Glass APIs.
    /// On older versions, it provides a close approximation.
    @Published public var enableLiquidGlassCompat: Bool = true
    
    /// Liquid Glass depth amount (for iOS 26 compatibility).
    @Published public var liquidGlassDepth: CGFloat = 0.5
    
    // MARK: - Initialization
    
    private init() {
        setupAccessibilityObservers()
    }
    
    // MARK: - Private
    
    private func setupAccessibilityObservers() {
        #if os(iOS) || os(tvOS)
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.reduceTransparencyStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.objectWillChange.send()
        }
        
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.reduceMotionStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.objectWillChange.send()
        }
        #endif
    }
}

// MARK: - Environment Key

private struct GlassConfigurationKey: EnvironmentKey {
    static let defaultValue = GlassConfiguration.shared
}

extension EnvironmentValues {
    /// The glass configuration for the current environment.
    public var glassConfiguration: GlassConfiguration {
        get { self[GlassConfigurationKey.self] }
        set { self[GlassConfigurationKey.self] = newValue }
    }
}

// MARK: - Accessibility Helpers

extension GlassConfiguration {
    
    /// Whether transparency effects should be reduced.
    public var shouldReduceTransparency: Bool {
        guard respectReduceTransparency else { return false }
        #if os(iOS) || os(tvOS)
        return UIAccessibility.isReduceTransparencyEnabled
        #elseif os(macOS)
        return NSWorkspace.shared.accessibilityDisplayShouldReduceTransparency
        #else
        return false
        #endif
    }
    
    /// Whether motion/animations should be reduced.
    public var shouldReduceMotion: Bool {
        guard respectReduceMotion else { return false }
        #if os(iOS) || os(tvOS)
        return UIAccessibility.isReduceMotionEnabled
        #elseif os(macOS)
        return NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        #else
        return false
        #endif
    }
    
    /// Returns an appropriate animation considering accessibility settings.
    public var accessibleAnimation: Animation? {
        shouldReduceMotion ? nil : defaultAnimation
    }
}

// MARK: - Device Performance

extension GlassConfiguration {
    
    /// Returns whether the current device can handle full-quality effects.
    public var supportsFullQuality: Bool {
        guard useAdaptivePerformance else { return true }
        
        #if os(iOS)
        // Check for older devices with limited GPU
        let deviceModel = UIDevice.current.model
        return !deviceModel.contains("iPad mini") || ProcessInfo.processInfo.physicalMemory > 2_000_000_000
        #else
        return true
        #endif
    }
    
    /// The appropriate blur radius based on device capabilities.
    public func adaptiveBlurRadius(for style: GlassStyle) -> CGFloat {
        let baseRadius = style.blurIntensity * 30
        return supportsFullQuality ? baseRadius : baseRadius * 0.6
    }
}
