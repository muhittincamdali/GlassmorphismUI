// GlassStyle.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - GlassStyle

/// Defines the visual style of glass effects.
///
/// Use this to customize the appearance of glass backgrounds throughout your app.
///
/// ## Example
///
/// ```swift
/// Text("Hello")
///     .glass(style: .prominent)
/// ```
public struct GlassStyle: Sendable, Hashable {
    
    // MARK: - Properties
    
    /// The blur intensity (0.0 to 1.0).
    public let blurIntensity: CGFloat
    
    /// The tint color applied over the blur.
    public let tintColor: Color
    
    /// The tint opacity (0.0 to 1.0).
    public let tintOpacity: CGFloat
    
    /// The border opacity for the glass edge highlight.
    public let borderOpacity: CGFloat
    
    /// The shadow radius.
    public let shadowRadius: CGFloat
    
    /// The shadow opacity.
    public let shadowOpacity: CGFloat
    
    /// Whether to use vibrancy effects.
    public let useVibrancy: Bool
    
    // MARK: - Initialization
    
    /// Creates a custom glass style.
    ///
    /// - Parameters:
    ///   - blurIntensity: Blur amount (0.0 to 1.0). Default is 0.5.
    ///   - tintColor: The tint color. Default is white.
    ///   - tintOpacity: Tint opacity. Default is 0.1.
    ///   - borderOpacity: Border highlight opacity. Default is 0.2.
    ///   - shadowRadius: Shadow blur radius. Default is 10.
    ///   - shadowOpacity: Shadow opacity. Default is 0.15.
    ///   - useVibrancy: Enable vibrancy. Default is true.
    public init(
        blurIntensity: CGFloat = 0.5,
        tintColor: Color = .white,
        tintOpacity: CGFloat = 0.1,
        borderOpacity: CGFloat = 0.2,
        shadowRadius: CGFloat = 10,
        shadowOpacity: CGFloat = 0.15,
        useVibrancy: Bool = true
    ) {
        self.blurIntensity = max(0, min(1, blurIntensity))
        self.tintColor = tintColor
        self.tintOpacity = max(0, min(1, tintOpacity))
        self.borderOpacity = max(0, min(1, borderOpacity))
        self.shadowRadius = max(0, shadowRadius)
        self.shadowOpacity = max(0, min(1, shadowOpacity))
        self.useVibrancy = useVibrancy
    }
    
    // MARK: - Presets
    
    /// A subtle, barely-there glass effect.
    public static let subtle = GlassStyle(
        blurIntensity: 0.3,
        tintOpacity: 0.05,
        borderOpacity: 0.1,
        shadowRadius: 5,
        shadowOpacity: 0.1
    )
    
    /// The default glass style - balanced and versatile.
    public static let regular = GlassStyle()
    
    /// A more prominent glass effect with higher contrast.
    public static let prominent = GlassStyle(
        blurIntensity: 0.7,
        tintOpacity: 0.15,
        borderOpacity: 0.3,
        shadowRadius: 15,
        shadowOpacity: 0.2
    )
    
    /// A thick, frosted glass appearance.
    public static let frosted = GlassStyle(
        blurIntensity: 1.0,
        tintOpacity: 0.2,
        borderOpacity: 0.15,
        shadowRadius: 8,
        shadowOpacity: 0.12
    )
    
    /// Ultra-thin material similar to iOS system UI.
    public static let ultraThin = GlassStyle(
        blurIntensity: 0.2,
        tintOpacity: 0.03,
        borderOpacity: 0.08,
        shadowRadius: 3,
        shadowOpacity: 0.05
    )
    
    /// Thick material for high-contrast backgrounds.
    public static let thick = GlassStyle(
        blurIntensity: 0.9,
        tintOpacity: 0.25,
        borderOpacity: 0.35,
        shadowRadius: 20,
        shadowOpacity: 0.25
    )
    
    /// No glass effect - useful for conditional styling.
    public static let clear = GlassStyle(
        blurIntensity: 0,
        tintOpacity: 0,
        borderOpacity: 0,
        shadowRadius: 0,
        shadowOpacity: 0,
        useVibrancy: false
    )
}

// MARK: - GlassMaterial

/// The underlying material type for glass effects.
///
/// Maps to SwiftUI's Material types with appropriate fallbacks.
public enum GlassMaterial: String, CaseIterable, Sendable {
    /// Ultra-thin blur with minimal tinting.
    case ultraThin
    
    /// Thin blur effect.
    case thin
    
    /// Regular/medium blur effect.
    case regular
    
    /// Thick blur with more opacity.
    case thick
    
    /// Maximum blur and tinting.
    case ultraThick
    
    /// The corresponding SwiftUI Material.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public var material: Material {
        switch self {
        case .ultraThin: return .ultraThinMaterial
        case .thin: return .thinMaterial
        case .regular: return .regularMaterial
        case .thick: return .thickMaterial
        case .ultraThick: return .ultraThickMaterial
        }
    }
    
    /// The blur radius for fallback implementations.
    public var blurRadius: CGFloat {
        switch self {
        case .ultraThin: return 10
        case .thin: return 15
        case .regular: return 20
        case .thick: return 30
        case .ultraThick: return 40
        }
    }
    
    /// The background opacity for fallback implementations.
    public var backgroundOpacity: CGFloat {
        switch self {
        case .ultraThin: return 0.3
        case .thin: return 0.4
        case .regular: return 0.5
        case .thick: return 0.6
        case .ultraThick: return 0.7
        }
    }
}

// MARK: - GlassCornerStyle

/// The corner style for glass shapes.
public enum GlassCornerStyle: Sendable {
    /// Sharp, square corners.
    case square
    
    /// Rounded corners with a specific radius.
    case rounded(CGFloat)
    
    /// Fully rounded corners (capsule shape).
    case capsule
    
    /// Continuous (superellipse) corners - iOS 13+ style.
    case continuous(CGFloat)
    
    /// The corner radius value.
    public var radius: CGFloat {
        switch self {
        case .square: return 0
        case .rounded(let r): return r
        case .capsule: return .infinity
        case .continuous(let r): return r
        }
    }
    
    /// Whether to use continuous corner style.
    public var isContinuous: Bool {
        switch self {
        case .continuous: return true
        default: return false
        }
    }
}

// MARK: - Default Corner Radii

extension GlassCornerStyle {
    /// Small corner radius (8pt).
    public static let small = GlassCornerStyle.continuous(8)
    
    /// Medium corner radius (12pt).
    public static let medium = GlassCornerStyle.continuous(12)
    
    /// Large corner radius (16pt).
    public static let large = GlassCornerStyle.continuous(16)
    
    /// Extra large corner radius (20pt).
    public static let extraLarge = GlassCornerStyle.continuous(20)
    
    /// System default corner radius (matches iOS buttons).
    public static let system = GlassCornerStyle.continuous(10)
}
