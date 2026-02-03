import SwiftUI

/// A navigation bar component with a glassmorphism background.
///
/// ```swift
/// GlassNavBar(title: "Explore") {
///     Button(action: {}) { Image(systemName: "line.3.horizontal") }
/// } trailing: {
///     Button(action: {}) { Image(systemName: "bell") }
/// }
/// ```
public struct GlassNavBar<Leading: View, Trailing: View>: View {
    // MARK: - Properties

    private let title: String
    private let leading: Leading
    private let trailing: Trailing
    private let material: GlassMaterial

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a glass navigation bar.
    ///
    /// - Parameters:
    ///   - title: The navigation title.
    ///   - material: The glass material. Defaults to `.thin`.
    ///   - leading: The leading bar content.
    ///   - trailing: The trailing bar content.
    public init(
        title: String,
        material: GlassMaterial = .thin,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.material = material
        self.leading = leading()
        self.trailing = trailing()
    }

    // MARK: - Body

    public var body: some View {
        HStack {
            leading
                .frame(width: 44, height: 44)

            Spacer()

            Text(title)
                .font(.headline)
                .foregroundStyle(.white)

            Spacer()

            trailing
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .glass(
            configuration: .init(
                borderWidth: 0.5,
                borderOpacity: 0.2,
                cornerRadius: 0,
                shadowRadius: 4,
                shadowOpacity: 0.08
            ),
            material: material
        )
    }
}

// MARK: - Convenience Initializers

public extension GlassNavBar where Leading == EmptyView, Trailing == EmptyView {
    /// Creates a glass navigation bar with only a title.
    ///
    /// - Parameters:
    ///   - title: The navigation title.
    ///   - material: The glass material. Defaults to `.thin`.
    init(title: String, material: GlassMaterial = .thin) {
        self.init(title: title, material: material, leading: { EmptyView() }, trailing: { EmptyView() })
    }
}

public extension GlassNavBar where Trailing == EmptyView {
    /// Creates a glass navigation bar with a leading view.
    init(
        title: String,
        material: GlassMaterial = .thin,
        @ViewBuilder leading: () -> Leading
    ) {
        self.init(title: title, material: material, leading: leading, trailing: { EmptyView() })
    }
}

// MARK: - Previews

#if DEBUG
#Preview("GlassNavBar") {
    ZStack {
        LinearGradient(colors: [.indigo, .purple], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

        VStack {
            GlassNavBar(title: "Explore") {
                Image(systemName: "line.3.horizontal")
                    .foregroundStyle(.white)
            } trailing: {
                Image(systemName: "bell.fill")
                    .foregroundStyle(.white)
            }

            Spacer()
        }
    }
}
#endif
