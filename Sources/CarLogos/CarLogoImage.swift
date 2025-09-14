import SwiftUI

public struct CarLogoImage: View {
    public let logo: CarLogo
    public var variant: CarLogosStore.Variant = .thumb
    public var contentMode: ContentMode = .fit

    public init(logo: CarLogo, variant: CarLogosStore.Variant = .thumb, contentMode: ContentMode = .fit) {
        self.logo = logo
        self.variant = variant
        self.contentMode = contentMode
    }

    public var body: some View {
        if let image = platformImage() {
            image
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityLabel(Text(logo.name))
        } else {
            // Very lightweight placeholder
            Rectangle()
                .fill(.secondary)
                .overlay(Text(logo.slug.uppercased()).font(.caption).bold().foregroundStyle(.background))
                .aspectRatio(1, contentMode: .fit)
                .accessibilityLabel(Text("\(logo.name) logo placeholder"))
        }
    }

    private func platformImage() -> Image? {
        guard let url = CarLogosStore.localURL(for: logo, variant: variant) else {
          return nil
        }

        #if os(macOS)
        return NSImage(contentsOf: url).map {
          Image(nsImage: $0)
        }
        #else
        return UIImage(contentsOfFile: url.path).map {
          Image(uiImage: $0)
        }
        #endif
    }
}
