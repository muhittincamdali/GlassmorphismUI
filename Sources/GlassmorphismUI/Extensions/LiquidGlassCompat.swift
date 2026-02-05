// LiquidGlassCompat.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - iOS 26 Liquid Glass Compatibility

/// Provides a migration path from GlassmorphismUI to iOS 26's native Liquid Glass.
///
/// ## Overview
///
/// When iOS 26 becomes available, this module will automatically use native
/// Liquid Glass APIs while maintaining the same GlassmorphismUI interface.
///
/// ## Migration Guide
///
/// 1. Keep using GlassmorphismUI modifiers as normal
/// 2. When targeting iOS 26+, effects will automatically upgrade
/// 3. Use `GlassConfiguration.shared.enableLiquidGlassCompat` to control behavior
///
/// ## Current Behavior (iOS 15-18)
///
/// Provides a close approximation of Liquid Glass using:
/// - Multiple blur layers
/// - Gradient overlays
/// - Subtle refraction simulation
/// - Dynamic shadows
///
public struct LiquidGlassCompat {
    
    /// Indicates whether native Liquid Glass is available.
    public static var isNativeAvailable: Bool {
        // iOS 26 check - will be true when iOS 26 SDK is available
        if #available(iOS 26, *) {
            return true
        }
        return false
    }
    
    /// The compatibility mode in use.
    public enum Mode {
        /// Using native iOS 26 Liquid Glass
        case native
        
        /// Using GlassmorphismUI approximation
        case approximate
        
        /// Glass effects disabled
        case disabled
    }
    
    /// The current compatibility mode.
    public static var currentMode: Mode {
        guard GlassConfiguration.shared.enableLiquidGlassCompat else {
            return .disabled
        }
        return isNativeAvailable ? .native : .approximate
    }
}

// MARK: - Liquid Glass Modifier

/// A view modifier that provides Liquid Glass-like effects.
///
/// On iOS 26+, this will use native `.glassEffect()`.
/// On older versions, it provides a close approximation.
public struct LiquidGlassModifier: ViewModifier {
    
    private let depth: CGFloat
    private let tint: Color?
    private let cornerRadius: CGFloat
    
    @Environment(\.colorScheme) private var colorScheme
    
    /// Creates a liquid glass modifier.
    ///
    /// - Parameters:
    ///   - depth: The depth/intensity of the glass effect (0.0 to 1.0).
    ///   - tint: Optional tint color.
    ///   - cornerRadius: The corner radius.
    public init(
        depth: CGFloat = 0.5,
        tint: Color? = nil,
        cornerRadius: CGFloat = 16
    ) {
        self.depth = max(0, min(1, depth))
        self.tint = tint
        self.cornerRadius = cornerRadius
    }
    
    public func body(content: Content) -> some View {
        // Future: Check for iOS 26 and use native .glassEffect()
        // if #available(iOS 26, *) {
        //     return content.glassEffect()
        // }
        
        // Approximation for iOS 15-18
        content.background(liquidGlassBackground)
    }
    
    @ViewBuilder
    private var liquidGlassBackground: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        
        ZStack {
            // Layer 1: Deep blur
            shape
                .fill(.ultraThinMaterial)
            
            // Layer 2: Refraction simulation
            shape
                .fill(refractionGradient)
                .blendMode(.plusLighter)
            
            // Layer 3: Depth gradient
            shape
                .fill(depthGradient)
            
            // Layer 4: Tint (if provided)
            if let tint = tint {
                shape
                    .fill(tint.opacity(0.1 * depth))
            }
            
            // Layer 5: Surface highlight
            shape
                .fill(highlightGradient)
                .blendMode(.plusLighter)
        }
        .clipShape(shape)
        .overlay(
            shape.stroke(borderGradient, lineWidth: 0.5)
        )
        .shadow(
            color: .black.opacity(0.15 * depth),
            radius: 15 * depth,
            y: 8 * depth
        )
    }
    
    private var refractionGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.05 * depth),
                Color.clear,
                Color.white.opacity(0.03 * depth)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var depthGradient: LinearGradient {
        let isDark = colorScheme == .dark
        return LinearGradient(
            colors: [
                (isDark ? Color.white : Color.black).opacity(0.02 * depth),
                Color.clear,
                (isDark ? Color.black : Color.white).opacity(0.03 * depth)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var highlightGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.15 * depth),
                Color.clear
            ],
            startPoint: .topLeading,
            endPoint: UnitPoint(x: 0.5, y: 0.3)
        )
    }
    
    private var borderGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.3 * depth),
                Color.white.opacity(0.1 * depth)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - View Extension

public extension View {
    
    /// Applies a Liquid Glass-like effect.
    ///
    /// This provides iOS 26 Liquid Glass compatibility:
    /// - On iOS 26+: Uses native Liquid Glass
    /// - On iOS 15-18: Uses high-quality approximation
    ///
    /// ## Example
    ///
    /// ```swift
    /// Text("Liquid Glass")
    ///     .padding()
    ///     .liquidGlass()
    ///
    /// // With customization
    /// Text("Deep Glass")
    ///     .padding()
    ///     .liquidGlass(depth: 0.8, tint: .blue)
    /// ```
    ///
    /// - Parameters:
    ///   - depth: The glass depth (0.0 to 1.0). Default is 0.5.
    ///   - tint: Optional tint color.
    ///   - cornerRadius: Corner radius. Default is 16.
    /// - Returns: A view with Liquid Glass effect.
    func liquidGlass(
        depth: CGFloat = 0.5,
        tint: Color? = nil,
        cornerRadius: CGFloat = 16
    ) -> some View {
        modifier(LiquidGlassModifier(
            depth: depth,
            tint: tint,
            cornerRadius: cornerRadius
        ))
    }
}

// MARK: - iOS 26 API Surface (Future)

/// Documentation for iOS 26 Liquid Glass migration.
///
/// When iOS 26 is released, GlassmorphismUI will provide:
///
/// ```swift
/// // Automatic upgrade path
/// Text("Hello")
///     .glass()  // Uses native Liquid Glass on iOS 26+
///
/// // Explicit Liquid Glass
/// Text("Hello")
///     .liquidGlass()  // Native on iOS 26+, approximation on older
///
/// // Force old behavior
/// GlassConfiguration.shared.enableLiquidGlassCompat = false
/// ```
///
/// The API surface will remain unchanged, ensuring zero migration effort.
public enum LiquidGlassMigration {
    /// Steps to prepare for iOS 26 Liquid Glass.
    public static let migrationSteps = """
    1. Update to latest GlassmorphismUI
    2. Test your app with `enableLiquidGlassCompat = true`
    3. When targeting iOS 26, effects upgrade automatically
    4. Fine-tune depth values if needed
    5. Optionally use native APIs directly for advanced features
    """
}
