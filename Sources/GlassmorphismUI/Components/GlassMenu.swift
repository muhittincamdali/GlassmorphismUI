//
//  GlassMenu.swift
//  GlassmorphismUI
//
//  A context menu and dropdown menu component with glassmorphism styling.
//  Supports nested menus, custom icons, and smooth reveal animations.
//

import SwiftUI

// MARK: - Menu Item Model

/// Represents a single item in a glass menu.
public struct GlassMenuItem: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let icon: String?
    public let iconColor: Color
    public let isDestructive: Bool
    public let isDisabled: Bool
    public let badge: String?
    public let submenu: [GlassMenuItem]?
    public let action: (@Sendable () -> Void)?
    
    /// Creates a new menu item.
    /// - Parameters:
    ///   - id: Unique identifier (defaults to UUID)
    ///   - title: Display title for the item
    ///   - icon: SF Symbol name for the icon
    ///   - iconColor: Color for the icon
    ///   - isDestructive: Whether this is a destructive action (shows red)
    ///   - isDisabled: Whether the item is disabled
    ///   - badge: Optional badge text to display
    ///   - submenu: Optional array of child menu items
    ///   - action: Closure executed when item is tapped
    public init(
        id: String = UUID().uuidString,
        title: String,
        icon: String? = nil,
        iconColor: Color = .primary,
        isDestructive: Bool = false,
        isDisabled: Bool = false,
        badge: String? = nil,
        submenu: [GlassMenuItem]? = nil,
        action: (@Sendable () -> Void)? = nil
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.iconColor = isDestructive ? .red : iconColor
        self.isDestructive = isDestructive
        self.isDisabled = isDisabled
        self.badge = badge
        self.submenu = submenu
        self.action = action
    }
    
    /// Creates a divider item for visual separation.
    public static var divider: GlassMenuItem {
        GlassMenuItem(id: "divider-\(UUID().uuidString)", title: "---")
    }
    
    /// Returns true if this item is a divider.
    public var isDivider: Bool {
        title == "---"
    }
}

// MARK: - Menu Configuration

/// Configuration options for customizing glass menu appearance.
public struct GlassMenuConfiguration: Sendable {
    /// The blur intensity of the glass effect
    public var blurIntensity: CGFloat
    /// The tint color applied to the glass surface
    public var tintColor: Color
    /// The opacity of the tint color
    public var tintOpacity: CGFloat
    /// Corner radius for the menu
    public var cornerRadius: CGFloat
    /// Padding inside the menu
    public var padding: CGFloat
    /// Spacing between menu items
    public var itemSpacing: CGFloat
    /// Height of each menu item
    public var itemHeight: CGFloat
    /// Border width for the glass edge
    public var borderWidth: CGFloat
    /// Border color for the glass edge
    public var borderColor: Color
    /// Shadow radius
    public var shadowRadius: CGFloat
    /// Shadow color
    public var shadowColor: Color
    /// Animation for menu reveal
    public var animation: Animation
    /// Whether to show icons
    public var showIcons: Bool
    /// Minimum menu width
    public var minWidth: CGFloat
    /// Maximum menu width
    public var maxWidth: CGFloat
    /// Whether to dismiss on item selection
    public var dismissOnSelect: Bool
    /// Haptic feedback on selection
    public var hapticFeedback: Bool
    
    /// Creates a new menu configuration with default values.
    public init(
        blurIntensity: CGFloat = 0.9,
        tintColor: Color = .white,
        tintOpacity: CGFloat = 0.1,
        cornerRadius: CGFloat = 14,
        padding: CGFloat = 6,
        itemSpacing: CGFloat = 2,
        itemHeight: CGFloat = 44,
        borderWidth: CGFloat = 0.5,
        borderColor: Color = .white.opacity(0.3),
        shadowRadius: CGFloat = 20,
        shadowColor: Color = .black.opacity(0.2),
        animation: Animation = .spring(response: 0.3, dampingFraction: 0.8),
        showIcons: Bool = true,
        minWidth: CGFloat = 200,
        maxWidth: CGFloat = 300,
        dismissOnSelect: Bool = true,
        hapticFeedback: Bool = true
    ) {
        self.blurIntensity = blurIntensity
        self.tintColor = tintColor
        self.tintOpacity = tintOpacity
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.itemSpacing = itemSpacing
        self.itemHeight = itemHeight
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        self.animation = animation
        self.showIcons = showIcons
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.dismissOnSelect = dismissOnSelect
        self.hapticFeedback = hapticFeedback
    }
    
    /// Preset for a compact menu style
    public static var compact: GlassMenuConfiguration {
        GlassMenuConfiguration(
            padding: 4,
            itemSpacing: 1,
            itemHeight: 36,
            minWidth: 150,
            maxWidth: 220
        )
    }
    
    /// Preset for a spacious menu style
    public static var spacious: GlassMenuConfiguration {
        GlassMenuConfiguration(
            cornerRadius: 18,
            padding: 10,
            itemSpacing: 4,
            itemHeight: 52,
            minWidth: 240,
            maxWidth: 340
        )
    }
}

