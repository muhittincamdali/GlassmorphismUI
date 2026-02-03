import SwiftUI

/// A pre-built card component with a glassmorphism background.
///
/// `GlassCard` wraps your content in a rounded glass panel with
/// optional padding and material configuration:
///
/// ```swift
/// GlassCard {
///     VStack {
///         Text("Title").font(.headline)
///         Text("Subtitle").font(.subheadline)
///     }
/// }
/// ```
public struct GlassCard<Content: View>: View {
    // MARK: - Properties

    private let content: Content
    private let configuration: GlassConfiguration
    private let material: GlassMaterial
    private let padding: CGFloat

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a glass card.
    ///
    /// - Parameters:
    ///   - configuration: Glass configuration. Defaults to `.default`.
    ///   - material: Glass material. Defaults to `.regular`.
    ///   - padding: Inner content padding. Defaults to `16`.
    ///   - content: The card's content.
    public init(
        configuration: GlassConfiguration = .default,
        material: GlassMaterial = .regular,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.material = material
        self.padding = padding
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        content
            .padding(padding)
            .glass(configuration: cardConfiguration, material: material)
    }

    // MARK: - Private

    /// The card uses a slightly larger corner radius than the base configuration.
    private var cardConfiguration: GlassConfiguration {
        var config = configuration
        if config.cornerRadius < 20 {
            config.cornerRadius = 20
        }
        return config
    }
}

// MARK: - Convenience Initializers

public extension GlassCard {
    /// Creates a glass card with a specific material preset.
    ///
    /// - Parameters:
    ///   - material: The glass material to use.
    ///   - content: The card's content.
    init(
        material: GlassMaterial,
        @ViewBuilder content: () -> Content
    ) {
        self.init(configuration: .default, material: material, padding: 16, content: content)
    }
}

// MARK: - Previews

#if DEBUG
#Preview("GlassCard") {
    ZStack {
        LinearGradient(colors: [.orange, .pink, .purple], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

        VStack(spacing: 20) {
            GlassCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notifications")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text("You have 3 new messages")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            GlassCard(material: .thick) {
                HStack {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                    Text("Favorites")
                        .foregroundStyle(.white)
                    Spacer()
                    Text("12")
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
        }
        .padding()
    }
}
#endif
