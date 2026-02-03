import SwiftUI

/// A model describing a single tab bar item.
public struct GlassTabItem: Identifiable, Sendable {
    /// Stable identifier.
    public let id: String

    /// SF Symbol name for the tab icon.
    public let icon: String

    /// Display title for the tab.
    public let title: String

    /// Creates a tab item.
    ///
    /// - Parameters:
    ///   - icon: SF Symbol name.
    ///   - title: Tab title.
    public init(icon: String, title: String) {
        self.id = icon + title
        self.icon = icon
        self.title = title
    }
}

/// A tab bar with a glassmorphism background.
///
/// ```swift
/// GlassTabBar(
///     selectedIndex: $tab,
///     items: [
///         GlassTabItem(icon: "house", title: "Home"),
///         GlassTabItem(icon: "magnifyingglass", title: "Search"),
///         GlassTabItem(icon: "person", title: "Profile")
///     ]
/// )
/// ```
public struct GlassTabBar: View {
    // MARK: - Properties

    /// The currently selected tab index.
    @Binding public var selectedIndex: Int

    /// The tab items to display.
    private let items: [GlassTabItem]

    /// The glass material for the bar background.
    private let material: GlassMaterial

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a glass tab bar.
    ///
    /// - Parameters:
    ///   - selectedIndex: Binding to the selected tab index.
    ///   - items: The tab items.
    ///   - material: The glass material. Defaults to `.regular`.
    public init(
        selectedIndex: Binding<Int>,
        items: [GlassTabItem],
        material: GlassMaterial = .regular
    ) {
        self._selectedIndex = selectedIndex
        self.items = items
        self.material = material
    }

    // MARK: - Body

    public var body: some View {
        HStack {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                tabButton(for: item, at: index)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .glass(
            configuration: .init(
                borderWidth: 0.6,
                borderOpacity: 0.2,
                cornerRadius: 28,
                shadowRadius: 10,
                shadowOpacity: 0.12
            ),
            material: material
        )
    }

    // MARK: - Private

    private func tabButton(for item: GlassTabItem, at index: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                selectedIndex = index
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: item.icon)
                    .font(.system(size: 20, weight: isSelected(index) ? .semibold : .regular))

                Text(item.title)
                    .font(.caption2.weight(isSelected(index) ? .semibold : .regular))
            }
            .foregroundStyle(isSelected(index) ? .white : .white.opacity(0.5))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(
                Group {
                    if isSelected(index) {
                        Capsule()
                            .fill(.white.opacity(colorScheme == .dark ? 0.1 : 0.15))
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }

    private func isSelected(_ index: Int) -> Bool {
        selectedIndex == index
    }
}

// MARK: - Previews

#if DEBUG
struct GlassTabBarPreview: View {
    @State private var tab = 0

    var body: some View {
        ZStack {
            LinearGradient(colors: [.cyan, .blue, .purple], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                Spacer()
                GlassTabBar(
                    selectedIndex: $tab,
                    items: [
                        GlassTabItem(icon: "house", title: "Home"),
                        GlassTabItem(icon: "magnifyingglass", title: "Search"),
                        GlassTabItem(icon: "heart", title: "Likes"),
                        GlassTabItem(icon: "person", title: "Profile")
                    ]
                )
                .padding(.horizontal)
            }
        }
    }
}

#Preview("GlassTabBar") { GlassTabBarPreview() }
#endif
