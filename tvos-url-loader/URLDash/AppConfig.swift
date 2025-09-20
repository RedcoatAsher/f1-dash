import Foundation

/// Global configuration values for the tvOS web container app.
enum AppConfig {
    /// The single source of truth for the URL that should be loaded by the app.
    ///
    /// Update this value when you want to ship the same binary with a different
    /// destination. Keeping it in one place makes it easy to maintain multiple
    /// branded variants of the application.
    static let urlString = "https://example.com"

    /// A validated URL generated from ``urlString``.
    static var appURL: URL {
        guard let url = URL(string: urlString) else {
            preconditionFailure("Invalid URL string: \(urlString)")
        }
        return url
    }
}
