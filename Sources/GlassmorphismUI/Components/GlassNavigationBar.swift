// GlassNavigationBar.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - GlassNavigationBar

/// A navigation bar with glass background.
///
/// ## Example
///
/// ```swift
/// GlassNavigationBar(title: "Home") {
///     Button(action: {}) {
///         Image(systemName: "gear")
///     }
/// }
///
/// GlassNavigationBar(title: "Settings") {
///     // Leading items
/// } trailing: {
///     // Trailing items
/// }
/// ```
public struct GlassNavigationBar<Leading: View, Trailing: View>: View {
    
    // MARK: - Properties
    
    private let title: String
    private let subtitle: String?
    private let style: GlassStyle
    private let leading: Leading?
    private let trailing: Trailing?
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Initialization
    
    /// Creates a navigation bar with title only.
    public init(
        title: String,
        subtitle: String? = nil,
        style: GlassStyle = .regular
    ) where Leading == EmptyView, Trailing == EmptyView {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.leading = nil
        self.trailing = nil
    }
    
    /// Creates a navigation bar with trailing items.
    public init(
        title: String,
        subtitle: String? = nil,
        style: GlassStyle = .regular,
        @ViewBuilder trailing: () -> Trailing
    ) where Leading == EmptyView {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.leading = nil
        self.trailing = trailing()
    }
    
    /// Creates a navigation bar with leading items.
    public init(
        title: String,
        subtitle: String? = nil,
        style: GlassStyle = .regular,
        @ViewBuilder leading: () -> Leading
    ) where Trailing == EmptyView {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.leading = leading()
        self.trailing = nil
    }
    
    /// Creates a navigation bar with leading and trailing items.
    public init(
        title: String,
        subtitle: String? = nil,
        style: GlassStyle = .regular,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.leading = leading()
        self.trailing = trailing()
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 16) {
            // Leading
            if let leading = leading {
                leading
                    .frame(minWidth: 44)
            }
            
            Spacer()
            
            // Title
            VStack(spacing: 2) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Trailing
            if let trailing = trailing {
                trailing
                    .frame(minWidth: 44)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(minHeight: 56)
        .glass(style: style, cornerRadius: 0)
    }
}

// MARK: - GlassNavigationBarModifier

/// A view modifier that adds a glass navigation bar to a view.
public struct GlassNavigationBarModifier<Leading: View, Trailing: View>: ViewModifier {
    
    private let title: String
    private let subtitle: String?
    private let style: GlassStyle
    private let leading: Leading?
    private let trailing: Trailing?
    
    public init(
        title: String,
        subtitle: String? = nil,
        style: GlassStyle = .regular,
        leading: Leading?,
        trailing: Trailing?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.leading = leading
        self.trailing = trailing
    }
    
    public func body(content: Content) -> some View {
        VStack(spacing: 0) {
            GlassNavigationBar(
                title: title,
                subtitle: subtitle,
                style: style,
                leading: { leading ?? EmptyView() as! Leading },
                trailing: { trailing ?? EmptyView() as! Trailing }
            )
            
            content
        }
    }
}

// MARK: - View Extension

public extension View {
    
    /// Adds a glass navigation bar to the top of the view.
    ///
    /// - Parameters:
    ///   - title: The navigation title.
    ///   - subtitle: Optional subtitle.
    ///   - style: The glass style.
    /// - Returns: A view with a glass navigation bar.
    func glassNavigationBar(
        title: String,
        subtitle: String? = nil,
        style: GlassStyle = .regular
    ) -> some View {
        modifier(GlassNavigationBarModifier<EmptyView, EmptyView>(
            title: title,
            subtitle: subtitle,
            style: style,
            leading: nil,
            trailing: nil
        ))
    }
}

// MARK: - GlassBackButton

/// A back button with glass styling for navigation.
public struct GlassBackButton: View {
    
    private let action: () -> Void
    private let title: String?
    
    public init(title: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.body.weight(.medium))
                
                if let title = title {
                    Text(title)
                        .font(.body)
                }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct GlassNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                GlassNavigationBar(title: "Home")
                
                GlassNavigationBar(
                    title: "Settings",
                    subtitle: "Customize your experience"
                ) {
                    GlassBackButton { }
                } trailing: {
                    Button(action: {}) {
                        Image(systemName: "gear")
                    }
                }
                
                Spacer()
            }
        }
    }
}
#endif
