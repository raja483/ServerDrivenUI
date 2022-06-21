import SwiftUI

struct MarkdownParserCacheKey: EnvironmentKey {

    public static var defaultValue: CHMarkdownParserCache?

}

@available(iOS 13.0, *)
extension EnvironmentValues {

    public var markdownParserCache: CHMarkdownParserCache? {
        get { self[MarkdownParserCacheKey.self] }
        set { self[MarkdownParserCacheKey.self] = newValue }
    }
}