// MARK: - Menu Item View

private struct GlassMenuItemView: View {
    let item: GlassMenuItem
    let configuration: GlassMenuConfiguration
    let onTap: () -> Void
    
    @State private var isPressed = false
    @State private var isHovered = false
    
    var body: some View {
        if item.isDivider {
            dividerView
        } else {
            itemButton
        }
    }
    
    private var dividerView: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.1))
            .frame(height: 1)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
    }
    
    private var itemButton: some View {
        Button(action: handleTap) {
            HStack(spacing: 12) {
                // Icon
                if configuration.showIcons, let icon = item.icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(item.isDisabled ? .secondary : item.iconColor)
                        .frame(width: 24)
                }
                
                // Title
                Text(item.title)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(titleColor)
                    .lineLimit(1)
                
                Spacer(minLength: 4)
                
                // Badge
                if let badge = item.badge {
                    Text(badge)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(item.isDestructive ? Color.red : Color.blue)
                        )
                }
                
                // Submenu indicator
                if item.submenu != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .frame(height: configuration.itemHeight)
            .frame(minWidth: configuration.minWidth - configuration.padding * 2,
                   maxWidth: configuration.maxWidth - configuration.padding * 2)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius - 4, style: .continuous))
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(item.isDisabled)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
    
    private var titleColor: Color {
        if item.isDisabled {
            return .secondary
        } else if item.isDestructive {
            return .red
        } else {
            return .primary
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        if isPressed || isHovered {
            RoundedRectangle(cornerRadius: configuration.cornerRadius - 4, style: .continuous)
                .fill(Color.primary.opacity(0.08))
        }
    }
    
    private func handleTap() {
        guard !item.isDisabled else { return }
        
        if configuration.hapticFeedback {
            triggerHaptic()
        }
        
        withAnimation(.easeInOut(duration: 0.1)) {
            isPressed = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isPressed = false
            onTap()
        }
    }
    
    private func triggerHaptic() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }
}

// MARK: - Glass Menu View

/// A dropdown or context menu with glassmorphism styling.
///
/// Example usage:
/// ```swift
/// GlassMenu(items: [
///     GlassMenuItem(title: "Copy", icon: "doc.on.doc") { print("Copy") },
///     GlassMenuItem(title: "Delete", icon: "trash", isDestructive: true) { print("Delete") }
/// ])
/// ```
public struct GlassMenu: View {
    // MARK: - Properties
    
    private let items: [GlassMenuItem]
    private let configuration: GlassMenuConfiguration
    private let onDismiss: (() -> Void)?
    
    @State private var isVisible = false
    @State private var activeSubmenu: GlassMenuItem?
    
    // MARK: - Initialization
    
    /// Creates a new glass menu.
    /// - Parameters:
    ///   - items: Array of menu items to display
    ///   - configuration: Configuration options for appearance
    ///   - onDismiss: Optional closure called when menu is dismissed
    public init(
        items: [GlassMenuItem],
        configuration: GlassMenuConfiguration = GlassMenuConfiguration(),
        onDismiss: (() -> Void)? = nil
    ) {
        self.items = items
        self.configuration = configuration
        self.onDismiss = onDismiss
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: configuration.itemSpacing) {
            ForEach(items) { item in
                GlassMenuItemView(
                    item: item,
                    configuration: configuration
                ) {
                    handleItemTap(item)
                }
            }
        }
        .padding(configuration.padding)
        .background(glassBackground)
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .overlay(borderOverlay)
        .shadow(
            color: configuration.shadowColor,
            radius: configuration.shadowRadius,
            x: 0,
            y: 8
        )
        .scaleEffect(isVisible ? 1 : 0.9)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(configuration.animation) {
                isVisible = true
            }
        }
    }
    
    // MARK: - Glass Background
    
    private var glassBackground: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(configuration.blurIntensity)
            
            Rectangle()
                .fill(configuration.tintColor.opacity(configuration.tintOpacity))
            
            // Top highlight
            VStack {
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.2),
                        Color.white.opacity(0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 40)
                
                Spacer()
            }
        }
    }
    
    // MARK: - Border Overlay
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .stroke(
                LinearGradient(
                    colors: [
                        configuration.borderColor,
                        configuration.borderColor.opacity(0.3)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: configuration.borderWidth
            )
    }
    
    // MARK: - Item Tap Handler
    
    private func handleItemTap(_ item: GlassMenuItem) {
        if let submenu = item.submenu, !submenu.isEmpty {
            activeSubmenu = item
        } else {
            item.action?()
            if configuration.dismissOnSelect {
                dismissMenu()
            }
        }
    }
    
    private func dismissMenu() {
        withAnimation(configuration.animation) {
            isVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss?()
        }
    }
}

// MARK: - Context Menu Modifier

