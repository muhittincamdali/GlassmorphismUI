// GlassCard.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - GlassCard

/// A card component with glass background.
///
/// ## Example
///
/// ```swift
/// GlassCard {
///     VStack {
///         Image(systemName: "star.fill")
///         Text("Featured")
///     }
/// }
///
/// // With header and footer
/// GlassCard {
///     Text("Content")
/// } header: {
///     Text("Title")
/// } footer: {
///     Button("Action") { }
/// }
/// ```
public struct GlassCard<Content: View, Header: View, Footer: View>: View {
    
    // MARK: - Properties
    
    private let style: GlassStyle
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let content: Content
    private let header: Header?
    private let footer: Footer?
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Initialization
    
    /// Creates a glass card with content only.
    public init(
        style: GlassStyle = .regular,
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) where Header == EmptyView, Footer == EmptyView {
        self.style = style
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
        self.header = nil
        self.footer = nil
    }
    
    /// Creates a glass card with content and header.
    public init(
        style: GlassStyle = .regular,
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header
    ) where Footer == EmptyView {
        self.style = style
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
        self.header = header()
        self.footer = nil
    }
    
    /// Creates a glass card with content, header, and footer.
    public init(
        style: GlassStyle = .regular,
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header,
        @ViewBuilder footer: () -> Footer
    ) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
        self.header = header()
        self.footer = footer()
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let header = header {
                header
                    .font(.headline)
                
                Divider()
                    .background(Color.white.opacity(0.2))
            }
            
            content
            
            if let footer = footer {
                Divider()
                    .background(Color.white.opacity(0.2))
                
                footer
                    .font(.subheadline)
            }
        }
        .padding(padding)
        .glass(style: style, cornerRadius: cornerRadius)
    }
}

// MARK: - GlassCardStyle

/// Predefined styles for glass cards.
public enum GlassCardStyle {
    /// Standard card appearance.
    case standard
    
    /// Elevated card with more prominent shadow.
    case elevated
    
    /// Flat card with minimal depth.
    case flat
    
    /// Inset card that appears recessed.
    case inset
    
    var glassStyle: GlassStyle {
        switch self {
        case .standard:
            return .regular
        case .elevated:
            return GlassStyle(
                shadowRadius: 20,
                shadowOpacity: 0.25
            )
        case .flat:
            return GlassStyle(
                shadowRadius: 0,
                shadowOpacity: 0
            )
        case .inset:
            return GlassStyle(
                tintOpacity: 0.05,
                borderOpacity: 0.1,
                shadowRadius: 2,
                shadowOpacity: 0.05
            )
        }
    }
}

// MARK: - Convenience Initializers

extension GlassCard where Header == EmptyView, Footer == EmptyView {
    
    /// Creates a glass card with a predefined style.
    public init(
        cardStyle: GlassCardStyle,
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            style: cardStyle.glassStyle,
            cornerRadius: cornerRadius,
            padding: padding,
            content: content
        )
    }
}

// MARK: - Preview

#if DEBUG
struct GlassCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                GlassCard {
                    Text("Simple Card Content")
                }
                
                GlassCard {
                    Text("Card with all sections")
                } header: {
                    Label("Header", systemImage: "star.fill")
                } footer: {
                    HStack {
                        Spacer()
                        Text("Footer")
                    }
                }
            }
            .padding()
        }
    }
}
#endif
