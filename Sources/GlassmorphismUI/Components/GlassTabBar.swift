// GlassTabBar.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - GlassTabItem

/// Represents a tab item in a glass tab bar.
public struct GlassTabItem: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let icon: String
    public let selectedIcon: String?
    public let badge: String?
    
    /// Creates a glass tab item.
    ///
    /// - Parameters:
    ///   - id: Unique identifier.
    ///   - title: The tab title.
    ///   - icon: SF Symbol name for unselected state.
    ///   - selectedIcon: SF Symbol name for selected state. Defaults to filled variant.
    ///   - badge: Optional badge text.
    public init(
        id: String,
        title: String,
        icon: String,
        selectedIcon: String? = nil,
        badge: String? = nil
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.selectedIcon = selectedIcon ?? "\(icon).fill"
        self.badge = badge
    }
}

// MARK: - GlassTabBar

/// A tab bar with glass styling.
///
/// ## Example
///
/// ```swift
/// @State private var selectedTab = "home"
///
/// let tabs = [
///     GlassTabItem(id: "home", title: "Home", icon: "house"),
///     GlassTabItem(id: "search", title: "Search", icon: "magnifyingglass"),
///     GlassTabItem(id: "profile", title: "Profile", icon: "person")
/// ]
///
/// GlassTabBar(selection: $selectedTab, items: tabs)
/// ```
public struct GlassTabBar: View {
    
    // MARK: - Properties
    
    @Binding private var selection: String
    private let items: [GlassTabItem]
    private let style: GlassStyle
    private let height: CGFloat
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.glassConfiguration) private var configuration
    
    // MARK: - Initialization
    
    /// Creates a glass tab bar.
    ///
    /// - Parameters:
    ///   - selection: Binding to the selected tab ID.
    ///   - items: The tab items.
    ///   - style: The glass style. Default is `.regular`.
    ///   - height: The tab bar height. Default is 80.
    public init(
        selection: Binding<String>,
        items: [GlassTabItem],
        style: GlassStyle = .regular,
        height: CGFloat = 80
    ) {
        self._selection = selection
        self.items = items
        self.style = style
        self.height = height
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                tabButton(for: item)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, 24) // Safe area
        .frame(height: height)
        .glass(style: style, cornerRadius: 0)
    }
    
    // MARK: - Private
    
    @ViewBuilder
    private func tabButton(for item: GlassTabItem) -> some View {
        let isSelected = selection == item.id
        
        Button {
            withAnimation(configuration.accessibleAnimation ?? .easeInOut(duration: 0.2)) {
                selection = item.id
            }
            
            #if os(iOS)
            if configuration.enableHaptics {
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            }
            #endif
        } label: {
            VStack(spacing: 4) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: isSelected ? (item.selectedIcon ?? item.icon) : item.icon)
                        .font(.system(size: 22))
                        .symbolRenderingMode(.hierarchical)
                    
                    if let badge = item.badge {
                        badgeView(badge)
                    }
                }
                
                Text(item.title)
                    .font(.caption2)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .foregroundColor(isSelected ? .primary : .secondary)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(item.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
    
    @ViewBuilder
    private func badgeView(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(Capsule().fill(.red))
            .offset(x: 8, y: -4)
    }
}

// MARK: - GlassTabView

/// A container view that pairs content with a glass tab bar.
///
/// ## Example
///
/// ```swift
/// GlassTabView(selection: $selectedTab, items: tabs) { tabId in
///     switch tabId {
///     case "home": HomeView()
///     case "search": SearchView()
///     default: EmptyView()
///     }
/// }
/// ```
public struct GlassTabView<Content: View>: View {
    
    @Binding private var selection: String
    private let items: [GlassTabItem]
    private let style: GlassStyle
    private let content: (String) -> Content
    
    public init(
        selection: Binding<String>,
        items: [GlassTabItem],
        style: GlassStyle = .regular,
        @ViewBuilder content: @escaping (String) -> Content
    ) {
        self._selection = selection
        self.items = items
        self.style = style
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            content(selection)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            GlassTabBar(selection: $selection, items: items, style: style)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - Floating Glass Tab Bar

/// A floating pill-shaped tab bar with glass styling.
public struct FloatingGlassTabBar: View {
    
    @Binding private var selection: String
    private let items: [GlassTabItem]
    private let style: GlassStyle
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(
        selection: Binding<String>,
        items: [GlassTabItem],
        style: GlassStyle = .prominent
    ) {
        self._selection = selection
        self.items = items
        self.style = style
    }
    
    public var body: some View {
        HStack(spacing: 24) {
            ForEach(items) { item in
                floatingTabButton(for: item)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .glass(style: style, cornerStyle: .capsule)
        .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
    }
    
    @ViewBuilder
    private func floatingTabButton(for item: GlassTabItem) -> some View {
        let isSelected = selection == item.id
        
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selection = item.id
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? (item.selectedIcon ?? item.icon) : item.icon)
                    .font(.system(size: 20))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
            }
            .foregroundColor(isSelected ? .primary : .secondary)
            .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#if DEBUG
struct GlassTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                FloatingGlassTabBar(
                    selection: .constant("home"),
                    items: [
                        GlassTabItem(id: "home", title: "Home", icon: "house"),
                        GlassTabItem(id: "search", title: "Search", icon: "magnifyingglass"),
                        GlassTabItem(id: "profile", title: "Profile", icon: "person", badge: "3")
                    ]
                )
                .padding(.bottom, 20)
                
                GlassTabBar(
                    selection: .constant("home"),
                    items: [
                        GlassTabItem(id: "home", title: "Home", icon: "house"),
                        GlassTabItem(id: "search", title: "Search", icon: "magnifyingglass"),
                        GlassTabItem(id: "profile", title: "Profile", icon: "person")
                    ]
                )
            }
        }
    }
}
#endif