/// A view modifier that presents a glass context menu on long press.
public struct GlassContextMenuModifier<MenuContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let configuration: GlassMenuConfiguration
    let menuContent: () -> MenuContent
    
    @State private var menuPosition: CGPoint = .zero
    @State private var contentSize: CGSize = .zero
    
    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            contentSize = geometry.size
                        }
                        .preference(
                            key: FramePreferenceKey.self,
                            value: geometry.frame(in: .global)
                        )
                }
            )
            .onPreferenceChange(FramePreferenceKey.self) { frame in
                menuPosition = CGPoint(x: frame.midX, y: frame.maxY + 8)
            }
            .onLongPressGesture(minimumDuration: 0.5) {
                triggerHaptic()
                withAnimation(configuration.animation) {
                    isPresented = true
                }
            }
            .overlay(
                Group {
                    if isPresented {
                        ZStack {
                            // Backdrop
                            Color.black.opacity(0.01)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation(configuration.animation) {
                                        isPresented = false
                                    }
                                }
                            
                            // Menu
                            menuContent()
                                .position(x: menuPosition.x, y: menuPosition.y + 100)
                        }
                    }
                }
            )
    }
    
    private func triggerHaptic() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #endif
    }
}

// MARK: - Frame Preference Key

private struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

// MARK: - View Extension

public extension View {
    /// Attaches a glass context menu that appears on long press.
    /// - Parameters:
    ///   - isPresented: Binding controlling menu visibility
    ///   - configuration: Configuration options for appearance
    ///   - content: The menu content to display
    func glassContextMenu<MenuContent: View>(
        isPresented: Binding<Bool>,
        configuration: GlassMenuConfiguration = GlassMenuConfiguration(),
        @ViewBuilder content: @escaping () -> MenuContent
    ) -> some View {
        modifier(
            GlassContextMenuModifier(
                isPresented: isPresented,
                configuration: configuration,
                menuContent: content
            )
        )
    }
    
    /// Attaches a glass context menu with predefined menu items.
    /// - Parameters:
    ///   - isPresented: Binding controlling menu visibility
    ///   - items: Array of menu items
    ///   - configuration: Configuration options for appearance
    func glassContextMenu(
        isPresented: Binding<Bool>,
        items: [GlassMenuItem],
        configuration: GlassMenuConfiguration = GlassMenuConfiguration()
    ) -> some View {
        glassContextMenu(isPresented: isPresented, configuration: configuration) {
            GlassMenu(items: items, configuration: configuration) {
                isPresented.wrappedValue = false
            }
        }
    }
}

// MARK: - Dropdown Menu Wrapper

/// A button that presents a glass dropdown menu when tapped.
public struct GlassDropdownMenu<Label: View>: View {
    private let items: [GlassMenuItem]
    private let configuration: GlassMenuConfiguration
    private let label: () -> Label
    
    @State private var isPresented = false
    
    /// Creates a dropdown menu button.
    /// - Parameters:
    ///   - items: Array of menu items
    ///   - configuration: Configuration options for appearance
    ///   - label: The button label view
    public init(
        items: [GlassMenuItem],
        configuration: GlassMenuConfiguration = GlassMenuConfiguration(),
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.items = items
        self.configuration = configuration
        self.label = label
    }
    
    public var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                withAnimation(configuration.animation) {
                    isPresented.toggle()
                }
            } label: {
                label()
            }
            
            if isPresented {
                GlassMenu(items: items, configuration: configuration) {
                    withAnimation(configuration.animation) {
                        isPresented = false
                    }
                }
                .offset(y: 50)
                .zIndex(100)
            }
        }
        .overlay(
            Group {
                if isPresented {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(configuration.animation) {
                                isPresented = false
                            }
                        }
                }
            }
        )
    }
}

// MARK: - Preview Provider

#if DEBUG
struct GlassMenu_Previews: PreviewProvider {
    static var previews: some View {
        GlassMenuPreviewContainer()
    }
}

private struct GlassMenuPreviewContainer: View {
    @State private var showContextMenu = false
    
    let sampleItems: [GlassMenuItem] = [
        GlassMenuItem(title: "Copy", icon: "doc.on.doc") { print("Copy") },
        GlassMenuItem(title: "Share", icon: "square.and.arrow.up") { print("Share") },
        .divider,
        GlassMenuItem(title: "Edit", icon: "pencil", badge: "Pro") { print("Edit") },
        GlassMenuItem(title: "Duplicate", icon: "plus.square.on.square") { print("Duplicate") },
        .divider,
        GlassMenuItem(title: "Delete", icon: "trash", isDestructive: true) { print("Delete") }
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.orange, .pink, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Glass Menu Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Dropdown menu
                GlassDropdownMenu(items: sampleItems) {
                    HStack {
                        Text("Actions")
                        Image(systemName: "chevron.down")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                }
                
                // Static menu display
                GlassMenu(items: sampleItems)
                
                // Long press target
                Text("Long press me")
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .glassContextMenu(isPresented: $showContextMenu, items: sampleItems)
            }
        }
    }
}
#endif
